#!/bin/bash
# Claude Code statusline — モデル / ディレクトリ / git / コンテキスト使用量 / レート制限
# stdin の JSON 仕様: https://code.claude.com/docs/en/statusline
input=$(cat)
j() { echo "$input" | jq -r "$1"; }

MODEL=$(j '.model.display_name // "?"')
CWD=$(j '.workspace.current_dir // "?"')
DIR=${CWD/#$HOME/\~}
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)

USED=$(j '.context_window.total_input_tokens // 0')
SIZE=$(j '.context_window.context_window_size // 200000')
PCT=$(j '.context_window.used_percentage // 0' | cut -d. -f1)
[ -z "$PCT" ] && PCT=0
REM=$((100 - PCT))

# 色分け: 〜59% 緑 / 60〜79% 黄 / 80%〜 赤（auto-compact が近い）
if [ "$PCT" -ge 80 ]; then C=$'\e[31m'; elif [ "$PCT" -ge 60 ]; then C=$'\e[33m'; else C=$'\e[32m'; fi
R=$'\e[0m'; DIM=$'\e[2m'; CYAN=$'\e[36m'

# コンテキストバー（20マス）
FILL=$((PCT / 5)); BAR=""
for ((i = 0; i < 20; i++)); do
    if [ "$i" -lt "$FILL" ]; then BAR+="█"; else BAR+="░"; fi
done

# サブスクのレート制限（Pro/Max のみ。最初の応答後に出現）
# 使用率と、いつ回復するか（resets_at）を表示。80% 以上で赤色警告
fmt_epoch() { date -r "$1" "+$2" 2>/dev/null || date -d "@$1" "+$2" 2>/dev/null; } # macOS/Linux 両対応
L5=$(j '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)
R5=$(j '.rate_limits.five_hour.resets_at // empty')
L7=$(j '.rate_limits.seven_day.used_percentage // empty' | cut -d. -f1)
R7=$(j '.rate_limits.seven_day.resets_at // empty')
LIM=""
if [ -n "$L5" ] || [ -n "$L7" ]; then
    T5=""; [ -n "$R5" ] && T5="(→$(fmt_epoch "$R5" '%H:%M'))"
    T7=""; [ -n "$R7" ] && T7="(→$(fmt_epoch "$R7" '%m/%d'))"
    CL=$DIM
    { [ "${L5:-0}" -ge 80 ] || [ "${L7:-0}" -ge 80 ]; } && CL=$'\e[31m'
    LIM=" ${CL}| Max枠 5h:${L5:-?}%${T5} 7d:${L7:-?}%${T7}${R}"
fi

printf '%s%s%s %s%s\n' "$CYAN" "$MODEL" "$R" "$DIR" "${BRANCH:+ ${DIM}(${BRANCH})${R}}"
printf '%s%s%s ctx %sk/%sk 使用%s%% 残り%s%%%s\n' "$C" "$BAR" "$R" $((USED / 1000)) $((SIZE / 1000)) "$PCT" "$REM" "$LIM"
