FROM ubuntu:14.04
ARG GITHUB_PAT
MAINTAINER Nick Monk <nick@monk.software>
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
# Git
    apt-get install -y ca-certificates git-core ssh && \
    apt-get install -y git && \
# Java 8
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \ 
# Emacs
    apt-get install -y emacs24-nox && \
    apt-get install -y rlwrap

# Fixes empty home
ENV HOME /root

WORKDIR /root
RUN git clone https://$GITHUB_PAT@github.com/nimo71/clojure.emacs.d.git && \
    mv clojure.emacs.d .emacs.d && \
    cd .emacs.d && \
    git submodule init && \
    git submodule update

# Leiningen
ENV LEIN_ROOT 1
RUN cd /usr/bin  && \
    wget https://raw.github.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mkdir ~/.lein && \
    echo '{:repl {:plugins [[cider/cider-nrepl "0.11.0"]]}}' >> ~/.lein/profiles.clj && \
    lein

EXPOSE 3449
