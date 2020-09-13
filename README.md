# Dump Encryptor

Das Bash Skript verschlüsselt eine Datei, deren Pfad als Parameter übergeben wird. Dazu  generiert das Skript einen zufälligen symmetrischen Schlüssel für die Verschlüsselung mit GPG und verschlüsselt damit die Datei. Anschließend verschlüsselt das Skript asymmetrisch den symmetrischen Schlüssel asymmetrisch mit dem öffentlichen Schlüssel des Empfängers. Der asymmetrisch verschlüsselte Schlüssel, die verschlüsselte Datei und ein Bash-Skript zum Entschlüsseln werden in eine ZIP-Datei gepackt.  

## Systemvoraussetzungen

Voraussetzung zum Verschlüsseln sind GPG und ein vorliegender öffentlicher Schlüssel. Jener kann entweder mit `gpg --import` importiert werden oder er wird auf einem Keyserver gesucht. 

Voraussetzung zum Entschlüsseln sind natürlich auch GPG und vorhandener privater Schlüssel.

