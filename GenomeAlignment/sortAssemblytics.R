library(tidyverse)


sort_assemblytics = function(inputfile) {
	t=read.table(inputfile, header=F)
	t=t%>%group_by(V1)%>%arrange(V1,V2)
	t_del=t[t$V7=="Repeat_contraction" | t$V7=="Deletion" | t$V7=="Tandem_contraction",]
	t_ins=t[t$V7=="Repeat_expansion" | t$V7=="Insertion" | t$V7=="Tandem_expansion",]
	t_del=t_del[!(duplicated(t_del$V1) & duplicated(t_del$V2) & duplicated(t_del$V3)),]
	t_ins=t_ins[!(duplicated(t_ins$V1) & duplicated(t_ins$V2) & duplicated(t_ins$V3)),]
	out1=gsub("bed", "DEL.bed", inputfile)
	out2=gsub("bed", "INS.bed", inputfile)
	acc=gsub("\\.Assemblytics_structural_variants.bed", "", inputfile)
	mypath=getwd()
	acc=gsub(mypath, "", acc)
	t_del$V4=paste(acc,t_del$V4, sep="_")
	t_ins$V4=paste(acc,t_ins$V4, sep="_")
	write.table(t_del, file=out1, col.names=F, quote=F, sep='\t', row.names=F)
	write.table(t_ins, file=out2, col.names=F, quote=F, sep='\t', row.names=F)
}

#setwd("/scratch-cbe/users/robin.burns/001Alyrata/Mummer")
args <- commandArgs(TRUE)
sort_assemblytics(inputfile=args[1])
