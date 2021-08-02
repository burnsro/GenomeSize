#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=20  # 14 physical cores per task
#SBATCH --mem=160G   # 64GB of RAM
#SBATCH --qos=short
#SBATCH --time=0-04:00:00
#SBATCH --output=%A_%a.kmc.stdout
#SBATCH --array=1-22

ml anaconda3/2019.03
cd /groups/nordborg/projects/suecica/005scripts/001Software
ml anaconda3/2019.03
source activate RobinCondaSCRATCH3/

out='/scratch-cbe/users/robin.burns/001Alyrata/bayesTyper/kmc3'

samples=$raw'/myfastq'

export l=$SLURM_ARRAY_TASK_ID\p
line=`sed -n $l $samples`
acc=`echo $line | cut -d ' ' -f1`
echo $acc

cd $out

kmc -fq -t20 -sf20 -sp20 -sr20 -k31 -m160 -ci3 @${out}/${acc}.lst  ${acc} /scratch-cbe/users/robin.burns/tmp
cd $out
kmc_tools transform ${acc} -ci1 dump -s ${acc}.txt
perl -i -ne 'print unless $seen{$_}++' ${acc}.txt
awk -F '\t' '{print ">kmer31_"NR-1"\n"$1}' ${acc}.txt > ${acc}.31kmers.fa


#from the Arabidopsis lyrata genome
kmc -fm -t1 -sr1 -k31 -m30 Aly.maskedrdiff_result.fasta Aly.maskedrdiff_result.kmc /scratch-cbe/users/robin.burns/tmp

kmc_tools transform Aly.maskedrdiff_result.kmc -ci1 dump -s Aly.maskedrdiff_result.kmc.txt
awk -F '\t' '{print ">kmer31_"NR-1"\n"$1}' Aly.maskedrdiff_result.kmc.txt > MN47.31kmers.fasta 

#Are unique kmers in the lyrata genome present in the accession kmers?
python /groups/nordborg/projects/transposons/Robin/Alyrata/003scripts/getkmerhashtable.py -a MN47.31kmers.fasta -r ${acc} 


awk -F '\t' '{print ">kmer31_shared"NR-1"\n"$1}' ${acc}.shared > ${acc}.shared.tmp
awk -F '\t' '{print ">kmer31_unique"NR-1"\n"$1}' ${acc}.unique > ${acc}.unique.tmp
mv ${acc}.shared.tmp ${acc}.shared
mv ${acc}.unique.tmp ${acc}.unique



