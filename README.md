💡 Tips & Tricks
Batch Process Multiple Sites
bashfor site in google.com github.com wikipedia.org; do
  echo "Processing $site..."
  ./sitemap-generator.sh << EOF
1
$site
1
n
n
EOF
done
View Files Quickly
bash# Show all generated sitemaps
cat sitemap_*.txt

# Show the most recent one
cat $(ls -t sitemap_*.txt | head -1)
Copy to Clipboard (macOS)
bashcat my-sitemap.txt | pbcopy
Copy to Clipboard (Linux)
bashcat my-sitemap.txt | xclip -selection clipboard
🚀 Quick Start Cheat Sheet
bash# Clone
git clone https://github.com/Facchi-Marco/sitemap-generator
cd sitemap-generator

# Make executable
chmod +x sitemap-generator.sh

# Run
./sitemap-generator.sh

# Then choose option 1, enter your URL, and follow prompts!
❓ FAQ
Q: Can I use this on Windows?
A: Yes! Use Git Bash (comes with Git for Windows).
Q: Does this work with dynamic websites?
A: It works best with static sites. Dynamic sites may require JavaScript rendering (not supported yet).
Q: Can I export to JSON or XML?
A: Currently exports to .txt. You can convert manually or request this feature!
Q: Is my data safe?
A: Yes! Everything runs locally on your computer. No data is sent anywhere.
Q: Why is crawling slow?
A: The script respects server resources. Use lower crawl depth for faster results.



Made with ❤️ by Marco Facchi
⭐ If you find this useful, please consider giving it a star on GitHub!
bash# Happy crawling! 🚀
./sitemap-generator.sh
