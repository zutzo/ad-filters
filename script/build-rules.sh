#!/bin/bash
#进入目录
cd $(cd "$(dirname "$0")";pwd)
#下载规则
urls=(
    "https://raw.githubusercontent.com/Cats-Team/AdRules/main/dns.txt"
    #"https://raw.githubusercontent.com/LoopDns/Fuck-you-MIUI/main/Fhosts"
    #"https://raw.githubusercontent.com/francis-zhao/quarklist/master/dist/quarklist.txt"
   # "https://raw.githubusercontent.com/blocklistproject/Lists/master/adguard/ads-ags.txt"
    #"https://gitlab.com/quidsup/notrack-blocklists/-/raw/master/trackers.list"
    "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/multi.txt"
)

for url in "${urls[@]}"; do
    curl -sS "$url" >> dns.txt
done
#添加自定义规则
cat ../rules/myrules.txt >> dns.txt
#修复换行符问题
sed -i 's/\r//' dns.txt
#去重
python sort.py dns.txt 
#压缩优化
hostlist-compiler -c dns.json -o dns-output.txt
#仅输出黑名单
cat dns-output.txt | grep -P "^\|\|.*\^$" > dns.txt
#再次排序
python sort.py dns.txt 
#移动规则
mv dns.txt ../rules/dns.txt
#清除缓存
rm -rf ./*.txt
