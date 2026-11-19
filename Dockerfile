# TODO 1 : image de base légère
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# TODO 2 : utilisateur système non-root d'UID 10001
RUN useradd --system --uid 10001 --no-create-home appuser

# TODO 3 : répertoire de travail
WORKDIR /app

# TODO 4 : d'abord les dépendances seules (pour le cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# TODO 5 : ensuite le code
COPY app.py calendrier.py ./

ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

# TODO 6 : passer en non-root
USER 10001

# TODO 7 : documenter le port
EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "app:app"]
