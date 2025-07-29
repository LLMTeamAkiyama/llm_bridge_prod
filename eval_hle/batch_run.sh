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

sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p1"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p2"
# sh ${SCTRPI_ROOT}/_run.sh "LLMTeamAkiyama/sft_p3"
