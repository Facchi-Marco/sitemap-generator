#!/bin/bash

# ============================================================================
# SITEMAP GENERATOR - Générateur de sitemap automatique & manuel
# Usage: ./sitemap-generator.sh
# ============================================================================

set -e

# Couleurs pour le terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
TEMP_DIR=$(mktemp -d)
OUTPUT_FILE="sitemap_$(date +%Y%m%d_%H%M%S).txt"
trap "rm -rf $TEMP_DIR" EXIT

# ============================================================================
# FUNCTIONS
# ============================================================================

print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║     🗂️  SITEMAP GENERATOR              ║"
    echo "║     Générateur de structure web        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Valider une URL
validate_url() {
    local url=$1
    if [[ $url =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

# Normaliser une URL
normalize_url() {
    local url=$1
    if [[ ! $url =~ ^https?:// ]]; then
        url="https://$url"
    fi
    echo "$url"
}

# Extraire le domaine
get_domain() {
    local url=$1
    echo "$url" | sed -E 's|https?://||; s|/.*||'
}

# ============================================================================
# MODE 1: SITEMAP.XML AUTO
# ============================================================================

try_sitemap_xml() {
    local url=$1
    local domain=$(get_domain "$url")
    
    print_info "Recherche du sitemap.xml..."
    
    # Essayer sitemap.xml à la racine
    local sitemap_url="${url%/}/sitemap.xml"
    
    if curl -s --connect-timeout 5 -I "$sitemap_url" | grep -q "200\|301\|302"; then
        print_success "Sitemap trouvé!"
        
        # Télécharger et parser
        local xml_file="$TEMP_DIR/sitemap.xml"
        curl -s "$sitemap_url" > "$xml_file"
        
        # Parser le XML et extraire les URLs
        print_info "Parsing du sitemap..."
        
        {
            echo "SITEMAP: $domain"
            echo "Source: $sitemap_url"
            echo "Date: $(date)"
            echo "─────────────────────────────────────────"
            echo ""
            
            # Extraire les <loc> du XML
            grep -oP '(?<=<loc>)[^<]+' "$xml_file" | while read page; do
                # Nettoyer l'URL
                local path=$(echo "$page" | sed "s|https\?://$domain||")
                [ -z "$path" ] && path="/"
                echo "  📄 $path"
            done
        } | tee "$TEMP_DIR/result.txt"
        
        return 0
    else
        return 1
    fi
}

# ============================================================================
# MODE 2: CRAWL AUTOMATIQUE
# ============================================================================

crawl_site() {
    local url=$1
    local max_depth=${2:-2}
    local domain=$(get_domain "$url")
    
    print_info "Crawl du site (profondeur: $max_depth)..."
    print_warning "Cela peut prendre un moment..."
    echo ""
    
    local found_urls=()
    local visited=()
    
    # Fonction récursive de crawl
    crawl_recursive() {
        local current_url=$1
        local depth=$2
        
        # Limite de profondeur
        [ $depth -gt $max_depth ] && return
        
        # Vérifier si déjà visité
        if [[ " ${visited[@]} " =~ " ${current_url} " ]]; then
            return
        fi
        visited+=("$current_url")
        
        # Télécharger la page
        local html=$(curl -s --connect-timeout 5 "$current_url" 2>/dev/null || echo "")
        
        if [ -z "$html" ]; then
            return
        fi
        
        # Extraire tous les liens
        echo "$html" | grep -oP 'href="\K[^"]+' | while read link; do
            # Normaliser le lien
            local full_url="$link"
            if [[ ! $link =~ ^https?:// ]]; then
                if [[ $link =~ ^/ ]]; then
                    full_url="https://$domain$link"
                else
                    full_url="https://$domain/$(dirname $current_url | sed "s|https\?://$domain||")/$link"
                fi
            fi
            
            # Vérifier que c'est du même domaine
            if [[ $full_url =~ ^https?://$domain ]]; then
                # Nettoyer l'URL (enlever fragments, etc)
                full_url=$(echo "$full_url" | sed 's/#.*//')
                
                # Vérifier si c'est pas un fichier binaire
                if [[ ! $full_url =~ \.(jpg|png|gif|pdf|zip|exe)$ ]]; then
                    found_urls+=("$full_url")
                fi
            fi
        done
    }
    
    # Début du crawl
    crawl_recursive "$url" 0
    
    # Afficher les résultats uniques
    {
        echo "SITEMAP: $domain"
        echo "Date: $(date)"
        echo "─────────────────────────────────────────"
        echo ""
        
        printf '%s\n' "${found_urls[@]}" | sort -u | while read page; do
            local path=$(echo "$page" | sed "s|https\?://$domain||")
            [ -z "$path" ] && path="/"
            echo "  📄 $path"
        done
    } | tee "$TEMP_DIR/result.txt"
}

# ============================================================================
# MODE 3: FORMULAIRE MANUEL
# ============================================================================

manual_mode() {
    local site_name=$1
    
    echo ""
    print_info "Mode manuel - Entrez la structure (Ctrl+D pour terminer):"
    echo "Format: Section"
    echo "        - Sous-page"
    echo "        - Sous-page"
    echo ""
    
    local content=""
    while IFS= read -r line; do
        content+="$line"$'\n'
    done
    
    echo ""
    echo "SITEMAP: $site_name"
    echo "─────────────────────────────────────────"
    echo ""
    echo "$content"
}

# ============================================================================
# MENU PRINCIPAL
# ============================================================================

main() {
    print_header
    
    echo "Choisissez une option:"
    echo "1. Analyser un site (auto)"
    echo "2. Créer manuellement"
    echo "3. Quitter"
    echo ""
    read -p "Option (1-3): " choice
    
    case $choice in
        1)
            echo ""
            read -p "URL du site (ex: exemple.com ou https://exemple.com): " user_url
            
            if [ -z "$user_url" ]; then
                print_error "URL vide!"
                return 1
            fi
            
            user_url=$(normalize_url "$user_url")
            
            if ! validate_url "$user_url"; then
                print_error "URL invalide!"
                return 1
            fi
            
            print_info "Analyse de: $user_url"
            echo ""
            
            # Essayer sitemap.xml d'abord
            if try_sitemap_xml "$user_url"; then
                RESULT="$?"
            else
                print_warning "Sitemap.xml non trouvé, passage au crawl..."
                echo ""
                
                # Demander la profondeur
                read -p "Profondeur de crawl (1-3, défaut: 2): " depth
                depth=${depth:-2}
                
                crawl_site "$user_url" "$depth"
            fi
            ;;
        2)
            read -p "Nom du site: " site_name
            manual_mode "$site_name"
            ;;
        3)
            print_info "Au revoir!"
            exit 0
            ;;
        *)
            print_error "Option invalide!"
            main
            ;;
    esac
    
    echo ""
    echo "─────────────────────────────────────────"
    echo ""
    
    # Sauvegarder en fichier
    if [ -f "$TEMP_DIR/result.txt" ]; then
        read -p "Sauvegarder dans un fichier? (o/n): " save_choice
        if [[ $save_choice == "o" ]] || [[ $save_choice == "O" ]]; then
            read -p "Nom du fichier (défaut: $OUTPUT_FILE): " custom_name
            OUTPUT_FILE=${custom_name:-$OUTPUT_FILE}
            
            cp "$TEMP_DIR/result.txt" "$OUTPUT_FILE"
            print_success "Sauvegardé dans: $(pwd)/$OUTPUT_FILE"
        fi
    fi
    
    echo ""
    read -p "Continuer? (o/n): " continue_choice
    if [[ $continue_choice == "o" ]] || [[ $continue_choice == "O" ]]; then
        main
    else
        print_info "Au revoir!"
    fi
}

# ============================================================================
# LANCER
# ============================================================================

main
