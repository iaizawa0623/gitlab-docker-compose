# gitlab-docker-compose
gitlab-docker-compose

## installation

### 環境変数設定
```bash
cp .env.sample .env
vi .env
```

### オレオレ証明書を作成する場合(公開サーバでは使用しないでください!)
```bash
mkdir -p gitlab/config/ssl
cd gitlab/config/ssl

# rootCAの秘密鍵を作成
openssl genrsa -out ca.key -aes256 2048

# rootCAの秘密鍵の内容を確認
openssl rsa -text -noout -in ca.key

# rootCAの証明書署名要求の作成
openssl req -new -key ca.key -out ca.csr -subj "/C=JP/ST=Tokyo/O=iaizawa/CN=ca"

# rootCAのCSRの内容を確認
openssl req -text -noout -in ca.csr

# 「X509.V3」の設定
cat > rootca_v3.ext << EOF
basicConstraints       = critical, CA:true
subjectKeyIdentifier   = hash
keyUsage               = critical, keyCertSign, cRLSign
EOF

# rootCAの証明書の作成（自己署名）
openssl x509 -req -in ca.csr -signkey ca.key -days 365 -sha256 -extfile rootca_v3.ext -out ca.crt

# rootCAの証明書の内容を確認
openssl x509 -text -noout -in ca.crt

# オレオレ証明書を作成する
if [ `hostname | grep '.local'` ] ; then
  DOMAIN=`hostname`
else
  DOMAIN=`hostname`.local
fi
echo "subjectAltName = DNS:$DOMAIN" > extfile.txt

# サーバー秘密鍵を作成
openssl genrsa 2048 > $DOMAIN.key

# 署名要求書を作成
openssl req -new -key $DOMAIN.key -subj "/C=JP/ST=Tokyo/O=iaizawa/CN=$DOMAIN" > $DOMAIN.csr

# プライベート認証局で署名してサーバー証明書を作成
openssl x509 -in $DOMAIN.csr -CA ca.crt -CAkey ca.key -days 3650 -req -sha256 -extfile extfile.txt > $DOMAIN.crt

# サーバー証明書の中身を確認
openssl x509 -text < $DOMAIN.crt

cd -
```

## Run
```bash
docker compose up -d
```

## 参考
- https://docs.gitlab.com/
