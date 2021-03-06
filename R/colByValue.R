##' colByValue
##' 
##' The function colByValue convert the values in matrix into colors
##' 
##' 
##' 
##' @param x matrix with values.
##' @param col a list of colors such as that generated by \code{\link{rainbow}}, \code{\link{heat.colors}}, \code{\link{topo.colors}}, \code{\link{terrain.colors}} or similar functions.
##' @param range the range of x. values out of the range will be changed to the max or min value of the range.
##' @param breaks either a numeric vector of two or more unique cut points or a single number (greater than or equal to 2) giving the number of intervals into which x is to be cut.
##' @param las numeric in {0,1,2,3}; the style of axis labels.
##' @param cex.axis The magnification to be used for axis annotation relative to the current setting of cex.
##' @param ... additional arguments passed on to \code{\link{image}} function to generate the color bar.
##' @export
##' @return A matrix with colors.
##' @examples temp<-rnorm(1000)
##' col<-colByValue(temp,col=colorRampPalette(c('chartreuse4','white','firebrick'))(1024),range=c(-2,2))
##' col<-colByValue(temp,col=colorRampPalette(c('chartreuse4',
##' 'white','firebrick'))(5),breaks=c(-5,-1,-0.1,0.1,1,5),cex.axis=0.8)
colByValue<-function(x,col,range=NA,breaks=NA,cex.axis=2,las=1,...) {
	if (is.vector(x)) {
		x<-as.matrix(x)
	}
	if (is.na(range[1])) {} else {
		x[x<range[1]]<-range[1]
		x[x>range[2]]<-range[2]
	}
	if (is.na(breaks[1])) {
		ff <- seq(min(x,na.rm=T),max(x,na.rm=T), length=length(col))
		bg2<-apply(as.matrix(as.numeric(unlist(x))),1,function(x) rank(c(ff,x),ties.method ="min")[length(col)+1])
		dens <-matrix(bg2,nrow(x),ncol(x))
		result<-matrix(col[dens],nrow=nrow(x),ncol=ncol(x))
		row.names(result)<-row.names(x)
		image(x=1:2,y=as.matrix(ff),z=t(ff),col=col,xaxt="n",ylab="",las=las,xlab="",xlim=c(1,4),bty="n",...)
		return(result)
	} else {
		temp<-cut(as.numeric(unlist(x)),breaks=breaks,include.lowest=T)
		if (length(col)!=length(levels(temp))) {stop("length:col != length: cut result")}
		result<-matrix(col[as.numeric(temp)],nrow=nrow(x),ncol=ncol(x))
		row.names(result)<-row.names(x)
		image(x=1:2,y=as.matrix(1:(length(breaks)-1)),z=t(1:(length(breaks)-1)),col=col,xaxt="n",yaxt="n",ylab="",xlab="",xlim=c(0,3),...)
		axis(2, at = 1:(length(breaks)-1),labels=levels(temp),las=las,cex.axis=cex.axis)
		return(result)
	}
}

