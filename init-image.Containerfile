FROM alpine:3.18

RUN apk update \
    && apk add --no-cache curl jq \
    && rm -rf /var/cache/apk/* \
    && mkdir /app \
    && chgrp -R 0 /app \
    && chmod -R g=u /app 

USER 1001

ENTRYPOINT ["jq"]