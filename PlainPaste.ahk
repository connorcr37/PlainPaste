#Requires AutoHotkey v2.0
#SingleInstance Force

;-------------------------------------------------------------------------------
; Smart‑Punctuation → ASCII Converter
;-------------------------------------------------------------------------------
; Hotkey      : Ctrl+Shift+V
; Purpose     : When pressed, converts “curly quotes”, – dashes, … ellipses,
;               non‑breaking spaces, bullets, etc. on the clipboard to plain
;               ASCII and pastes the result.
; How it works:
;    1. Waits briefly for fresh clipboard text (if the user has just copied).
;    2. Backs up the entire clipboard (all formats).
;    3. Cleans the text via CleanText().
;    4. Performs a regular paste (Ctrl+V).
;    5. Optionally restores the rich clipboard after a short delay.
;-------------------------------------------------------------------------------

; USER CONFIGURATION
RestoreOriginalClipboard := true      ; Set to false if you never want it restored.
ClipboardRestoreDelayMs  := 250       ; Delay (ms) before restoring rich clipboard.

; HOTKEY DEFINITION
^+v:: PastePlainAscii()   ; Ctrl+Shift+V

; MAIN ROUTINE
PastePlainAscii() {
    global RestoreOriginalClipboard, ClipboardRestoreDelayMs

    ; 1. Ensure there is text on the clipboard (wait up to 400 ms if user just copied)
    if !ClipWait(0.4) {
        MsgBox "No text detected on the clipboard.", "Smart‑Punctuation Converter", "Icon!"
        return
    }

    ; 2. Backup current clipboard (all formats: text, images, files, etc.)
    savedClip := ClipboardAll()

    ; 3. Convert smart punctuation → plain ASCII
    cleaned := CleanText(A_Clipboard)
    A_Clipboard := cleaned

    ; 4. Perform the physical paste
    Send "^v"

    ; 5. Restore rich clipboard (optional)
    if RestoreOriginalClipboard {
        Sleep ClipboardRestoreDelayMs
        A_Clipboard := savedClip
    }
}

; TEXT‑CLEANING FUNCTION
CleanText(str) {
    ; Replacement pairs: smart‑punctuation → ASCII
    static repl := Map(
        "—", "-",   ; em dash → hyphen surrounded by spaces
        "–", "-",       ; en dash → hyphen
        "…", "...",     ; ellipsis
        "•", "-",       ; bullet → hyphen
        "‘", "'",       ; opening single quote
        "’", "'",       ; closing single quote / apostrophe
        "“", '"',       ; opening double quote
        "”", '"'        ; closing double quote
    )

    for char, replacement in repl
        str := StrReplace(str, char, replacement)

    ; Non‑breaking space → normal space
    str := StrReplace(str, Chr(0x00A0), " ")

    ; Remove zero‑width characters often copied from the web
    str := RegExReplace(str, "\x{200B}|\x{200C}|\x{200D}", "")

    return str
}