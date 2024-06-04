FROM nginx:1.23.4-alpine
LABEL maintaner="Fernando Constantino <const.fernando@gmail.com>"

ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ferdn4ndo/docker-containers-monitor"
LABEL org.label-schema.description="A lightweight docker image for monitoring containers' resource usage and memory load in a web server with a simple UI, including a complete CI workflow."
LABEL org.label-schema.vcs-url="https://github.com/ferdn4ndo/docker-containers-monitor"
LABEL org.label-schema.usage="/README.md"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run --rm --env-file ./.env ferdn4ndo/docker-containers-monitor"
LABEL org.label-schema.docker.cmd.devel="docker run --rm --env-file ./.env -v ./scripts:/backup/scripts ferdn4ndo/docker-containers-monitor"
LABEL org.label-schema.docker.cmd.test="docker run --rm --env-file ./.env ferdn4ndo/docker-containers-monitor tests.sh"

WORKDIR /scripts

RUN apk update \
    && apk add bash \
    && apk add coreutils \
    && apk add docker-cli \
    && apk del -f nginx-module-image-filter \
    && apk del -f libpng \
    && apk del -f tiff \
    && apk update \
    && apk upgrade -f -v \
    && rm -rf /var/cache/apk/*

ADD scripts /scripts
ADD html /usr/share/nginx/html
ADD default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

ENTRYPOINT ["sh", "entrypoint.sh"]

CMD [ "echo", "Default command successfully executed" ]
