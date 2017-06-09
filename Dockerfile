FROM python:3.6.0

RUN mkdir -p /app

COPY requirements.txt /app/requirements.txt

WORKDIR /app

COPY . /app

RUN make dependencies

VOLUME ["/app/output"]

CMD make build
