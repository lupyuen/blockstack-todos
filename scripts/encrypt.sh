#!/usr/bin/env bash

echo This is a test > /tmp/encrypt.txt

## openssl rsautl -encrypt -inkey ~/.ssh/github_rsa.pub -pubin -in /tmp/encrypt.txt -out /tmp/encrypt.dat
## openssl x509 -in ~/.ssh/github_rsa.pub -pubkey -noout >/tmp/public_key.pem

## ssh-keygen -f ~/.ssh/github_rsa.pub -e -m pem >/tmp/public_key.pem
## cat /tmp/public_key.pem

## openssl rsautl -encrypt -inkey /tmp/public_key.pem -pubin -in /tmp/encrypt.txt -out /tmp/encrypt.dat

## openssl rsautl -oaep -encrypt -inkey ~/.ssh/github_rsa.pub -pubin -in /tmp/encrypt.txt -out /tmp/encrypt.dat

ssh-keygen -e -f ~/.ssh/github_rsa.pub -m PKCS8 > /tmp/public_key.pem

## openssl rsa -in ~/.ssh/github_rsa.pub -pubout > /tmp/public_key.pem
cat /tmp/public_key.pem

openssl rsautl -encrypt -inkey /tmp/public_key.pkcs8 -pubin -in /tmp/encrypt.txt -out /tmp/encrypt.dat

## openssl rsautl -encrypt -inkey /tmp/public_key.pem -pubin -in /tmp/encrypt.txt -out /tmp/encrypt.dat
