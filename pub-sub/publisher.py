#!/usr/bin/env python
import pika
import sys
import signal
import os
import time

# Log message publisher. Publishes to a local exchange, but other hosts can subscribe to the exchange too.

def stop(signal, frame):
    print("[%i] Closing connection" % pid)
    connection.close()
    print("[%i] Shutting down" % pid)
    sys.exit(0)
signal.signal(signal.SIGINT, stop)

pid = os.getpid()

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

# Specify exchange this time since fanout publishing is not allowed for nameless exchanges
channel.exchange_declare(exchange='logs',
                         type='fanout')

while True:
    message = "INFO: " + (' '.join(sys.argv[1:]) or "Hello at %i" % time.time())
    channel.basic_publish(exchange='logs',
                          routing_key='',
                          body=message)
    print("[%i] Sent %r" % (pid, message))
    time.sleep(2)
