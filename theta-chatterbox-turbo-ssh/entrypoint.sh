#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p /var/run/sshd /root/.ssh /workspace
chmod 0700 /root/.ssh

if [[ -n "${SSH_PUBLIC_KEY:-}" ]]; then
  printf '%s
' "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys
  chmod 0600 /root/.ssh/authorized_keys
else
  echo "warning: SSH_PUBLIC_KEY is empty; SSH login will not be authorized" >&2
fi

ssh-keygen -A >/dev/null

python - <<'EOF_PY'
import os
import torch
print(f"THETA_CHATTERBOX_IMAGE=1", flush=True)
print(f"THETA_IMAGE_TORCH_VERSION={torch.__version__}", flush=True)
print(f"THETA_IMAGE_CUDA_AVAILABLE={torch.cuda.is_available()}", flush=True)
print(f"THETA_IMAGE_CUDA_DEVICE={torch.cuda.get_device_name(0) if torch.cuda.is_available() else ''}", flush=True)
print(f"HF_HOME={os.environ.get('HF_HOME', '')}", flush=True)
EOF_PY

exec /usr/sbin/sshd -D -e
