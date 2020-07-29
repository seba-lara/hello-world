FROM centos:7

RUN yum install -y gcc centos-release-scl rh-python36
RUN yum update -y
#RUN scl /opt/rh/rh-python36/enable rh-python36
COPY scripts/helloworld.py /root/
