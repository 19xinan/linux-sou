# linux-sou
Linux信息内网收集脚本,收集包括配置信息数据库配置，各种密码如敏感信息，云主机key搜索、一键完成内网信息收集。
# 使用方法
## 快速使用
```
wget https://github.com/19xinan/linux-sou/blob/main/linux-sou.sh;chmod +x ./linux-sou.sh;./linux-sou.sh
```
## 自定义用法（推荐）
1.下载
```
wget https://github.com/19xinan/linux-sou/blob/main/linux-sou.sh
```
2.加权限
```
chmod +x ./linux-sou.sh
```
3.修改配置
```
# 定义要搜索的文件类型（搜索文件）
file_types=("*.env" "*.properties" "config.json" "conf.json" "config.yaml" "conf.yaml" "config.yml" "conf.yml" "*.bash_history" "*config*" "web.xml" "*database*" "*pass*" "conf.json" "conf.json" "*.conf" "*.txt" "*.log" "*.xml" "*.config" "*.cfg" "*.ini" "*history")

# 定义要查找的模式（定义关键字）
patterns=("DB_HOST" "DB_USER" "DB_PASS" "DATABASE_URL" "API_KEY" "SECRET_KEY" "ACCESS_KEY" "PRIVATE_KEY" "jdbc:" "LTA" "password" "username" "token" "oauth" "auth_token" "api_token" "api_key" "Authorization" "client_secret" "client_id")

# 定义要搜索的位置
search_locations=("/" )#从根目录搜索，匹配误差大
#search_locations=("/www" "/home" "/root" "/var" )
#search_locations=("/www" "/home" "/root" "/etc" "/var" "/opt" "/usr" "/tmp")
```
4.执行
```
./linux-sou.sh
```
5.搜索结果会打印在输出文件formatted_sensitive_info.txt中。
