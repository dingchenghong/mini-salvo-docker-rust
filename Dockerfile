FROM centos:centos7.9.2009 as builder
WORKDIR /app
COPY . /app/
ADD cargo_config /root/.cargo/config
RUN export RUSTUP_DIST_SERVER="https://rsproxy.cn" \
    && export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup" \
    && yum install -y git gcc gcc-c++ openssl openssl-devel \
    && curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh > /tmp/rustup-init.sh \
    && chmod +x /tmp/rustup-init.sh \
    && /tmp/rustup-init.sh -y \
    && /root/.cargo/bin/cargo build --release \
    && strip target/release/mini-salvo-docker-rust

FROM centos:centos7.9.2009
COPY --from=0 /app/target/release/mini-salvo-docker-rust .
EXPOSE 8080
ENTRYPOINT ["/mini-salvo-docker-rust"]


