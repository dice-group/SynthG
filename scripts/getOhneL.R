#14/12/2019
#Remove triples that have their object as a Literal
# then gives statistics about triple counts in each predicate

srcfname="dbp.nt"
conR<-file(srcfname,"r")
conW<-file("dbp_ol.nt","w")
chz=10000
olz=0
while(1==1){
    tl=readLines(conR,chz)
    if(length(tl)==0) break;
     tlOhneL=tl[!grepl('\"',tl)]
     olz=olz+length(tlOhneL)
     writeLines(unique(tlOhneL),conW)
     print(olz)
     }
     
#################

trp=read.table('dbp_ol.nt',sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)

xx=table(trp[,2])
t0=proc.time()
p1k=xx[xx>999]
t1k=trp[trp[,2]%in%p1k,]

prduri=names(p1k)
    Res=NULL
    for(p in 1:length(prduri)){
        print(p)
        cnt=sum(trp[,2]==prduri[p])
        cntS=length(unique(trp[trp[,2]==prduri[p],1]))
        cntO=length(unique(trp[trp[,2]==prduri[p],3]))
        Res=rbind(Res,data.frame(stringsAsFactors=FALSE,prd=prduri[p],cnt,cntS,cntO,minf=min(cntS,cntO)/cnt))
        
    }
    dim(Res)
    t1=proc.time()
t1-t0
    