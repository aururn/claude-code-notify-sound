"""通知音 (sounds/done.wav, sounds/attention.wav) を生成するスクリプト。

音を調整したいときは NOTES の周波数や AMP を変えて `python generate.py` を実行する。
"""
import math
import struct
import wave
from pathlib import Path

SR = 44100
AMP = 0.22

# (ファイル名, [(周波数Hz, 開始秒), ...], 全体の長さ秒)
NOTES = [
    ("done.wav", [(392.0, 0.0), (523.3, 0.12)], 0.8),       # G4 -> C5「ポーン」
    ("attention.wav", [(440.0, 0.0), (440.0, 0.18)], 0.7),  # A4 x2「ポッポッ」
]


def render(notes, total):
    buf = [0.0] * int(total * SR)
    for freq, start in notes:
        s = int(start * SR)
        for i in range(len(buf) - s):
            t = i / SR
            env = min(1, t / 0.015) * math.exp(-t * 6)
            buf[s + i] += math.sin(2 * math.pi * freq * t) * env * AMP
    fade = int(0.05 * SR)
    for i in range(fade):
        buf[-1 - i] *= i / fade
    return buf


def save(path, buf):
    with wave.open(str(path), "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(b"".join(struct.pack("<h", int(max(-1, min(1, x)) * 32767)) for x in buf))


if __name__ == "__main__":
    out = Path(__file__).parent / "sounds"
    out.mkdir(exist_ok=True)
    for name, notes, total in NOTES:
        save(out / name, render(notes, total))
        print(f"wrote {out / name}")
