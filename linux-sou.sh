#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # 没有颜色

# 定义要搜索的文件类型
file_types=("*.env" "*.properties" "config.json" "conf.json" "config.yaml" "conf.yaml" "config.yml" "conf.yml" "*.bash_history" "*config*" "web.xml" "*database*" "*pass*" "conf.json" "conf.json" "*.conf" "*.txt" "*.xml" "*.config" "*.cfg" "*.ini" "*history")
#file_types=("*.env" "*.properties" "config.json" "conf.json" "config.yaml" "conf.yaml" "config.yml" "conf.yml" "*.bash_history" "*config*" "web.xml" "*database*" "*pass*" "conf.json" "conf.json" "*.conf" "*.txt" "*.log" "*.xml" "*.config" "*.cfg" "*.ini" "*history")

# 定义要查找的模式
patterns=("DB_HOST" "DB_USER" "DB_PASS" "DATABASE_URL" "API_KEY" "SECRET_KEY" "ACCESS_KEY" "PRIVATE_KEY" "jdbc:" "LTA" "password" "username" "client_secret" "client_id")
# patterns=("DB_HOST" "DB_USER" "DB_PASS" "DATABASE_URL" "API_KEY" "SECRET_KEY" "ACCESS_KEY" "PRIVATE_KEY" "jdbc:" "LTA" "password" "username" "token" "oauth" "auth_token" "api_token" "api_key" "Authorization" "client_secret" "client_id")

# 创建日志文件
output_file="formatted_sensitive_info.txt"
> "$output_file"

echo "开始搜索敏感信息..."

# 定义要搜索的位置
search_locations=("/www" "/home" "/root" "/var" )
#search_locations=("/www" "/home" "/root" "/etc" "/var" "/opt" "/usr" "/tmp")

# 遍历文件类型
for file_type in "${file_types[@]}"; do
    echo "搜索文件类型: $file_type"
    # 查找匹配的文件并遍历
    for location in "${search_locations[@]}"; do
        while IFS= read -r file; do
            # 检查文件内容是否包含指定的模式
            contains_pattern=false
            for pattern in "${patterns[@]}"; do
                if grep -q "$pattern" "$file"; then
                    contains_pattern=true
                    break
                fi
            done

            if [ "$contains_pattern" = true ]; then
                echo "检查文件: $file"
                # 遍历模式
                for pattern in "${patterns[@]}"; do
                    # 查找模式匹配
                    matches=$(grep -in "$pattern" "$file" | grep -v "^\s*$")
                    if [[ ! -z "$matches" ]]; then
                        echo -e "${RED}在文件 $file 中找到匹配模式 $pattern:${NC}"
                        echo "$matches"
                        # 记录到格式化输出文件
                        echo "File: $file" >> "$output_file"
                        while IFS= read -r line; do
                            line_number=$(echo "$line" | cut -d: -f1)
                            matched_line=$(echo "$line" | cut -d: -f2-)
                            echo "Line $line_number: $matched_line" >> "$output_file"
                        done <<< "$matches"
                        echo "" >> "$output_file"
                    fi
                done
            fi
        done < <(find "$location" -type f -name "$file_type" 2>/dev/null)
        # 添加延迟
        sleep 0.1
    done
done

echo -e "${GREEN}搜索完成。结果已记录到${output_file}${NC}"