#install RepeatMasker using conda

out='/path/to/outdir'
ref='/path/to/fastafile'
telib='/path/to/TEfastafile' #TAIR10 TEs?

cd $out
RepeatMasker -e ncbi -pa 16 -lib $out/$telib -a -dir ${out} ${out}/${ref}

