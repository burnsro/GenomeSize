#!/usr/bin/env python                                                                         
from optparse import OptionParser
parser=OptionParser()
parser.add_option("-f", "--file", dest="file", help="file", default="")
(options, args)=parser.parse_args()

file=options.file
out=open('%s_bases'%file, "w")
out.write('A,C,G,T,N\n')
from Bio import SeqIO
for cur_record in SeqIO.parse('%s'%file, "fasta") :
	#count nucleotides in this record...
	A_count = cur_record.upper().seq.count('A')
	C_count = cur_record.upper().seq.count('C')
	G_count = cur_record.upper().seq.count('G')
	T_count = cur_record.upper().seq.count('T')
	N_count = cur_record.upper().seq.count('N')
	out.write('%s,%s,%s,%s,%s\n'%(A_count, C_count, G_count, T_count, N_count))
out.close()
