#!/bin/bash

# Generate self-signed SSL certificates
openssl req -x509 -nodes -newkey rsa:4096 -days 365 \
    -out ./srcs/requirements/nginx/tools/dgoremyk.42.fr.crt \
    -keyout ./srcs/requirements/nginx/tools/dgoremyk.42.fr.key \
    -subj "/C=DE/ST=NS/L=Wolfsburg/O=42/OU=42/CN=dgoremyk.42.fr/UID=dgoremyk"
