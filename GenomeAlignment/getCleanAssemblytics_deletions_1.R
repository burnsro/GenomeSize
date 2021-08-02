library(tidyverse)
getclean=function(myfile) {
	t=read.table(file=myfile, header=F)
	t_nondup=t[!(duplicated(t$V4)),]
	t_dup=t[(duplicated(t$V4)),]
	tt=t_nondup[!(t_nondup$V4%in%t_dup$V4),]
	outfile=gsub("bed", "clean.bed", myfile)
	write.table(tt[,c(1:11)], file=outfile, col.names=F, row.names=F, quote=F, sep='\t')
}


args <- commandArgs(TRUE)
getclean(myfile=args[1])
