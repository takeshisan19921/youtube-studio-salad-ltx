#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p /var/run/sshd /root/.ssh
chmod 0700 /root/.ssh

if [[ -n "${SSH_PUBLIC_KEY:-}" ]]; then
  printf '%s\n' "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys
  chmod 0600 /root/.ssh/authorized_keys
else
  echo "warning: SSH_PUBLIC_KEY is empty; SSH login will not be authorized" >&2
fi

ssh-keygen -A >/dev/null

python - <<'PY'
import torch
print(f"THETA_IMAGE_TORCH_VERSION={torch.__version__}", flush=True)
print(f"THETA_IMAGE_CUDA_AVAILABLE={torch.cuda.is_available()}", flush=True)
PY

exec /usr/sbin/sshd -D -e

