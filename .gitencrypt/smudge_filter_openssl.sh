#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED="pass:`tail -n 1 .password`"

# If decryption fails, use `cat` instead. 
# Error messages are redirected to /dev/null.
openssl enc -md md5 -d -base64 -aes-256-ecb -k $PASS_FIXED 2> /dev/null || cat
