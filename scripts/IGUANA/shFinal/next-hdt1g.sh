#for f in $(ls IGUANA/dbp/$1)
#do
f=$1
	echo "executing hdt $f"
	pkill -f hdt
	#cd ~/IGUANA/hdt-java-rc2/ && ./rdf2hdt.sh -rdftype turtle $f $f.hdt
	cd ~/IGUANA
	./start-hdt.sh $f.hdt
	sleep 5m
	gn=$(echo ${f:30} | sed -e 's/[^a-zA-Z0-9]//g')
	echo "$gn"
	cp iguana.config iguanaTMP.config
	sed -i -e 's,GraphName,'"$gn"',g' iguanaTMP.config
	sed -i -e 's,TSTORE,hdt,g' iguanaTMP.config
	sed -i -e 's,ENDPOINT,http://localhost:3030/hdtservice/query,g' iguanaTMP.config
	./start-iguana.sh iguanaTMP.config
	#pkill -f hdt
	echo "done"
#done
