#!/usr/bin/env python3
# a custom python script for reformatting the Assemblytics result

from optparse import OptionParser
parser=OptionParser()
parser.add_option("-b", "--bed", dest="bed", help="bed file", default="")
parser.add_option("-r", "--ref", dest="ref", help="ref name", default="")
parser.add_option("-q", "--que", dest="que", help="query name", default="")
parser.add_option("-v", "--vcf", dest="vcf", help="vcf name", default="")
(options, args)=parser.parse_args()

# Import modules
from pyfasta import Fasta
from Bio.Seq import Seq


# Load original 2.0.vcf
bed_path = options.bed
ref_fasta_path = options.ref
query_fasta_path = options.que

# Output file path
vcf_path = options.vcf

# Read fasta files
ref_fasta = Fasta(ref_fasta_path)
query_fasta = Fasta(query_fasta_path)

# Convert bed to vcf

# Read_bed
with open(bed_path,'r') as bed_lines:
    with open(vcf_path,'w') as vcf:
        # Remove header: manual
        for each_line in bed_lines:
            chrom, ref_start, ref_stop, ID, size, strand, _type, ref_gap_size, query_gap_size, query_coordinates, method = each_line.strip().split()
            query_tig, query_region, query_strand = query_coordinates.split(':')
            query_region_forward, query_region_reverse = query_region.split('-')
            chrom_num = chrom.split()[0]
            
            ref_region_seq = ref_fasta[chrom][int(ref_start):int(ref_stop)]
            
            query_region_seq = query_fasta[query_tig][int(query_region_forward):int(query_region_reverse)]
            
            # Empty seq cases
            if int(ref_start) == int(ref_stop):
                ref_region_seq = '.'
                
            if int(query_region_forward) == int(query_region_reverse):
                query_region_seq = '.'
            
            
            # If strand is reverse, do reverse_complement()
            if strand == '-':
                ref_region_seq = str(Seq(ref_region_seq).reverse_complement())
            if query_strand == '-':
                query_region_seq = str(Seq(query_region_seq).reverse_complement())
            
            
            vcf.write('\t'.join([chrom_num, ref_start, ID, ref_region_seq, query_region_seq, '.', "PASS", '.']) + "\n")
    
