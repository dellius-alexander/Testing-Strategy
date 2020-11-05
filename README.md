# Testing-Strategy

This project demonstrates one way to deploy **jenkins** on a **kubenetes** single node bare-metal cluster. Jenkins data is persisted externally via NFS share directory to persist system restarts. This pipeline will be used to build, test and deploy applications, webservices/webserver, and so much more. As each iteration of our application is committed to this version control tool, we will test the integrety of the application. If any failures occur, the deployment process will be rolled back, development will be notifed and corrections will be made before the processes is repeated, until all tests have passed. Then then app is deployed to your production environment or server.

---
---
## Testing with Cypress
We have used ***Cypress*** to conduct end-to-end testing within an isolated jenkins environment. Upon each commit as tests are updated for the current version under development, qa writes tests scripts/specs that jenkins will employ to test against newly checked in code or updates to our application.  
<br/>
Upon each iteration Cypress will be rebuild via [Dockerfile](cypress.Dockerfile), tests imported and ran against our application. 

---
---
<iframe
  src="media\@jenkins-deployment-664dfb6f79-zbgnf__var_jenkins_home_workspace_cypress_build 2020-11-04 21-01-27 - Shortcut.lnk"
  style="width:100%; height:300px;"
></iframe>