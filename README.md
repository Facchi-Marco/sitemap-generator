# 🗂️ Sitemap Generator

A powerful and easy-to-use command-line tool to automatically generate website sitemaps. Drop a URL and get your site structure in seconds!

## ✨ Features

- **Automatic Sitemap Detection** - Finds and parses existing `sitemap.xml` files
- **Smart Web Crawling** - Falls back to automatic crawling if sitemap not found
- **Manual Mode** - Create custom site structures by hand
- **File Export** - Save results as `.txt` files
- **Cross-Platform** - Works on macOS, Linux, and Windows (Git Bash)
- **Zero Dependencies** - Only uses `curl` and `grep` (pre-installed on most systems)

## 📋 Prerequisites

- Bash shell
- `curl` (for fetching URLs)
- `grep` (for parsing)

Most systems have these built-in. If not:

**macOS:**
```bash
brew install curl
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install curl grep
```

**Windows:** Use Git Bash (comes with Git)

## 🚀 Installation

### Option 1: Clone from GitHub (Recommended)

```bash
git clone https://github.com/Facchi-Marco/sitemap-generator
cd sitemap-generator
chmod +x sitemap-generator.sh
```

### Option 2: Download Directly

```bash
# Download the script
curl -O https://raw.githubusercontent.com/Facchi-Marco/sitemap-generator/main/sitemap-generator.sh

# Make it executable
chmod +x sitemap-generator.sh
```

## 📖 Usage

### Start the Program

```bash
./sitemap-generator.sh
```

You'll see a menu with three options:

```
╔════════════════════════════════════════╗
║     🗂️  SITEMAP GENERATOR              ║
║     Générateur de structure web        ║
╚════════════════════════════════════════╝

Choisissez une option:
1. Analyser un site (auto)
2. Créer manuellement
3. Quitter

Option (1-3):
```

### Option 1: Analyze a Website (Automatic)

```bash
Option (1-3): 1
URL du site (ex: exemple.com ou https://exemple.com): google.com
```

The script will:
1. ✅ Try to find and parse `sitemap.xml`
2. ✅ If not found, automatically crawl the site
3. ✅ Display results in the terminal
4. ✅ Ask if you want to save to a file

**Example Output:**
```
ℹ Recherche du sitemap.xml...
✓ Sitemap trouvé!
ℹ Parsing du sitemap...

SITEMAP: google.com
Source: https://google.com/sitemap.xml
Date: Mon Feb 14 12:30:45 CET 2025
─────────────────────────────────────────

  📄 /
  📄 /about
  📄 /products
  📄 /contact
  📄 /blog
```

**Save to File:**
```
Sauvegarder dans un fichier? (o/n): o
Nom du fichier (défaut: sitemap_20250214_123045.txt): my-sitemap.txt
✓ Sauvegardé dans: /Users/yourname/my-sitemap.txt
```

### Option 2: Create Manually

```bash
Option (1-3): 2
Nom du site: My Awesome Website
```

Then enter your site structure (press `Ctrl+D` when done):

```
Accueil
About
Services
- Web Design
- Development
- Consulting
Blog
Contact
```

**Output:**
```
SITEMAP: My Awesome Website
─────────────────────────────────────────

Accueil
About
Services
- Web Design
- Development
- Consulting
Blog
Contact
```

### Option 3: Exit

```bash
Option (1-3): 3
```

Closes the program.

## 🎯 Examples

### Analyze GitHub

```bash
./sitemap-generator.sh
# Choose option 1
# Enter: github.com
# Choose crawl depth when asked
```

### Analyze Your Own Website

```bash
./sitemap-generator.sh
# Choose option 1
# Enter: https://yourwebsite.com
# Wait for results
```

### Create a Portfolio Sitemap

```bash
./sitemap-generator.sh
# Choose option 2
# Enter: My Portfolio
# Type your structure manually
```

## 📁 Output Files

