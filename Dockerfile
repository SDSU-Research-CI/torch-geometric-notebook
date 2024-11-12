ARG BASE_IMAGE=quay.io/jupyter/pytorch-notebook:cuda12-2024-07-29
FROM ${BASE_IMAGE}

USER root

# Give jovyan passwordless sudo
RUN echo "jovyan ALL=(ALL:ALL) NOPASSWD" >> /etc/sudoers.d/user \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

USER ${NB_USER}
WORKDIR /home/${NB_USER}

RUN pip install pyg_lib torch_geometric torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.4.0+cu121.html
