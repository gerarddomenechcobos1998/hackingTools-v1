# pull Ubuntu 20.04 image
FROM ubuntu:20.04 

# install basic commands
RUN apt-get update --fix-missing
RUN apt-get -y upgrade
RUN apt-get install -y apt-utils
RUN apt-get install -y bash
# install net tools
RUN apt install net-tools
RUN apt install -y iputils-ping
RUN apt install -y whois
RUN apt install -y dnsutils
RUN apt install -y netcat
# Environments
# IMPORTANT while using Debian systems in Docker: This environment avoids interaction with CMD while installing packages via apt. 
ENV DEBIAN_FRONTEND=noninteractive

# install git
RUN apt-get install -y git

# Install other tools
RUN apt-get install -y nano
# Install hacking tools
RUN apt install nmap -y 
# install docker
RUN apt-get install -y ca-certificates
RUN apt-get install -y curl
RUN apt-get install -y apt-transport-https
# When install software-properties-common asks for timezone, then add this package to fix problems while building docker file
RUN apt-get install -y tzdata
RUN apt-get install -y software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# "dpkg --print-architecture" returns the architecture
# the $(command) uses output of the command specified as a variable
RUN add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu focal stable"
# docker-ce : docker engine, community edition. Requires docker-ce-cli.
RUN apt-get install -y docker-ce
# docker-ce-cli: command line interface for docker engine, community edition
RUN apt-get install -y docker-ce-cli
# containerd.io : daemon containerd. It works independently on the docker packages, and it is required by the docker packages. containerd is available as a daemon for Linux and Windows. It manages the complete container lifecycle of its host system, from image transfer and storage to container execution and supervision to low-level storage to network attachments and beyond.
RUN apt-get install -y containerd.io

# Install docker-compose
# RUN apt-get install docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
# docker-compose-plugin: its a cli of docker-compose
RUN apt-get install docker-compose-plugin

# jq its a JSON converter
RUN apt-get install -y jq
# Install nodeJS
RUN curl -s https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
# Install yarn 
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN npm install --global yarn

# copy-dependencies package --> Updates the package.json file in the target folder to include the values of dependencies, peerDependencies and devDependencies from the package.json in the source folder
RUN yarn global add copy-dependencies

# Install pip3
RUN apt-get install python3-pip -y
RUN apt install libcurl4-openssl-dev libssl-dev
# Install terminal zsh
RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p 'history-substring-search' \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    -p https://github.com/zsh-users/zsh-completions
RUN chsh -s $(which zsh)
RUN PATH="$PATH:/usr/bin/zsh"

# INSTALL ETHICAL HACKING TOOLS
WORKDIR ~
# Install wfuzz
RUN pip install wfuzz
# Copy SecLists
RUN git clone https://github.com/danielmiessler/SecLists.git
# Install sqlmap
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
# Install subbrute
RUN git clone https://github.com/TheRook/subbrute
# Install Nikto
RUN git clone https://github.com/sullo/nikto

# Run
COPY ./docker-entrypoint.sh .
CMD ./docker-entrypoint.sh