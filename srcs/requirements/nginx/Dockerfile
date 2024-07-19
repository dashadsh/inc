FROM alpine:3.19

ARG DOMAIN_NAME

RUN apk update && apk upgrade && apk add --no-cache openssl 
RUN apk add --no-cache nginx

# mounted in docker-compose.yml
# COPY ./conf/default.conf /etc/nginx/http.d/default.conf

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

COPY ./tools/${DOMAIN_NAME}.crt /etc/nginx/ssl/${DOMAIN_NAME}.crt
COPY ./tools/${DOMAIN_NAME}.key /etc/nginx/ssl/${DOMAIN_NAME}.key

#EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
