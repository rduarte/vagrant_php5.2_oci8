#!/usr/bin/env bash

# Atualizando os repositórios
apt-get update

# Instalando o apache e configurando para o vagrant
apt-get install -y apache2 apache2-dev
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

# Instalando depedencias do PHP
apt-get build-dep php5
apt-get install -y php5 php5-dev php-pear autoconf automake curl libcurl3-openssl-dev build-essential libxslt1-dev re2c libxml2 libxml2-dev php5-cli bison libbz2-dev libreadline-dev
apt-get install -y libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libjpeg8-dev libjpeg8  libgd-dev libgd3 libxpm4 libltdl7 libltdl-dev
apt-get install -y libssl-dev openssl
apt-get install -y gettext libgettextpo-dev libgettextpo0
apt-get install -y libicu-dev
apt-get install -y libmhash-dev libmhash2
apt-get install -y libmcrypt-dev libmcrypt4
apt-get install -y libaio1

# Instalando PHPBrew
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
sudo mv phpbrew /usr/local/bin/phpbrew
mkdir -p /opt/phpbrew
sudo phpbrew init --root=/opt/phpbrew
sudo phpbrew update --old

# Descompactar a biblioteca Oracle instantclient basic e sdk
cd /vagrant/oracle/
unzip instantclient-sdk-linux-12.2.0.1.0.zip
unzip instantclient-basic-linux-12.2.0.1.0.zip
ln -s /vagrant/oracle/instantclient_12_2/libclntsh.so.12.1 /vagrant/oracle/instantclient_12_2/libclntsh.so
ln -s /vagrant/oracle/instantclient_12_2/libocci.so.12.1 /vagrant/oracle/instantclient_12_2/libocci.so

# Instalando versão 5.2.17 do PHP com suporte ao oci8
sudo phpbrew install php-5.2.17 +default +apxs2=/usr/bin/apxs2
sudo phpbrew switch php-5.2.17
sudo pecl install oci8-1.4.10
#
