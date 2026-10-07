#!/bin/bash

# 1. 移除旧的统计信息（从---到文件末尾）
sed -i '/^---$/,$d' README.md

# 2. 追加新的统计信息
echo -e "\n---\n**DNS规则统计**\n\n规则总数: $(grep -vc '^!' ./rules/dns.txt)\n\n最后更新: $(date '+%Y-%m-%d %H:%M:%S')" >> README.md

# 3. 显示最新统计
tail -n 4 README.md
