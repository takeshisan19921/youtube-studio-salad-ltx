FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive     PYTHONUNBUFFERED=1     THETA_CHATTERBOX_TURBO_SSH_IMAGE=1     HF_HOME=/opt/chatterbox-cache/huggingface     HF_HUB_CACHE=/opt/chatterbox-cache/huggingface/hub     TRANSFORMERS_CACHE=/opt/chatterbox-cache/huggingface/transformers     XDG_CACHE_HOME=/opt/chatterbox-cache/xdg

RUN apt-get update &&     apt-get install -y --no-install-recommends       ca-certificates curl ffmpeg git libsndfile1 openssh-server rsync tini &&     rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip setuptools wheel &&     python -m pip install --no-cache-dir chatterbox-tts==0.1.7 &&     python - <<'EOF_PY'
import torch
from chatterbox.tts_turbo import ChatterboxTurboTTS
print('torch', torch.__version__)
print('cuda available at build', torch.cuda.is_available())
print('chatterbox turbo class', ChatterboxTurboTTS.__name__)
EOF_PY

RUN python - <<'EOF_PY'
from huggingface_hub import snapshot_download
path = snapshot_download(
    repo_id='ResembleAI/chatterbox-turbo',
    allow_patterns=['*.safetensors', '*.json', '*.txt', '*.pt', '*.model'],
)
print('cached chatterbox turbo snapshot', path)
EOF_PY

COPY entrypoint.sh /usr/local/bin/theta-chatterbox-turbo-ssh-entrypoint
RUN chmod 0755 /usr/local/bin/theta-chatterbox-turbo-ssh-entrypoint

WORKDIR /workspace
EXPOSE 22

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/theta-chatterbox-turbo-ssh-entrypoint"]
