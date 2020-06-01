## KICAD ##
# https://github.com/INTI-CMNB/kicad_debian/blob/master/Dockerfile
FROM setsoft/kicad_debian as kicad
LABEL MAINTAINER nerdyscout <nerdyscout@posteo.de>
LABEL Description="export various files from KiCad projects"
LABEL VERSION="v0.2"

# update packages
RUN apt-get update

# install pip3
RUN apt-get install -y python3-pip 
## install packages via pip3
RUN pip3 install kikit==0.4
RUN pip3 install kibom==1.7.1 
RUN pip3 install kicost==1.1.4
RUN apt-get install -y python3-cairo libmagickwand-dev && pip3 install pcbdraw==0.3.0

# install npm
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
## install packages via npm
RUN npm install -g @tracespace/cli@4.2.1 

# copy submodules
COPY opt /opt
## InteractiveHtmlBom
COPY submodules/InteractiveHtmlBom/InteractiveHtmlBom /opt/ibom
## kiplot
RUN apt-get install -y python3-yaml
COPY submodules/kiplot /opt/kiplot
RUN cd /opt/kiplot && pip3 install -e .
## kicad-automation-scripts
COPY submodules/kicad-automation-scripts /opt/kicad-automation
RUN pip3 install psutil==5.7.0 
RUN pip3 install xvfbwrapper==0.2.9 
RUN apt-get install -y xvfb xclip xdotool xsltproc 
RUN cd /opt/kicad-automation && python3 setup.py install
RUN alias pcbnew_do=/opt/kicad-automation/src/pcbnew_do && alias eeschema_do=/opt/kicad-automation/src/eeschema_do

#alias for all commands
COPY functions.sh .
COPY kicad-exports.sh /entrypoint.sh

WORKDIR /mnt
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]