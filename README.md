# Testing-Strategy

This project demonstrates how to use **jenkins** running inside a **kubenetes** single node cluster and persisted NFS share directory. We are using jenkins to create a CI/CD pipeline in order to build, test and deploy a webservice/webserver. Tests will be ran throughout each environment. If any failures occur, the deployment process will be rolled back, development will be notifed and corrections will be made before the processes is repeated, until all tests have passed. At which time updates will be deployed to the production environment.
