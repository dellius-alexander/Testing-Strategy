# escape=\ (backslash)
#
FROM cypress/included:5.4.0
USER root
RUN mkdir -p /home/cypress
WORKDIR /home/cypress/e2e
RUN useradd cypress -d /home/cypress
RUN usermod -aG root cypress && newgrp root && su cypress
RUN env && echo $(id -u)
RUN npm config -g set user cypress
RUN eval bash
RUN cd /home/cypress
RUN mkdir -p /home/cypress/e2e && \
    cd /home/cypress/e2e 
WORKDIR  /home/cypress/e2e
ENV __CYPRESS_TESTS__=/home/cypress/e2e/cypress/integration/
ENV __CYPRESS_DIR__=/home/cypress/e2e/cypress
# avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=1

# disable shared memory X11 affecting Cypress v4 and Chrome
# https://github.com/cypress-io/cypress-docker-images/issues/270
ENV QT_X11_NO_MITSHM=1
ENV _X11_NO_MITSHM=1
ENV _MITSHM=0

# should be root user
RUN echo "whoami: $(whoami)"
#RUN npm config -g set user cypress

# command "id" should print:
# uid=0(root) gid=0(root) groups=0(root)
# which means the current user is root
RUN id

# point Cypress at the /root/cache no matter what user account is used
# see https://on.cypress.io/caching
ENV CYPRESS_CACHE_FOLDER=/root/.cache/Cypress
RUN npm install --save-dev "cypress@5.4.0"
RUN cypress verify

# Cypress cache and installed version
# should be in the root user's home folder
RUN cypress cache path
RUN cypress cache list
RUN cypress info

# give every user read access to the "/root" folder where the binary is cached
# we really only need to worry about the top folder, fortunately
RUN ls -la /root
RUN chmod 755 /root
# always grab the latest NPM and Yarn
# otherwise the base image might have old versions
RUN npm i -g yarn@latest npm@latest
# Install additional plugins
RUN npm i cy-view --save-dev
RUN npm i cypress-commands --save-dev
RUN npm i cypress-cy-select --save-dev
RUN npm i -D cypress-wait-until --save-dev
RUN npm install -D cypress-xpath --save-dev
# unset NODE_OPTIONS # this is not the same as export NODE_OPTIONS=
ENV NODE_OPTIONS='--max-http-header-size=1048576 --http-parser=legacy'
ENV __PACKAGE_JSON__=/home/cypress/e2e/package.json
ENV __CYPRESS_JSON__=/home/cypress/e2e/cypress.json
# set debugging for dev purposes *************
ENV DEBUG="cypress:* cypress run" 
RUN printf "node version:    $(node -v)\n"
RUN printf "npm version:     $(npm -v)\n"
RUN printf "yarn version:    $(yarn -v)\n"
RUN printf "debian version:  $(cat /etc/debian_version)\n"
RUN printf "user:            $(whoami)\n"
RUN printf "chrome:          $(google-chrome --version)\n"
RUN printf "firefox:         $(firefox --version)\n"
# copy files to the new image
COPY [ "package.json", "." ]
RUN printf "\n\nContents of: ${pwd} \n\n" \
&& pwd && ls -lia && sleep 2 \
&& cat package.json
COPY [ "cypress.json", "/home/cypress/e2e/" ]
RUN printf "\n\nContents of: /home/cypress/e2e \n\n" \
&& ls -lia /home/cypress/e2e \
&& sleep 2 && printf "\n\ncypress.json file:\n\n" \
&& cat /home/cypress/e2e/cypress.json \
&& printf "\n\n"
RUN printf "\n\nCypress Tests Directory: ${__CYPRESS_TESTS__}\n\n"
COPY [ "./cypress_tests/", "${__CYPRESS_TESTS__}" ]
RUN printf "\n\nContents of: ${__CYPRESS_TESTS__} \n\n" \
&& ls -lia ${__CYPRESS_TESTS__} && sleep 2
# verify configuration files
RUN printf "\n${__PACKAGE_JSON__}\n\n" \
&& cat ${__CYPRESS_JSON__}\n
RUN printf "\nPachage.json file: \n\n" \
&& cat ${__PACKAGE_JSON__}\n \
&&  printf "\nCypress.json file: \n\n${__CYPRESS_JSON__}\n"
RUN env
RUN printf "\nCurrent Directory: \n${pwd}\n\nObjects in current directory: \n\n" \
&& ls -lia ${pwd} && printf "\n\nRoot directory: \n\n" && ls -lia /
#
# cypress run command
CMD [ "cypress", "run" ]
