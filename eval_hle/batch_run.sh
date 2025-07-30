#!/bin/bash
#SBATCH --job-name=eval
#SBATCH --partition=P09
#SBATCH --nodelist=osk-gpu76
#SBATCH --nodes=1
#SBATCH --gpus-per-node=2
#SBATCH --cpus-per-task=64
#SBATCH --time=04:00:00
#SBATCH --output=/home/Competition2025/P09/%u/logs/eval/%x-%j.out
#SBATCH --error=/home/Competition2025/P09/%u/logs/eval/%x-%j.err
#SBATCH --export=OPENAI_API_KEY=""
#SBATCH --export=HF_TOKEN=""

SCTRPI_ROOT=${HOME}/llm_bridge_prod


sh ${SCTRPI_ROOT}/_run.sh "/home/Competition2025/P09/shareP09/models/DeepSeek-R1-Distill-Qwen-32B"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/cleand_meta-math_MetaMathQA"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p1"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p2"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p3"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p4"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p5"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_DeepScaleR-Preview-Dataset"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/cleand_meta-math_MetaMathQA"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_Omni-Math"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_gair_limo"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_OpenMathReasoning"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_OpenMathInstruct-2"


