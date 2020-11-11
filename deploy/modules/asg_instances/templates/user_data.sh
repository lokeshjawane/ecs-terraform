#!/bin/bash

apt-get update
apt-get  install httpd apache2 -y
sudo systemctl restart apache2
