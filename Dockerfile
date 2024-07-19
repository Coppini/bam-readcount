FROM ubuntu:22.04 AS build

RUN apt-get update \
    && apt-get install -y \
        automake \
        build-essential \
        curl \
        git \
        cmake \
 && rm -rf /var/lib/apt/lists/* \
 && apt clean autoclean \
 && apt autoremove --yes

RUN git clone https://github.com/genome/bam-readcount \
    && mkdir -p bam-readcount/build \
    && cd bam-readcount/build \
    && cmake .. \
    && make \
    && cd ../.. \
    && mv bam-readcount/build/bin/bam-readcount /usr/local/bin/bam-readcount \ 
    && /usr/local/bin/bam-readcount --version | grep bam-readcount \
    && rm -rf bam-readcount/

FROM ubuntu:22.04

COPY --from=build /usr/local/bin/bam-readcount /usr/local/bin/bam-readcount

CMD ["/usr/local/bin/bam-readcount"]
ENTRYPOINT ["/usr/local/bin/bam-readcount"]

