#!/usr/bin/env python                                                                                                
import sys
from optparse import OptionParser
parser=OptionParser()

parser.add_option('-n', "--names", dest="names", help="names file", default="")
parser.add_option("-f", "--fasta", dest="fasta", help="fasta file", default="")
parser.add_option("-a", "--acc", dest="acc", help="acc name", default="")
(options, args)=parser.parse_args()

names=options.names
acc=options.acc
fasta=options.fasta

out=open('%s.primaryT.faa'%acc, "w")

mynames = set()
for line in open('%s'%names, "r"):
	line=line.strip().split("\t")
	mynames.add(line[0])	

skip = 0
for line in open('%s'%fasta, "r"):
    if line[0] == '>':
        tline=line.strip().split(' ') 
        accessorIDWithArrow = str(tline[0])
        accessorID = accessorIDWithArrow.replace('>', '')
        print (accessorID)
	#break
        if accessorID in mynames:
            out.write("%s\n"%(accessorIDWithArrow))
            skip = 0
        else:
            skip = 1
    else:
        if not skip:
            out.write("%s"%(line))

out.close()
