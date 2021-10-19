#First install GATK using conda
#We want gatk 3, gatk 4 is buggy
out='/path/to/outdir'
ref='/path/to/T2Tfile'

#First call variants using individuals and ploidy then switch to per chromosome
#Go it through step by step
# put '#' beside step commands you are not using, sorry it is a little tedious


#need to write for loop to make myind the bam file of interest as we
#are using condor 
#this might get a little busy
acc=myind
ploidy=2

#need to write for loop to make mychrom the chrom we are looking at
chrom=mychrom


TMP='/path/to/tmp'
cd $out
#==================================== STEP1 =========================================
# ==== call SNPs and indels with GATK - Haplotype Caller per each Chromosome per individual ====
#echo "for the given input file ${inputfile}, the output vcf file is $output_vcf_file"

java -Xmx30g -Djava.io.tmpdir=$TMP -jar $EBROOTGATK/GenomeAnalysisTK.jar \
	-R ${ref} \
	-T HaplotypeCaller \
	-I ${out}/${acc}.filt.bam\
	--emitRefConfidence GVCF \
	-o ${out}/${acc}.${chrom}.g.vcf \
	--sample_ploidy ${ploidy} \
	-variant_index_type LINEAR \
	-variant_index_parameter 128000 \
	-nct 16 \
	-L ${chrom}
 


#==================================== STEP2 ===============================================
# ==== combine g.vcf files of all individuals for a given chromosome with CombineGVCFs ====
#input files are *.g.vcf files obtained from the script above

cd $out
ls *$chrom.g.vcf > $chrom.list


java -Xmx80g -Djava.io.tmpdir=$TMP -jar $EBROOTGATK/GenomeAnalysisTK.jar \
	   -R ${ref} \
	   -T CombineGVCFs \
	   -V ${out}/${chrom}.list \
	   -o ${out}/T2Tcol.${chrom}.combined.g.vcf


#=========================================== STEP3 =======================================================
# ==== convert g.vcf file of a given chr to a vcf with GenotypeGVCFs for joint genotyping of all inds ====


##echo "for the input file $input_file2, the output file is $output_file2"
java -Xmx85g -Djava.io.tmpdir=$TMP -jar $EBROOTGATK/GenomeAnalysisTK.jar \
	   -R $ref \
	   -T GenotypeGVCFs \
	   --variant ${out}/T2Tcol.${chrom}.combined.g.vcf \
	   -o ${out}/T2Tcol.${chrom}.combined.vcf  \
	   -nt 16



#================================================ STEP4 ==================================================
# ==== merge vcf files from all chrs to produce a single vcf prior to SNP filtration with CatVariants ====
#CatVariants concatenates vcf files of non-overlapping genome intervals, with the same set and ORDER of samples

java -Xmx70g -Djava.io.tmpdir=$TMP -cp $EBROOTGATK/GenomeAnalysisTK.jar org.broadinstitute.gatk.tools.CatVariants \
	   -R $ref \
	   --variant ${out}/T2Tcol.Chr1.combined.vcf \
	   --variant ${out}/T2Tcol.Chr2.combined.vcf \
	   --variant ${out}/T2Tcol.Chr3.combined.vcf \
	   --variant ${out}/T2Tcol.Chr4.combined.vcf \
	   --variant ${out}/T2Tcol.Chr5.combined.vcf \
	   -out ${out}/T2Tcol.fullgenome.combined.vcf \
	   -assumeSorted \
	   -log cat.all.chrs.log \
	   --logging_level ERROR \



# ============== CALL BIALLELIC VARIANT SITES ===============
# in addition to excluding non-variant sites, restrict variant sites to biallelic SNPs
java -Xmx60g -Djava.io.tmpdir=$TMP -jar $EBROOTGATK/GenomeAnalysisTK.jar \
	   -R $ref \
	   -T SelectVariants \
	   --variant ${out}/T2Tcol.fullgenome.combined.vcf \
	   -o $out/T2Tcol.fullgenome.combined.biallelicindels.vcf \
	   -selectType INDEL \
	   --restrictAllelesTo BIALLELIC \
	   -nt 6

############Parse output###########
cd $out
python indelVCF2CSV.py
#make a nice CSV file of results
