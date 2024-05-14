# gitlab-docker-compose
gitlab-docker-compose

## installation

```
mkdir -p gitlab/ssl
mkdir gitlab-runner

cd gitlab/ssl
openssl genrsa 2048 > server.key
openssl req -new -key server.key > server.csr
openssl x509 -days 3650 -req -sha256 -signkey server.key < server.csr > server.crt
openssl x509 -text < server.crt
```