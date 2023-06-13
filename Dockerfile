FROM python:3.8-slim

ARG USER_NAME=md5user

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y gcc libc-dev netcat libpq-dev curl unzip
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#RUN unzip awscliv2.zip
#RUN ./aws/install

RUN pip install --upgrade pip setuptools wheel
RUN pip install pipenv


COPY Pipfile* /tmp/
RUN cd /tmp && pipenv install --dev && pipenv requirements > requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN apt-get clean
RUN rm -f /var/lib/apt/list/*

RUN useradd -ms /bin/bash $USER_NAME
USER $USER_NAME

RUN mkdir /home/$USER_NAME/src
WORKDIR /home/$USER_NAME/src
COPY ./src /home/$USER_NAME/src

#ENTRYPOINT [ "python", "-m", "main", "m2a-transcode-bbcwwtest-media", "zee/promo_15_min.mxf" ]