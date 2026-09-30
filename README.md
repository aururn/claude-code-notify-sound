<div align="center">

# claude-code-notify-sound

Claude Code の Hooks を使って，作業の区切りで通知音を鳴らす設定

[![Claude Code](https://img.shields.io/badge/Claude_Code-Hooks-D97757?style=for-the-badge&logo=claude&logoColor=white)](https://docs.claude.com/en/docs/claude-code/hooks)
![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0wIDBoMTEuNHYxMS40SDB6TTEyLjYgMEgyNHYxMS40SDEyLjZ6TTAgMTIuNmgxMS40VjI0SDB6TTEyLjYgMTIuNkgyNFYyNEgxMi42eiIvPjwvc3ZnPg==)
![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white)

</div>

---

## 概要

別のウィンドウで作業していても，Claude の応答が終わったときや許可を求めているときに音で気づけます．

| タイミング | フック | 音 |
|---|---|---|
| 応答が終わったとき | `Stop` | `sounds/done.wav`（低めの「ポーン」，G4 → C5） |
| 許可待ち・入力待ちのとき | `Notification` | `sounds/attention.wav`（「ポッポッ」，A4 × 2） |

## インストール

```bash
git clone https://github.com/aururn/claude-code-notify-sound.git
cd claude-code-notify-sound
```

<details open>
<summary><b>Windows</b></summary>

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

</details>

<details open>
<summary><b>macOS / Linux</b></summary>

```bash
./install.sh
```

> [!NOTE]
> Linux では `paplay` または `aplay` を使います．どちらも無い場合はインストールを中断します．

</details>

### インストーラの処理内容

- `sounds/*.wav` を `~/.claude/sounds/` にコピーする
- `~/.claude/settings.json` に `Stop` / `Notification` フックを追加する
  - 元のファイルは `settings.json.bak` に残す
  - 他のフックや設定は変更しない
- 何度実行しても同じフックが重複しない
- 最後に動作確認として `done.wav` を1回再生する

> [!TIP]
> 実行中の Claude Code には，`/hooks` を一度開くか再起動すると反映されます．

## 音の変更

`generate.py` の `NOTES`（周波数）と `AMP`（音量）を編集してから実行し，インストーラをもう一度実行します．

```python
NOTES = [
    ("done.wav", [(392.0, 0.0), (523.3, 0.12)], 0.8),       # G4 -> C5「ポーン」
    ("attention.wav", [(440.0, 0.0), (440.0, 0.18)], 0.7),  # A4 x2「ポッポッ」
]
```

```bash
python generate.py
```

## アンインストール

次のどちらかで元に戻せます．

- Claude Code の `/hooks` から該当フックを削除する
- `~/.claude/settings.json.bak` を `settings.json` に戻す

## ファイル構成

```
.
├── install.sh       # macOS / Linux 用インストーラ
├── install.ps1      # Windows 用インストーラ
├── generate.py      # 通知音の生成スクリプト
└── sounds/
    ├── done.wav       # 応答完了の音
    └── attention.wav  # 許可待ちの音
```
