#!/bin/sh

nohup sh /usr/local/elasticsearch-5.6.3/bin/elasticsearch &

tail -f nohup.out
