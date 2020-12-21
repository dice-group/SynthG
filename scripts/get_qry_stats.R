#2/4/2020
#Author: Abdelmoneim Amer Desouki, Paderborn University, Informatik, FG NGonga

get_qry_stats<-function(qtxt,endpoint){
    require(SPARQL)
    allRes=NULL
    for(i in 1:length(qtxt)){
    # i=1
        qry=qtxt[i]
        
        print(i)
        print(qry)
        t0=proc.time()
        out <- tryCatch(
            {
            qd=SPARQL(endpoint,qry)
             Res <- qd$results
             print(nrow(Res))
            cntRes=nrow(Res)
            },error=function(cond) {
                message(paste("Query invalid"))
                message("Here's the original error message:")
                message(cond)
                # Choose a return value in case of error
                return(-1)
            })
            t1=proc.time()
            allRes=rbind(allRes,cbind(i,out,(t1-t0)[3]))
    }
  return(allRes)
}

