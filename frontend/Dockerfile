# Étape 1 : Installation et Construction
FROM debian:latest AS build-env

RUN apt-get update && apt-get install -y curl git unzip

# Installation de Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Préparation de l'environnement web
RUN flutter doctor
RUN flutter config --enable-web

# Copie du code et construction
COPY . /app
WORKDIR /app
RUN flutter pub get
RUN flutter build web

# Étape 2 : Diffusion via un serveur léger (Nginx)
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
