# PlainPaste

Smart‑punctuation → ASCII paste hotkey for Windows (AutoHotkey v2).

---

## Quick Start

1. Run `PlainPaste.ahk` (or the compiled EXE).
2. Copy some text.
3. Press **Ctrl + Shift + V** → text is cleaned and pasted as plain ASCII.

## Requirements

- Windows 10/11
- [AutoHotkey v2](https://www.autohotkey.com/) installed (unless you use the EXE)

## Configuration

```ahk
RestoreOriginalClipboard := true  ; keep rich clipboard
ClipboardRestoreDelayMs  := 250   ; delay (ms) before restore
```

Adjust these at the top of the script. Change the hotkey by editing `^+v::`.

## What Gets Fixed

- “ ” ‘ ’  →  " '
- — –       →  -
- …         →  ...
- •         →  -
- Non‑breaking & zero‑width spaces  →  regular space (or removed)

## How It Works (TL;DR)

1. Backs up the clipboard → cleans text → pastes → restores clipboard.

## License

MIT

