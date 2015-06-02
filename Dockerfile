FROM jakubzapletal/ubuntu:14.04.1

RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive

RUN wget --content-disposition "http://www.opscode.com/chef/download-server?p=ubuntu&pv=12.04&m=x86_64&v=latest&prerelease=false&nightlies=false"
RUN dpkg -i chef-server*.deb

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

ADD scripts/reconfigure_chef.sh /usr/local/bin/
ADD scripts/run.sh /usr/local/bin/

CMD rsyslogd -n

VOLUME /root
VOLUME /var/log

CMD ["run.sh"]
