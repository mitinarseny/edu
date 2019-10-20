ARG PANDOC_VERSION=2.7.3
FROM pandoc/latex:${PANDOC_VERSION}

RUN apk add --no-cache \
  make \
  jq
