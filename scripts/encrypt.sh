#!/usr/bin/env bash

echo This is a test > /tmp/encrypt.txt

ssh-keygen -e -f ~/.ssh/github_rsa.pub -m PKCS8 > /tmp/public_key.pem
cat /tmp/public_key.pem

openssl rsautl -encrypt -inkey /tmp/public_key.pkcs8 -pubin -in /tmp/encrypt.txt -out /tmp/encrypt.dat

####

ssh-keygen -e -f ~/.ssh/github_rsa.pub -m PKCS8 > /tmp/public_key.pem
cat /tmp/public_key.pem
