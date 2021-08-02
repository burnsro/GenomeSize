library(tidyverse)

sort_orientated = function(inputfile) {
	t=read.csv(inputfile, header=T)
	t=t%>%group_by(t$ref)%>%arrange(ref, ref_start)
	out=gsub("csv", "uniqalign.bed", inputfile)
	write.table(t[,c(7,1,2,8,3,4)], file=out, col.names=T, quote=F, sep='\t', row.names=F)
}


args <- commandArgs(TRUE)
sort_orientated(inputfile=args[1])
