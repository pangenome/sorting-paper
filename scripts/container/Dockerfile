ROM debian:bookworm-slim AS binary

LABEL description="ODGI: understanding pangenome graphs"
LABEL base_image="debian:bullseye-slim"
LABEL software="ODGI"
LABEL about.home="https://github.com/pangenome/odgi"
LABEL about.license="SPDX:MIT"

# dependencies
RUN apt-get update \
    && apt-get install -y \
                       git \
                       bash \
                       cmake \
                       make \
                       g++ \
                       python3-dev \
                       libatomic-ops-dev \
                       autoconf \
                       libgsl-dev \
                       zlib1g-dev \
                       libzstd-dev \
                       libjemalloc-dev \
                       libhts-dev \
                       build-essential \
                       pkg-config \
                       wget \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/pangenome/odgi.git

RUN cd odgi \
    && git checkout cffe70a14ce0cf51aa7e2e1c297b75cdcc33d5e9 \
    && cmake -H. -DCMAKE_BUILD_TYPE=Release -Bbuild \
    && cmake --build build -- -j $(nproc) \
    && cp bin/odgi /usr/local/bin/odgi \
    && rm -rf deps \
    && rm -rf .git \
    && rm -rf build \
    && apt-get clean \
    && apt-get purge  \
    && rm -rf /var/lib/apt/lists/* /tmp/*

RUN cd .. && git clone --recursive https://github.com/asl/BandageNG.git
RUN apt update && apt install -y qt6-base-dev qt6-svg-dev
RUN cd BandageNG \
    && git checkout b1ee07d1a43c8de5befbf72ebd8625229236a6c3 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && cp BandageNG /usr/local/bin/BandageNG

RUN chmod 777 /usr/local/bin/odgi
RUN chmod 777 /usr/local/bin/BandageNG

SHELL ["/bin/bash", "-c"]
