#Minimap2 of the reference genomes of Alyrata and Athaliana

library(pafr)
library(ggplot2)
library(ggpubr)
setwd("/Users/robin.burns/Documents/004Alyrata/013Minimap2")
#Comparison to the reference
mn47_col0=read_paf("MN47_Col0.paf")
prim_mn47_col0 <- filter_secondary_alignments(mn47_col0)
at2al_cov=plot_coverage(prim_mn47_col0, fill='qname') + scale_fill_brewer(palette="Set1")
at2al_div=ggplot(prim_mn47_col0, aes(alen, de)) + 
  geom_point(alpha=0.6, colour="#1b9e77", size=2) + 
  scale_x_continuous("Alignment length (kb)", label =  function(x) x/ 1e3) +
  scale_y_continuous("Divergence from aligned regions") + 
  theme_pubr()

col0_mn47=read_paf("Col0_MN47.paf")
prim_col0_mn47 <- filter_secondary_alignments(col0_mn47)
al2at_cov=plot_coverage(prim_col0_mn47, fill='qname') + scale_fill_brewer(palette="Set1")
al2at_div=ggplot(prim_col0_mn47, aes(alen, de)) + 
  geom_point(alpha=0.6, colour="#d95f02", size=2) + 
  scale_x_continuous("Alignment length (kb)", label =  function(x) x/ 1e3) +
  scale_y_continuous("Divergence from aligned regions") + 
  theme_pubr()


Length_variants=read.table(file='LengthVariants.txt', header=F)
Length_variants_m=melt(Length_variants)

indels=ggplot(Length_variants_m, aes(x=V1, y=value, fill=V1)) +
  geom_bar(stat='identity') + 
  theme_light() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  ylab("count") +
  scale_fill_manual(values=c("#6baed6","#fd8d3c","#08519c","#bd0026"))


pdf("~/Desktop/Reference_Aln.pdf", height=8, width=8)
library(ggpubr)
ggarrange(at2al_cov,al2at_cov,at2al_div,indels,labels=c('a','b', 'c','d'),
          ncol=2, nrow=2, align='hv')
dev.off()
