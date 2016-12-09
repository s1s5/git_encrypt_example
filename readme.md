# 使い方
# 初期化
## opensslをインストール
コマンドから使えるようにしておく。

## .passwordを作成
- saltは24字以下の16進数
- パスワードは適当に,以下のような.passwordファイルを作成する
```
<salt>
<password>
```
## .gitignoreに.passwordを追加
このrepositoryでは入れちゃってるけど,
これは秘密裏にやりとりする。バージョン管理しないこと!!

## .gitencryptの作成
このレポジトリの.gitencryptを取ってくる

## 適用対象の設定(.gitattributes)
以下のように設定するとencryptディレクトリ内のymlファイルだけ対象となる
```
encrypt/*.yml filter=openssl diff=openssl
```

## .git/configにフィルタを設定
### bashの人
以下の行を追加する
```
[filter "openssl"]
    smudge = .gitencrypt/smudge_filter_openssl.sh
    clean = .gitencrypt/clean_filter_openssl.sh
[diff "openssl"]
    textconv = .gitencrypt/diff_filter_openssl.sh
```

### PowerShellの人
以下の行を追加する
```
[filter "openssl"]
    smudge = .gitencrypt/smudge_filter_openssl.ps1
    clean = .gitencrypt/clean_filter_openssl.ps1
[diff "openssl"]
    textconv = .gitencrypt/diff_filter_openssl.ps1
```

### 後は普通にPUSHすればOK
```
$ git clone --bare . /tmp/a.git
$ git push /tmp/a.git/
```

# cloneして持ってくる
+ cloneする
+ .passwordを秘密裏にコピーしてくる
+ 上記.git/configにフィルタを設定と同じことをする
+ `$ git reset --hard`を実行(最初だけ)

# 諸注意
- encryptされてない奴がはいっちゃったら消すしかないかも
