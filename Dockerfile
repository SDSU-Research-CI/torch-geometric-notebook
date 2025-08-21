ARG BASE_IMAGE=quay.io/jupyter/pytorch-notebook:cuda12-2025-07-07
FROM ${BASE_IMAGE}

USER root
WORKDIR /opt

# Give jovyan passwordless sudo
RUN echo "jovyan ALL=(ALL:ALL) NOPASSWD" >> /etc/sudoers.d/user

# Install Rclone and VSCode Server
RUN curl -O https://rclone.org/install.sh \
 && bash /opt/install.sh \
 && rm -f /opt/install.sh \
 && curl -fsSL https://code-server.dev/install.sh | sh

# Fix permissions issues from any root installs of software
RUN fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

USER ${NB_USER}
WORKDIR /home/${NB_USER}

# Install torch geometric
RUN pip install pyg_lib torch_geometric torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.7.1+cu128.html

# Install VSCode Server proxy
RUN pip install jupyter-codeserver-proxy
