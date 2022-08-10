FROM rust as build
RUN apt-get update
RUN apt-get install cmake -y
RUN git clone --single-branch --branch master https://github.com/golemfactory/yagna.git yagna
RUN cd yagna && cargo build --release --all
RUN git clone --single-branch --branch scx1332/trying_to_run2 https://github.com/golemfactory/ya-runtime-http-auth.git ya-runtime-http-auth
RUN cd ya-runtime-http-auth && cargo build --release 
RUN cd ya-runtime-http-auth && cargo build --release -p ya-http-proxy --bin ya-http-proxy --features="bin"
RUN apt-get install openssl -y
RUN mkdir privatecerts
RUN cd privatecerts && openssl req -nodes -x509 -newkey rsa:4096 -keyout server.key -out server.cert -sha256 -days 3650 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"


FROM python:3.9
RUN mkdir /runtime
RUN mkdir /runtime/plugins
RUN mkdir /runtime/plugins/ya-runtime-bor
RUN mkdir /runtime/plugins/ya-runtime-bor/services
RUN mkdir /runtime/provider_dir
RUN mkdir /privatecerts
COPY --from=0 /yagna/target/release/yagna /runtime
COPY --from=0 /yagna/target/release/ya-provider /runtime
COPY --from=0 /yagna/target/release/exe-unit /runtime/plugins
COPY --from=0 /ya-runtime-http-auth/target/release/ya-http-proxy /runtime/plugins/ya-runtime-bor
COPY --from=0 /ya-runtime-http-auth/target/release/ya-runtime-http-auth /runtime/plugins/ya-runtime-bor
COPY --from=0 /privatecerts/server.cert /privatecerts/server.cert
COPY --from=0 /privatecerts/server.key /privatecerts/server.key
COPY run.sh /runtime
RUN chmod +x /runtime/run.sh
COPY plugins/ya-runtime-bor.json /runtime/plugins
COPY plugins/ya-runtime-bor/services/bor-service-template.txt /runtime/plugins/ya-runtime-bor/services
COPY provider_dir/presets.json /runtime/provider_dir

WORKDIR /runtime
CMD ./run.sh
