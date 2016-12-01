```sh
$ mkdir .gitencrypt
$ cd .gitencrypt
$ touch clean_filter_openssl smudge_filter_openssl diff_filter_openssl 
$ chmod 755 *
$ # edit three files
$ git init
```

- clean_filter_openssl
```sh
#!/bin/bash

SALT_FIXED=<your-salt> # 24 or less hex characters
PASS_FIXED=<your-passphrase>

openssl enc -base64 -aes-256-ecb -S $SALT_FIXED -k $PASS_FIXED
```

- smudge_filter_openssl
```sh
#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED=<your-passphrase>

# If decryption fails, use `cat` instead. 
# Error messages are redirected to /dev/null.
openssl enc -d -base64 -aes-256-ecb -k $PASS_FIXED 2> /dev/null || cat
```

- diff_filter_openssl 
```sh
#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED=<your-passphrase>

# Error messages are redirect to /dev/null.
openssl enc -d -base64 -aes-256-ecb -k $PASS_FIXED -in "$1" 2> /dev/null || cat "$1"
```

- .gitattributes
```
* filter=openssl diff=openssl
[merge]
    renormalize = true
```

- .git/config
```
[filter "openssl"]
    smudge = .gitencrypt/smudge_filter_openssl
    clean = .gitencrypt/clean_filter_openssl
[diff "openssl"]
    textconv = .gitencrypt/diff_filter_openssl
```
