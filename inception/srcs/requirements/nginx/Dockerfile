FROM alpine:3.18

RUN apk update && apk upgrade && \  
	apk add nginx && apk add openssl && \ 
	apk add dumb-init

# openssl 명령어를 이용해 새로운 SSL 인증서를 생성한다.
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt \
	-subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/CN=dkham"
# openssl : 보안 관련 작업을 수행하는 툴킷
# req : 인증서 서명 요청 생성 및 처리와 관련된 명령어
# -x509: X.509 인증서를 자체 서명. 이 옵션이 주어지면 req는 CSR을 생성하는 대신 새로운 자체 서명된 인증서를 생성
# -nodes: 이 옵션이 있으면 개인키를 암호화하지 않음
# -days 365 : 인증서의 유효기간
# -newkey rsa:2048: 2048비트 RSA 키를 생성
# -keyout /etc/nginx/cert.key: 생성된 개인키를 /etc/nginx/cert.key에 저장
# -out /etc/nginx/cert.crt: 생성된 인증서를 /etc/nginx/cert.crt에 저장
# ’-subj : 인증서의 주체를 지정. /C=국가, /ST=주, /L=도시, /O=조직, /CN=일반 이름

COPY conf/nginx.conf /etc/nginx/nginx.conf

# 이미지가 런타임에 443 포트를 사용하도록 설정. 이는 HTTPS 통신을 위한 표준 포트
EXPOSE 443

# 컨테이너가 시작될 때 실행할 프로그램을 설정. dumb-init은 신호를 자식 프로세스에 전달하고, 자식 프로세스의 종료를 처리하여 좀비 프로세스를 방지.
ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

# 컨테이너가 시작될 때 CMD 명령어를 실행. nginx를 데몬 모드로 실행하지 않도록 설정 
# Docker 컨테이너는 foreground로 실행되는 프로세스를 필요로 하기 때문
CMD [ "nginx", "-g", "daemon off;" ]