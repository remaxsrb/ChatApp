#!/bin/bash

# Create cert directory only if needed (optional here since you're already in it)
mkdir -p .

# Step 1: Generate CA private key
openssl genrsa -out ca-key.pem 2048

# Step 2: Generate CA certificate (self-signed)
openssl req -x509 -new -nodes -key ca-key.pem -sha256 -days 1024 -out ca-cert.pem \
  -subj "/C=RS/ST=Beograd/L=Beograd/O=MyCompany/OU=Dev/CN=localhost"

# Step 3: Generate server private key
openssl genrsa -out server-key.pem 2048

# Step 4: Create server CSR config with SAN
cat > server-csr.cnf <<EOF
[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[dn]
C = RS
ST = Beograd
L = Beograd
O = MyCompany
OU = Dev
CN = localhost

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1   = localhost
DNS.1  	= localhost.local
IP.1    = 127.0.0.1
EOF

# Step 5: Create the CSR
openssl req -new -key server-key.pem -out server-csr.pem -config server-csr.cnf

# Step 6: Sign the server cert with the CA, include SANs
openssl x509 -req -in server-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial \
  -out server-cert.pem -days 500 -sha256 -extfile server-csr.cnf -extensions req_ext

