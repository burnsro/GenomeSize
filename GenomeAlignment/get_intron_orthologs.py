from optparse import OptionParser                                                                                                             
parser=OptionParser()
parser.add_option('-i', '--i', dest='intron', help='intron', default='') #fasta file of introns
parser.add_option('-n', '--n', dest='name', help='name', default='') #name of intron

parser.add_option('-l', '--l', dest='lyrata', help='lyrata', default='') #fasta file of lyrata genes
parser.add_option('-g', '--g', dest='gene', help='gene', default='') #name of gene

parser.add_option('-t', '--t', dest='thaliana', help='thaliana', default='') #fasta file of thaliana genes
parser.add_option('-o', '--o', dest='ortho', help='ortho', default='') #name of orthologs


(options, args)=parser.parse_args()


name="%s"%options.name
NAME_DICT = {}
NAME_DICT[name[:]] = 1

gene="%s"%options.gene
GENE_DICT={}
GENE_DICT[gene[:]] = 1

ortho="%s"%options.ortho
ORTHO_DICT={}
ORTHO_DICT[ortho[:]] = 1

out=open('%s.align_fasta'%options.gene, 'w')
skip = 0
for line in open("%s"%options.intron, "r"):
    if line[0] == '>':
        _splitline = line.split(' ')
        accessorIDWithArrow = _splitline[0]
        accessorID = accessorIDWithArrow[1:-1]
        # print accessorID
        if accessorID in NAME_DICT:
            out.write(line)
            skip = 0
        else:
            skip = 1
    else:
        if not skip:
            out.write(line)

for line in open("%s"%options.lyrata, "r"):
	if line[0] == '>':
		_splitline = line.split(' ')
		accessorIDWithArrow = _splitline[0]
		accessorID = accessorIDWithArrow[1:-1]
		if accessorID in GENE_DICT:
			out.write(line)
			skip=0
		else:
			skip=1
	else:
		if not skip:
			out.write(line)

for line in open("%s"%options.thaliana, "r"):
	if line[0] == '>':
		_splitline = line.split(' ')
		accessorIDWithArrow = _splitline[0]
		accessorID = accessorIDWithArrow[1:-1]
		if accessorID in ORTHO_DICT:
			out.write(line)
			skip=0
		else:
			skip=1
	else:
		if not skip:
			out.write(line)
out.close()
