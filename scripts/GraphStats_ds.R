#Calculate grah statistic of SynthG paper
library(igraph)
#7/4/2020

dsname='dbp'
seeds=c(1,123,159,321,333)
if(dsname=='dbp'){
    fpth='~/abd/dbp/'
    fnames=paste0('dbp16_',c('org','R100_sf1_prd_recon',sprintf('R100_sf1_seed%d_prd_rotated',seeds)),'.nt')
}else{
    fpth='~/abd/sw/'
    fnames=paste0('swfcTbox_',c('org','R100_sf1_i270_recon',sprintf('R100_sf1_seed%d_prd_rotated',seeds)),'.nt')
}
Res=NULL
for(i in 1:length(fnames)){
   print(i)
   print(fnames[i])
    t0=proc.time()
    trp=read.table(sprintf('%s%s',fpth,fnames[i]),sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)
    t1=proc.time()
    t1-t0 #450

    # TODO: isConnected, diameter, clusters
    nrow(trp)
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
    t2=proc.time()
# No. of classes
# aa[grepl("#type>$",aa)]
    cnt_class=length(unique(trp[trp[,2]=="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>",3]))
    # No. of properties
    cnt_prop=length(unique(unlist(trp[,2])))
    # No. of subjects
    cnt_subj=length(unique(unlist(trp[,1])))
    cnt_obj=length(unique(unlist(trp[,3])))
    cnt_obj_only=length(unique(trp[!(trp[,3] %in% trp[,1]),3]))

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
trngls=triangles(g)
(vTriangles=length(trngls)/3)
tg1-tg0

    print(sprintf("cnt_classes:%d,cnt_prop:%d,cnt_subj:%d, cnt_obj:%d, obj_only:%d",cnt_class,cnt_prop,cnt_subj,cnt_obj,cnt_obj_only))
    Res=rbind(Res,cbind(i,nv,ne,avgDegree,maxInDegree=max(ie),maxOutDegree=max(oe),stdDevInDegree=sd(ie),stdDevOutDegree=sd(oe),
                cnt_class=cnt_class,cnt_subj=cnt_subj,cnt_obj=cnt_obj,cnt_obj_only=cnt_obj_only,t10=(t1-t0)[3],t21=(t2-t1)[3],
                vTriangles=vTriangles, cntClstrs=cl$no, mxClSz=max(cl$csize)
                )    )
  }
  
  write.csv(file=sprintf('~/%s_gstatsCl.csv',substring(fnames[1],1,4)),cbind(fnames,Res))  

  
  
############################################################
  
  source('~/abd/RDF/prefixes.R')
source('~/abd/RDF/calc_strdness.R')
dsname='dbp'
# dsname='swfc'
seeds=c(1,123,159,321,333)
if(dsname=='dbp'){
    fpth='~/abd/dbp/'
    fnames=paste0('dbp16_',c('org','R100_sf1_prd_recon',sprintf('R100_sf1_seed%d_prd_rotated',seeds)),'.nt')
}else{
    fpth='~/abd/sw/'
    fnames=paste0('swfcTbox_',c('org','R100_sf1_i270_recon',sprintf('R100_sf1_seed%d_prd_rotated',seeds)),'.nt')
}

t0=proc.time()
Res=NULL
for(i in 1:length(fnames)){#1 done
#i=1
    print(i)
   print(fnames[i])
    t0=proc.time()
    trp=read.table(sprintf('%s%s',fpth,fnames[i]),sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)
    t1=proc.time()
    t1-t0 #450
    # tmp=calc_strdness(trp,rdftype)
    # tmp=calc_strdness_par(trp,rdftype,OS_WIN=FALSE,ncores=4,dsname)
    # allstr[[names(fnames)[i]]]=tmp$CHD
    t2=proc.time()
    tmpRS=calc_RSpeciality_par(trp,OS_WIN=FALSE,ncores=3,dsname)
    t3=proc.time()
    # allstr[[names(fnames)[i]]]=tmp$RS
    # Res=rbind(Res,cbind(i,strctrdnss=tmp$CHD,RSp=tmpRS$RS,t01=(t1-t0)[3],t12=(t2-t1)[3],t23=(t3-t2)[3]))
    Res=rbind(Res,cbind(i,RSp=tmpRS$RS,t01=(t1-t0)[3],t12=(t2-t1)[3],t23=(t3-t2)[3]))
    # Res=rbind(Res,cbind(i,strctrdnss=tmp$CHD,t01=(t1-t0)[3],t12=(t2-t1)[3],t23=(t3-t2)[3]))
  write.csv(file=sprintf('~/%s_Rspec.csv',substring(fnames[1],1,4)),cbind(fnames[1:i],Res))  
}
t1=proc.time()
# print(allstr)
t1-t0

 
  write.csv(file=sprintf('~/%s_strd_Rspec.csv',substring(fnames[1],1,4)),cbind(fnames,Res))  
  
 { ################### Parallel   ########################
    source('~/abd/RDF/prefixes.R')
source('~/abd/RDF/calc_strdness.R')

dsname='dbp'
seeds=c(1,123,159,321,333)
if(dsname=='dbp'){
    fpth='~/abd/dbp/'
    fnames=paste0('dbp16_',c('org','R100_sf1_prd_recon',sprintf('R100_sf1_seed%d_prd_rotated',seeds)),'.nt')
}else{
    fpth='~/abd/sw/'
    fnames=paste0('swfcTbox_',c('org','R100_sf1_i270_recon',sprintf('R100_sf1_seed%d_prd_rotated',seeds)),'.nt')
}

ncores=4

require(parallel)
	require(doParallel)
      cluster <- parallel::makeForkCluster(ncores,outfile=sprintf("%s_calc_strd_RS_par_nc%d.log",substring(fnames[1],1,5),ncores))#not in windows, copy only changed
    
	registerDoParallel(cluster)
  
t0=proc.time()
Res=NULL
# for(i in 1:length(fnames)){
foreach(i in 1:length(fnames)){
    print(i)
    print(fnames[i])
    t0=proc.time()
    trp=read.table(sprintf('%s%s',fpth,fnames[i]),sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)
    t1=proc.time()
    t1-t0 #450
    tmpStr=calc_strdness(trp,rdftype)
    # allstr[[names(fnames)[i]]]=tmp$CHD
    t2=proc.time()
    tmpRS=calc_RSpeciality(trp,rdftype)
    t3=proc.time()
    # allstr[[names(fnames)[i]]]=tmp$RS
    save(file=sprintf('~/%s_strd_Rspec.csv',fnames[i]),tmpStr,tmpRS)  
    Res=cbind(i,strctrdnss=tmpStr$CHD,RSp=tmpRS$RS,t01=(t1-t0)[3],t12=(t2-t1)[3],t23=(t3-t2)[3])
}
t1=proc.time()
# print(allstr)
t1-t0
}

######################### test par
{


    # tmp1=calc_strdness_par(trp,ncores=5,'sw')
    
    i=1
    print(i)
   print(fnames[i])
    t0=proc.time()
    trp=read.table(sprintf('%s%s',fpth,fnames[i]),sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)
    t1=proc.time()
    t1-t0 #450
    
tmp1=calc_strdness_par(trp,rdftype=rdftype,OS_WIN=FALSE,ncores=8,dsname)


}
