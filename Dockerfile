FROM alpine:3.20

WORKDIR /app

RUN echo "hello from sada artifact registry" > /app/hello.txt

CMD ["cat", "/app/hello.txt"]
