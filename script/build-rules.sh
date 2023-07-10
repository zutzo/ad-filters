#!/bin/bash
cd $(cd "$(dirname "$0")";pwd)

urls=(
    "https://adguardteam.github.io/HostlistsRegistry/assets/filter_32.txt"
    "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
    "https://raw.githubusercontent.com/Cats-Team/AdRules/main/dns.txt"
    "https://raw.githubusercontent.com/sjhgvr/oisd/main/abp_big.txt"
    "https://raw.githubusercontent.com/LoopDns/Fuck-you-MIUI/main/Fhosts"
    "https://adguardteam.github.io/HostlistsRegistry/assets/filter_38.txt"
    "https://raw.githubusercontent.com/francis-zhao/quarklist/master/dist/quarklist.txt"
    "https://raw.githubusercontent.com/blocklistproject/Lists/master/adguard/ads-ags.txt"
    "https://gitlab.com/quidsup/notrack-blocklists/-/raw/master/trackers.list"
    "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/multi.txt"
)

for url in "${urls[@]}"; do
    curl -sS "$url" >> dns.txt
done

python sort.py dns.txt 
hostlist-compiler -c dns.json -o dns-output.txt
cat dns-output.txt | grep -P "^\|\|.*\^$" > dns.txt
python sort.py dns.txt 
mv dns.txt ../rules/dns.txt
rm -rf ./*.txt
