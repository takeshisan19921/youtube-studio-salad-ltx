# Theta Chatterbox Turbo SSH Image

Theta EdgeCloud worker image for YouTube Studio technical Chatterbox Turbo smoke tests and future audio workers.

Includes:

- PyTorch 2.6 CUDA 12.4 runtime
- `chatterbox-tts==0.1.7`
- Chatterbox Turbo model snapshot cached from `ResembleAI/chatterbox-turbo`
- SSH server for Theta GPU Node access
- `ffmpeg`, `git`, `curl`, `rsync`, `libsndfile1`, `tini`

Does not include secrets, voice references, scripts, IDrive credentials, generated media, or final packages.

Runtime output must stay on Theta worker scratch during generation and sync to IDrive E2 as the durable store.
This image is not a READY/PASS decision by itself. It only removes the image build, pip install, and model-download cold starts for the Chatterbox Turbo lane.
