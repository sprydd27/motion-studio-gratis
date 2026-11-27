---
name: youtube-highlight-clipper
description: Use when someone gives a YouTube, podcast, X Space or stream link and wants it cut into short highlight clips with burned-in captions, a title, a watermark and an optional AI voice-over.
---

# YouTube highlight clipper

Turn a long video (YouTube, podcast, livestream replay, X Space/broadcast) into short, punchy highlight clips ready to post.

## 0. Collect the brief (ask only what's missing)

- Source link(s) and optional timestamps or a list of "best moments" (e.g. the creator's own review points).
- Platform/format: horizontal 1920x1080 (X, YouTube) or vertical 1080x1920 (Reels, Shorts, TikTok).
- Watermark/handle text, and an optional avatar/logo image for a corner.
- Language for captions and voice-over.
- Voice-over: none, or a TTS provider + voice ID.
- Captions: on or off.
- Clip count and target length (default 30–90 s each).

## 1. Download and inspect

```
yt-dlp -f "bv*[height<=1080]+ba/b" --merge-output-format mp4 -o source.mp4 "<URL>"
ffprobe -v error -show_entries format=duration -of csv=p=0 source.mp4
```

If the link is unavailable or members-only, stop and ask for a file upload.

## 2. Transcribe

Use a local Whisper model (no API credits needed):

```
pip install -U openai-whisper   # or faster-whisper
whisper source.mp4 --model small --language <lang> --output_format json --word_timestamps True
```

Keep word-level timestamps; they drive both moment-finding and captions.

## 3. Pick the moments

- If the user gave points or timestamps, map each one to the transcript and find the exact start and end.
- Otherwise score segments for hooks: strong opinions, surprises, laughs, reveals, numbers, conflict.
- Start each clip on a hook (no warm-up). End on a punchline or a complete thought.
- Verify visually: export a contact sheet (`ffmpeg -vf "fps=1/2,scale=320:-1,tile=6x5"`) and check that the frames match what the transcript claims. Cut out overlays such as unrelated app windows, private info or explicit content (blur when in doubt).
- Never claim something happens in the footage that you didn't verify. Tell the user when the moment they asked for isn't there or sits at a different timestamp.

## 4. Render each clip (ffmpeg)

Layout, horizontal:

- Video scaled to fill 1920x1080 (blurred background padding if the aspect ratio differs).
- Title at the top, 2–6 words, bold (Anton/Montserrat Black), white with a dark outline.
- Captions at the bottom, 2–5 words per line, highlighted words in an accent color, generated as an ASS file from the word timestamps.
- Watermark handle top right at about 60% opacity.
- Optional avatar bottom left in a thin white frame.
- For vertical, put the video in the middle third with the title above and captions below.
- Export: H.264 High, yuv420p, 30 fps, AAC 48 kHz 192 kbps, `-movflags +faststart`. Keep the loudness around −14 to −16 LUFS (loudnorm).

## 5. Optional voice-over (TTS)

- Write a short script per clip: hook line, 1–3 commentary lines, punchline. Match the creator's tone and language, and keep each line under about 15 words.
- Generate one TTS file per line (easier retries; respects rate limits). Put emotion tags such as [excited] or [shocked] inline if the model supports them. Don't send a separate "style" prompt that might get read aloud.
- Place lines in the gaps or over less important game/talk audio. Duck the original audio to about 20–25% under the voice (sidechaincompress or volume keyframes).
- Watch the provider's free-tier limits (requests per minute and per day); queue and resume instead of failing.
- Use only the provider and voice the user picked. Never switch providers silently.

## 6. QA before delivering

- Watch or skim every clip: check audio sync, captions vs. speech, text inside safe margins, no leftover overlays, watermark present.
- Check ffprobe shows the right resolution, fps and duration.
- Name files `clip_<n>_<slug>.mp4`. Deliver each with a one-line description and a suggested post caption.

## 7. Report

List each clip: its title, its length, the source timestamps used, and anything you couldn't find or had to change.
