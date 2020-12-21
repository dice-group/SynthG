uri2lbl<-function(uri){
    lbl=character(length(uri))
    for(i in 1:length(uri)){
        name=substring(uri[i],regexpr("/[^/]*$", uri[i])+1,nchar(uri[i]))
        x=regexpr("#",name,fixed=T)#instring
       lbl[i]=substr(name,x+attr(x,"match.length"),nchar(name))
       if( substring(lbl[i],nchar(lbl[i]))=='>') lbl[i]=substring(lbl[i],1,nchar(lbl[i])-1)
    }
    return(lbl)
}

ltr2dbl<-function(ltr){
    # lbl=character(length(ltr))
    x=regexpr("^^",ltr,fixed=T)
    ltr[x>1]=substr(ltr[x>1],1,x-1)
    ltr=gsub("\"","",ltr)
    # browser()
    return(as.numeric(ltr))
}

#source('uri2lbl.R')