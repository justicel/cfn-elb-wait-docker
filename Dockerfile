FROM alpine:3.7

RUN apk update \
  && apk add python \
  && apk add py-pip \
  && apk add curl \
  && apk add bash \
  && pip install awscli \
  && pip install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /

ENTRYPOINT ["/entrypoint.sh"]
