openssl rsautl -decrypt -inkey %userprofile%\.ssh\github_rsa -in \temp\encrypt.dat -out \temp\new_encrypt.txt
cat \temp\new_encrypt.txt
