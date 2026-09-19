#!/bin/bash

# 切换到脚本所在目录
cd $(cd "$(dirname "$0")";pwd)

# 定义规则源的URL列表并下载规则文件，合并保存到 dns.txt 中
urls=(
    "https://raw.githubusercontent.com/Cats-Team/AdRules/main/dns.txt"
    "https://big.oisd.nl"
    #"https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/multi.txt"
)

for url in "${urls[@]}"; do
    curl -sSL "$url" >> dns.txt
done

# 添加自定义规则
cat ../rules/myrules.txt >> dns.txt

# 修复换行符，统一格式
sed -i 's/\r//' dns.txt

# 去重并排序规则
python sort.py dns.txt 

# 下载 oisd 白名单
curl -s https://oisd.nl/excludes.php | grep -o '<a href=[^>]*>[^<]*' | sed 's/.*>//' | sort -u > oisd.txt

# 使用 hostlist-compiler 优化生成的规则
hostlist-compiler -c dns.json -o dns-output.txt

# 提取仅包含黑名单规则的行到 dns.txt
cat dns-output.txt | grep -v '\[' > dns.txt

# 再次排序规则
python sort.py dns.txt 

# 处理并生成纯域名列表文件
cat dns.txt | grep -vE '(@|\*|\[)' | grep -Po "(?<=\|\|).+(?=\^)" | grep -v "\*" > ./domain.txt
cat domain.txt | sed "s/^/\+\./g" > ./domainset.txt
#cat domain.txt |sed "s/^/DOMAIN-SUFFIX,/g" > ./filter.list

wget https://github.com/SagerNet/sing-box/releases/download/v1.11.11/sing-box-1.11.11-linux-amd64.tar.gz
tar -zxf sing-box-1.11.11-linux-amd64.tar.gz
mv sing-box-1.11.11-linux-amd64/sing-box sing-box
chmod +x sing-box
./sing-box rule-set convert dns.txt -t adguard
mv dns.srs ../rules/adfilter-singbox.srs
rm sing-box sing-box-1.11.11-linux-amd64*

# 下载 mihomo 工具的最新版本并解压
wget https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/version.txt
version=$(cat version.txt)
wget "https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/mihomo-linux-amd64-$version.gz"
gzip -d "mihomo-linux-amd64-$version.gz"
chmod +x "mihomo-linux-amd64-$version"

# 使用 mihomo 工具将规则集转换为指定格式
./"mihomo-linux-amd64-$version" convert-ruleset domain text domainset.txt mihomo.mrs

# 移动生成的规则文件
mv dns.txt mihomo.mrs ../rules/

# 清理缓存文件
rm -rf ./*.txt 

rm "mihomo-linux-amd64-$version"
