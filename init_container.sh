#!/usr/bin/env bash
###############################################################################
###############################################################################
RED='\033[0;31m' # Red
NC='\033[0m' # No Color CAP
__PROJECT_ENV__=$(find ~+ -type f -name 'project.env')
###############################################################################
###############################################################################
###############################################################################
function __get_env__(){
###############################################################################
# Local project.env
# Checking if environments have loaded
#source $(find ~+ -type f -name 'project.env')
if [[ -f ${1} ]]; then
source ${1}
wait $!
fi
printf "\n"
echo  "Cypress directory: ${__TEST_DIR__}"
echo  "Cypress dockerfile:  ${__CYPRESS_DOCKERFILE__}"
echo  "Webserver Dockerfile:  ${__WWW_DOCKERFILE__}"
echo  "Display Variable: ${__DISPLAY__}"
echo  "Server Gateway:  ${__IP_ADDR__}"
echo  "Hyfi Container Count: ${__HYFI_CNTR_COUNT__}"
echo  "Cypress Container Count: ${__CYPRESS_CNTR_COUNT__}"
echo  "Cypress sample file: ${__CYPRESS_SAMPLE__}"
printf "\n"
#
wait $!
}
###############################################################################
###############################################################################
function init(){
###############################################################################
__get_env__ ${__PROJECT_ENV__}
wait $!
#
echo  "Hyfi Container Count: ${__HYFI_CNTR_COUNT__}"
echo  "Cypress Container Count: ${__CYPRESS_CNTR_COUNT__}"
#
# Starting webserver ...
if [[ ${__HYFI_CNTR_COUNT__} != 0 ]]; then
# Docker build ...
printf "\nBuilding Webserver docker image...\n\n"    

docker build \
-t ${__WWW_WEBSERVER_IMAGE__} \
-f ${__WWW_DOCKERFILE__} .
wait $!

[[  $? != 0 ]] && \
printf "Sorry Docker build failed...\n$?\n" && \
exit $? 

printf "\nStarting Webserver...\n\n"

docker run -it --rm -d \
-p 32609:80 \
--cpus="0.5" \
--name www \
${__WWW_WEBSERVER_IMAGE__}
wait $!

else
    printf "\nWebserver is up and running...\n"
fi
#
 wait $!
#
# Start Cypress ...
if [[ ${__CYPRESS_CNTR_COUNT__}  != 0 ]]; then
# Docker build ...
printf "\nBuilding Cypress docker image...\n\n"

docker build \
-t ${__CYPRESS_INCLUDED_IMAGE__}  \
-f ${__CYPRESS_DOCKERFILE__} .
wait $!

[[  $? != 0  ]] && \
printf "Sorry Docker build failed...\n$?\n" && \
exit $?

wait $!

printf "\nDocker Cypress build complete...\n"

# Docker run ...
printf "\nStarting Cypress GUI...\n\n"

docker run -it --rm  -d \
--cap-add=sys_nice \
--ulimit rtprio=99 \
--memory=1024m \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e ${__DISPLAY__} \
-e DEBUG='cypress:* cypress run' \
-w /e2e \
--entrypoint=cypress \
--name=cypress \
${__CYPRESS_INCLUDED_IMAGE__}  run --project . \
--config baseUrl=http://host.docker.internal:32609

wait $!

# setup debug logging
[ $? == 0 ] && docker logs -f cypress

sleep 1

else
printf "\nCypress is up and running ...\n"
sleep 1
fi
touch init_container.lock
#
}
###############################################################################
###############################################################################
init
###############################################################################
###############################################################################
# # Docker run ...
# printf "\nStarting Cypress GUI...\n\n"

# docker run -it --rm  -d -P \
# --cap-add=sys_nice \
# --ulimit rtprio=99 \
# --memory=1024m \
# -v /tmp/.X11-unix:/tmp/.X11-unix \
# -v  qa:/e2e \
# -e DISPLAY=${__DISPLAY__} \
# -e DEBUG='cypress:*' \
# --entrypoint=cypress \
# --name=cypress \
# dalexander2israel/cypress/included:v1 \
###############################################################################
# open --project . \
# --config baseUrl=http://host.docker.internal:32679
###############################################################################
# run --project . \
# --headless --browser firefox --spec 'cypress/integration/sample.spec.js'