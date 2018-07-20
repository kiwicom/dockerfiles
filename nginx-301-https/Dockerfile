FROM nginx:1.15.1-alpine

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 81

CMD ["nginx", "-g", "daemon off;"]

LABEL name=nginx-301-https \
      maintainer="Adam Janis <adam.janis@kiwi.com>"
