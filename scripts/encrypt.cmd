echo This is a test > \temp\encrypt.txt

ssh-keygen -e -f "%userprofile%\.ssh\github_rsa.pub" -m PKCS8 > \temp\public_key.pkcs8

cat \temp\public_key.pkcs8

openssl rsautl -encrypt -inkey \temp\public_key.pkcs8 -pubin -in \temp\encrypt.txt -out \temp\encrypt.dat
