# Doc: https://medium.com/@yakuphanbilgic3/create-self-signed-certificates-and-keys-with-openssl-4064f9165ea3

# Generate a Private Key
# Generate a Self-Signed Certificate
openssl genpkey -algorithm RSA -out ../certs/key.pem
openssl req -new -x509 -key ../certs/key.pem -out ../certs/cert.pem -days 365