FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install pipenv and compilation dependencies
RUN pip install pipenv
RUN apt-get update && apt-get install -y --no-install-recommends gcc

COPY app/ /app
# Manage dependencies with Pipenv but install them with pip in the container, so autocomplete works
# in our IDE.
RUN cd /app && pipenv lock -r > requirements.txt && pipenv lock -r --dev-only > dev-requirements.txt

# Create and switch to a new user
RUN useradd --create-home appuser
USER appuser

WORKDIR /app

RUN pip install -r requirements.txt && pip install -r dev-requirements.txt
