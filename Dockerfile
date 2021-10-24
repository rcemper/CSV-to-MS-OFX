ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
FROM $IMAGE

USER root   
## add git
# RUN apt update && apt-get -y install git

WORKDIR /opt/irisbuild
COPY MONEY MONEY

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild 
RUN chmod -R 777 /opt/irisbuild/MONEY

USER ${ISC_PACKAGE_MGRUSER}

#COPY  Installer.cls .
COPY src src
COPY module.xml module.xml
COPY iris.script iris.script

RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly
