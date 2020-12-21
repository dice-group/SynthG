pkill -f virtuoso
pkill -f fuseki
pkill -f graphdb
pkill -f blazegraph

rm -rf ~/IGUANA/fuseki/apache-jena-fuseki-3.8.0/DS/

~/IGUANA/fuseki/apache-jena-3.8.0/bin/tdbloader2 --loc ~/IGUANA/fuseki/apache-jena-fuseki-3.8.0/DS $1 
cd ~/IGUANA/fuseki/apache-jena-fuseki-3.8.0/ && ./fuseki-server --loc=DS /ds &
sleep 1m

