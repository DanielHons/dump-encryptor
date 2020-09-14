#!/bin/bash

print_usage() {
  printf  """
Usage: $0 -r recepient@example.com -f fileToEncrypt -t
An public key for encryption must be found in the keyring or on the keyserver (of gpg), \
otherwise the encryption will fail.

The flag t is optional. If optional the public key will be trusted without the key has been marked trusted.
It is more secure, to mark the key as trusted using the gpg cli and omit the flag t


"""
}

autoTrust=" --trust-model always "

tmpDir="/tmp/foo"
mkdir $tmpDir

while getopts 'r:f:o:t' flag; do
  case "${flag}" in
    r) recepient="${OPTARG}" ;;
    f) file="${OPTARG}" ;;
    t) autoTrust="true" ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [[ -z ${recepient} || -z ${file} ]]; then
  print_usage
  exit 1
fi


fileBaseName=$(basename -- $file)

if  command -v sha256sum &> /dev/null
then
  # Works on linux
  SYMMETRIC_KEY=$(date +%s | sha256sum | base64 | head -c 64 ; echo)
else
  # Works on MacOS
  SYMMETRIC_KEY=$(date +%s | shasum -a 256 | base64 | head -c 64 ; echo)
fi


echo $SYMMETRIC_KEY > ${tmpDir}/sym.key
gpg --armor --output ${tmpDir}/${fileBaseName}.asc --symmetric --pinentry-mode=loopback --passphrase  "$SYMMETRIC_KEY" $file
gpg --armor -e -r $recepient --output ${tmpDir}/key.asc ${tmpDir}/sym.key

rm ${tmpDir}/sym.key

cat >> ${tmpDir}/decrypt.sh<< EOF
#!/bin/bash
if  ! command -v gpg &> /dev/null
then
  echo "gpg is not installed"
  exit 1;
fi
SYMMETRIC_KEY=\$(gpg -d key.asc)
gpg -d ${autoTrust}--output ${fileBaseName} --pinentry-mode=loopback --passphrase  "\$SYMMETRIC_KEY" ${fileBaseName}.asc
EOF

chmod +x ${tmpDir}/decrypt.sh

zip -j "$file".enc.zip ${tmpDir}/${fileBaseName}.asc ${tmpDir}/key.asc ${tmpDir}/decrypt.sh

rm -r ${tmpDir}

