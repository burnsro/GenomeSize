from optparse import OptionParser                                                                                                    
parser=OptionParser()
parser.add_option('-r', '--ref', dest='ref', help='reference kmers', default='')
parser.add_option("-a", "--acc", dest="acc", help="acc kmers", default="")
(options, args)=parser.parse_args()

import sys
from Bio import SeqIO

kmers_acc=set()
for kmer in SeqIO.parse("%s"%options.acc, "fasta"):
	kmers_acc.add(hash(str(kmer.seq)))



out=open('%s.shared'%options.ref, 'w')
out2=open('%s.unique'%options.ref, 'w')
kmers_ref=set()
for record in SeqIO.parse('%s'%options.ref, "fasta"):
	seq_hash = hash(str(record.seq))
	kmers_ref.add(hash(str(record.seq)))
	if seq_hash in kmers_acc:
		#out.write(str(record.seq)+ '\n')
		out.write(str(record.seq)+ '\t' + len(str(record.seq)) + '\n')
	else:
		out2.write(str(record.seq)+ '\n')











