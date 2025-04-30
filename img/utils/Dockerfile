FROM debian:bullseye-slim

ENV LIQUIBASE_VERSION=4.23.2
ENV ORACLE_INSTANT_CLIENT_VERSION=23.6.0.24.10
# SSH
RUN apt-get update && apt-get install -y \
    openjdk-11-jre \
    openssh-server \
    curl \
    unzip \
    && apt-get clean

RUN mkdir -p /run/sshd && chmod 0755 /run/sshd

RUN mkdir -p /etc/ssh && chmod 755 /etc/ssh

RUN chmod 600 /etc/ssh/ssh_host_ed25519_key && \
    chmod 644 /etc/ssh/ssh_host_ed25519_key.pub && \
    chmod 644 /etc/ssh/sshd_config
RUN ssh-keygen -A

# USER Setup
ENV USER=utils
RUN useradd -m -s /bin/bash ${USER}
RUN chown -R  ${USER}:${USER} /etc/ssh

# Liquibase
RUN curl -Lo /tmp/liquibase.zip https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.zip \
    && unzip /tmp/liquibase.zip -d /opt/liquibase \
    && ln -s /opt/liquibase/liquibase /usr/local/bin/liquibase \
    && rm /tmp/liquibase.zip

ENV PATH="/opt/liquibase:$PATH"

# Oracle Client
COPY /tmp/instantclient-basic.zip /tmp/
COPY /tmp/instantclient-tools.zip /tmp/

RUN unzip -o /tmp/instantclient-basic.zip -d /opt/oracle \
    && unzip -o /tmp/instantclient-tools.zip -d /opt/oracle \
    && rm /tmp/instantclient-basic.zip /tmp/instantclient-tools.zip \
    && ln -s /opt/oracle/instantclient_*/sqlldr /usr/local/bin/sqlldr

RUN apt-get update && apt-get install -y libaio1 \
    && ln -s /opt/oracle/instantclient_23_6/libclntsh.so.23.1 /usr/local/lib/libclntsh.so.23.1 && ln -s /opt/oracle/instantclient_23_6/libclntshcore.so.23.1 /usr/local/lib/libclntshcore.so.23.1
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_23_6:$LD_LIBRARY_PATH
RUN ldconfig
RUN apt-get clean
#
USER ${USER}
RUN mkdir -p /home/${USER} && \
    chown -R ${USER}:${USER} /home/${USER}

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD ss -tuln | grep :22 || exit 1

CMD ["/usr/sbin/sshd", "-D"]
