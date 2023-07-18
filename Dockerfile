#FROM tensorflow/tensorflow:latest
##FROM python:3.8-slim-buster
#COPY quint /quint
#COPY requirements.txt /requirements.txt
#RUN pip install --upgrade pip
#RUN pip install -r requirements.txt
#RUN python -m spacy download en_core_web_lg
##RUN python -m spacy download en_core_web_sm
#CMD uvicorn quint.api.fast:app --host 0.0.0.0 --port $PORT
#
#
##docker run -e PORT=8000 -p 8000:8000 --env-file .env $GCR_MULTI_REGION/$PROJECT/$IMAGE

#FROM python:3.9-slim
#FROM condaforge/mambaforge
#FROM continuumio/miniconda3
FROM tensorflow/tensorflow:latest

WORKDIR /opt/quint

RUN apt-get update
#RUN apt-get install -y gcc
RUN apt-get install -y python3.9

#RUN pip install --upgrade pip
RUN pip install poetry

COPY pyproject.toml /opt/quint/pyproject.toml
COPY poetry.lock /opt/quint/poetry.lock
RUN poetry install

#COPY environment.yml /opt/quint/environment.yml

#RUN mamba init && . /root/.bashrc
#RUN conda activate .

# https://medium.com/@chadlagore/conda-environments-with-docker-82cdc9d25754
#ADD environment.yml /opt/quint/environment.yml

#RUN conda env create -f /opt/quint/environment.yml
#RUN mamba env create -f /opt/quint/environment.yml
#RUN echo "source activate env" > ~/.bashrc
#ENV PATH /opt/conda/envs/quint/bin:$PATH



# FIXME: Consolidate apt-get installs after dev
RUN apt-get update
RUN apt-get install -y ffmpeg

COPY . /opt/quint/


#CMD conda info --envs
CMD poetry run uvicorn quint.api.fast:app --host 0.0.0.0 --port 8000
