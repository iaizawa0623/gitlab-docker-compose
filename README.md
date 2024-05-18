# gitlab-docker-compose
gitlab-docker-compose

## installation

```bash
# 管理者の初期パスワードを設定
echo 'your_root_password' > root_password.txt

# サーバー証明書の作成
cd gitlab/ssl

# 秘密鍵を作成
openssl genrsa 2048 > gitlab.local.key

# 署名要求書を作成
openssl req -new -key gitlab.local.key -subj "/C=JP/ST=Tokyo/O=iaizawa/CN=gitlab.local" > gitlab.local.csr

# 署名してサーバー証明書を作成
openssl x509 -days 3650 -req -sha256 -signkey gitlab.local.key < gitlab.local.csr > gitlab.local.crt

# サーバー証明書の中身を確認
openssl x509 -text < gitlab.local.crt
```

## 参考
- https://docs.gitlab.com/
