#!/bin/bash

echo "Installing go tools"
go get -u github.com/projectdiscovery/subfinder/v2/cmd/subfinder
go get -u github.com/projectdiscovery/nuclei/v2/cmd/nuclei
go get -u github.com/projectdiscovery/httpx/cmd/httpx
go get -u github.com/tomnomnom/assetfinder
go get -u github.com/tomnomnom/httprobe
go get -u github.com/tomnomnom/waybackurls
go get -u github.com/ffuf/ffuf
go get -u github.com/lc/gau
go get -u github.com/hakluke/hakrawler
go get -u github.com/OJ/gobuster
go get -u github.com/asciimoo/wuzz
