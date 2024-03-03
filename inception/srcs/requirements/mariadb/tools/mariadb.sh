#!/bin/sh
# Bourne Shell(/bin/sh) 인터프리터를 사용하여 실행

# 'cat << EOF > 파일명' 명령어는 여러 줄을 파일에 작성하는 데 사용
# 이 경우에는 'config.sql'에 SQL 스크립트를 작성하는 데 사용. 'EOF'는 작성할 텍스트의 시작과 끝을 나타내는 표시자
cat << EOF > config.sql
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysqld --bootstrap < config.sql
# 'mysqld --bootstrap' 이 모드는 주로 데이터베이스 초기화나 시스템 테이블 생성과 같은 저수준의 작업을 수행할 때 사용
# 이 모드에서는 SQL 명령을 실행하지만 완전히 초기화하지는 않음. '< config.sql' 부분은 'config.sql'의 내용을 'mysqld' 명령에 입력하도록 쉘에 지시

chown -R mysql:mysql /run/mysqld /var/lib/mysql
# /run/mysqld 및 /var/lib/mysql 디렉토리의 소유자를 'mysql' 사용자와 그룹으로 변경 
# '-R' 옵션은 'chown'에게 재귀적으로 작동하도록 지시하여 디렉토리와 그 내용의 소유자를 변경

mysqld --user=mysql --datadir=/var/lib/mysql
# 'mysql' 사용자로 MariaDB 서버를 시작하고, 데이터 디렉토리로 '/var/lib/mysql'을 지정
# 데이터 디렉토리는 MariaDB가 데이터베이스 파일을 저장하는 위치