Files are saved in the directory where you run the script with names like:
```
sitemap_20250214_120530.txt
sitemap_20250214_120545.txt
my-sitemap.txt
```

Find them in your current folder:
```bash
# List all sitemap files
ls sitemap*.txt

# Open a file
cat sitemap_20250214_120530.txt

# Or open in your text editor
code my-sitemap.txt
```

## ⚙️ Advanced Usage

### Custom Crawl Depth

When crawling a website, you can control how deep the crawler goes:

```
Profondeur de crawl (1-3, défaut: 2): 1  # Shallow - faster
Profondeur de crawl (1-3, défaut: 2): 2  # Medium - balanced
Profondeur de crawl (1-3, défaut: 2): 3  # Deep - thorough (slower)
```

### Running Without Interactive Menu

For scripting purposes, you can modify the script to accept command-line arguments.

## 🔧 Troubleshooting

### "Command not found: ./sitemap-generator.sh"

Make sure the file is executable:
```bash
chmod +x sitemap-generator.sh
```

### "URL vide!" Error

You must enter a URL. Examples:
- `google.com` ✅
- `https://github.com` ✅
- `youtube.com` ✅

### Crawling Takes Too Long

Reduce the crawl depth:
```
Profondeur de crawl (1-3, défaut: 2): 1
```

### No Results Found

Some sites block automated crawling. Try:
1. Checking if the site has a public `sitemap.xml`
2. Using a shallower crawl depth (1 instead of 2)
3. Creating the sitemap manually

## 📝 File Format

Output files are plain text with a simple format:

```
SITEMAP: example.com
Source: https://example.com/sitemap.xml
Date: Mon Feb 14 12:30:45 CET 2025
─────────────────────────────────────────

  📄 /
  📄 /about
  📄 /products
  📄 /contact
```

You can:
- Edit them in any text editor
- Import them into spreadsheets
- Convert them to other formats
- Share them with your team

## 🤝 Contributing

Found a bug? Have an idea? Feel free to:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

```
MIT License

Copyright (c) 2025 Facchi-Marco

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 💡 Tips & Tricks

### Batch Process Multiple Sites

```bash
for site in google.com github.com wikipedia.org; do
  echo "Processing $site..."
  ./sitemap-generator.sh << EOF
1
$site
1
n
n
EOF
done
```

### View Files Quickly

```bash
# Show all generated sitemaps
cat sitemap_*.txt

# Show the most recent one
cat $(ls -t sitemap_*.txt | head -1)
```

### Copy to Clipboard (macOS)

```bash
cat my-sitemap.txt | pbcopy
```

### Copy to Clipboard (Linux)

```bash
cat my-sitemap.txt | xclip -selection clipboard
```

## 🚀 Quick Start Cheat Sheet

```bash
# Clone
git clone https://github.com/Facchi-Marco/sitemap-generator
cd sitemap-generator

# Make executable
chmod +x sitemap-generator.sh

# Run
./sitemap-generator.sh

# Then choose option 1, enter your URL, and follow prompts!
```

## ❓ FAQ

**Q: Can I use this on Windows?**
A: Yes! Use Git Bash (comes with Git for Windows).

**Q: Does this work with dynamic websites?**
A: It works best with static sites. Dynamic sites may require JavaScript rendering (not supported yet).

**Q: Can I export to JSON or XML?**
A: Currently exports to `.txt`. You can convert manually or request this feature!

**Q: Is my data safe?**
A: Yes! Everything runs locally on your computer. No data is sent anywhere.

**Q: Why is crawling slow?**
A: The script respects server resources. Use lower crawl depth for faster results.

## 📞 Support

If you have questions or issues:
1. Check the Troubleshooting section above
2. Review examples in this README
3. Open an issue on GitHub

---

**Made with ❤️ by Marco Facchi**

⭐ If you find this useful, please consider giving it a star on GitHub!

```bash
# Happy crawling! 🚀
./sitemap-generator.sh
```
