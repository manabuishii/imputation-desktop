#!/bin/bash

# O is not install packages, 1 is install packages
INSTALLPACKAGE=0

#
INSTALLDIR=$PWD/sapporo-install
EXECUTABLEWORKFLOWSJSON_PATH=${INSTALLDIR}/imputation-desktop/scripts/executable_workflows.json
RUNSH_PATH=${INSTALLDIR}/imputation-desktop/scripts/run.singularity.sh
NUXTCONFIGTS_PATH=${INSTALLDIR}/imputation-desktop/scripts/nuxt.config.ts
PREREGISTEREDSERVICES_PATH=${INSTALLDIR}/imputation-desktop/scripts/preRegisteredServices.json
UWSGIYAML_PATH=${INSTALLDIR}/imputation-desktop/scripts/uwsgi.yaml
STARTSTOPSCRIPTDIRECTORY_PATH=${INSTALLDIR}/imputation-desktop/scripts/


# instgall packages
if [ ${INSTALLPACKAGE} -eq 1 ]; then
    sudo apt-get update
    sudo apt-get install git build-essential libffi-dev libssl-dev libcurl4-openssl-dev zlib1g-dev -y --no-install-recommends
    sudo apt-get clean
    sudo rm -rf /var/lib/apt/lists/*
    # pip install cwltool==3.1.20210816212154
fi


mkdir ${INSTALLDIR}
chmod 777 ${INSTALLDIR}
cd ${INSTALLDIR}

curl -O -L https://nodejs.org/dist/v14.17.6/node-v14.17.6-linux-x64.tar.xz
xz -d node-v14.17.6-linux-x64.tar.xz
tar -xvf node-v14.17.6-linux-x64.tar
# TODO install nodejs into PATH
# export PATH=~/nodejs/node-v14.17.6-linux-x64/bin:$PATH
export PATH=${INSTALLDIR}/node-v14.17.6-linux-x64/bin:${PATH}

curl -O -L https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
tar zxvf Python-3.9.7.tgz
cd Python-3.9.7
./configure --prefix=${INSTALLDIR}/python/py397
make
make install

cd ..

# imputation server
git clone https://github.com/ddbj/imputation-server-ui.git
cd imputation-server-ui
${INSTALLDIR}/python/py397/bin/python3 -m venv venv-imputationserver-web-ui
source venv-imputationserver-web-ui/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
#nohup python3 app.py &
deactivate
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/start-imputation-server-ui.sh .
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/stop-imputation-server-ui.sh .
cd ..

# imputation desktop
# for settting files
git clone https://github.com/manabuishii/imputation-desktop.git

# sapporo-service
git clone https://github.com/sapporo-wes/sapporo-service.git -b 1.0.16
cd sapporo-service
## setting files
cp ${EXECUTABLEWORKFLOWSJSON_PATH} sapporo/executable_workflows.json
cp ${RUNSH_PATH} sapporo/run.sh
# cp ${UWSGIYAML_PATH} uwsgi.yaml
##
${INSTALLDIR}/python/py397/bin/python3 -m venv venv-sapporo-service
source venv-sapporo-service/bin/activate
# some libraries are not found VM environment.
# those libraries are required for uwsgi, but this time we do not use uwsgi.
# So we install sapporo related libraries manually.
## Original: pip install --no-deps sapporo==1.0.16
pip install --no-deps sapporo==1.0.16
pip install requests Flask jsonschema
pip install cwltool==3.1.20210816212154
#nohup python3 sapporo/app.py --host=0.0.0.0 --run-sh sapporo/run.sh  --executable-workflows sapporo/executable_workflows.json &
deactivate
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/start-sapporo-service.sh .
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/stop-sapporo-service.sh .
cd ..

# sapporo-web
git clone https://github.com/sapporo-wes/sapporo-web.git -b 1.0.10
cd sapporo-web
curl -o src/plugins/loadPreRegisteredServices.ts https://raw.githubusercontent.com/sapporo-wes/sapporo-web/d7be4a559ba3d431aef05a1f93d11254ba8083b8/src/plugins/loadPreRegisteredServices.ts
# copy setting files
cp ${NUXTCONFIGTS_PATH} nuxt.config.ts
cp ${PREREGISTEREDSERVICES_PATH} src/assets/preRegisteredServices.json
# TODO set readonly mode
npm install yarn
# export PATH=node_modules/.bin:$PATH
node_modules/.bin/yarn install --flozen-lock
node_modules/.bin/yarn generate
#nohup node_modules/.bin/yarn start &
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/start-sapporo-web.sh .
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/stop-sapporo-web.sh .
# 
cd ..
# startall.sh
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/startall.sh .
cp ${STARTSTOPSCRIPTDIRECTORY_PATH}/stopall.sh .
./startall.sh

