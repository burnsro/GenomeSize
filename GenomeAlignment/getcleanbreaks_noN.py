#!/usr/bin/env python                                                                         
from optparse import OptionParser
parser=OptionParser()
parser.add_option("-v", "--vcf", dest="vcf", help="vcf file", default="")
(options, args)=parser.parse_args()

vcf=options.vcf

out=open('%s_cleanNames'%vcf, 'w')
out2=open('%s_basecount'%vcf, 'w')
out2.write('%s,%s,%s,%s,%s\n'%("N", "A", "T", "G","C"))
for line in open('%s'%vcf, 'r'):
	line=line.strip().split('\t')
	chr=line[0].strip()
	Spos=line[1].strip()
	Name=line[2].strip()
	seq=line[3].strip()
	seq2=seq.upper()
	seqN=seq2.count("N")
	seqA=seq2.count("A")
	seqT=seq2.count("T")
	seqC=seq2.count("C")
	seqG=seq2.count("G")
	start=seq2[0:54]
	startN=start.find("N")
	end=seq2[-3:-54]
	endN=end.find("N")
	#out2.write('%s,%s,%s,%s,%s\n'%("N", "A", "T", "G","C"))
	out2.write('%s,%s,%s,%s,%s\n'%(seqN, seqA, seqT, seqC,seqG))
	if (len(seq2)-2)>=100 and seqN/(seqA+seqT+seqC+seqG)<=0.2 and startN==-1 and endN==-1:
		out.write('%s\n'%(Name))
out.close()
