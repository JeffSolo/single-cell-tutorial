FROM continuumio/miniconda:latest

ARG CONDA_ENV=sc-tutorial
ARG CONDA_ENV_PATH=/opt/conda/envs/${CONDA_ENV}
ARG CASE_STUDY_DIR=./data/Haber-et-al_mouse-intestinal-epithelium

COPY . /single-cell-tutorial/

WORKDIR /single-cell-tutorial/

RUN /opt/conda/bin/conda update conda -y \
    && /opt/conda/bin/conda env create -f ./sc_tutorial_environment.yml --name $CONDA_ENV \
    && /opt/conda/bin/conda clean -afy
RUN mkdir -p "${CONDA_ENV_PATH}/etc/conda/activate.d/" \
    && mkdir -p "${CONDA_ENV_PATH}/etc/conda/deactivate.d/" \
    && mv ./build_files/activate_env_vars.sh ${CONDA_ENV_PATH}/etc/conda/activate.d/env_vars.sh \
    && mv ./build_files/deactivate_env_vars.sh ${CONDA_ENV_PATH}/etc/conda/deactivate.d/env_vars.sh \
    && rm -r ./build_files/ \
    && rm sc_tutorial_environment.yml

ENV PATH /opt/conda/envs/sc-tutorial/bin:$PATH
RUN echo "source activate sc-tutorial" > ~/.bashrc

RUN wget -P "${CASE_STUDY_DIR}" ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE92nnn/GSE92332/suppl/GSE92332_RAW.tar
RUN mkdir "${CASE_STUDY_DIR}/GSE92332_RAW" \
    && tar -C "${CASE_STUDY_DIR}/GSE92332_RAW" -xvf "${CASE_STUDY_DIR}/GSE92332_RAW.tar" \
    && gunzip ${CASE_STUDY_DIR}/GSE92332_RAW/*_Regional_*
RUN wget -P "${CASE_STUDY_DIR}" ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE92nnn/GSE92332/suppl/GSE92332_Regional_UMIcounts.txt.gz
RUN gunzip "${CASE_STUDY_DIR}/GSE92332_Regional_UMIcounts.txt.gz"
