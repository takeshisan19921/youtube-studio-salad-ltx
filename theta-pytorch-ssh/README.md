# Theta PyTorch SSH Image

Minimal custom image for Theta EdgeCloud GPU Node tests.

Why this exists:

- `thetalabsorg/pytorch_cuda_with_ssh:v0.0.2` booted on a community RTX 3090 and exposed `nvidia-smi`, but did not include `torch`.
- `thetalabsofficial/pytorch_cuda_with_ssh:blackwell-1.0` stayed `Pending` during the short smoke window on the same 3090 class.
- The factory needs a small PyTorch-ready SSH image before Theta can be used as a reliable fallback GPU lane.

What it includes:

- Official PyTorch CUDA runtime: `pytorch/pytorch:2.12.0-cuda12.6-cudnn9-runtime`
- `openssh-server`
- `ffmpeg`, `git`, `curl`, `rsync`, `tini`
- Runtime `SSH_PUBLIC_KEY` install into `/root/.ssh/authorized_keys`

What it does not include:

- No models
- No Comfy cache
- No generated media
- No IDrive credentials

Build and push from a machine with registry access:

```bash
export THETA_PYTORCH_SSH_IMAGE=ghcr.io/YOUR_ORG/youtube-studio-theta-pytorch-ssh:torch212-cu126
automation/theta_pytorch_ssh_image/build_and_push.sh
```

Theta GPU Node payload should keep:

- `deployment_image_id`: `img_n67q5y3xu9pcyqqcajz5cd72263n`
- `container_image`: the pushed image URI
- `additional_ports`: `[22]`
- `container_port`: `0`
- `env_vars.SSH_PUBLIC_KEY`: local public key
- `price_hr`: capped, for example `1300`
- `vm_id`: live `community_*` RTX 3090 node id
- `shard`: live node shard

First runtime proof command:

```bash
python - <<'PY'
import torch
print(torch.__version__)
print(torch.cuda.is_available())
print(torch.cuda.get_device_name(0))
x = torch.ones((16, 16), device="cuda")
print(float(x.sum().item()))
PY
```

Do not call this factory-ready until a Theta smoke verifies SSH, `nvidia-smi`,
`torch.cuda`, IDrive upload, and stop behavior in the same run.

