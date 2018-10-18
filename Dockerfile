FROM docker.io/python:alpine

RUN pip3 install guessit
ADD mnamer.py /bin

ENTRYPOINT ["/bin/mnamer.py"]
