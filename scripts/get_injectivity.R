# 14/12/2019

get_injectivity<-function(trp,topstars=2){
#topstars of prd ratio to totalCnt
    prduri=unique(trp[,2])
    Res=NULL
    for(p in 1:length(prduri)){
        print(p)
        cnt=sum(trp[,2]==prduri[p])
        cntS=length(unique(trp[trp[,2]==prduri[p],1]))
        cntO=length(unique(trp[trp[,2]==prduri[p],3]))
        cntE=length(unique(append(trp[trp[,2]==prduri[p],1],trp[trp[,2]==prduri[p],3])))
        Res=rbind(Res,data.frame(stringsAsFactors=FALSE,prd=prduri[p],cnt,cntS,cntO,cntE,minf=min(cntS,cntO)/cnt,injE=2-cntE*1.0/cnt))   
    }
    return(Res)
}

## 
get_inj_thr <-function(tpr,a=-1.33,b=-0.027){
#get threshold of injectivity for a required tpr (true positive rate)
require(pracma)
    # fx<-function(x){-1.33*log(x)-0.027}
    xs <- findzeros(function(x) a*log(x)+b - tpr,0.001, 1)
 return(xs)
}

injf<-function(x,a=-1.33,b=-0.027) {a*log(x)+b}

squaredError <- function(a,b,x,y) {sum((y-injf(x,a=a,b=b))^2)}
