FROM pytorch/pytorch:2.12.0-cuda12.6-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    THETA_PYTORCH_SSH_IMAGE=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl ffmpeg git openssh-server rsync tini && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/theta-pytorch-ssh-entrypoint
RUN chmod 0755 /usr/local/bin/theta-pytorch-ssh-entrypoint && \
    python - <<'PY'
import torch
print("torch", torch.__version__)
PY

WORKDIR /workspace
EXPOSE 22

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/theta-pytorch-ssh-entrypoint"]

