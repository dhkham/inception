#!/bin/sh
# 이 첫 번째 줄은 Bourne Shell(/bin/sh) 인터프리터를 사용하여 실행하라는 것을 정의한다.

# /var/www/html/wp-config.php 파일이 존재하지 않는 경우(즉, 워드프레스가 설치되지 않은 경우) 다음의 명령을 실행한다
if [ ! -f /var/www/html/wp-config.php ]; then

  # 워드프레스의 최신 버전을 다운로드하여 /var/www/html 경로에 설치
  /usr/local/bin/wp core download --allow-root --path=/var/www/html --force

  # wp-config.php 파일을 생성하고, DB 접속 정보를 설정
  /usr/local/bin/wp config create --allow-root --path=/var/www/html --dbhost=$MYSQL_HOST:$MYSQL_PORT --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --force

  # 워드프레스를 설치하고, 사이트 제목, 관리자 계정 정보를 설정
  /usr/local/bin/wp core install --allow-root --path=/var/www/html --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email

  # 추가 사용자를 생성하고, 이메일, 비밀번호, 역할을 설정
  /usr/local/bin/wp user create --path=/var/www/html $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author

  # 워드프레스 테마를 활성화한다.
  /usr/local/bin/wp theme activate --path=/var/www/html twentytwentytwo
else
  echo "WordPress is already installed"
  # 이미 워드프레스가 설치되어 있다면 메시지를 출력
fi

# start php-fpm
# PHP-FPM을 데몬 프로세스로 실행하지 않고 포어그라운드에서 실행한다.
# Docker 컨테이너와 같은 환경에서는 주 프로세스를 포어그라운드에서 실행하는 것이 일반적이다.
# php-fpm을 백그라운드 모드로 실행하면, Docker는 주 프로세스가 종료된 것으로 간주하여 컨테이너를 종료한다.
/usr/sbin/php-fpm82 --nodaemonize