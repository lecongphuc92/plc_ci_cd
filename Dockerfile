# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONUNBUFFERED=1

WORKDIR /code
COPY requirements.txt /code/

RUN apt-get update \
    && apt-get -y install libpq-dev gcc
RUN pip install -r requirements.txt
COPY . /code/

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.wsgi:application"]
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
