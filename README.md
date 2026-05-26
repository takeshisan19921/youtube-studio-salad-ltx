# YouTube Studio Salad LTX Runtime

Public runtime image for Salad LTX probes.

This image intentionally includes only the software layer:

- CUDA 12.4 runtime
- Python and PyTorch CUDA wheels
- FFmpeg
- ComfyUI
- ComfyUI-LTXVideo custom nodes

It does not include LTX model weights. Model files, job manifests, logs, and
outputs stay in IDrive E2.

Image:

```text
ghcr.io/takeshisan19921/youtube-studio-salad-ltx:cu124-v1
```
