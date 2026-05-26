FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

LABEL org.opencontainers.image.source="https://github.com/takeshisan19921/youtube-studio-salad-ltx"
LABEL org.opencontainers.image.description="Salad runtime image for YouTube Studio LTX probes: CUDA, PyTorch, ComfyUI, and ComfyUI-LTXVideo nodes. No model weights."

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    COMFY_DIR=/opt/salad-ltx/ComfyUI

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    git \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    build-essential \
  && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip wheel setuptools \
  && python3 -m pip install --index-url https://download.pytorch.org/whl/cu124 \
    torch torchvision torchaudio

RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR" \
  && python3 -m pip install -r "$COMFY_DIR/requirements.txt" \
  && mkdir -p "$COMFY_DIR/custom_nodes" \
  && git clone --depth 1 https://github.com/Lightricks/ComfyUI-LTXVideo.git "$COMFY_DIR/custom_nodes/ComfyUI-LTXVideo" \
  && python3 -m pip install -r "$COMFY_DIR/custom_nodes/ComfyUI-LTXVideo/requirements.txt"

WORKDIR /opt/salad-ltx

RUN python3 - <<'PY'
import importlib.util
import pathlib

comfy = pathlib.Path("/opt/salad-ltx/ComfyUI/main.py")
ltx = pathlib.Path("/opt/salad-ltx/ComfyUI/custom_nodes/ComfyUI-LTXVideo")
assert comfy.exists(), comfy
assert ltx.exists(), ltx
assert importlib.util.find_spec("torch") is not None
PY

EXPOSE 8188

CMD ["bash", "-lc", "cd /opt/salad-ltx/ComfyUI && python3 main.py --listen 0.0.0.0 --port 8188"]
