import json, sys
from faster_whisper import WhisperModel

model = WhisperModel("small", device="cpu", compute_type="int8")
segments, info = model.transcribe("source.mp4", language="en", word_timestamps=True)
out = {"language": info.language, "duration": info.duration, "segments": []}
for s in segments:
    out["segments"].append({
        "start": round(s.start, 2),
        "end": round(s.end, 2),
        "text": s.text.strip(),
        "words": [{"start": round(w.start, 2), "end": round(w.end, 2), "word": w.word} for w in s.words],
    })
with open("transcript.json", "w") as f:
    json.dump(out, f, indent=1, ensure_ascii=False)
print(f"segments={len(out['segments'])} duration={info.duration:.1f}s lang={info.language}")
