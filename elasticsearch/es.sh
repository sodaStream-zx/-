#!/bin/sh

els="$(ps -fe|grep elasticsearch |grep -v grep)"
if [ $? -ne 0  ];then
 	su - es -s /bin/bash /home/es/startes.sh
else
	echo "elasticsearch is running"
	tail -f /home/es/nohup.out
fi
