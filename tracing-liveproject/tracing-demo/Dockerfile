FROM ghcr.io/graalvm/graalvm-ce:20.3.1

RUN groupadd --system tracing --gid 1001 && useradd --no-log-init --system --gid tracing --uid 1001 tracing
USER tracing:tracing
COPY --chown=tracing:tracing ./build/libs/tracing-demo-0.0.1-SNAPSHOT.jar /opt/tracing-demo/

EXPOSE 8080/tcp
ENTRYPOINT ["java"]
CMD ["-jar", "/opt/tracing-demo/tracing-demo-0.0.1-SNAPSHOT.jar"]
