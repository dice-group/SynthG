pkill -f fuseki
pkill -f virtuoso
pkill -f graphdb
#pkill -f blazegraph

cp hdt-java-rc2/fuseki_example.ttl hdt-java-rc2/real.ttl
cd hdt-java-rc2/ && sed -i -e 's,FILE,'"$1"',g' real.ttl
cd ~/IGUANA/fuseki-hdt/ && ./fuseki-server --config=../hdt-java-rc2/real.ttl &

