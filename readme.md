- .passwordを作成

-- saltは24字以下の16進数

-- パスワードは適当に,以下のような.passwordファイルを作成する

```
<salt>
<password>
```
-- .gitignoreに.passwordを追加、このrepositoryは入れちゃってるけど,
   これは秘密裏にやりとりする。バージョン管理しないこと!!

- gitencryptの作成
```sh
$ mkdir .gitencrypt
$ cd .gitencrypt
$ touch clean_filter_openssl smudge_filter_openssl diff_filter_openssl 
$ chmod 755 *
$ # edit three files
```

-- clean_filter_openssl
```sh
#!/bin/bash

SALT_FIXED=`head -n 1 .password` # 24 or less hex characters
PASS_FIXED="pass:`tail -n 1 .password`"

openssl enc -base64 -aes-256-ecb -S $SALT_FIXED -k $PASS_FIXED
```

-- smudge_filter_openssl
```sh
#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED="pass:`tail -n 1 .password`"

# If decryption fails, use `cat` instead. 
# Error messages are redirected to /dev/null.
openssl enc -d -base64 -aes-256-ecb -k $PASS_FIXED 2> /dev/null || cat
```

-- diff_filter_openssl 
```sh
#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED="pass:`tail -n 1 .password`"

# Error messages are redirect to /dev/null.
openssl enc -d -base64 -aes-256-ecb -k $PASS_FIXED -in "$1" 2> /dev/null || cat "$1"
```

- .gitattributesで適用対象を決める
以下のように設定するとそのファイルだけ対象となる
```
encrypt/*.yml filter=openssl diff=openssl
```

- 後は普通にPUSHすればOK
```
$ git clone --bare . /tmp/a.git
$ git push /tmp/a.git/
```

- cloneする側

-- .passwordを秘密裏にコピーしてくる

-- .git/configを編集
以下の行を追加する
```
[filter "openssl"]
    smudge = .gitencrypt/smudge_filter_openssl
    clean = .gitencrypt/clean_filter_openssl
[diff "openssl"]
    textconv = .gitencrypt/diff_filter_openssl
```
-- `$ git reset --hard`
