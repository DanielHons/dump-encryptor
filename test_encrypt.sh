#!/usr/bin/env bash

RECIPIENT=$1 # You must provide a recipient you have the private key imported in your gpg chain where you run this test
SECRET_CONTENT="Content of my secret file"
mkdir test
echo $SECRET_CONTENT > test/myfile.txt
./encrypt.sh -f test/myfile.txt -r ${RECIPIENT}

# Now remove the original file
rm test/myfile.txt

cd test
unzip myfile.txt.enc.zip

# We can remove the backup now
rm myfile.txt.enc.zip

./decrypt.sh
rm key.asc myfile.txt.asc decrypt.sh

DECRYPTED_TEXT="$(cat myfile.txt)"

cd ..


if [[ "${DECRYPTED_TEXT}" == "$SECRET_CONTENT" ]]; then
    echo "Test completed - nothing was changed"
    rm -r test
    exit 0
else
    echo "Test failed - check the test folder"
    ecit 1
fi