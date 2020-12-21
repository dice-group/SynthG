for f in $(ls IGUANA/SWDFfc/*.nt)
do
cat suite.id|xargs -I '{}' cp -r queryInstances oldQueryInstances/'{}'
	rm -rf queryInstances/
	./start-ref.sh $f
	echo "executing $f"
	pkill -f fuseki
	./start-fuseki.sh $f
        ./count-triples-fuseki.sh
	sleep 2m
	gn=$(echo ${f:33} | sed -e 's/[^a-zA-Z0-9]//g')
	echo "$gn"
	cp iguana.config iguanaTMP.config
	sed -i -e 's,GraphName,'"$gn"',g' iguanaTMP.config
	sed -i -e 's,TSTORE,Fuseki,g' iguanaTMP.config
	sed -i -e 's,ENDPOINT,http://localhost:3030/ds/sparql,g' iguanaTMP.config
	./start-iguana.sh iguanaTMP.config
	#pkill -f fuseki
	echo "done"
done
