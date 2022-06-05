FROM centos:centos7

ENV VER=8.2.2

RUN yum -y install wget perl-Digest-SHA

RUN groupadd --gid 1234 elasticsearch && \
    adduser --uid 1234 --gid 1234 --home /usr/share/elasticsearch elasticsearch

RUN mkdir -p /usr/share/elasticsearch/ && chown -R 1234:1234 /usr/share/elasticsearch/
RUN mkdir -p /var/lib/elasticsearch/ && chown -R 1234:1234 /var/lib/elasticsearch/

USER 1234:1234

WORKDIR /usr/share/elasticsearch

RUN wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VER}-linux-x86_64.tar.gz && \
    wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VER}-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-${VER}-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-${VER}-linux-x86_64.tar.gz && \
    mv elasticsearch-${VER}/* ./ && \
    sed -i "/node.name/c\node.name: netology_test" /usr/share/elasticsearch/config/elasticsearch.yml && \
    sed -i "/path.data/c\path.data: /var/lib/elasticsearch" /usr/share/elasticsearch/config/elasticsearch.yml

EXPOSE 9200

CMD ["bin/elasticsearch"]
