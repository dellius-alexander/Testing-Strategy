# Testing-Strategy

This project demonstrates one way to deploy **jenkins** on a **kubenetes** single node bare-metal cluster. Jenkins data is persisted externally via NFS share directory to persist system restarts. This pipeline will be used to build, test and deploy applications, webservices/webserver, and so much more. As each iteration of our application is committed to this version control tool, we will test the integrety of the application. If any failures occur, the deployment process will be rolled back, development will be notifed and corrections will be made before the processes is repeated, until all tests have passed. Then then app is deployed to your production environment or server.

---
---
## Testing with Cypress
We have used ***Cypress*** to conduct end-to-end testing within an isolated jenkins environment. Upon each commit as tests are updated for the current version under development, qa writes tests scripts/specs that jenkins will employ to test against newly checked in code or updates to our application.  
<br/>
Upon each iteration Cypress will be rebuilt via [cypress.Dockerfile](./cypress.Dockerfile).  Once the environment is setup we get a snapshot of our testing environment in the form of a docker image ([<Some_Docker_User_Account>/cypress_included:5.4.0](./cypress.Dockerfile)). The custom image is now ready to spin up any time we need to run any tests suite as need.  Each Jenkins testing environment is also equipt with docker and kubernetes support using access credentials.  see [JENKINS_README](./kubernetes/jenkins/JENKINS_READ.md). 

---
---

## CI/CD Pipeline Build
---
The pipeline build has been automated using the *[__init_container__.sh](./__init_container__.sh)* script which will be executed inside the Jenkins Pod to kick-off our tests.

You may use various methods to define a jenkins build. For the purpose of this project we emply a shell script to automate our pipeline.

---

### Build Stages:
<br/>

**This process has been automated for ease of use upon script execution:**
<br/>

A. The environment is cleansed of any old version of the repo. 

B. A new copy of the repo is cloned into our Jenkins environment.

C. The *[__init_container__.sh](./__init_container__.sh)* script is executed 
   in our Jenkins environment. The script setups up your environment by 
   access the environment file, which is loosely coupled for flexibility 
   of environments.  Then we starts our build process, in the following order.

   1. Clone the repo containing the webservice files and build the new 
      webservice image.
   2. Use our newly created image in our local registry and run the webservice.
   3. Clone the repo containing our cypress tests scripts and build the test 
      environment image.
   4. Run the new image and all test inside your new environment.
   5. Tests are ran against our new webservice container from our 
      cypress container.
   6. Once completed, the webservice and test environment is distroyed and 
      cleansed for the next interation.

---
### <a id="demo-video">See Demo Video</a>
.... <!-- post content -->

[![Jenkins](media/screenshot_contact_sizing.png)](https://www.youtube.com/embed/jFOrcgQPZ1k "Jenkins")

.... <!-- post content -->
