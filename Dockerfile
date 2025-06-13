# Étape 1 : Image de base
FROM python:3.10-slim

# Étape 2 : Création du répertoire
WORKDIR /app

# Étape 3 : Copier le code
COPY app/ ./app/
COPY requirements.txt .

# Étape 4 : Installer les dépendances
RUN pip install -r requirements.txt

# Étape 5 : Lancer l'app
CMD ["python", "app/main.py"]
