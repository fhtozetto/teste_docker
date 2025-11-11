FROM python:3.12-slim

# Instalar dependências
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    wget \
    zsh \
    fonts-powerline \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Instalar Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Instalar plugins populares
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configurar .zshrc
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting python docker)/g' ~/.zshrc && \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc

# Definir Zsh como shell padrão
RUN chsh -s $(which zsh)

# Criar script para fixar permissões SSH
RUN echo '#!/bin/bash\n\
if [ -d "/root/.ssh" ]; then\n\
    # Copiar .ssh para um diretório temporário com permissões corretas\n\
    cp -r /root/.ssh /root/.ssh-temp\n\
    rm -rf /root/.ssh\n\
    mv /root/.ssh-temp /root/.ssh\n\
    \n\
    # Ajustar permissões\n\
    chmod 700 /root/.ssh\n\
    chmod 600 /root/.ssh/id_* 2>/dev/null || true\n\
    chmod 644 /root/.ssh/*.pub 2>/dev/null || true\n\
    chmod 644 /root/.ssh/config 2>/dev/null || true\n\
    chmod 644 /root/.ssh/known_hosts 2>/dev/null || true\n\
fi' > /usr/local/bin/fix-ssh-permissions.sh && \
    chmod +x /usr/local/bin/fix-ssh-permissions.sh

# Instalar UV
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

COPY pyproject.toml ./
COPY uv.lock* ./

RUN uv sync

COPY . .

# Executar fix de permissões e então sleep
CMD ["/bin/bash", "-c", "/usr/local/bin/fix-ssh-permissions.sh && sleep infinity"]




# FROM python:3.12-slim

# # Instalar dependências
# RUN apt-get update && \
#     apt-get install -y \
#     git \
#     curl \
#     wget \
#     zsh \
#     fonts-powerline \
#     openssh-client \
#     && rm -rf /var/lib/apt/lists/*

# # Instalar Oh My Zsh
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# # Instalar plugins populares
# RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# # Configurar .zshrc
# RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting python docker)/g' ~/.zshrc && \
#     sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc

# # Definir Zsh como shell padrão
# RUN chsh -s $(which zsh)

# # Criar diretório SSH com permissões corretas
# RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# # Instalar UV
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# WORKDIR /app

# COPY pyproject.toml ./
# COPY uv.lock* ./

# RUN uv sync

# COPY . .

# CMD ["sleep", "infinity"]



# FROM python:3.12-slim

# # Instalar dependências
# RUN apt-get update && \
#     apt-get install -y \
#     git \
#     curl \
#     wget \
#     zsh \
#     fonts-powerline \
#     && rm -rf /var/lib/apt/lists/*

# # Instalar Oh My Zsh
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# # Instalar plugins populares
# RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# # Configurar .zshrc
# RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting python docker)/g' ~/.zshrc && \
#     sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc

# # Definir Zsh como shell padrão
# RUN chsh -s $(which zsh)

# # Instalar UV
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# WORKDIR /app

# COPY pyproject.toml ./
# COPY uv.lock* ./

# RUN uv sync

# COPY . .

# CMD ["sleep", "infinity"]