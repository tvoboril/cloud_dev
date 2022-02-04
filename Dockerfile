FROM ubuntu:latest
LABEL maintainer="Tomas Voboril"
RUN apt-get update
RUN apt-get install -y sudo curl git wget nano vim zsh unzip tmux openssh-client rsync apt-transport-https ca-certificates gnupg python
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install -y google-cloud-sdk
RUN wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson
RUN chmod +x cfssl cfssljson
RUN mv cfssl cfssljson /usr/local/bin/
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/
RUN adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser && \
    echo "devuser:p@ssword1" | chpasswd &&  usermod -aG sudo devuser
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sudo ./aws/install
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx
RUN sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
RUN sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
RUN curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
USER devuser
CMD ["zsh"]
