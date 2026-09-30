#!/usr/bin/env bash
# Claude Code 通知音インストーラ (macOS / Linux)
# 使い方: ./install.sh
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
claude_dir="$HOME/.claude"
sound_dir="$claude_dir/sounds"
settings="$claude_dir/settings.json"

mkdir -p "$sound_dir"
cp "$here"/sounds/*.wav "$sound_dir/"

if [ "$(uname)" = "Darwin" ]; then
  player="afplay"
elif command -v paplay >/dev/null 2>&1; then
  player="paplay"
elif command -v aplay >/dev/null 2>&1; then
  player="aplay -q"
else
  echo "音声プレイヤー (paplay / aplay) が見つかりません" >&2
  exit 1
fi

[ -f "$settings" ] && cp "$settings" "$settings.bak"

python3 - "$settings" "$sound_dir" "$player" <<'EOF'
import json, os, sys
settings, sound_dir, player = sys.argv[1:]
d = json.load(open(settings, encoding="utf-8")) if os.path.exists(settings) else {}
hooks = d.setdefault("hooks", {})
for event, wav in (("Stop", "done.wav"), ("Notification", "attention.wav")):
    # 以前このスクリプトで入れたフック (.claude/sounds を鳴らすもの) だけ取り除き、他のフックは残す
    kept = [g for g in hooks.get(event, [])
            if not any(".claude/sounds/" in h.get("command", "") for h in g.get("hooks", []))]
    kept.append({"hooks": [{"type": "command", "async": True, "timeout": 10,
                            "command": f"{player} '{sound_dir}/{wav}'"}]})
    hooks[event] = kept
with open(settings, "w", encoding="utf-8") as f:
    json.dump(d, f, ensure_ascii=False, indent=2)
EOF

echo "インストールしました: $settings"
$player "$sound_dir/done.wav"
