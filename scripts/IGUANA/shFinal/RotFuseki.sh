for s in 1 123 159 321 333 ; do 
      fname=`echo "IGUANA/dbp/dbp16_R100_sf1_seed${s}_prd_rotated.nt"`;  
      echo $fname; 
      rm queryInstances/-2143154546/*; 
      cp qiDbp/seed$s/* queryInstances/-2143154546/ ; 
      ./next-fuseki1g.sh $fname
done
