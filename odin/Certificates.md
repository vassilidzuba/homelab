# Certificates

We will create a private CA authority using OpenSSL, for use in the homelab only, and apply it to nginx.

We follow the instructions from [https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/](https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/).

We will take *Manul* as organisation name.


##  Create a private key for the CA

    CANAME=Manul-RootCA
    mkdir $CANAME
    cd $CANAME
    openssl genrsa -aes256 -out $CANAME.key 4096

## Create Certificate of the CA

    openssl req -x509 -new -nodes -key $CANAME.key -sha256 -days 1826 -out $CANAME.crt
    openssl req -x509 -new -nodes -key $CANAME.key -sha256 -days 1826 -out $CANAME.crt -subj '/CN=Manul Root CA/C=FR/ST=IleDeFrance/L=Paris/O=Manul'


## Add the CA certificate to the trusted root certificates

    sudo apt install -y ca-certificates
    sudo cp $CANAME.crt /usr/local/share/ca-certificates
    sudo update-ca-certificates

## Create a certificate for the webserver

    MYCERT=odin.manul.lan
    openssl req -new -nodes -out $MYCERT.csr -newkey rsa:4096 -keyout $MYCERT.key -subj '/CN=Websever/C=FR/ST=Paris/L=Paris/O=Manul'

``` bash
cat > $MYCERT.v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = odin.manul.lan
DNS.2 = freebox.manul.lan
IP.1 = 192.168.0.20
IP.2 = 192.168.0.254
EOF
```

## Sign the certificate

   openssl x509 -req -in $MYCERT.csr -CA $CANAME.crt -CAkey $CANAME.key -CAcreateserial -out $MYCERT.crt -days 730 -sha256 -extfile $MYCERT.v3.ext
   
   
## Add the certificate to the certificate store

### Debian

    cp $CNAME.crt /usr/local/share/ca-certificates
    update-ca-certificates
    
## Arch

    trust anchor --store $CNAME.crt
    update-ca-trust
    
# Running nginx with the certificates

The container file must be changed; the new one has been copied into [scripts/nginx-certificate.container](nginx-certificate.container).

One need to copy the .crt and .key files into ~/nginx.

One also need a modified configuration file `nginx.conf`. A copy is available in [config/nginx/nginx.conf](config/nginx/nginx.conf).

    