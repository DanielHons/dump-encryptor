# Dump Encryptor

Das Bash Skript verschlüsselt eine Datei, deren Pfad als Parameter übergeben wird. Dazu  generiert das Skript einen zufälligen symmetrischen Schlüssel für die Verschlüsselung mit GPG und verschlüsselt damit die Datei. Anschließend verschlüsselt das Skript asymmetrisch den symmetrischen Schlüssel mit dem öffentlichen Schlüssel des Empfängers. Der asymmetrisch verschlüsselte Schlüssel, die verschlüsselte Datei und ein Bash-Skript zum Entschlüsseln werden in eine ZIP-Datei gepackt.  

## Systemvoraussetzungen

Voraussetzung zum Verschlüsseln sind GPG und ein vorliegender öffentlicher Schlüssel. Jener kann entweder mit `gpg --import` importiert werden oder er wird auf einem Keyserver gesucht. 

Voraussetzung zum Entschlüsseln sind natürlich auch GPG und ein vorhandener privater Schlüssel.

### Test
To execute the test you need gpg installed and have a keypair (private and public key) for a username or email address imported 
in your local keychain. In this case, provide the username (or mail address) as the only parameter to the test.
```
./test_encrypt.sh me@mysite.com
```

A successful response will look similar to this:
```
  adding: myfile.txt.asc (deflated 14%)
  adding: key.asc (deflated 22%)
  adding: decrypt.sh (deflated 24%)
Archive:  myfile.txt.enc.zip
  inflating: myfile.txt.asc          
  inflating: key.asc                 
  inflating: decrypt.sh              
gpg: verschlüsselt mit 4096-Bit RSA Schlüssel, ID 767B23573D759005, erzeugt 2019-11-11
      "Daniel Hons <mail@danielhons.de>"
gpg: AES verschlüsselte Daten
gpg: Verschlüsselt mit einer Passphrase
Test completed - nothing was changed
```

while the above example refers to the public key provided at [my website](https://danielhons.de/assets/pgp-public-key.asc)