#18/2/2020
  #Calculate structuredness and relation speciality of a dataset : Saleem et al. WWW Conference 2019.
  # Also in parallel : _par
  #This file part of https://github.com/dice-group/SynthG
  #Author: Abdelmoneim Amer Desouki, Paderborn University, Informatik, FG NGonga
  #Based on Java implementation: https://github.com/dice-group/triplestore-benchmarks
  
calc_strdness<-function(trp,rdftype="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>"){
    #Calculate structuredness of a dataset: much faster than Java version:
    ## https://github.com/dice-group/triplestore-benchmarks/blob/master/src/main/java/org/aksw/simba/dataset/stats/Structuredness.java
    ## Modified Algorithm
    
    Prds=unique(trp[,2])
    I_C=table(trp[trp[,2]==rdftype,3])
    CL=names(I_C)
    pcM=matrix(0,nrow=length(Prds),ncol=length(CL))
    print(dim(pcM))
    rownames(pcM)=Prds
    colnames(pcM)=CL
    
    typeProb=trp[trp[,2]==rdftype ,-2]
    # for(p in Prds[Prds!=rdftype]){#gives exact results to Excel sheet
    for(p in Prds){#
       print(p)
       pE=unique(trp[trp[,2]==p,1])#subject only
        Cp=table(typeProb[typeProb[,1] %in% pE,2])
        if(length(Cp)>0){
            ix=cbind(which(Prds==p),match(names(Cp),CL))
            pcM[ix]=Cp
        }
    }

    cs=colSums(pcM)
    P_C=colSums(pcM!=0)
    CV=ifelse(cs==0,0,cs/(P_C*I_C))
    # CV=ifelse(cs==0,0,cs/(P_C*cs))
    WTCV=(I_C + P_C)/(sum(pcM!=0) + sum(I_C))#sum(I_C)
     # print(sum(cs))
    
    #structuredness
    CHD=sum(CV*WTCV)
     
    # sum(CV (C) * WTCV (C))
    print(paste("structuredness:",CHD))
    
    return(list(CHD=CHD,CA=data.frame(stringsAsFactors=FALSE,type=names(I_C),CV,WTCV,I_C=as.vector(I_C),P_C,cs),pcM=pcM))
}

 # trp=read.table('swfcTbox_org.nt',sep=' ',quote = "\"",stringsAsFactors =FALSE,fill=TRUE,comment.char = "",na.strings ="",row.names=NULL)

calc_RSpeciality<-function(trp,rdftype="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>"){
    #Calculate relation speciality of a dataset
    # require(moments)
    isIRI=substring(trp[,3],1,1)=="<"
    Prds=unique(trp[isIRI,2])
    # E=unique(append(trp[,1],trp[,3]))
    totalSubjects=length(unique(trp[,1]))
    
    allK=NULL
    Tr=table(trp[,2])
    # for(p in Prds){#
    for(p in Prds){#
            # p=Prds[1]
            print(p)
            tmp=table(trp[trp[,2]==p ,1])
            xi=rep(0,totalSubjects+1);   xi[1:length(tmp)]=as.vector(tmp)
            n=totalSubjects
            mu=mean(xi)
            Sigma=sd(xi)#in kurosis calc sigma used N instead of N-1
            # if(p=="<http://rdfs.org/ns/void#inDataset>") browser()
            if(n < 4 | Sigma==0) {
                    Kr=0
             }else{
               Kr = n*(n + 1)/((n-1)*(n-2)*(n-3))* sum((xi-mu)^4)/Sigma^4-( 3*(n-1)^2/((n-2)*(n-3)))
               }
            allK=rbind(allK,data.frame(stringsAsFactors=FALSE,p,n,mu,Sigma,Kr,Tr=Tr[p]))
            }
      
      # RS=sum(Tr*allK[match(names(Tr),allK[,'p']),'Kr'])/sum(Tr)   
      totalTriples=nrow(trp)
      RS=sum(allK[,'Tr']*allK[,'Kr'])/totalTriples  
      print(paste("RSpeciality:",RS))
      return(list(RS=RS,Kr=allK,n=n,totalTriples=totalTriples))
 }      
 ###############
