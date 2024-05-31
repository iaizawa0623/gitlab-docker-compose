# gitlab-docker-compose
gitlab-docker-compose

## installation

### 環境変数設定
```bash
mkdir -p gitlab-runner
touch gitlab-runner/config.toml
cp .env.sample .env
vi .env
```

### プライベート認証局と証明書の作成
公開サーバでは使用しないでください!

```bash
mkdir -p ssl
mkdir -p certs
cd ssl

# -------------------------------------------
# 環境変数設定
# -------------------------------------------
ORG="`whoami`"
ROOT_CA="`whoami`_ROOT_CA"
INTER_CA="`whoami`_INTER_CA"
DOMAIN='gitlab.local'

# 20 years
ROOT_DAYS=7300
# 10 years
INTER_DAYS=3650
# 1 years+
SERVER_DAYS=397

# ルート証明書の設定
cat > ${ROOT_CA}.ext << EOF
basicConstraints       = CA:true
subjectKeyIdentifier   = hash
keyUsage               = keyCertSign, cRLSign
EOF

# 中間証明書の設定
cat > ${INTER_CA}.ext << EOF
basicConstraints       = CA:true
subjectKeyIdentifier   = hash
keyUsage               = keyCertSign, cRLSign
EOF

# サーバー証明書の設定
cat > ${DOMAIN}.ext << EOF
authorityKeyIdentifier = keyid, issuer
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth, clientAuth
subjectAltName         = @alt_names
[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOF

# -------------------------------------------
# ルート証明書を作成
# -------------------------------------------

# ルート証明書の秘密鍵を作成
openssl genrsa -out $ROOT_CA.key -aes256 2048

# ルート証明書の秘密鍵の内容を確認
# openssl rsa -text -noout -in $ROOT_CA.key

# ルート証明書の署名要求の作成
openssl req -new -key $ROOT_CA.key -out $ROOT_CA.csr -subj "/C=JP/ST=Tokyo/O=$ORG/CN=$ROOT_CA"

# ルート証明書のCSRの内容を確認
# openssl req -text -noout -in $ROOT_CA.csr

# ルート証明書の作成（自己署名）
openssl x509 -req -in $ROOT_CA.csr -signkey $ROOT_CA.key -days ${ROOT_DAYS} -sha256 -extfile $ROOT_CA.ext -out $ROOT_CA.crt

# ルート証明書の内容を確認
# openssl x509 -text -noout -in $ROOT_CA.crt

# -------------------------------------------
# 中間証明書を作成する
# -------------------------------------------

# 中間証明書の秘密鍵を作成
openssl genrsa -out $INTER_CA.key -aes256 2048

# 中間証明書の秘密鍵の内容を確認
# openssl rsa -text -noout -in $INTER_CA.key

# 中間証明書の証明書署名要求の作成
openssl req -new -key $INTER_CA.key -out $INTER_CA.csr -subj "/C=JP/ST=Tokyo/O=$ORG/CN=$INTER_CA"

# 中間証明書のCSRの内容を確認
# openssl req -text -noout -in $INTER_CA.csr

# 中間証明書の証明書の作成（ルート証明書で署名）
openssl x509 -req -in $INTER_CA.csr -CA $ROOT_CA.crt -CAkey $ROOT_CA.key -CAcreateserial -days ${INTER_DAYS} -sha256 -out $INTER_CA.crt -extfile ${INTER_CA}.ext

# -------------------------------------------
# サーバー証明書を作成
# -------------------------------------------

# サーバー秘密鍵を作成
openssl genrsa 2048 > $DOMAIN.key

# 署名要求書を作成
openssl req -new -key $DOMAIN.key -subj "/C=JP/ST=Tokyo/O=$ORG/CN=$DOMAIN" > $DOMAIN.csr

# 中間証明書で署名してサーバー証明書を作成
openssl x509 -req -in $DOMAIN.csr -CA $INTER_CA.crt -CAkey $INTER_CA.key -CAcreateserial -days ${SERVER_DAYS} -req -sha256 -extfile ${DOMAIN}.ext > $DOMAIN.crt

# サーバー証明書の中身を確認
# openssl x509 -text < $DOMAIN.crt

# チェーンを追加
cat $INTER_CA.crt $ROOT_CA.crt >> $DOMAIN.crt

c_rehash .
openssl verify -show_chain -CApath . $DOMAIN.crt

cd -
cp ssl/*.crt certs/
cp ssl/$DOMAIN.* certs/
```

## Run
```bash
docker compose up -d
```

## 参考
- https://docs.gitlab.com/
