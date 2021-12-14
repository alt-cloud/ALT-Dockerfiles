FROM altlinux/base:p9

MAINTAINER alt-cloud

RUN apt-get update && \
    apt-get install -y python-module-pip \
                       python-module-setuptools \
                       python-dev \
                       gcc \
                       ; \
    rm -f /var/cache/apt/archives/*.rpm \
          /var/cache/apt/*.bin \
          /var/lib/apt/lists/*.*

CMD ["python"]
