#!/usr/bin/env bash
######################################################################
set -e
# Install Cypress Locally
# Modify HOME & USER below:
HOME="/home/dalexander" # Update user home directory
USER="dalexander"       # Update username
printf "\n\nHome Directory: $HOME\nUSER: $USER\n\n"
######################################################################
# install dependencies
apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev \
libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 \
libxtst6 xauth xvfb
######################################################################
# Setup environment variables
# Location of node npm npm binaries
export NODEJS_HOME="/usr/local/share/node-v14.16.0-linux-x64/bin"
# Cypress downloads the matching Cypress binary to the global system cache; Linux: ~/.cache/Cypress
export CYPRESS_CACHE_FOLDER="$HOME/cypress_projects/.cache/Cypress"
export CYPRESS_PROJECT_DIR="$HOME/cypress_projects"
# Install a version different than the default npm package
export CYPRESS_INSTALL_BINARY=6.8.0
export CYPRESS_CRASH_REPORTS=0
######################################################################
cd $HOME/Downloads
if [ -d $HOME/cypress_projects ]; then 
printf "\n\nRemoving old cypress project directory......\n\n"
rm -rf $HOME/cypress_projects &>/dev/null
fi
wait $!
# create installation directory for cypress and custom cache location 
mkdir -p $HOME/cypress_projects &>/dev/null &&
mkdir -p $HOME/cypress_projects/.cache/Cypress &>/dev/null &&



# Take ownership of the directory
chown $USER:$USER -R $CYPRESS_PROJECT_DIR
echo "Cypress cache folder: $CYPRESS_CACHE_FOLDER"
echo "Nodejs home: $NODEJS_HOME"

# download, unzip and move node to /usr/local/share directory
printf "\n\nDownloading nodejs......\n"
sleep 3
curl -fsSL https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz \
-o $HOME/Downloads/node-v14.16.0-linux-x64.tar.xz

printf "\nmoving node to /usr/local/share......\n"
sleep 3
tar -xvf $HOME/Downloads/node-v14.16.0-linux-x64.tar.xz -C /usr/local/share/ 


printf "\n\nSetting up node to persist reboots......\n"
sleep 3
# Add node to PATH
if [ $(cat $HOME/.bash_aliases | grep -ic "CYPRESS" ) -lt 1 ] && [ $(echo $PATH | grep -ic "$NODEJS_HOME") -eq 0 ]; then
  # persist reboots
  cat >>$HOME/.bash_aliases<<EOF
#####################################################################
#########################  NodeJS Binaries  #########################
# NodeJS
export NODEJS_HOME="/usr/local/share/node-v14.16.0-linux-x64/bin/"
export CYPRESS_CACHE_FOLDER="$HOME/cypress_projects/.cache/Cypress"
# opt out of sending exception data
export CYPRESS_CRASH_REPORTS=0
export CYPRESS_INSTALL_BINARY=6.8.0
#####################################################################
################### UPDATE EXPORT PATH ##############################
export PATH='$PATH:$NODEJS_HOME'
EOF
sleep 3
source $HOME/.bash_aliases
# setup cypress project config file
fi
#
#
printf "\n\nSetting up cypress environment......\n\n"
cat >$CYPRESS_PROJECT_DIR/cypress.json<<EOF
{
  "env": {
      "CYPRESS_CACHE_FOLDER": "~/cypress_projects/.cache/Cypress"
  },
  "pageLoadTimeout": 60000,
  "viewportWidth": 1920,
  "viewportHeight": 1080
}
EOF

# project global configurations file
cat >$CYPRESS_PROJECT_DIR/package.json<<EOF
{
"name": "cypress-test-suite-demo",
"description": "Example full e2e test code coverage.",
"scripts": {
  "cypress:open": "cypress open",
  "cypress:run": "cypress run"
},
"devDependencies": {
  "cypress": "^6.8.0"
},
"license": "MIT"
}
EOF
#

cd $CYPRESS_PROJECT_DIR
sleep 3
printf "\n\nLocation of cypress install location: $CYPRESS_PROJECT_DIR\n\n"
# verify node added to path
if [ $(echo ${PATH} | grep -ic 'node-v14.16.0-linux-x64') -eq 0 ]; then
export PATH="$PATH:$NODEJS_HOME"
fi
printf "\n\nInstalling Cypress.....\n\n"
sleep 1
npm install cypress  --save-dev
sleep 3
npm install cypress-xpath --save-dev
wait $!
# Take ownership of the project folder
chown $USER:$USER -R $CYPRESS_PROJECT_DIR
wait $!
npx cypress open &
wait $!
sleep 3
if [ -f "$CYPRESS_PROJECT_DIR/cypress/support/index.js" ]; then
cat >>$CYPRESS_PROJECT_DIR/cypress/support/index.js<<EOF
/// <reference types="cypress" />
// ***********************************************************
// This example plugins/index.js can be used to load plugins
//
// You can change the location of this file or turn off loading
// the plugins file with the 'pluginsFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/plugins-guide
// ***********************************************************

// This function is called when a project is opened or re-opened (e.g. due to
// the project's config changing)

/**
 * @type {Cypress.PluginConfig}
 */
// eslint-disable-next-line no-unused-vars
// export a function
module.exports = (on, config) => {
  // bind to the event we care about
  on('<event>', (arg1, arg2) => {
    // plugin stuff here
    // -----------------------------------------------------------
//////////////////////////////////////////////////////////////
// Install cypress-xpath
///////////////////////////////
// w: npm install -D cypress-xpath
// w: yarn add cypress-xpath --dev
// Then include in your project's cypress/support/index.js
    require('cypress-xpath')
  })
}

EOF
fi
printf "\n\nInstallation complete......\n\n"
exit 0