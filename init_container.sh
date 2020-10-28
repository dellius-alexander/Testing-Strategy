#!/usr/bin/env bash
###########################################################
###########################################################
###########################################################
# Build docker image
__DOCKER__="docker" # docker command
wait $!
export __CYPRESS_DIR__=$(find ~+ -type d -name "cypress")  &> dev null
wait $!
export __CYPRESS_DOCKERFILE__=$(find ~+ -type f -name "cypress.dockerfile")  &> dev null
wait $!
export __CYPRESS_SAMPLE__=$(find ~+ -type f -name "sample.spec.js")  &> dev null
wait $!
export __WWW_DIR__=$(find ~+ -type d -name "www")  &> dev null
wait $!
export __WWW_DOCKERFILE__=$(find ~+ -type f -name "www.dockerfile")  &> dev null
wait $!
export __IP_ADDR__="$(grep nameserver /etc/resolv.conf | gawk {'print $2'})"  &> dev null
wait $!
export __DISPLAY__=${__IP_ADDR__}:0.0 
wait $!
export __CYPRESS__="cypress"
wait $!
export __HYFI_CNTR_COUNT__=$(docker ps -a | grep --count www |  gawk {'print $1'})   &> dev null
export __CYPRESS_CNTR_COUNT__=$(docker ps -a | grep --count cypress |  gawk {'print $1'})   &> dev null
wait $!
#
#
printf "\n"
printf "Cypress directory: ${__CYPRESS_DIR__}\n"
printf "Cypress dockerfile: ${__CYPRESS_DOCKERFILE__}\n"
printf "Cypress sample file: ${__CYPRESS_SAMPLE__}\n"
printf "Website Directory: ${__WWW_DIR__}\n"
printf "Webserver Dockerfile: ${__WWW_DOCKERFILE__}\n"
printf "Display variable: ${__DISPLAY__}\n"
printf "Server Gateway: ${__IP_ADDR__}\n"
printf "Hyfi Container Count: ${__HYFI_CNTR_COUNT__}\n"
printf "Cypress Container Count: ${__CYPRESS_CNTR_COUNT__}\n"
printf "\n"
#
wait $!
#
# Starting webserver ...
if [ ${__HYFI_CNTR_COUNT__} == 0 ]; then

    # Docker build ...
    printf "\nBuilding Webserver docker image...\n\n"    
    
docker build \
-t www_hyfi:v1 \
-f ${__WWW_DOCKERFILE__} . #&> dev null

    if [ $? != 0 ]; then
        printf "Sorry Docker build failed...\n$?\n"
        exit $?
    fi    

    printf "\nStarting Webserver...\n\n"

docker run -it --rm -d \
-v ${__WWW_DIR__}:/usr/share/nginx/html \
-w /usr/share/nginx/html \
-p 32769:80 \
--cpus="0.5" \
--name www \
www_hyfi:v1                   
#&> dev null

else
    printf "\nWebserver is up and running  ...\n"
fi
#
 wait $!
#
# Start Cypress ...
if [ ${__CYPRESS_CNTR_COUNT__}  == 0 ]; then
    # Docker build ...
    printf "\nBuilding Cypress docker image...\n\n"

    docker build \
    -t cypress_included:dev_01 \
    -f ${__CYPRESS_DOCKERFILE__} . #&> dev null

    if [ $? != 0 ]; then
        printf "Sorry Docker build failed...\n$?\n"
        exit $?
    fi    

    printf "\n$?\n"
    wait $!
    
    printf "\nDocker Cypress build complete...\n"
    
    # Docker run ...
    printf "\nStarting Cypress GUI...\n\n"

    docker run -it --rm  -d -P \
    --cap-add=sys_nice \
    --ulimit rtprio=99 \
    --memory=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${PWD}:/e2e \
    -w /e2e \
    -e DISPLAY=${__DISPLAY__} \
    -e DEBUG='cypress:*' \
    --entrypoint=cypress \
    --name=cypress \
    cypress_included:dev_01  open --project . \
    --browser firefox --spec 'cypress/integration/sample.spec.js' \
    --config baseUrl=http://host.docker.internal:32769
    
    #--browser chrome --spec ./cypress/integration/www_tests/sample.spec.js
    #--config baseUrl=http://host.docker.internal:32769
    #run --browser firefox --spec 'cypress/integration/sample.spec.js'


    # capture debug logging
    [ $? == 0 ] && docker logs -f cypress


else
    printf "\nCypress is up and running ...\n"
fi
#
wait $!

