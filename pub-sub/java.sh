#!/bin/sh

javac -cp ".:../Setup/amqp-client-4.0.2.jar" -d . src/Subscriber.java
java -cp ".:../Setup/amqp-client-4.0.2.jar:../Setup/slf4j-api-1.7.21.jar:../Setup/slf4j-simple-1.7.22.jar" Subscriber
