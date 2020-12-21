pkill -f graphdb
pkill -f virtuoso
pkill -f fuseki
pkill -f blazegraph

./graphdb/bin/loadrdf --force -c graphdb/configOld.ttl -m parallel $1
cd graphdb/ && ./bin/graphdb -s -d
