from optparse import OptionParser
parser=OptionParser()
parser.add_option("-f", "--fastq", dest="fastq", help="fastq file", default="")
parser.add_option("-x", "--fasta", dest="fasta", help="fasta file", default="")
#parser.add_option("-d", "--dir", dest="dir", help="directory", default="")
(options, args)=parser.parse_args()



from Bio import SeqIO

records = SeqIO.parse("%s"%options.fastq, "fastq")
count = SeqIO.write(records, "%s"%options.fasta, "fasta")
