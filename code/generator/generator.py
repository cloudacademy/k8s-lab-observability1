import time
import random
import threading
import requests
import os

apiurl = os.environ['API_URL']

endpoints = ('one', 'two', 'three', 'four', 'error')

def run():
    while True:
        try:
            target = random.choice(endpoints)
            requests.get(f"{apiurl}/{target}", timeout=1)

        except:
            pass


if __name__ == '__main__':
    for _ in range(4):
        thread = threading.Thread(target=run)
        thread.setDaemon(True)
        thread.start()

    while True:
        time.sleep(1)
