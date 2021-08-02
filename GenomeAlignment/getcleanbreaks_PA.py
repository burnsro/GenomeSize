#!/usr/bin/env python                                                                         
from optparse import OptionParser
import sys
parser=OptionParser()
parser.add_option("-n", "--name", dest="name", help="name file", default="")
parser.add_option("-p", "--pop", dest="population", help="pop file", default="")
(options, args)=parser.parse_args()


name=options.name
pop=options.population


allele_names=set()
for line in open('%s'%name,'r'):
	line=line.strip().split('\t')
	allele=line[0]
	allele_names.add(allele)
#print(allele_names)

out=open('%s.PA.txt'%name, 'w')
for line in open('%s'%pop, 'r'):
	line=line.strip().split('\t')
	called=line[3]	
	called=called.strip().split(';')
	called=set(called)
	test=called.intersection(allele_names)
	if len(test)==0:
		out.write("0\n")
	elif len(test)>0:
		out.write("1\n")
	else:
		pass
out.close()
