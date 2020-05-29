# NOTE: To use SSH with wp-cli you need to copy an unofficial image bitroniq/docker-wordpress-cli-sage
#   You need to modify the Dockerfile to add your SSH credentials and build your image wpssh
#   $ alias wpssh="docker run -it --rm --volumes-from objWp --network container:objWp wpssh --ssh=root@domain/var/www/html --allow-root"
#   $ wpssh --info

# Dockerfile
# https://github.com/bitroniq/docker-wordpress-cli-sage
# https://hub.docker.com/r/bitroniq/docker-wordpress-cli-sage/

# Official wordpress-cli image on steroids with SAGE (roots.io) dev
# environment and SSH access

# Author: mail@piotrkowalski.info

FROM wordpress:cli

# Use environment variables to set the password
# ARG password=password - set default value.
# It will overwritten when provide ARG during the build process:
# $ docker build --build-arg password=a_value
ARG password=password

# ARG password - expects a value
# Will fail if not provide any
#ARG password

# set default value from ARG
# You can echo the variable inside your container
ENV password=${password}

# Change user to root for the following commands
# - wordpress-cli is using USER www-data, so we need to overwrite this
# - make sure to ssh as `www-data` or `su - www-data` if you use docker interactive shell
USER root

# Install SSH
RUN \
  apk add --update shadow openssh && \
  rm -rf /tmp/* /var/cache/apk/*

# Make sure we get fresh keys
RUN \
  mkdir /var/run/sshd && \
  rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key && \
  ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
  ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa

# Fix www-data uid mismatch in wordpress:latest
# https://github.com/docker-library/wordpress/issues/256
# INFO: Issue has been fixed on 2019-03-10
# RUN \
#     userdel -r www-data && \
#     userdel -r xfs && \
#     groupadd -g 33 www-data && \
#     useradd -d /var/www/html -s /bin/ash -g www-data -G www-data -u 33 www-data && \
#     echo "www-data:password" | chpasswd

# Install SAGE requirements
# https://github.com/roots/sage#requirements
# https://roots.io/guides/automate-sage-9-deployment-with-deploybot/
RUN \
  apk add npm  && \
  apk add nodejs && \
  apk add composer && \
  apk add zip && \
  apk add unzip
RUN \
  npm install --global npm@latest && \
  npm install --global yarn && \
  npm install --global webpack

#
# Add SSH key and change permissions 
COPY id_rsa_do1 id_rsa_do1.pub /root/.ssh/

RUN \
  cd /root/.ssh && \
  mv id_rsa_do1 id_rsa && \
  mv id_rsa_do1.pub id_rsa.pub && \
  chmod 0400 /root/.ssh/id_rsa && \
  chmod 0400 /root/.ssh/id_rsa.pub

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]