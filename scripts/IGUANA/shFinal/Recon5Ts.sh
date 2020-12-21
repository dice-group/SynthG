      fname=`echo "IGUANA/dbp/dbp16_R100_sf1_prd_recon.nt"`;  
      echo $fname; 
      rm queryInstances/-2143154546/*; 
      cp qiDbp/rec/* queryInstances/-2143154546/ ; 
      cp blazegraphRecon.jnl blazegraph.jnl
      ./next-blazegraph1g.sh $fname
sleep 30
      pkill blazegraph
sleep 30
	./next-fuseki1g.sh $fname
sleep 30
	pkill fuseki
sleep 30
	./next-graphdb1g.sh $fname
sleep 30
pkill graphdb
sleep 30
	./next-virtuoso1g.sh $fname
sleep 30
pkill virtuoso
sleep 30
./next-hdt1g.sh $fname




