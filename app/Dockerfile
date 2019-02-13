FROM tensorflow/tensorflow:latest-py3

RUN pip install jupyter
COPY startup.py .

CMD [ "python", "startup.py" ]