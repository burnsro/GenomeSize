#!/usr/bin/perl

use strict;
use warnings;

my $infile = "Athila_integrase_sequences_wHuck.fasta.aligned";
my $outfile = "Athila_integrase_sequences_wHuck.fasta.phylip";

open my $IN, "<", $infile or die $!;
open my $OUT, ">", $outfile or die $!;

my @sequences;
my $max_id_length = 0;

while (my $line = <$IN>) {
  chomp $line;

  if ($line =~ /^>/) {
    my ($id) = $line =~ /^>(.+)/;

    $max_id_length = length $id if length $id > $max_id_length;

    push @sequences, {
      id => $id,
      seq => "",
    };
  }
  else {
    $sequences[-1]{seq} .= $line;
  }
}

close $IN;

my $num_sequences = scalar @sequences;
my $alignment_length = length $sequences[0]{seq};

print $OUT "$num_sequences $alignment_length\n";

for my $seq (@sequences) {
  my $id = sprintf "%-${max_id_length}s", $seq->{id};

  print $OUT "$id  $seq->{seq}\n";
}

close $OUT;
