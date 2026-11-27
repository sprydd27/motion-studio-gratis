"""RIFE smoke test 3s: 30->60fps on ASMR pilot scene 3 (kb3.mp4, t=0-3s), 288x512 CPU.
Loads model once, interpolates each consecutive pair, saves mids as m%03d.png
(interleaved later with ffmpeg). Prints progress + timing per frame.
"""
import sys, time, torch, numpy as np
from PIL import Image
sys.path.insert(0, '/home/hatch/workspace/motion-studio/rife')
from train_log.RIFE_HDv3 import Model

BASE = '/home/hatch/workspace/motion-studio/tmp/rife-smoke-3s'
FR = f'{BASE}/frames'
OUT = f'{BASE}/mids'
import os
os.makedirs(OUT, exist_ok=True)

def load(path):
    img = Image.open(path).convert('RGB')
    arr = np.asarray(img, dtype=np.float32) / 255.0
    return torch.from_numpy(arr).permute(2, 0, 1).unsqueeze(0)

t0 = time.time()
model = Model()
model.load_model('/home/hatch/workspace/motion-studio/rife/train_log', -1)
model.eval()
model.device()
print('model loaded in %.1fs' % (time.time() - t0), flush=True)

files = sorted(os.listdir(FR))
print('frames:', len(files), flush=True)
prev = load(f'{FR}/{files[0]}')
times = []
for i in range(len(files) - 1):
    cur = load(f'{FR}/{files[i+1]}')
    s = time.time()
    with torch.no_grad():
        mid = model.inference(prev, cur)
    times.append(time.time() - s)
    out = (mid[0].permute(1, 2, 0).numpy() * 255).clip(0, 255).astype(np.uint8)
    Image.fromarray(out).save(f'{OUT}/m{i+1:03d}.png')
    prev = cur
    if (i + 1) % 15 == 0:
        print(f'{i+1}/{len(files)-1} mids, avg {sum(times)/len(times):.2f}s/frame', flush=True)
print('DONE mids:', len(times), 'avg %.2fs total %.1fs' % (sum(times)/len(times), sum(times)), flush=True)
