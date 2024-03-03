FROM alpine:3.18

RUN apk update && apk upgrade && \
	apk add mariadb && apk add mariadb-client && \
	apk add dumb-init && apk add --no-cache bash && apk add --no-cache shadow

# mariadb-install-db 명령을 사용하여 MariaDB 데이터 디렉토리를 초기화
# --datadir 옵션으로 데이터 디렉토리를 /var/lib/mysql로 설정
# --auth-root-authentication-method=normal 옵션은 MariaDB의 루트 사용자에 대한 인증 방법을 설정
# ‘normal’을 설정하면, 루트 사용자는 비밀번호를 사용하여 인증해야 함. 보안상 더 안전한 방법으로, 원격 또는 로컬 접속 시에 비밀번호 요구
RUN	mariadb-install-db --datadir=/var/lib/mysql --auth-root-authentication-method=normal

# 기존 user인 mysql을 지우고 uid 999를 갖는 user mysql 생성
RUN userdel mysql
RUN useradd -u 999 mysql

# /run/mysqld와 /var/lib/mysql 디렉토리를 생성
# /run/mysqld는 MariaDB서버가 소켓 파일을 저장하는 디렉토리
# /var/lib/mysql은 MariaDB 데이터 디렉토리
# -p 옵션은 경로에 해당하는 디렉토리가 없다면, 전부 만들어줌
RUN	mkdir -p /run/mysqld /var/lib/mysql

# 호스트 시스템에서 conf/my.cnf 파일을 컨테이너 내부의 /etc/my.cnf 경로로 복사
COPY conf/my.cnf /etc/my.cnf

# 호스트 시스템에서 tools/mariadb.sh 파일을 컨테이너 내부의 /etc/mariadb.sh 경로로 복사
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

# mariadb.sh 스크립트에 실행 권한을 부여
RUN chmod +x /usr/local/bin/mariadb.sh

# 컨테이너가 호스트와 통신할 수 있도록 3306번 포트 노출
# 이 포트는 MariaDB 서버가 기본적으로 사용하는 포트
EXPOSE 3306

# 컨테이너가 실행될 때의 진입점과 기본 실행 명령을 설정
# /usr/bin/dumb-init은 MariaDB 프로세스를 초기화하는 데 사용
ENTRYPOINT [ "/usr/bin/dumb-init", "--", "/usr/local/bin/mariadb.sh" ]
