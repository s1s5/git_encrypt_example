#!/bin/bash

SALT_FIXED=`head -n 1 .password` # 24 or less hex characters
PASS_FIXED="pass:`tail -n 1 .password`"

openssl enc -base64 -aes-256-ecb -S $SALT_FIXED -k $PASS_FIXED
