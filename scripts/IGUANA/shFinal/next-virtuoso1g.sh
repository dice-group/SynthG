echo "============next virtuoso ==================="
f=$1
        echo $f
	echo "executing $f"
	#pkill -f virtuoso
	#./start-virtuoso.sh $f *
       ./start-virtuoso.sh $f
       ./count-triples-virtuoso.sh
	sleep 2m
#swdffc 33
	gn=$(echo ${f:33} | sed -e 's/[^a-zA-Z0-9]//g')
	echo "$gn"
	cp iguana.config iguanaTMP.config
	sed -i -e 's,GraphName,'"$gn"',g' iguanaTMP.config
	sed -i -e 's,TSTORE,Virtuoso,g' iguanaTMP.config
	sed -i -e 's,ENDPOINT,http://localhost:8890/sparql,g' iguanaTMP.config
	./start-iguana.sh iguanaTMP.config
	#pkill -f virtuoso
	echo "done"

