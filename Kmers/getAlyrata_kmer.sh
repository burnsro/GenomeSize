#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=20  # 14 physical cores per task
#SBATCH --mem=160G   # 64GB of RAM
#SBATCH --qos=short
#SBATCH --time=0-04:00:00
#SBATCH --output=%A_%a.kmc.stdout
#SBATCH --array=1-22

ml anaconda3/2019.03
#conda create -p /groups/nordborg/projects/suecica/005scripts/001Software/RobinCondaSCRATCH python=2.7 #or 3.6 just run this command once then source it
cd /groups/nordborg/projects/suecica/005scripts/001Software
ml anaconda3/2019.03
source activate RobinCondaSCRATCH3/
#out='/scratch-cbe/users/robin.burns/001Alyrata/Asmvar/11B02'
out='/scratch-cbe/users/robin.burns/001Alyrata/bayesTyper/kmc3'
#out='/scratch-cbe/users/robin.burns/001Alyrata/junctions/Aly'
#out='/scratch-cbe/users/robin.burns/001Alyrata/junctions/Aly'
#out='/scratch-cbe/users/robin.burns/001Alyrata/Athaliana/6909'
#raw='/groups/nordborg/projects/nordborg_rawdata/Phylogenomics/phylogenomics/RAWdata/Phylogenomics/renamedRAW'
#raw='/groups/nordborg/projects/transposons/Robin/Alyrata/006Matilla'
#raw='/groups/nordborg/projects/nordborg_rawdata/Alyrata/PCR_free'
#raw='/groups/nordborg/projects/nordborg_rawdata/Phylogenomics/Ext_data_krzysztof/Lyrata_All'
#raw='/groups/nordborg/projects/transposons/Robin/Alyrata/sra'
#raw='/groups/nordborg/projects/the1001genomes_archive/ARCHIVE/FASTQ_files/fastq_all'
#samples=$raw'/diploids_lyrata.txt'
#samples=$out/mysamples
#samples='/groups/nordborg/projects/transposons/Robin/Alyrata/003scripts/samples_Kextdata.txt'
#samples=$raw'/myfastq'
samples=$out'/notdone'
#samples=${out}/'myAly'
export l=$SLURM_ARRAY_TASK_ID\p
line=`sed -n $l $samples`
acc=`echo $line | cut -d ' ' -f1`
echo $acc
#acc='Alyratapetraea31'
#acc='MN47.31kmers.fasta'
#acc='6909411B21.31kmers.fasta'
#ls $raw/${acc}.*.fastq.gz > $out/${acc}.lst
cd $out

kmc -fq -t20 -sf20 -sp20 -sr20 -k31 -m160 -ci3 @${out}/${acc}.lst  ${acc} /scratch-cbe/users/robin.burns/tmp
#export PATH='/groups/nordborg/projects/suecica/005scripts/001Software/BayesTyper/ntHash':$PATH
#ml tabix/0.2.6-gcccore-7.3.0
cd $out

#lastal -e25 -v -q3 -j4 alydb 11B02.fa | last-split -s35 -v >  aly11B02.maf

#AsmvarDetect='/groups/nordborg/projects/suecica/005scripts/001Software/AsmVar/src/AsmvarDetect'
#$AsmvarDetect/ASV_VariantDetector -s alyath -t Arabidopsis_lyrata.sm.fa -i alyath.maf.gz  -o athaly_${acc}  -q Arabidopsis_thaliana.sm.fa -r ${acc} > athaly.age_${acc} 2> athaly.AsmVarDetection.log_${acc}

#bayesTyperTools makeBloom -k $acc -p 16
#bayesTyper cluster -v final.vcf.gz -s mysameples_BT_batch1.tsv -g Aly.fasta -d Aly_nonchromosome_sm_MtCp.fa -p 16

#bayesTyper genotype -v bayestyper_unit_1/variant_clusters.bin -c bayestyper_cluster_data -s mysameples_BT_batch1.tsv -g Aly.fasta -d Aly_nonchromosome_sm_MtCp.fa -o bayestyper_unit_1/bayestyper -z -p 16


#kmc -fm -t1 -sr1 -k31 -m30 Aly.maskedrdiff_result.fasta Aly.maskedrdiff_result.kmc /scratch-cbe/users/robin.burns/tmp

#kmc_tools transform Aly.maskedrdiff_result.kmc -ci1 dump -s Aly.maskedrdiff_result.kmc.txt
#awk -F '\t' '{print ">kmer31_"NR-1"\n"$1}' Aly.maskedrdiff_result.kmc.txt > Aly.maskedrdiff_result.kmc31.fasta
kmc_tools transform ${acc} -ci1 dump -s ${acc}.txt
perl -i -ne 'print unless $seen{$_}++' ${acc}.txt
awk -F '\t' '{print ">kmer31_"NR-1"\n"$1}' ${acc}.txt > ${acc}.31kmers.fa

#python /groups/nordborg/projects/transposons/Robin/Alyrata/003scripts/getkmerhashtable.py -a MN47.31kmers.fasta -r ${acc} 

#python /groups/nordborg/projects/transposons/Robin/Alyrata/003scripts/getkmerhashtable.py -a Columbia_alignments_forreadcheck.smaller31forbed.fa -r ${acc}


#awk -F '\t' '{print ">kmer31_shared"NR-1"\n"$1}' ${acc}.shared > ${acc}.shared.tmp
#awk -F '\t' '{print ">kmer31_unique"NR-1"\n"$1}' ${acc}.unique > ${acc}.unique.tmp
#mv ${acc}.shared.tmp ${acc}.shared
#mv ${acc}.unique.tmp ${acc}.unique



