$SALT_FIXED=$(Get-Content .password -head 1)
$PASS_FIXED="pass:$(Get-Content .password -tail 1)"

openssl enc -base64 -aes-256-ecb -S $SALT_FIXED -k $PASS_FIXED
