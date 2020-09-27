#!/bin/sh
DEDYNAUTH=`pwd`/.dedynauth
if [ -f ${DEDYNAUTH} ]; then
    source ${DEDYNAUTH}
fi

if [ -z "$DEDYN_TOKEN" ] ; then
    >&2 echo "Variable \$DEDYN_TOKEN not found. Please set DEDYN_TOKEN=(your dedyn.io token) to your dedyn.io access token in $DEDYNAUTH, e.g."
    >&2 echo 
    >&2 echo "DEDYN_TOKEN=d41d8cd98f00b204e9800998ecf8427e"
    exit 2
fi

if [ -z "$DEDYN_NAME" ] ; then
    >&2 echo "Variable \$DEDYN_NAME not found. Please set DEDYN_NAME=(your dedyn.io name) to your dedyn.io name in $DEDYNAUTH, e.g."
    >&2 echo
    >&2 echo "DEDYN_NAME=foobar.dedyn.io"
    exit 3
fi

if ./run_certbot.sh 

then
  for domain in $DOMAINS; do
    d=${domain%%,*}
    mv /certs/$d.pem /certs/$d.cert.pem
    openssl pkcs12 -export -out /certs/$d.pfx -inkey /certs/$d.key.pem -in /certs/$d.cert.pem -certfile /certs/$d.chain.pem -password pass:$PASSWORD
    cat /certs/$d.fullchain.pem /certs/$d.key.pem > /certs/$d.pem
  done
  chown ${UID}:${GUID} /certs/*
  chmod o-rw /certs/*
  chmod g+r /certs/*
fi
