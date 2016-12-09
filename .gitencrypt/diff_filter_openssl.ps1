$PASS_FIXED="pass:$(Get-Content .password -tail 1)"
openssl enc -d -base64 -aes-256-ecb -k $PASS_FIXED -in "$1" 2> /dev/null || cat "$1"
