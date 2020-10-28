# escape=\ (backslash)
FROM nginx:stable
RUN apt-get update && apt-get -y upgrade
RUN echo "Successfully updated and upgrade"
# copy files to image
COPY [ "./www", "/usr/share/nginx/html" ]
RUN ls -lia /usr/share/nginx/html
EXPOSE 80
WORKDIR /usr/share/nginx/html
CMD [ "nginx", "-g", "daemon off;" ]
