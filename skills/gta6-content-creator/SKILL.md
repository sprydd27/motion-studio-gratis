---
name: gta6-content-creator
description: Use when an agent should run a GTA 6 (or any hot game) content channel on YouTube, TikTok and Instagram — find outlier videos, grab top stream clips, edit daily compilations and vertical shorts, make thumbnails, pass a fresh-agent quality gate, publish, and earn from clipping campaigns and YouTube ads.
---

# GTA 6 content creator (agent playbook)

Goal: run a game-content channel end to end with as little human time as possible, while staying monetizable and copyright-safe. Money comes from two places only: (1) clipping campaigns that pay per view, (2) YouTube ads once the channel qualifies. Source playbooks: @everestchris6's 9-prompt "make money from gta 6 with ai agents" and @Oluseyix's "Muse for GTA VI clipping" (stream link → clip tool → auto-upload).

## Hard rules (read before every run)
1. Read `STATUS.md` and `RULES.md` first on every run; write back to them at the end.
2. Never ask the owner to paste an API key, password, cookie or token in chat. Tell them where to click to connect it (OAuth / connector) or which env var / file to fill themselves.
3. Post ONLY what the owner approved until they say otherwise ("post only what I approve").
4. Every third-party clip keeps its source link + streamer handle; credit on screen and in the description.
5. Only reuse other people's footage when (a) it is inside a clipping campaign that grants rights, or (b) the creator allows clipping, or (c) it is the owner's own gameplay. Skip story spoilers/cutscenes, endings, leaks, exploits/glitch-money methods, and anything Rockstar asks to take down. Follow Rockstar's video policy and each platform's reused-content rules.
6. No official GTA/Rockstar logos as your own branding; use original wordmarks/fonts in thumbnails.
7. The Gauntlet rule (below) must say YES before anything is published.
8. Paid tools: show the owner the monthly cost before subscribing; prefer the free path listed in the toolbox.

## Toolbox (complete)

### Local CLI (install once)
| Tool | Install | Used for |
|---|---|---|
| ffmpeg / ffprobe | `apt install ffmpeg` (mac: `brew install ffmpeg`) | cut, crop, stack, burn captions, loudness, export |
| yt-dlp | `pip install -U yt-dlp` | download VODs/clips (YouTube, Twitch, Kick, TikTok) by URL; `--download-sections "*00:12:30-00:13:10"` grabs only a segment |
| PySceneDetect | `pip install "scenedetect[opencv]"` | find cuts/highlight boundaries: `scenedetect -i in.mp4 detect-adaptive list-scenes split-video` |
| faster-whisper | `pip install faster-whisper` | transcripts + word timestamps (`word_timestamps=True`) for word-by-word captions and hype-moment search ("no way", "wait", "bro") |
| auto-editor (optional) | `pip install auto-editor` | auto-remove dead air/silence from long VOD chunks |
| Python libs | `pip install pandas requests pillow opencv-python` | outlier math, CSVs, thumbnail compositing, face/motion detection |
| Node (optional) | `npm i -g @composio/cli` or use Composio SDK | connector hub if not using built-in connectors |

### Data / discovery
| Tool | Free path | Paid path |
|---|---|---|
| YouTube channel + video stats | YouTube Data API v3 (`search.list`, `channels.list`, `playlistItems.list`, `videos.list`) — free quota 10,000 units/day | Apify actors `streamers/youtube-scraper`, `streamers/youtube-channel-scraper` |
| Twitch top clips | Twitch Helix API: `GET /helix/games?name=Grand Theft Auto VI` → `GET /helix/clips?game_id=<id>&started_at=<24h ago>` (needs a free Twitch dev app Client-ID + app token) | Apify Twitch clips scrapers |
| Kick top clips | public kick.com category clip pages via yt-dlp/HTTP | Apify Kick scrapers |
| TikTok trending | manual hashtag pages via yt-dlp | Apify `clockworks/tiktok-scraper` |
| Stream → highlight auto-clipper | own pipeline (whisper + scenedetect + chat-spike) | clipscutter.com (from the Muse post), Opus Clip, Vizard, StreamLadder |

