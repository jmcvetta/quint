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

FROM tensorflow/tensorflow:latest

WORKDIR /opt/quint

# FIXME: Consolidate apt-get installs after dev
RUN apt-get update
RUN apt-get install -y ffmpeg
RUN apt-get install -y python3.9
RUN apt-get install -y python3.9-dev

RUN pip install poetry

COPY pyproject.toml /opt/quint/pyproject.toml
COPY poetry.lock /opt/quint/poetry.lock
RUN poetry install

COPY . /opt/quint/

CMD poetry run uvicorn quint.api.fast:app --host 0.0.0.0 --port 8000
