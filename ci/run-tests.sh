#!/bin/bash
[ -n "$DEBUG" ] && set -x
set -e
#
# test app
#
function test_app {
  echo "# Test $1 "
  set +e
  ret=0
  timeout=180;
  test_result=1
  until [ "$timeout" -le 0 -o "$test_result" -eq 0 ] ; do
      eval $1
      test_result=$?
      echo "Wait $timeout seconds: APP coming up ($test_result)";
      (( timeout-- ))
      sleep 1
  done
  if [ "$test_result" -gt 0 ] ; then
       ret=$test_result
       echo "ERROR: APP down"
       return $ret
  fi
  set -e

  return $ret
}

echo "# $(basename $0) started"
if [ -n "$DOCKERHUB_LOGIN" -a -n "$DOCKERHUB_TOKEN" ] ; then
  echo "$DOCKERHUB_LOGIN" | docker login --username $DOCKERHUB_TOKEN --password-stdin
fi

echo "# prepare artifacts tests"
cat <<EOF > artifacts
DESIGN_DATADIR=data-design
EOF
# ci config
#cp docker-compose-ci.yml docker-compose-custom.yml

echo "# clean env"
make down

echo "# build image"
make build

#echo "# up services"
#make up

#make test-up-backup   
#echo "# test all services"
#test_app "make test-all"

echo "# clean env"
make down

if [ -n "$DOCKERHUB_LOGIN" -a -n "$DOCKERHUB_TOKEN" ] ; then
  docker logout
fi
