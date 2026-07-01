import os
import sys
import re
import datetime

# 获取当前时间
now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

# 读取文件名
file_name = sys.argv[1]

# 打开文件并读取所有行
with open(file_name, 'r', encoding='utf8') as f:
    lines = f.readlines()

# 使用正则表达式移除含有 ! 的行
lines = [line for line in lines if not re.match(r'^[\s]*[#!]', line)]

# 对列表进行去重和排序
lines = sorted(list(set(lines)))

# 在开头添加信息
lines.insert(0, f'! Title: Big Ad filter\n')
lines.insert(1, f'! Total count: {len(lines)}\n')
lines.insert(2, f'! Update Time(UTC+8): {now}\n')

# 写入文件
with open(file_name, 'w', encoding='utf8') as f:
    f.writelines(lines)