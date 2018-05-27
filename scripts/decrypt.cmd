openssl rsautl -decrypt -ssl -inkey %userprofile%\.ssh\github_rsa -in \temp\encrypt.dat -out \temp\decrypt.txt
cat \temp\decrypt.txt
