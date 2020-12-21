pkill -f graphdb
pkill -f virtuoso
pkill -f fuseki
pkill -f blazegraph

cd graphdb/ && ./bin/loadrdf --force -p -c ./config.ttl -m parallel $1
cd ~/IGUANA/graphdb/ && ./bin/graphdb -Xmx4g -s -d
sleep 3m
