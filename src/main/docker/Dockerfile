FROM ubuntu:16.04
LABEL maintainer "xcatalyst@exadatum.com"



ENV AIRFLOW_USER=airflow
ENV AIRFLOW_GROUP=airflow
ENV AIRFLOW_UID=300
ENV AIRFLOW_GID=300



ARG CDH_REPO_URI=https://archive.cloudera.com/cdh6/6.1.0/ubuntu1604/apt
ARG CDH_RELEASE_NAME=xenial-cdh6.1.0
ARG AIRFLOW_VERSION=1.9.0
ENV ABFS_URI=
ENV AIRFLOW_HOME=/usr/local/airflow/
ENV PORT=8080


# Setting up required packages on ubuntu
RUN apt-get update -yqq \
 && apt-get install apt-utils -y \
 && apt-get install software-properties-common -yqq \
 && apt-get install openjdk-8-jre -yqq \
 && apt-get install apt-transport-https -yqq \
 && apt-get install module-init-tools -yqq \
 && apt-get install module-assistant -yqq \
 && apt-get install --reinstall linux-image-`uname -r` -yqq \
 && apt-get install wget -yqq


# Configure cloudera repository
RUN echo "deb ${CDH_REPO_URI} ${CDH_RELEASE_NAME} contrib" >> /etc/apt/sources.list.d/cloudera.list \
 && wget ${CDH_REPO_URI}/archive.key \
 && apt-key add archive.key \
 && apt-get update -yqq \
 && apt-get install hadoop hadoop-hdfs libhdfs0 openssl hadoop-hdfs-fuse -yqq


# Install airflow required dependencies
RUN apt-get install python-pip  -y\
 && apt-get install mysql-client  -y \
 && apt-get install libmysqlclient-dev -y \
 && pip install apache-airflow[crypto,celery,hive,jdbc,mysql]==$AIRFLOW_VERSION \
 && pip install celery[redis]==4.1.1

EXPOSE ${PORT}

# Setup Airflow user
RUN groupadd -g ${AIRFLOW_GID} ${AIRFLOW_GROUP} \
 && useradd -u ${AIRFLOW_UID} -g ${AIRFLOW_GROUP} -m -s /bin/bash ${AIRFLOW_USER}

ADD files/.ssh /home/${AIRFLOW_USER}/.ssh
ADD files/scripts/entrypoint.sh /home/${AIRFLOW_USER}/entrypoint.sh

RUN chown -R ${AIRFLOW_USER}:${AIRFLOW_GROUP} /home/${AIRFLOW_USER}/.ssh \
 && chmod -R 600 /home/${AIRFLOW_USER}

RUN chown  ${AIRFLOW_USER}:${AIRFLOW_GROUP} /home/${AIRFLOW_USER}/entrypoint.sh \
 && chmod +x /home/${AIRFLOW_USER}/entrypoint.sh

# Switch to the AIRFLOW user and start in user's home
USER ${AIRFLOW_USER}:${AIRFLOW_GROUP}
WORKDIR /home/${AIRFLOW_USER}

ENTRYPOINT [entrypoint.sh]
