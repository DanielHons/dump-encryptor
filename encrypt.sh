#!/bin/bash

print_usage() {
  printf "Usage: $0 -r recepient@example.com -f fileToEncrypt\n"
}

while getopts 'r:f:' flag; do
  case "${flag}" in
    r) recepient="${OPTARG}" ;;
    f) file="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done


if  command -v sha256sum &> /dev/null
then
  # Works on linux
  SYMMETRIC_KEY=$(date +%s | sha256sum | base64 | head -c 64 ; echo)
else
  # Works on MacOS
  SYMMETRIC_KEY=$(date +%s | shasum -a 256 | base64 | head -c 64 ; echo)
fi


echo $SYMMETRIC_KEY > sym.key
gpg --armor --output encrypted-dump.asc --symmetric --pinentry-mode=loopback --passphrase  "$SYMMETRIC_KEY" $file
gpg --armor  -e -r $recepient --output key.asc sym.key

rm sym.key

cat >> decrypt.sh<< EOF
#!/bin/bash
if  ! command -v gpg &> /dev/null
then
  echo "gpg is not installed"
  exit 1;
fi
SYMMETRIC_KEY=$(gpg -d key.asc)
gpg -d --output unencrypted-dump.sql --pinentry-mode=loopback --passphrase  "\$SYMMETRIC_KEY" encrypted-dump.asc
EOF

chmod +x decrypt.sh

zip "$file".enc.zip encrypted-dump.asc key.asc decrypt.sh

rm encrypted-dump.asc key.asc decrypt.sh

