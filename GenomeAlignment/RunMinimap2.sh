#!/usr/bin/env bash  
#SBATCH --nodes=1
#SBATCH --ntasks=16 # 14 physical cores per task
#SBATCH --mem=64G   # 64GB of RAM
#SBATCH --qos=short
#SBATCH --time=0-06:00:00
#SBATCH --output=%A_%a.Minimap2_SVs.stdout
#SBATCH --array=1-13

CONDA_ENVS_PATH='/groups/nordborg/projects/suecica/005scripts/001Software'
CONDA_PKGS_DIRS=/opt/anaconda/pkgs='/groups/nordborg/projects/suecica/005scripts/001Software'
cd /groups/nordborg/projects/suecica/005scripts/001Software
ml anaconda3/2019.03
source activate RobinCondaSCRATCH3/
ml matplotlib/3.1.1-foss-2018b-python-3.6.6
#out='/scratch-cbe/users/robin.burns/002WGA/Minimap2/MN47ref/sam'
#out='/scratch-cbe/users/robin.burns/002WGA/Minimap2/MN47ref/sam/ref_Col0short'
cd $out

samples=$out'/mypairs'
export l=$SLURM_ARRAY_TASK_ID\p
line=`sed -n $l $samples`
query=`echo $line | cut -d ' ' -f2`
echo $query
ref=`echo $line | cut -d ' ' -f1`
echo $ref


cd $out
minimap2 -a -x asm20 --cs -r2k -t 16 ${ref}.softmasked.fasta ${query}.softmasked.fasta > ${ref}_${query}.sam
samtools sort -@16 -o ${ref}_${query}.bam ${ref}_${query}.sam
samtools index ${ref}_${query}.bam
mkdir -p ${ref}_${query}
cd ${ref}_${query}

#cd $out
#/groups/nordborg/projects/suecica/005scripts/001Software/minimap2-2.21_x64-linux/minimap2 -c -x asm20 --cs -t 16 ${ref}.softmasked.fasta ${query}.softmasked.fasta > ${ref}_${query}.paf
#sort -k6,6 -k8,8n ${ref}_${query}.paf > ${ref}_${query}.sorted.paf
#paftools.js call -l 5000 -L 10000 ${ref}_${query}.sorted.paf > ${ref}_${query}.var.txt

#Paftools only considers indels from within the alignments, anything that doesn't align is not counted

#minimap2 -PD -k19 -w19 -m200 -t8 ${ref}.softmasked.fasta ${ref}.softmasked.fasta > ${ref}_self.paf

#for figuring out potentially duplicated regions


#Ok lets try assembyltics using samtodelta from minimap2
cd ${ref}_${query}
cp $out/${ref}_${query}.sam .

scripts='/groups/nordborg/projects/transposons/Robin/Alyrata/003scripts'
python ${scripts}/sam2delta.py ${ref}_${query}.sam 

assemblytics=/groups/nordborg/projects/suecica/005scripts/001Software/Assemblytics/scripts/Assemblytics
${assemblytics} ${ref}_${query}.sam.delta ${ref}_${query} 250 50 1000000 #500bp anchor min 50bp size and max 1Mb size

#Clean up SV calls
ml r/3.5.1-foss-2018b
ml bedtools/2.27.1-foss-2018b
cp ${scripts}/sortAssemblytics.R .
R --vanilla --slave --no-save --no-restore --args ${ref}_${query}.Assemblytics_structural_variants.bed < sortAssemblytics.R 
bedtools intersect -a  ${ref}_${query}.Assemblytics_structural_variants.DEL.bed -b ${ref}_${query}.Assemblytics_structural_variants.DEL.bed -F 1 -wa -wb > ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.bed

R --vanilla --slave --no-save --no-restore --args ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.bed < ${scripts}/getCleanAssemblytics_deletions_1.R                                                                                                 


#Make VCF of SV calls and remove SVs that are the result of N bases
#Need to reload conda because of environment conflicts with pyfasta
source activate /groups/nordborg/projects/suecica/005scripts/001Software/RobinCondaSCRATCH3/
python ${scripts}/Reformatting_Assemblytics_result.py -b ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.bed -v ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.vcf -r $out/$ref.softmasked.fasta -q ${out}/$query.softmasked.fasta
python ${scripts}/getcleanbreaks_noN.py -v ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.vcf
python ${scripts}/getcleanbreaks_table.py -n ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.vcf_cleanNames -b ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.bed -a ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean

ml bedtools/2.27.1-foss-2018b
bedtools getfasta -fi $out/${ref}.softmasked.fasta -bed ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.noN.bed -fo ${ref}_${query}.DEL.merged.clean.fa -name
ml biopython/1.74-foss-2018b-python-3.6.6
##############For composition###############
python ${scripts}/countbases.py -f ${ref}_${query}.DEL.merged.clean.fa

ml r/3.5.1-foss-2018b
R --vanilla --slave --no-save --no-restore --args ${ref}_${query}.oriented_coords.csv < ${scripts}/sortOrientated.R 

source activate /groups/nordborg/projects/suecica/005scripts/001Software/RobinCondaSCRATCH3/
python ${scripts}/getquery_breakpoints_assemblytics.py -b ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.noN.bed
python ${scripts}/getquery_breakpoints_assemblytics.1kbupdown.py -b ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.noN.bed #need a long enough region to align so start with 1kb up and down

bedtools getfasta -fi $out/${query}.softmasked.fasta -bed ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.noN.bed_QueryPos.bed -fo ${ref}_${query}.DELQueryPos.merged.clean.fa -name

bedtools getfasta -fi $out/${query}.softmasked.fasta -bed ${ref}_${query}.Assemblytics_structural_variants.DEL.merged.clean.noN.bed_QueryPos.1kbupdown.bed -fo ${ref}_${query}.DELQueryPos.1kbupdown.clean.fa -name

