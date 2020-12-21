#for f in $(ls IGUANA/dbp/$1)
#do
f=$1
	echo "executing GraphDB $f"
	pkill -f graphdb
	./start-graphdb.sh $f
	./count-triples-graphdb.sh
	sleep 2m
	gn=$(echo ${f:30} | sed -e 's/[^a-zA-Z0-9]//g')
	echo "$gn"
	cp iguana.config iguanaTMP.config
	sed -i -e 's,GraphName,'"$gn"',g' iguanaTMP.config
	sed -i -e 's,TSTORE,GraphDB,g' iguanaTMP.config
	sed -i -e 's,ENDPOINT,http://localhost:7200/repositories/repo,g' iguanaTMP.config
	./start-iguana.sh iguanaTMP.config
	pkill -f graphdb
	echo "done"
#done
