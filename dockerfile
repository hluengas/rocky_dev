FROM rockylinux:latest

ENV USERNAME "umbriel"
ENV PASSWORD "password"
ENV UID "1000"
ENV GID "1000"
ENV HOMEDIR "/home/umbriel"
ENV USERSHELL /usr/bin/fish

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm && \
    dnf install -y https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm && \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo && \
    dnf upgrade -y && \
    dnf install -y \
        code \
        fish \
        libxshmfence \
        openssh-clients \
        openssh-server \
        passwd \
        sudo

RUN ssh-keygen -A && \
    mkdir ${HOMEDIR} && \
    groupadd --gid ${GID} ${USERNAME} && \
    adduser -M \
        -G wheel \
        -u ${UID} \
        -g ${GID} \
        -d ${HOMEDIR} \
        -s ${USERSHELL} \
        ${USERNAME} && \
    echo -e "${PASSWORD}\n${PASSWORD}" | passwd ${USERNAME}

# USER ${UID}:${GID}

EXPOSE 22

CMD /usr/sbin/sshd -D -e