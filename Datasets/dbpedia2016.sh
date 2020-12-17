#17/12/2019

# in core-i18n
#ALL Literals: short_abstracts_en.ttl.bz2,long_abstracts_en.ttl.bz2 specific_mappingbased_properties_en.ttl.bz2
#revision_ids_en, page_ids_en, labels_en, category_labels_en

wget http://downloads.dbpedia.org/2016-04/core-i18n/en/persondata_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/mappingbased_objects_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/infobox_properties_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/infobox_property_definitions_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/instance_types_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/instance_types_transitive_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/disambiguations_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/citation_data_en.ttl.bz2

#wget http://downloads.dbpedia.org/2016-04/core-i18n/en/specific_mappingbased_properties_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/topical_concepts_en.ttl.bz2

##Set II
##links
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/external_links_en.ttl.bz2
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/interlanguage_links_en.ttl.bz2
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/wikipedia_links_en.ttl.bz2
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/page_links_en.ttl.bz2
##All Literals
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/category_labels_en.ttl.bz2
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/labels_en.ttl.bz2
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/revision_ids_en.ttl.bz2
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/page_ids_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/article_categories_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/geo_coordinates_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/geo_coordinates_mappingbased_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/homepages_en.ttl.bz2
# wget http://downloads.dbpedia.org/2016-04/core-i18n/en/infobox_properties_mapped_en.ttl.bz2
wget http://downloads.dbpedia.org/2016-04/core-i18n/en/redirects_en.ttl.bz2


bunzip2 *.ttl.bz2

##
# find . -name '*.ttl' |
# # find . -name '*.ttl' -size -3G -size +1G|
# while read fname  
# do
    # echo $fname;
    # # rapper -g "$fname" -o ntriples >$fname".nt"
    # serdi -i turtle "$fname" -o ntriples >$fname".nt"
# done

for fname in *.ttl; do
        echo $fname;
	serdi -i turtle "$fname" -o ntriples >$fname".nt"
done

#  ALL Literals
# rapper -g short_abstracts_en.ttl -o ntriples >short_abstracts_en.ttl.nt
#>2G
#4M ALL Literals
# serdi -i turtle long_abstracts_en.ttl -o ntriples >long_abstracts_en.nt
#17M
serdi -i turtle mappingbased_objects_en.ttl -o ntriples >mappingbased_objects_en.nt
#78M
serdi -i turtle infobox_properties_en.ttl -o ntriples >infobox_properties_en.nt
#31M
serdi -i turtle instance_types_transitive_en.ttl -o ntriples >instance_types_transitive_en.nt
wc -l instance_types_transitive_en.nt

# instance_types_en 5m
wc -l infobox_properties_en.ttl

serdi -i turtle revision_ids_en.ttl -o ntriples >revision_ids_en.nt
serdi -i turtle wikipedia_links_en.ttl -o ntriples >wikipedia_links_en.nt
serdi -i turtle interlanguage_links_en.ttl -o ntriples >interlanguage_links_en.nt
serdi -i turtle article_categories_en.ttl -o ntriples >article_categories_en.nt

serdi -i turtle infobox_properties_mapped_en.ttl -o ntriples >infobox_properties_mapped_en.nt
serdi -i turtle  page_ids_en.ttl -o ntriples >page_ids_en.nt
serdi -i turtle  page_links_en.ttl -o ntriples >page_links_en.nt

# ./wikipedia_links_en.ttl
# ./article_categories_en.ttl
# ./infobox_properties_mapped_en.ttl
# ./page_ids_en.ttl
# ./interlanguage_links_en.ttl
# ./page_links_en.ttl
# ./revision_ids_en.ttl


# remove triples with object as a Literal

for fname in *.nt; do
        echo $fname;
	grep -v "\"" "$fname" >ol/$fname".ol.nt"
done

##########################################################################
##All Literals
# revision_ids_en
# page_ids_en
# labels_en
# category_labels_en

######################
for fname in *.nt; do
        echo `wc -l "$fname"`
done
######################
# Links : exclude [26+5+1.5+1.25+5]=36GB
# /home/hadoop/abd/synthg/dbp16/ol/page_links_en.nt.ol.nt
# /home/hadoop/abd/synthg/dbp16/ol/wikipedia_links_en.nt.ol.nt
# /home/hadoop/abd/synthg/dbp16/ol/interlanguage_links_en.nt.ol.nt
# /home/hadoop/abd/synthg/dbp16/ol/external_links_en.ttl.nt.ol.nt
