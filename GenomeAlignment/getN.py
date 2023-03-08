import argparse
from Bio import SeqIO

parser = argparse.ArgumentParser(description="Converts N bases in a FASTA file to a BED file.")
parser.add_argument("-i", "--input", metavar="input_file", type=str, required=True,
                    help="the input FASTA file")
parser.add_argument("-o", "--output", metavar="output_file", type=str, required=True,
                    help="the output BED file")

args = parser.parse_args()

input_file = args.input
output_file = args.output

with open(output_file, "w") as output:
    for record in SeqIO.parse(input_file, "fasta"):
        seq_name = record.id
        seq = record.seq
        n_starts = []
        n_stops = []
        n_start = None
        for i, base in enumerate(seq):
            if base == "N":
                if n_start is None:
                    n_start = i
            else:
                if n_start is not None:
                    n_starts.append(n_start)
                    n_stops.append(i)
                    n_start = None
        if n_start is not None:
            n_starts.append(n_start)
            n_stops.append(len(seq))
        for n_start, n_stop in zip(n_starts, n_stops):
            output.write(f"{seq_name}\t{n_start}\t{n_stop}\n")
