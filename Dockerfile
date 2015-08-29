FROM ubuntu:14.04
MAINTAINER Semyon Novikov <me@sdfgh153.ru>

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y sqlite3
RUN curl http://racket.infogroep.be/6.2.1/racket-6.2.1-x86_64-linux-ubuntu-precise.sh > racket.sh
RUN echo "yes\n1\n" | /bin/bash racket.sh
RUN rm racket.sh

ADD . /home/
EXPOSE 8000
ENTRYPOINT cd /home && racket ./server.rkt
