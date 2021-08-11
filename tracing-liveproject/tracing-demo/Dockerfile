FROM ghcr.io/graalvm/graalvm-ce:20.3.1

RUN groupadd --system tracing --gid 1001 && useradd --no-log-init --system --gid tracing --uid 1001 tracing
USER tracing:tracing
COPY --chown=tracing:tracing ./tracing-demo-0.0.1-SNAPSHOT.jar /opt/tracing-demo/

ENV JAEGER_ENDPOINT="http://host.docker.internal:14268/api/traces"
ENV JAEGER_SAMPLER_TYPE=const
ENV JAEGER_SAMPLER_PARAM=1
EXPOSE 8080/tcp
ENTRYPOINT ["java"]
CMD ["-jar", "/opt/tracing-demo/tracing-demo-0.0.1-SNAPSHOT.jar"]
