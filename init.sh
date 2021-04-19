#!/usr/bin/env bash
docker run -it --rm  -d --cap-add=sys_nice \
--ulimit rtprio=99 \
--memory=1024m \
-v ${PWD}/cypress_tests/:/home/cypress/e2e/cypress/integration/cypress_tests \
-v ${PWD}/video:/home/cypress/e2e/cypress/videos/ \
-e DEBUG='cypress:run' \
-e PAGELOADTIMEOUT=60000 \
-w /home/cypress/e2e --entrypoint=cypress \
--name=cypress registry.dellius.app/cypress/custom:v5.4.0  \
run --headless --browser firefox --spec '/home/cypress/e2e/cypress/integration/*'
