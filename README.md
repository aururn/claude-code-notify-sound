# claude-code-notify-sound

Claude Code の Hooks を使って通知音を鳴らす設定。

| タイミング | フック | 音 |
|---|---|---|
| 応答が終わったとき | `Stop` | `sounds/done.wav`（低めの「ポーン」） |
| 許可待ち・入力待ちのとき | `Notification` | `sounds/attention.wav`（「ポッポッ」） |

## インストール

```bash
git clone https://github.com/aururn/claude-code-notify-sound.git
cd claude-code-notify-sound
```

**Windows**

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

**macOS / Linux**

```bash
./install.sh
```

インストーラがやること:

- `sounds/*.wav` を `~/.claude/sounds/` にコピーする
- `~/.claude/settings.json` に `Stop` / `Notification` フックを追加する（元のファイルは `settings.json.bak` に残す。他のフックはそのまま）
- 何度実行しても同じフックが重複しない

実行中の Claude Code には、`/hooks` を一度開くか再起動すると反映されます。

## 音を変える

`generate.py` の `NOTES`（周波数）と `AMP`（音量）を編集してから実行し、インストーラをもう一度実行する。

```bash
python generate.py
```

## アンインストール

`/hooks` から該当フックを削除するか、`settings.json.bak` を戻す。
