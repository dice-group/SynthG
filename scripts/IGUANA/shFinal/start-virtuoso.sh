pkill -f graphdb
pkill -f fuseki
pkill -f virtuoso

rm virtuoso-opensource/database/virtuoso.db
rm virtuoso-opensource/database/virtuoso.trx
rm virtuoso-opensource/database/virtuoso-temp.db
rm virtuoso-opensource/database/virtuoso.pxa
rm virtuoso-opensource/database/virtuoso.lck
rm virtuoso-opensource/database/virtuoso.log
cd virtuoso-opensource/bin/ && ./virtuoso-t +configfile ../database/virtuoso.ini
sleep 1m
~/IGUANA/virtuoso-opensource/bin/isql 1111 dba dba exec="ld_add('$1','http://example.com');"
~/IGUANA/virtuoso-opensource/bin/isql 1111 dba dba exec="rdf_loader_run();checkpoint;"
cd ~/IGUANA
sleep 2m
