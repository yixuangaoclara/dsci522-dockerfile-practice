# Use Jupyter's minimal-notebook image as the base image
FROM quay.io/jupyter/minimal-notebook:afe30f0c9ad8

# Switch to root user to install additional dependencies
USER root

# Ensure mamba is correctly installed
RUN conda install -n base -c conda-forge mamba

# Copy the conda.lock file into the Docker image
COPY conda-linux-64.lock /tmp/conda-linux-64.lock

# Use mamba to install packages from the lock file
RUN mamba update --quiet --file /tmp/conda-linux-64.lock \
    && mamba clean --all -y -f \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

# Switch back to the default notebook user
USER ${NB_UID}

# Set the working directory
WORKDIR /home/jovyan

# Expose the default notebook port
EXPOSE 8888

# Command to run the notebook server
CMD ["start-notebook.sh"]