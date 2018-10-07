FROM alt:sisyphus

MAINTAINER alt-cloud

RUN apt-get update && \
    apt-get install -y python3-module-pip; \
    rm -f /var/cache/apt/archives/*.rpm \
          /var/cache/apt/*.bin \
          /var/lib/apt/lists/*.*

CMD ["python3"]
