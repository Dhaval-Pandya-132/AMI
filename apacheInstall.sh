#!/bin/bash
echo "step : 1 update apt package"
sudo apt update 

echo "step : 2 install the Java Development Kit package with apt:--"
sudo apt install -y openjdk-8-jdk openjdk-8-jre

echo "step : 3  creating tomcat  group--"
sudo groupadd tomcat

echo "step : 4 create a new tomcat user. We’ll make this user a member of the tomcat group, with a home directory of /opt/tomcat "
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat 

echo "step : 5 Create tmp directory and download bin file "
cd /tmp
curl -O https://apache.osuosl.org/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz

echo "step : 6 We will install Tomcat to the /opt/tomcat directory"
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-*tar.gz -C /opt/tomcat --strip-components=1

echo "step : 7 Give the tomcat group ownership over the entire installation directory:"
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat

echo "step : 8 give the tomcat group read access to the conf directory and all of its contents"

sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
sudo chmod o+wrx -R webapps/ work/ temp/ logs/

echo "step : 9 creating apache.service file"

cd /etc/systemd/system/
sudo touch tomcat.service
sudo sh -c "echo [Unit] >> tomcat.service"   

sudo sh -c "echo Description=Apache Tomcat Web Application Container >> tomcat.service"
sudo sh -c "echo After=network.target >> tomcat.service"

sudo sh -c "echo [Service] >> tomcat.service"
sudo sh -c "echo Type=forking >> tomcat.service"

sudo sh -c "echo Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 >> tomcat.service"
sudo sh -c "echo Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid >> tomcat.service"
sudo sh -c "echo Environment=CATALINA_HOME=/opt/tomcat >> tomcat.service"
sudo sh -c "echo Environment=CATALINA_BASE=/opt/tomcat >> tomcat.service"
sudo sh -c "echo Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC' >> tomcat.service"
sudo sh -c "echo Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom' >> tomcat.service"

sudo sh -c "echo ExecStart=/opt/tomcat/bin/startup.sh >> tomcat.service"
sudo sh -c "echo ExecStop=/opt/tomcat/bin/shutdown.sh >> tomcat.service"

sudo sh -c "echo User=tomcat >> tomcat.service"
sudo sh -c "echo Group=tomcat >> tomcat.service"
sudo sh -c "echo UMask=0007 >> tomcat.service"
sudo sh -c "echo RestartSec=10 >> tomcat.service"
sudo sh -c "echo Restart=always >> tomcat.service"

sudo sh -c "echo [Install] >> tomcat.service"
sudo sh -c "echo WantedBy=multi-user.target >> tomcat.service"
echo "printing /etc/systemd/system/tomcat.service"
cat /etc/systemd/system/tomcat.service
cd -

echo "step : 10 reload the systemd daemon so that it knows about our service file:"
sudo systemctl daemon-reload
sudo systemctl start tomcat

echo "step : 11 Tomcat uses port 8080 to accept conventional requests"
sudo ufw allow 8080
sudo systemctl enable tomcat