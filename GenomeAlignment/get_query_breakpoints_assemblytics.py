#!/usr/bin/env python                                                                         
from optparse import OptionParser
parser=OptionParser()
parser.add_option("-b", "--bed", dest="bed", help="bed file", default="")
(options, args)=parser.parse_args()

bed=options.bed

out=open('%s_QueryPos.bed'%bed, 'w')
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
	aly_start=aly_pos[0]
	aly_end=aly_pos[1]
	out.write('%s\t%s\t%s\t%s\t%s\t%s\t%s\n'%(aly_chr, aly_start, aly_end, Name, chr, Spos, Epos))
out.close()
