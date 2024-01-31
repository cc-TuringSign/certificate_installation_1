# Manual Guide (English)

- This manual is **required work on the client side that calls the server**.

## Check root certificate
```bash
$ keytool -keystore "JAVA Home path/jre/lib/security/cacerts" -list -v -storepass changeit
```

- When you enter the above command, the entire list of root certificates stored in cacerts is displayed . Check the output and if there is no attached root certificate, add it using the command below .

## Add root certificate
```bash
$ keytool -import -keystore "JAVA Home path/jre/lib/security/cacerts" -file " Root certificate path and file name " -alias " Root certificate identification name " -storepass changeit
```

- The cacerts must be a default access path in the Java environment .
 
## Example of adding root certificate
```bash
$ keytool -import -keystore cacerts -file "OISTE WISeKey Global Root GB CA.pem" -alias "oistewisekeyglobalrootgbca" -storepass changeit
```