FROM python:3.9-alpine3.13

LABEL maintainer="GuiFernandess7"

# Shows the logs on the container 
ENV PYTHONUNBUFFERED 1 

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Default directory 
WORKDIR /app

EXPOSE 8000

# docker-compose will overwrite the arg "dev" to true
ARG DEV=false 

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # Install the postgresql client
    apk add --update --no-cache postgresql-client && \
    # --virtual .tmp-build-deps é usado para criar um pacote virtual chamado .tmp-build-deps que conterá todas as dependências a serem removidas mais tarde.
    apk add --update --no-cache --virtual .tmp-build-deps \
        # Install the packages and dependencies
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    ## fi closes the if statement
    fi && \
    # Deletes tmp directory to keep the image lightweight
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    # Avoids to use the root user in the docker container
    # It is used for security 
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user