FROM alpine:3.19

ARG DB_NAME \
    DB_USER \
    DB_PASS \
    DB_ROOT

### /var/run/mysql(d) - contains mysql.sock - unix sockert file for local connections 
### 777 allow all users read from and write to it
RUN apk update && apk add --no-cache mariadb mariadb-client && \
	mkdir /var/run/mysqld && chmod 777 /var/run/mysqld

#COPY ./conf/my-config.cnf /etc/my.cnf.d/my-config.cnf

RUN  sed -i "s|skip-networking|skip-networking=0|g" /etc/my.cnf.d/mariadb-server.cnf

### /var/lib/mysql - default data dir for databases, tables, data files
### --user=mysql - less damage potential since not a root
### RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY ./tools/script.sh .
RUN chmod +x script.sh && sh script.sh && rm script.sh

### /usr/bin/mysqld - MySQL/MariaDB server executable
### mysql - minimal privileges reduce the risk of security breaches
### 0.0.0.0 - listen to all connections on all available network interfaces
### otherwise we need to bind it to a specific Docker network IP address
### SEE: docker-compose ports "3306:3306" - will make accessible from host only  
CMD ["/usr/bin/mysqld", "--user=mysql", "--bind-address=0.0.0.0", "--skip-log-error"]

#CMD ["/usr/bin/mysqld", "--user=mysql", "--skip-log-error"]

#USER mysql
#CMD ["/usr/bin/mysqld", "--skip-log-error"]
