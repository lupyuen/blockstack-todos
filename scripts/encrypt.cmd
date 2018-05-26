echo This is a test > \temp\encrypt.txt
:: openssl rsautl -encrypt -inkey "%userprofile%\.ssh\github_rsa.pub" -pubin -in \temp\encrypt.txt -out \temp\encrypt.dat

:: openssl x509 -in "%userprofile%\.ssh\github_rsa.pub" -pubkey -noout >\temp\public_key.pem

ssh-keygen -f "%userprofile%\.ssh\github_rsa.pub" -e -m pem >..\Temp\public_key.pem

openssl rsautl -encrypt -inkey ..\Temp\public_key.pem -pubin -in \temp\encrypt.txt -out \temp\encrypt.dat
