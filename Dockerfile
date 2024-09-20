FROM python:3.12.5-alpine3.20

LABEL authors="SsantiVl"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requiremenst.dev.txt

WORKDIR /student_center

RUN adduser \
    --disabled-password \
    --no-create-home \
    dj-user && \
    apk add --no-cache gcc musl-dev postgresql-dev python3-dev && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install --no-cache-dir -r /tmp/requirements.dev.txt && \
    /py/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -rf /tmp

ENV PATH="/py/bin:$PATH"

USER dj-user

EXPOSE 8000

COPY . /student_center

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
