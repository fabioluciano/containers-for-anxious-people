FROM httpd:2-alpine
ARG DEPLOYMENT
ADD ${DEPLOYMENT} /usr/local/apache2/htdocs/