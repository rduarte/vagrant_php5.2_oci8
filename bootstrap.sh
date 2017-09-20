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
apt-get install -y php5 php5-dev php-pear autoconf automake curl libcurl3-openssl-dev build-essential libxslt1-dev re2c libxml2 libxml2-dev php5-cli bison libbz2-dev libreadline-dev libaio1 libmcrypt-dev libmcrypt4 libssl-dev openssl gettext libgettextpo-dev libgettextpo0 libicu-dev libmhash-dev libmhash2 libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libjpeg8-dev libjpeg8  libgd-dev libgd3 libxpm4 libltdl7 libltdl-dev unzip

# Instalando PHPBrew
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
sudo mv phpbrew /usr/local/bin/phpbrew
mkdir -p /opt/phpbrew
sudo -i
phpbrew init
export PHPBREW_ROOT=/opt/phpbrew      # php dist files and build files are stored here
export PHPBREW_HOME=/root/.phpbrew    # your configuration files.
source ~/.phpbrew/bashrc
phpbrew update --old

# Instalando versão 5.2.17 do PHP
phpbrew install php-5.2.17 +default +apxs2=/usr/bin/apxs2
cp /vagrant/php-5.2.17-patches/*patch /root/.phpbrew/build/php-5.2.17/
cd /root/.phpbrew/build/php-5.2.17/
patch -p1 < gmp.patch
patch -p1 < zip.patch
patch -p1 < disable_sslv2.patch
phpbrew install php-5.2.17 +default +apxs2=/usr/bin/apxs2
phpbrew switch php-5.2.17

# Descompactar a biblioteca Oracle instantclient basic e sdk
mkdir /opt/oracle/
cp /vagrant/assets/instantclient*zip /opt/oracle
cd /opt/oracle
unzip instantclient-sdk-linux-12.2.0.1.0.zip
unzip instantclient-basic-linux-12.2.0.1.0.zip
ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 /opt/oracle/instantclient_12_2/libclntsh.so
ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 /opt/oracle/instantclient_12_2/libocci.so

# Compilando modulo oci8 do PHP
echo 'instantclient,/opt/oracle/instantclient_12_2' | pecl install oci8-1.4.10
echo 'extension=oci8.so' >> /root/.phpbrew/php/php-5.2.17/etc/php.ini
service apache2 restart