### Creative
| Need | Tool |
|---|---|
| Thumbnails | best image model available (gpt-image / Nano Banana Pro / the agent's GenerateImage) + Pillow/ffmpeg for big 2–3 word text overlays; 1280×720 for YouTube |
| Titles, descriptions, tags | the agent itself, trained on `THUMBNAILS.md` patterns |
| Fonts | free bold display fonts (Anton, Bebas Neue, Montserrat Black) |
| Music/SFX | YouTube Audio Library or platform-native sounds only (no copyrighted music) |

### Publishing
| Platform | Free/official | Wrapper |
|---|---|---|
| YouTube (long + Shorts) | YouTube Data API `videos.insert` (OAuth; ~1,600 quota units/upload ≈ 6 uploads/day on default quota) or a YouTube connector | Composio YouTube |
| TikTok | TikTok Content Posting API (needs app review) or manual upload from draft | upload-post.com, Composio |
| Instagram Reels | Instagram Graph API (Business/Creator account linked to a FB Page; video must be at a public URL) | Composio Instagram, upload-post.com |
| Scheduling | platform-native schedulers or a routine/cron | Composio, upload-post |
| Clipping campaigns (money) | Whop Content Rewards and similar campaign boards; streamers' own Discord clip programs | — |

## Workspace files
`RULES.md` (rules + every Gauntlet verdict), `STATUS.md` (accounts, schedule, every posted link, earnings), `channels.csv`, `outliers.csv`, `THUMBNAILS.md`, `clips/YYYY-MM-DD.csv`, `script.md`, `out/` (renders).

## The 9 steps

### 1. Setup (one run)
- Install the toolbox CLIs; verify with `ffmpeg -version`, `yt-dlp --version`, `scenedetect version`, `python -c "import faster_whisper"`.
- Connect YouTube, Instagram, TikTok (and Apify/Twitch if used) through connectors/OAuth; tell the owner what to click. Never take keys in chat.
- Create `RULES.md` (copy the Hard rules + Gauntlet rule) and `STATUS.md`.
- Ask the owner: channel name/niche angle, language, posting schedule, which accounts, and whether to join clipping campaigns.

### 2. Find videos that blow up (weekly)
- Find 20–50 active English (or target-language) GTA channels → show list → wait for owner OK → save `channels.csv`.
- Pull each channel's last ~30 videos (views, publish date, duration, title, thumbnail URL).
- Outlier = views ≥ 3× the channel's median views (and published < 30 days). Save to `outliers.csv` with ratio.
- Each week report what changed (new formats, lengths, topics).

### 3. Learn from the winners
- Study outlier titles + thumbnails → write repeating patterns to `THUMBNAILS.md` (word count, colors, face/arrow/circle, curiosity gap, length of video).
- For each new video make 3 titles + 3 thumbnails (short text, 2–4 big words). Gauntlet picks the best; if none passes, make more.

### 4. Grab the best clips (daily)
- Pull the last 24h most-viewed GTA 6 clips from Twitch, Kick, TikTok (and YouTube stream links the owner pastes).
- Rank by views per hour since posted; keep top 15–30.
- Each row: url, streamer, platform, views, views/hr, duration, rights basis (campaign/allowed/own). Drop rows with no rights basis, cutscenes, endings, exploits.
- For long streams: download segment-wise with yt-dlp, run faster-whisper + scenedetect, mark hype moments (reaction words, laughter, loud audio peaks, chat spikes if available), cut 20–60s candidates.

### 5. Edit the daily episode (YouTube long)
- No intro: open on the single best clip.
- Length = median length of the compilations that won in `outliers.csv`.
- Each clip: one-line label + streamer handle on screen. Normalize loudness (`loudnorm`), hard cuts, no dead air.
- Description: every streamer credited with link; chapters with timestamps.
- Example concat: build a list file, then `ffmpeg -f concat -safe 0 -i list.txt -c:v libx264 -crf 20 -c:a aac -af loudnorm out/episode.mp4`.

### 6. Cut vertical clips (Shorts/TikTok/Reels)
- 1080×1920. Facecam on top (~1/3), gameplay below (~2/3); if no facecam, center-crop gameplay with slight zoom.
- First frame = the payoff. 15–45s.
- Word-by-word captions from faster-whisper (ASS subtitles, big bold, 1–3 words at a time, highlighted key word), kept clear of the app's UI zones (top ~10%, bottom ~20%, right ~15%).
- Example stack: `ffmpeg -i clip.mp4 -filter_complex "[0:v]crop=<cam>,scale=1080:640[top];[0:v]crop=<game>,scale=1080:1280[bot];[top][bot]vstack,subtitles=caps.ass" -c:a aac out/v1.mp4`.
- Tag the streamer; upload natively to each platform (not cross-posted watermarked files).

### 7. Make your own video
- Script from the owner's own gameplay only (guide, ranking, challenge, "every secret", map tour). Copy the length of winning outliers. Payoff first.
- Output `script.md`: hook, beats, what to record (shot list), 3 titles, description, tags.

### 8. The Gauntlet (before anything posts)
- Spawn a FRESH agent/session that has NOT seen your notes. Give it: frames from the cut (first frame, 3 mid frames, last frame), the thumbnail, the title, and 3 outliers for comparison.
- It answers YES or NO + the faults it found (hook, readability, caption overlap, credit missing, rights unclear, boring first 2s, text too long).
- Fix and re-check until YES. Write every verdict into `RULES.md` so the same fault never repeats.

### 9. Publish and get paid
- Send the owner the approval pack (video/thumbnail/title/description). Publish only approved items on the schedule.
- Submit every eligible vertical to its matching clipping campaign (follow that campaign's exact rules: tags, sound, min length, account age).
- Write every posted link, campaign submission, views and payouts into `STATUS.md`.
- YouTube ads only start after the channel qualifies for the Partner Program (1,000 subs + 4,000 public watch hours in 12 months, or 1,000 subs + 10M Shorts views in 90 days); pure compilations without added value risk "reused content" rejection, so mix in step-7 original videos and real commentary/labels.

## Daily routine (once set up)
1. Read RULES/STATUS → 2. step 4 clips → 3. step 6 verticals (3–5/day) → 4. step 5 episode (if daily episode enabled) → 5. Gauntlet → 6. approval pack to owner → 7. publish approved + submit to campaigns → 8. update STATUS. Weekly: step 2–3 refresh + report.

## Report format to the owner
Short: what was made (count + links/previews), Gauntlet verdicts, what's waiting for approval, what posted, views/earnings change, any account or rights risk.
