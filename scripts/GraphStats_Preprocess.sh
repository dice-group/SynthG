#4/8/2020
#
#Download
wget https://hobbitdata.informatik.uni-leipzig.de/rdfrepair/evaluation_datasets/dbpedia_shortend.zip

unzip dbpedia_shortend.zip

## convert to ntriples
cd dbpedia_shortend
for fname in *.ttl; do
        echo $fname;
	rapper -g "$fname" -o ntriples >$fname".nt"
done
#remove literals
# mkdir ol
for fname in *.ttl.nt; do
    echo $fname;
	grep -v "\"" "$fname" >$fname".ol.nt"
done
#######################
wget https://hobbitdata.informatik.uni-leipzig.de/rdfrepair/evaluation_datasets/wikidata_shortend.zip
unzip wikidata_shortend.zip

cd wikidata

for fname in *.nt; do
    echo $fname;
	grep -v "\"" "$fname" >$fname".ol.nt"
done
#############################
wget https://hobbitdata.informatik.uni-leipzig.de/rdfrepair/evaluation_datasets/scholarydata.zip

unzip scholarydata.zip

cd scholarydata

for fname in *.nt; do
    echo $fname;
	grep -v "\"" "$fname" >$fname".ol.nt"
done
#################################
wget https://hobbitdata.informatik.uni-leipzig.de/rdfrepair/evaluation_datasets/real_case_datasets.zip
unzip real_case_datasets

cd real_case_datasets

for fname in *.nt; do
    echo $fname;
	grep -v "\"" "$fname" >$fname".ol.nt"
done
#################################
wget https://hobbitdata.informatik.uni-leipzig.de/rdfrepair/evaluation_datasets/dbpedia.zip
unzip dbpedia.zip

cd dbpedia
for fname in *.ttl; do
        echo $fname;
serdi -i turtle "$fname" -o ntriples >$fname".nt"
done

for fname in *.ttl.nt; do
    echo $fname;
	grep -v "\"" "$fname" >$fname".ol.nt"
done
#################################
wget https://hobbitdata.informatik.uni-leipzig.de/rdfrepair/evaluation_datasets/lubm.zip
unzip lubm.zip

cd lubm
for fname in *.nt; do
    echo $fname;
	grep -v "\"" "$fname" >$fname".ol.nt"
done
################
for fname in *.ttl.nt; do
    echo $fname;
grep "> \.\| _" "$fname" |grep -v "\^" |wc -l
grep -v "\"" "$fname" |wc -l
done


for fname in *.ol.nt; do
    echo $fname;
grep "> \.\| _" "$fname" |grep -v "\^" |wc -l
wc -l "$fname"
done
