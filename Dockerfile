FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour + installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    nginx \
    openssh-server \
    iputils-ping \
    net-tools \
    nano \
    python3 \
    sudo \
    sshpass \
 && rm -rf /var/lib/apt/lists/*

# Préparation du service SSH
RUN mkdir -p /var/run/sshd && ssh-keygen -A

# Configuration SSH pour autoriser root et les mots de passe
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'Port 22' >> /etc/ssh/sshd_config

# Exposer nginx + SSH
EXPOSE 80 22

# Définir un mot de passe root
RUN echo "root:password" | chpasswd

# Démarrage de SSH en premier plan
CMD ["/usr/sbin/sshd", "-D"]


