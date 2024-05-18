# gitlab-docker-compose
gitlab-docker-compose

## installation

```bash
mkdir gitlab-runner

cd gitlab/ssl

# 秘密鍵を作成
openssl genrsa 2048 > server.key

# 署名要求書を作成
openssl req -new -key server.key -subj "/C=JP/ST=Some-State/O=Some-Org/CN=gitlab.local" > server.csr

# 署名してサーバー証明書を作成
openssl x509 -days 3650 -req -sha256 -signkey server.key < server.csr > server.crt

# サーバー証明書の中身を確認
openssl x509 -text < server.crt
```

## 参考
- https://docs.gitlab.com/
