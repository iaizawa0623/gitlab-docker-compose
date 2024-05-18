# gitlab-docker-compose
gitlab-docker-compose

## installation

```bash
cp .env.sample .env
vi .env

# オレオレ証明書を作成する場合(公開サーバでは使用しないでください!)
cd gitlab/certs

# e.g. DOMAIN=`hostname`
DOMAIN=your_domain

echo "subjectAltName = DNS:$DOMAIN" > extfile.txt

# サーバー秘密鍵を作成
openssl genrsa 2048 > $DOMAIN.key

# 署名要求書を作成
openssl req -new -key $DOMAIN.key -subj "/C=JP/ST=Tokyo/O=iaizawa/CN=$DOMAIN" > $DOMAIN.csr

# 署名してサーバー証明書を作成
openssl x509 -days 3650 -req -sha256 -signkey $DOMAIN.key -extfile extfile.txt < $DOMAIN.csr > $DOMAIN.crt

# サーバー証明書の中身を確認
openssl x509 -text < $DOMAIN.crt
```

## Run
```bash
docker compose up -d
```

## 参考
- https://docs.gitlab.com/