calc_RSpeciality_par<-function(trp,rdftype="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>",OS_WIN=FALSE,ncores=3,dsname=''){
    #Calculate relation speciality of a dataset
    # require(moments)
    require(parallel)
	require(doParallel)
     if(OS_WIN){
               cluster <- parallel::makeCluster(ncores,outfile=sprintf("%s_calc_RSpeciality_par_nc%d.log",dsname,ncores))
        }else{ 
               cluster <- parallel::makeForkCluster(ncores,outfile=sprintf("%s_calc_RSpeciality_par_nc%d.log",dsname,ncores))#not in windows, copy only changed
    }
	registerDoParallel(cluster)
    
    isIRI=substring(trp[,3],1,1)=="<"
    Prds=unique(trp[isIRI,2])
    # E=unique(append(trp[,1],trp[,3]))
    totalSubjects=length(unique(trp[,1]))
    
    n=totalSubjects
    # allK=NULL
    Tr=table(trp[,2])
    # for(p in Prds){#
    allK=foreach(i =1:length(Prds),.combine="rbind")%dopar%{#
       p=Prds[i]
            # p=Prds[1]
            print(p)
            tmp=table(trp[trp[,2]==p ,1])
            xi=rep(0,totalSubjects+1);   xi[1:length(tmp)]=as.vector(tmp)
            mu=mean(xi)
            Sigma=sd(xi)#in kurosis calc sigma used N instead of N-1
            # if(p=="<http://rdfs.org/ns/void#inDataset>") browser()
            if(n < 4 | Sigma==0) {
                    Kr=0
             }else{
               Kr = n*(n + 1)/((n-1)*(n-2)*(n-3))* sum((xi-mu)^4)/Sigma^4-( 3*(n-1)^2/((n-2)*(n-3)))
               }
            Res=data.frame(stringsAsFactors=FALSE,p,n,mu,Sigma,Kr,Tr=Tr[p])
            }
      
      
      # RS=sum(Tr*allK[match(names(Tr),allK[,'p']),'Kr'])/sum(Tr)   
      totalTriples=nrow(trp)
      RS=sum(allK[,'Tr']*allK[,'Kr'])/totalTriples  
      print(paste("RSpeciality:",RS))
       stopCluster(cluster)
      return(list(RS=RS,Kr=allK,n=n,totalTriples=totalTriples))
 }      
 ###############
 calc_strdness_par<-function(trp,rdftype="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>",OS_WIN=FALSE,ncores=3,dsname=''){
    #Calculate structuredness of a dataset
    
    require(parallel)
	require(doParallel)
     if(OS_WIN){
               cluster <- parallel::makeCluster(ncores,outfile=sprintf("%scalc_strdness_par_nc%d.log",dsname,ncores))
        }else{ 
               cluster <- parallel::makeForkCluster(ncores,outfile=sprintf("%scalc_strdness_par_nc%d.log",dsname,ncores))#not in windows, copy only changed
    }
	registerDoParallel(cluster)
    Prds=unique(trp[,2])
    I_C=table(trp[trp[,2]==rdftype,3])
    CL=names(I_C)
    pcM=matrix(0,nrow=length(Prds),ncol=length(CL))
    print(dim(pcM))
    rownames(pcM)=Prds
    colnames(pcM)=CL
 
    # for(p in Prds[Prds!=rdftype]){#gives exact results to Excel sheet
    typeProb=trp[trp[,2]==rdftype ,-2]
    tmpR=foreach(i =1:length(Prds))%dopar%{#
       p=Prds[i]
       print(p)
       pE=unique(trp[trp[,2]==p,1])#subject only
        # Cp=table(trp[trp[,2]==rdftype & trp[,1]%in% pE,3])
        Cp=table(typeProb[typeProb[,1] %in% pE,2])
        if(length(Cp)>0){
            # ix=cbind(which(Prds==p),match(names(Cp),CL))
            # pcM[ix]=Cp
            Res=cbind(i=which(Prds==p),j=match(names(Cp),CL),Cp)
        }else{
            Res=cbind(i=0,j=0,Cp=NA)
        }
    }
    
    print('set pcM...')
     for(l in 1:length(tmpR)){
      if(tmpR[[l]][1,1]>0){
         pcM[cbind(tmpR[[l]][,1],tmpR[[l]][,2])]=tmpR[[l]][,3]
      }
     }
    cs=colSums(pcM)
    P_C=colSums(pcM!=0)
    CV=ifelse(cs==0,0,cs/(P_C*I_C))
    # CV=ifelse(cs==0,0,cs/(P_C*cs))
    WTCV=(I_C + P_C)/(sum(pcM!=0) + sum(I_C))#sum(I_C)
     # print(sum(cs))
    # write.csv(file='swfc_org_CV.csv',cbind(CV,WTCV,I_C,P_C))
    #structuredness
    CHD=sum(CV*WTCV)
     # browser()
    # sum(CV (C) * WTCV (C))
    print(paste("structuredness:",CHD))
    
    stopCluster(cluster)
    return(list(CHD=CHD,CA=data.frame(stringsAsFactors=FALSE,type=names(I_C),CV,WTCV,I_C=as.vector(I_C),P_C,cs),pcM=pcM))
}


 ###########
 ##Test R implementation with original java implementation :
calc_strdness_j2r<-function(trp,rdftype="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>"){
getTypePredicates<-function(type){
 tS=trp[trp[,2]==rdftype & trp[,3]==type,1]
 return(unique(trp[trp[,1]%in% tS,2]))
}
getOccurences<-function(prd,type){
 tS=trp[trp[,2]==rdftype & trp[,3]==type,1]
 return(length(unique(trp[trp[,1]%in% tS & trp[,2]==prd,1])))
}
I_C=table(trp[trp[,2]==rdftype,3])
types=names(I_C)
WtDenom=sum(I_C)
stats=NULL
for(type in types){
occurenceSum=0
    typePrds=getTypePredicates(type)
    WtDenom=WtDenom+length(typePrds)
    for(p in typePrds){
     print(paste(p,type))
      occs=getOccurences(p,type)
      occurenceSum = (occurenceSum + occs);
    }
    if(length(typePrds)==0){
				denom = 1;
                }else{
                denom=length(typePrds)*I_C[type]
                }
    stats=rbind(stats,data.frame(stringsAsFactors=FALSE,type,P_C=length(typePrds),occSum=occurenceSum,denom,CV=occurenceSum*1.0/denom))
    }
    
    WTCV=(stats[,'P_C']+I_C)/WtDenom
    CHD=sum(stats[,'CV']*WTCV)
    
    return(list(CHD=CHD,WTCV=WTCV,stats=stats))
 
 }