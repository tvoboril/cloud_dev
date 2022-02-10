FROM ubuntu:latest
LABEL maintainer="Tomas Voboril"
# Base Tools
RUN apt-get update && apt-get install -y sudo curl git wget nano vim zsh unzip tmux openssh-client rsync apt-transport-https ca-certificates gnupg python ruby
RUN gem install colorls
# Google Cloud Tools
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install -y google-cloud-sdk
# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash    
# AWS CLI
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o "awscliv2.zip" && \ 
    unzip awscliv2.zip && \
    sudo ./aws/install       
# Install CFSSL  
RUN  wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson && \
  chmod +x cfssl cfssljson && \
  mv cfssl cfssljson /usr/local/bin/
# Install Kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/
# Kubectk and Kubens    
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
    curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
# Setup Dev User

RUN adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser && \
    echo "devuser:p@ssword1" | chpasswd &&  usermod -aG sudo devuser
RUN git clone https://github.com/tvoboril/zsh_master.git /home/devuser/zsh_master && \
chmod 777 /home/devuser/zsh_master/install.sh
USER devuser
CMD ["zsh"]
