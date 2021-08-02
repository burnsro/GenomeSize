#!/usr/bin/env python                                                                         
from optparse import OptionParser
parser=OptionParser()
parser.add_option("-b", "--bed", dest="bed", help="bed file", default="")
parser.add_option("-n", "--name", dest="name", help="name file", default="")
parser.add_option("-a", "--acc", dest="acc", help="acc file", default="")
(options, args)=parser.parse_args()


bed=options.bed
name=options.name
acc=options.acc

clean_names=set()
for name in open('%s'%name,'r'):
	name=name.strip().split('\t')
	name=name[0]
	clean_names.add(name)


out=open('%s.noN.bed'%acc, 'w')
for line in open('%s'%bed, 'r'):
	line=line.strip().split('\t')
	if line[3] in clean_names:
		out.write('%s\t%s\t%s\t%s\t%s\n'%(line[0], line[1],line[2],line[3], line[9]))
	else:
		pass
out.close()
