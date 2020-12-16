#!/bin/bash

apt-get update
apt-get  install  apache2 -y
sudo systemctl restart apache2
