#!/usr/bin/env python                                                                         
from optparse import OptionParser
parser=OptionParser()
parser.add_option("-b", "--bed", dest="bed", help="bed file", default="")
(options, args)=parser.parse_args()

bed=options.bed

out=open('%s_QueryPos.1kbupdown.bed'%bed, 'w')
for line in open('%s'%bed, 'r'):
	line=line.strip().split('\t')
	chr=line[0]
	Spos=line[1]
	Epos=line[2]
	Name=line[3]
	Aly=line[4]
	Aly=Aly.strip().split(':')
	aly_chr=Aly[0]
	aly_pos=Aly[1]
	aly_pos=aly_pos.strip().split('-')
	mypos=int(aly_pos[0])
	mypos2=int(aly_pos[1])
	aly_start=int(mypos-1000)
	aly_start=(abs(aly_start)+aly_start)/2 #make sure it is not negative  
	aly_start=int(aly_start)
	aly_end=int(mypos2+1000)
	out.write('%s\t%s\t%s\t%s\t%s\t%s\t%s\n'%(aly_chr, aly_start, aly_end, Name, chr, Spos, Epos))
out.close()
