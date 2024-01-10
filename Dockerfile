FROM ubuntu:latest

RUN apt update --allow-insecure-repositories && apt -y install git
COPY purge-git.sh /
