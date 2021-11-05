FROM python:3-alpine

ADD requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt

ADD api.py /var/server/api.py

CMD python /var/server/api.py
