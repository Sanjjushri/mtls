@echo off
setlocal

:: Set passwords and aliases
set STOREPASS=changeit
set KEYPASS=changeit
set CLIENT_ALIAS=client
set CA_ALIAS=root

:: Step 1: Generate CA key and certificate
echo Generating CA key and certificate...
openssl req -x509 -newkey rsa:4096 -days 365 -nodes ^
  -keyout ca.key -out ca.crt ^
  -subj "/CN=MyCA"

:: Step 2: Generate server key and CSR
echo Generating server key and CSR...
openssl req -newkey rsa:4096 -nodes -keyout server.key -out server.csr ^
  -subj "/CN=localhost"

:: Step 3: Sign server certificate with CA
echo Signing server certificate with CA...
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key ^
  -CAcreateserial -out server.crt -days 365

:: Step 4: Generate client key and CSR
echo Generating client key and CSR...
openssl req -newkey rsa:4096 -nodes -keyout client.key -out client.csr ^
  -subj "/CN=JavaClient"

:: Step 5: Sign client certificate with CA
echo Signing client certificate with CA...
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key ^
  -CAcreateserial -out client.crt -days 365

:: Step 6: Create PKCS12 file from client certificate and key
echo Creating PKCS12 file from client certificate and key...
openssl pkcs12 -export -in client.crt -inkey client.key ^
  -out client.p12 -name %CLIENT_ALIAS% -CAfile ca.crt -caname %CA_ALIAS% ^
  -passout pass:%STOREPASS%

:: Step 7: Import PKCS12 into Java KeyStore
echo Importing PKCS12 into Java KeyStore...
keytool -importkeystore -deststorepass %STOREPASS% -destkeypass %KEYPASS% ^
  -destkeystore client.keystore -srckeystore client.p12 -srcstoretype PKCS12 ^
  -srcstorepass %STOREPASS% -alias %CLIENT_ALIAS%

:: Step 8: Create Java TrustStore and import CA certificate
echo Creating Java TrustStore and importing CA certificate...
keytool -import -trustcacerts -alias %CA_ALIAS% -file ca.crt ^
  -keystore client.truststore -storepass %STOREPASS% -noprompt

echo.
echo ✅ All certificates and keystores have been generated successfully.
echo.

endlocal
pause
