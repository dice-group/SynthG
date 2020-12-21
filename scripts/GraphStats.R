#4/8/2020
#Calculation of Graph metirics in R

setwd('~/grphs/')
fnames=c('.nt','')#TODO: add file names in ntriples and without any triples of Literal object

Res=NULL
for(i in 1:length(fnames)){
    fname=fnames[i]
    # setwd('~/grcmp/real_case_datasets/');fname='scholarydata_dump.nt.ol.nt';i=1
    tl0=proc.time()
    print(paste(i,fname))
    trp=read.table(fname,sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)

    print(paste("#Triples:",nrow(trp)))
    t0=proc.time()
    # Vertices:
    nv=length(unique(c(unlist(trp[,1]),unlist(trp[,3]))))#,unlist(trp[,2])
    # Edges:#triples
    ne=nrow(trp)#sum(substring(unlist(trp[,3]),1,1)=='<')
    # avgDegree=#Edge/#Vertices
    avgDegree=ne/nv
    print(sprintf("#vert:%d, #Edges:%d, avgDegree:%f",nv,ne,avgDegree))
    ie=table(trp[,3])
    oe=table(trp[,1])
    print(sprintf("maxInDegree:%d, maxOutDegree:%d, stdDevInDegree:%f, stdDevOutDegree:%f",max(ie),max(oe),sd(ie),sd(oe)))

# No. of classes
# aa[grepl("#type>$",aa)]
    cnt_class=length(unique(trp[trp[,2]=="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>",3]))
    # No. of properties
    cnt_prop=length(unique(unlist(trp[,2])))
    # No. of subjects
    cnt_subj=length(unique(unlist(trp[,1])))
    cnt_obj=length(unique(unlist(trp[,3])))
    cnt_obj_only=length(unique(trp[!(trp[,3] %in% trp[,1]),3]))

    print(sprintf("cnt_classes:%d,cnt_prop:%d,cnt_subj:%d, cnt_obj:%d, obj_only:%d",cnt_class,cnt_prop,cnt_subj,cnt_obj,cnt_obj_only))
    #### number of clusters, max cluster size, undirected

library(igraph)

    tg0=proc.time()
    Ent=unique(append(trp[,1],trp[,3]))
    ik=cbind(match(trp[,1],Ent),match(trp[,3],Ent))
    # as.vector(t(ijk[,-2]))
    # g <- graph(as.vector(t(ijk[,-2])), directed=FALSE)
    g <- graph(as.vector(t(ik)), directed=FALSE)
    cl<-clusters(g)
    cl$no
    max(cl$csize)
    tg1=proc.time()
    tg1-tg0

    trngls=triangles(g)
    (vTriangles=length(trngls)/3)#vTriangles
    if(length(trngls)>0){
        ix1=seq(1,length(trngls),3)
        edges=rbind(cbind(trngls[ix1],trngls[ix1+1]),cbind(trngls[ix1],trngls[ix1+2]),cbind(trngls[ix1+1],trngls[ix1+2]))
        v1=apply(edges,1,function(x)min(x))
        v2=apply(edges,1,function(x)max(x))
        # paste(v1,v2)
        # ijk2=ijk[,-2]
        ijk2=ik
        ijk2v1=apply(ijk2,1,function(x)min(x))
        ijk2v2=apply(ijk2,1,function(x)max(x))
        # table(paste(ijk2v1,ijk2v2))
        ecnt=table(paste(ijk2v1,ijk2v2))[paste(v1,v2)]
        ecnt_m=matrix(ecnt,ncol=3)
        (eTriangles=sum(ecnt_m[,1]*1.0*ecnt_m[,2]*ecnt_m[,3]))
    }else{
        eTriangles=0
    }
    print(sprintf('vTr eTr %d %d',vTriangles,eTriangles))
    flg=(trp[,1]==trp[,3])#self relations
    print(sprintf("Self relations:%d",sum(flg)))

    ##
    # transitivity(graph) computes a global clustering coefficient (transitivity)
    (ratiotrg=transitivity(g))#ratio of the triangles and the connected triples in the graph:ClCoef
    (clavg=transitivity(g, type = "average"))#first computes the local clustering coefficients and then averages them
    # https://stackoverflow.com/questions/48853610/average-clustering-coefficient-of-a-network-igraph
    t1=proc.time()
    Res=rbind(Res,data.frame(i,fname,stringsAsFactors=FALSE,nv,ne,avgDegree,sdie=sd(ie),sdoe=sd(oe),avgie=mean(ie),avgoe=mean(oe),
    maxie=max(ie),maxoe=max(oe),cntClstr=cl$no ,vTriangles,eTriangles,pot_trngl=vTriangles/ratiotrg,clavg,ClCoef=ratiotrg,
            cnt_class,cnt_prop,cnt_subj,cnt_obj,cnt_obj_only,
            max(cl$csize),tload=(t0-tl0)[3],ttime=(t1-t0)[3]))
     # write.csv(file='graphCmp_stats_dbp_short.csv',Res,row.names=FALSE)
     # write.csv(file='graphCmp_stats_wikidata_short.csv',Res,row.names=FALSE)
     # write.csv(file='graphCmp_stats_scholarlydata.csv',Res,row.names=FALSE)
     # write.csv(file='graphCmp_stats_realds.csv',Res,row.names=FALSE)
     write.csv(file='graphCmp_stats_lubm.csv',Res,row.names=FALSE)

}


#Collect
setwd("\\Res\\")
csvFiles=c('.csv')#Results from above
 allSt=NULL
 for( fname in csvFiles){
     print(fname)
     tmp=read.csv(fname,stringsAsFactors=FALSE)
     allSt=rbind(allSt,data.frame(group=sub('.csv','',sub('graphCmp_stats_','',fname)),tmp))
 }
 dim(allSt)
 write.csv(file='graphCmp_allStats1.csv',allSt,row.names=FALSE)
 
