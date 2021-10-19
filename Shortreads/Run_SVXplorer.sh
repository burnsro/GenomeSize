#make sure bwa and samtools are insalled
ml bwa/0.7.17-foss-2018b
ml samtools/1.9-foss-2018b

out='/path/to/out'
ref='/path/to/reference/genome'
#make sure it is indexed with bwa and samtools
#map reads

#need for loop for each acc
acc=myacc

#samtools faidx $ref
#bwa index $ref
bwa mem -t 12 -M -U 15 -R '@RG\tID:'$acc'\tSM:'$acc'\tPL:Illumina\tLB:'$acc $ref $raw/${acc}.1.fastq.gz $raw/${acc}.2.fastq.gz > $out/$acc.sam
#increased penalty for unpaired reads
samtools view -@ 12  -bh -t $ref.fai -o $out/$acc.bam $out/$acc.sam
samtools sort -@ 12 -o $out/$acc.sort.bam $out/$acc.bam
samtools index $out/$acc.sort.bam
samtools rmdup $out/$acc.sort.bam $out/$acc.rmdup.bam
samtools index $out/$acc.rmdup.bam
rm $out/$acc.bam
rm $out/$acc.sort.bam*
rm $out/$acc.rmdup.bam*


#Run SVXplorer
#Read the github page
#get extractSplitReads_BwaMem from another software..
samtools view -@ 10 -h ${out}/${acc}.realigned.bam | extractSplitReads_BwaMem -i stdin | samtools view -Sb - > ${out}/${acc}.splitreads.bam
samtools view -@ 10 -F 3842 -b -o ${out}/${acc}.discordant.bam ${out}/${acc}.realigned.bam
samtools sort -n -@ 10 -o ${out}/${acc}.splitreads.sort.bam ${out}/${acc}.splitreads.bam

samtools index ${out}/${acc}.splitreads.sort.bam
samtools index ${out}/${acc}.discordant.sort.bam

svxplorer='/path/to/SVxplorer'
cd $out
${svxplorer} -w $out/${acc} -i ${out}/${acc}.discordant.bam ${out}/${acc}.splitreads.sort.bam ${out}/${acc}.rmdup.bam ${ref} 

