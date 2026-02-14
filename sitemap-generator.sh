#!/bin/bash

# Couleurs pour le terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

OUTPUT_FILE="sitemap_$(date +%Y%m%d_%H%M%S).txt"

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

validate_url() {
    local url=$1
    if [[ $url =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

normalize_url() {
    local url=$1
    if [[ ! $url =~ ^https?:// ]]; then
        url="https://$url"
    fi
    echo "$url"
}

get_domain() {
    local url=$1
    echo "$url" | sed -E 's|https?://||; s|/.*||'
}

try_sitemap_xml() {
    local url=$1
    local domain=$(get_domain "$url")
    
    print_info "Recherche du sitemap.xml..."
    
    local sitemap_url="${url%/}/sitemap.xml"
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$sitemap_url")
    
    if [[ "$http_code" == "200" ]]; then
        print_success "Sitemap trouvé!"
        
        local xml_content=$(curl -s "$sitemap_url")
        
        print_info "Parsing du sitemap..."
        
        echo "SITEMAP: $domain" > "$OUTPUT_FILE"
        echo "Source: $sitemap_url" >> "$OUTPUT_FILE"
        echo "Date: $(date)" >> "$OUTPUT_FILE"
        echo "─────────────────────────────────────────" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        
        echo "$xml_content" | grep -o '<loc>[^<]*</loc>' | sed 's/<loc>//g; s/<\/loc>//g' | while read page; do
            if [ ! -z "$page" ]; then
                local path=$(echo "$page" | sed "s|https\?://$domain||")
                [ -z "$path" ] && path="/"
                echo "  📄 $path" >> "$OUTPUT_FILE"
                echo "  📄 $path"
            fi
        done
        
        print_success "Sitemap parsé!"
        return 0
    else
        return 1
    fi
}

manual_mode() {
    local site_name=$1
    
    echo ""
    print_info "Mode manuel - Entrez la structure (Ctrl+D pour terminer):"
    echo "Format: Section"
    echo "        - Sous-page"
    echo ""
    
    echo "SITEMAP: $site_name" > "$OUTPUT_FILE"
    echo "Date: $(date)" >> "$OUTPUT_FILE"
    echo "─────────────────────────────────────────" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    while IFS= read -r line; do
        echo "$line" >> "$OUTPUT_FILE"
        echo "$line"
    done
}

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
            read -p "URL du site: " user_url
            
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
            
            if try_sitemap_xml "$user_url"; then
                echo ""
                echo "─────────────────────────────────────────"
                echo ""
                print_success "Sauvegardé dans: $(pwd)/$OUTPUT_FILE"
            else
                print_error "Sitemap.xml non trouvé"
                print_info "Utilisez option 2 pour mode manuel"
            fi
            ;;
        2)
            read -p "Nom du site: " site_name
            manual_mode "$site_name"
            echo ""
            echo "─────────────────────────────────────────"
            echo ""
            print_success "Sauvegardé dans: $(pwd)/$OUTPUT_FILE"
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
    read -p "Continuer? (o/n): " continue_choice
    if [[ $continue_choice == "o" ]] || [[ $continue_choice == "O" ]]; then
        main
    else
        print_info "Au revoir!"
    fi
}

main
