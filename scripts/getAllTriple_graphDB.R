#31/5/2019
#20/2/2020
# dump_one_graph ('http://bio2rdf.org/drugbank_resource:bio2rdf.dataset.drugbank.R3', './drugBank', 2000000000);
# sudo apt-get install libcurl4-openssl-dev libxml2-dev
#Author: Abdelmoneim Amer Desouki, Paderborn University, Informatik, FG NGonga

library(SPARQL) # SPARQL querying package
 
# Step 1 - Set up preliminaries and define query
endpoint <- "http://localhost:8890/sparql"
 
# create query statement
# query <-"select (count(*) as ?cnt) where { 	?s ?p ?o .}"
query <-"select (count(*) as ?cnt) from <http://bio2rdf.org/drugbank_resource:bio2rdf.dataset.drugbank.R3> where { 	?s ?p ?o .}"

# Step 2 - Use SPARQL package to submit query and save results to a data frame
qd <- SPARQL(endpoint,query)
Res <- qd$results
print(Res)

# query <-"select * where{ ?s ?p ?o} limit 1000 offset "
# qd <- SPARQL(endpoint,query)
# Res <- qd$results
# Res


qoffset =0
# query <-"select * where{ ?s ?p ?o} limit 1000 offset "
pageSize=5000
query <-sprintf("select * from <http://bio2rdf.org/drugbank_resource:bio2rdf.dataset.drugbank.R3> where{ ?s ?p ?o} limit %d offset ",pageSize)
rightDirectly=TRUE
 if(rightDirectly){
  con=file("drugbank_exp.nt",'wb')
 }
trp=NULL
while(1==1){
     query1 =sprintf("%s %d",query,qoffset)
    qd <- SPARQL(endpoint,query1)
    Res <- qd$results
    if(nrow(Res)==0) break;
    if(rightDirectly){
        Res_nt=cbind(Res,dot='.')
       writeLines(con,paste(Res[,1],Res[,2],Res[,3],'.'))
    }else{
        trp=rbind(trp,Res)
        }
    if(nrow(Res)<pageSize) break;
    print(qoffset)
    qoffset=qoffset + pageSize
}

 if(rightDirectly){
   close(con)
 }else{
    trp_nt=cbind(trp,dot='.')
    flg=(substring(trp[,3],1,1)=="_" | substring(trp[,3],1,1)=="<")
     table(flg)
    # flg
     # FALSE   TRUE
       # 210 488806
    trp_nt=cbind(trp[flg,],dot='.')

    write.table(file='drugbank_onto_rdfsplus-opt.nt',trp_nt,sep=' ',quote=FALSE,row.names=FALSE,col.names=FALSE)
}
    ###########################################################################    
    

