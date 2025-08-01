export HF_TOKEN=""
export OPENAI_API_KEY=""

MODEL_NAME=$1
TP=2
PORT=8080

#--- モジュール & Conda --------------------------------------------
module purge
module load cuda/12.6 miniconda/24.7.1-py312
module load cudnn/9.6.0
module load nccl/2.24.3

conda init
conda config --set auto_activate_base false
source ~/.bashrc
export CONDA_PATH="~/miniconda3/envs/llmbench/"
conda activate $CONDA_PATH


# Hugging Face 認証
export HF_HOME=${SLURM_TMPDIR:-$HOME}/.hf_cache
export TRANSFORMERS_CACHE=$HF_HOME
export HUGGINGFACE_HUB_TOKEN=$HF_TOKEN
mkdir -p "$HF_HOME"
echo "HF cache dir : $HF_HOME"                   # デバッグ用

mkdir -p predictions
mkdir -p judged
mkdir -p leaderboard

echo "start ${MODEL_NAME}"

#--- GPU 監視 -------------------------------------------------------
nvidia-smi -i 0,1,2,3,4,5,6,7 -l 3 > nvidia-smi.log &
pid_nvsmi=$!

#--- vLLM 起動（8GPU）----------------------------------------------
vllm serve ${MODEL_NAME} \
        --tensor-parallel-size ${TP} \
        --reasoning-parser deepseek_r1 \
        --rope-scaling '{"rope_type":"yarn","factor":4.0,"original_max_position_embeddings":32768}' \
        --max-model-len 131072 \
        --gpu-memory-utilization 0.95 \
        --port ${PORT} \
        > vllm.log 2>&1 &
pid_vllm=$!

#--- ヘルスチェック -------------------------------------------------
until curl -s http://127.0.0.1:${PORT}/health >/dev/null; do
        echo "$(date +%T) vLLM starting …"
        sleep 10
done
echo "vLLM READY"

#--- 推論 -----------------------------------------------------------

template="${HOME}/llm_bridge_prod/eval_hle/conf/config_TEMPLATE.yaml"
config="${HOME}/llm_bridge_prod/eval_hle/conf/config.yaml"
sed "s|PORT|${PORT}|" ${template} \
    | sed "s|MODEL_NAME|${MODEL_NAME}|" \
	  > ${config} &&\

python $HOME/llm_bridge_prod/eval_hle/predict.py > predict.log 2>&1

#--- 評価 -----------------------------------------------------------
python $HOME/llm_bridge_prod/eval_hle/judge.py &&\
    latest_dir=$(find "$HOME/leaderboard/" -maxdepth 1 -type d -printf "%f\n" \
		     | grep -E '^[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{2}_[0-9]{2}_[0-9]{2}$' \
		     | sort | tail -n 1)  &&\
    dir_name=${MODEL_NAME##*/}  &&\
    output_dir="/home/Competition2025/P09/shareP09/eval/hle/${dir_name}"  &&\
    mkdir -p $output_dir  &&\
    cp $HOME/leaderboard/${latest_dir}/* $output_dir  &&\
    chmod 777 $output_dir &&\
echo "cp to ${output_dir}"
#--- 後片付け -------------------------------------------------------
kill $pid_vllm
kill $pid_nvsmi
wait
