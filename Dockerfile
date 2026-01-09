FROM registry.fedoraproject.org/fedora-minimal:43

ARG VERSION=1.12.2

RUN case "$(arch)" in \
       aarch64|arm64|arm64e) \
         ARCHITECTURE='arm64'; \
         ;; \
       x86_64|amd64|i386) \
         ARCHITECTURE='amd64'; \
         ;; \
       *) \
         echo "Unsupported architecture"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/gpg.key https://rpm.grafana.com/gpg.key && \
    rpm --import /tmp/gpg.key && \
    curl -LfsSo /tmp/alloy.rpm https://github.com/grafana/alloy/releases/download/v${VERSION}/alloy-${VERSION}-1.${ARCHITECTURE}.rpm && \
    rpm -i /tmp/alloy.rpm && \
    rm -rf /var/lib/dnf /var/cache/* /tmp/alloy.rpm /tmp/gpg.key

ENTRYPOINT ["/usr/bin/alloy"]
ENV ALLOY_DEPLOY_MODE=docker
CMD ["run", "/etc/alloy/config.alloy", "--storage.path=/var/lib/alloy/data"]
