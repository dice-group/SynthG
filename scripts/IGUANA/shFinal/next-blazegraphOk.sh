for f in $(ls IGUANA/SWDFfc/*.nt)
do
        cat suite.id|xargs -I '{}' cp -r queryInstances oldQueryInstances/'{}'
	rm -rf queryInstances/
	echo "executing $f"
	pkill -f blazegraph
	./start-ref.sh $f
	./start-blazegraph.sh $f
	./count-triples-blazegraph.sh
	sleep 2m
	gn=$(echo ${f:33} | sed -e 's/[^a-zA-Z0-9]//g')
	echo "$gn"
	cp iguana.config iguanaTMP.config
	sed -i -e 's,GraphName,'"$gn"',g' iguanaTMP.config
	sed -i -e 's,TSTORE,Blazegraph,g' iguanaTMP.config
	sed -i -e 's,ENDPOINT,http://localhost:9999/blazegraph/sparql,g' iguanaTMP.config
	./start-iguana.sh iguanaTMP.config
	#pkill -f blazegraph
	echo "done"
done
