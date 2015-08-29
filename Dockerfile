FROM ubuntu:14.04
MAINTAINER Semyon Novikov <me@sdfgh153.ru>

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y sqlite3
RUN curl http://mirror.racket-lang.org/installers/6.2.1/racket-minimal-6.2.1-x86_64-linux-ubuntu-precise.sh > racket.sh
RUN echo "yes\n1\n" | /bin/bash racket.sh
RUN rm racket.sh
