#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED="pass:`tail -n 1 .password`"

# Error messages are redirect to /dev/null.
openssl enc -d -base64 -aes-256-ecb -k $PASS_FIXED -in "$1" 2> /dev/null || cat "$1"
