#!/bin/bash

#Actualizaciones
sudo apt update -y
sudo apt upgrade -y

#Instalación java 11 (lts 2022)
sudo apt install openjdk-8-jdk -y

#Borrar posibles configuración anterior
sudo deluser tomcat
sudo groupdel tomcat

#Agregar configuración
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

#Instalación de tomcat
cd /tmp
curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz

#Permisos de actualización
sudo mkdir /opt/tomcat
cd /opt/tomcat
sudo tar xzvf /tmp/apache-tomcat-9.0.*tar.gz -C /opt/tomcat --strip-components=1
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/

#Crear un archivo de unidad systemd  /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
cd /etc/systemd/system
sudo wget https://raw.githubusercontent.com/ben331/resources/main/tomcat.service
sudo systemctl daemon-reload
cd /opt/tomcat/bin
sudo ./startup.sh run
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo ufw allow 8080

#Configurar la interfaz de administración web tomcat
cd /opt/tomcat/conf/
rm tomcat-users.xml
wget https://raw.githubusercontent.com/ben331/resources/main/tomcat-users.xml
cd /opt/tomcat/webapps/manager/META-INF/
rm context.xml
wget https://raw.githubusercontent.com/ben331/resources/main/context.xml
cd /opt/tomcat/webapps/host-manager/META-INF/
rm context.xml
wget https://raw.githubusercontent.com/ben331/resources/main/context.xml
sudo systemctl restart tomcat
