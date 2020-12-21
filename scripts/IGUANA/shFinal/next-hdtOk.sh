for f in $(ls IGUANA/SWDFfc/*.nt)
do
cat suite.id|xargs -I '{}' cp -r queryInstances oldQueryInstances/'{}'
	rm -rf queryInstances/
	./start-ref.sh $f
	echo "executing $f"
	pkill -f hdt
	cd ~/IGUANA/hdt-java-rc2/ && ./rdf2hdt.sh -rdftype turtle $f $f.hdt
	cd ~/IGUANA
	./start-hdt.sh $f.hdt
	sleep 2m
	gn=$(echo ${f:33} | sed -e 's/[^a-zA-Z0-9]//g')
	echo "$gn"
	cp iguana.config iguanaTMP.config
	sed -i -e 's,GraphName,'"$gn"',g' iguanaTMP.config
	sed -i -e 's,TSTORE,hdt,g' iguanaTMP.config
	sed -i -e 's,ENDPOINT,http://localhost:3030/hdtservice/query,g' iguanaTMP.config
	./start-iguana.sh iguanaTMP.config
	#pkill -f hdt
	echo "done"
done
