FROM ubuntu:16.04

# set env vars
ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# configure apt behaviour
RUN echo "APT::Get::Install-Recommends 'false'; \n\
  APT::Get::Install-Suggests 'false'; \n\
  APT::Get::Assume-Yes "true"; \n\
  APT::Get::force-yes "true";" > /etc/apt/apt.conf.d/00-general

# systemd tweaks
RUN rm -rf /lib/systemd/system/getty*;

# install
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -yq apt-utils

# install typical requirements for testing
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq ssl-cert ca-certificates apt-transport-https python sudo curl net-tools vim iproute unzip vim wget git build-essential expect git gnupg2 pinentry-tty procps rpm ruby-dev curl
# install php
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq php composer php-xml php-intl php-mbstring php-common php-mcrypt php-gd php-mysql php-imap

# install fpm
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq libffi-dev
RUN gem install fpm --no-ri --no-rdoc

# install ghr
RUN wget -O /tmp/ghr.zip https://github.com/tcnksm/ghr/releases/download/v0.5.4/ghr_v0.5.4_linux_amd64.zip && (cd /usr/local/bin && unzip /tmp/ghr.zip) && chmod +x /usr/local/bin/ghr

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# finally run script on startup
CMD ["/bin/bash"]
