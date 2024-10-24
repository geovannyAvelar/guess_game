FROM python:3.8-slim-buster

RUN pip install gunicorn

COPY . /guess_game

WORKDIR /guess_game
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "run:app"]