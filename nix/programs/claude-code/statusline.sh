#!/bin/bash
input=$(cat)

dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
MAGENTA='\033[35m'
RESET='\033[0m'

branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)

display_dir="${dir/#$HOME/~}"
parts="$display_dir"
if [ -n "$branch" ]; then
	staged=$(git -C "$dir" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
	modified=$(git -C "$dir" diff --numstat 2>/dev/null | wc -l | tr -d ' ')

	if [ "$staged" -gt 0 ]; then
		parts="$parts|${GREEN}${branch}${RESET}"
	elif [ "$modified" -gt 0 ]; then
		parts="$parts|${YELLOW}${branch}${RESET}"
	else
		parts="$parts|${branch}"
	fi
fi
if [ -n "$model" ] && [ "$model" != "null" ]; then
	model_lower=$(echo "$model" | tr '[:upper:]' '[:lower:]')
	case "$model_lower" in
	*opus*) model_color="$MAGENTA" ;;
	*sonnet*) model_color="$YELLOW" ;;
	*haiku*) model_color="$CYAN" ;;
	*) model_color="$GREEN" ;;
	esac
	parts="$parts|${model_color}${model}${RESET}"
fi

if [ "$used_percentage" -ge 70 ]; then
	parts="$parts|${RED}ctx:${used_percentage}%${RESET}"
elif [ "$used_percentage" -ge 45 ]; then
	parts="$parts|${YELLOW}ctx:${used_percentage}%${RESET}"
else
	parts="$parts|${GREEN}ctx:${used_percentage}%${RESET}"
fi

if [ "$rate_5h" -ge 80 ]; then
	parts="$parts|${RED}5h:${rate_5h}%${RESET}"
elif [ "$rate_5h" -ge 50 ]; then
	parts="$parts|${YELLOW}5h:${rate_5h}%${RESET}"
else
	parts="$parts|${GREEN}5h:${rate_5h}%${RESET}"
fi

if [ "$rate_7d" -ge 80 ]; then
	parts="$parts|${RED}7d:${rate_7d}%${RESET}"
elif [ "$rate_7d" -ge 50 ]; then
	parts="$parts|${YELLOW}7d:${rate_7d}%${RESET}"
else
	parts="$parts|${GREEN}7d:${rate_7d}%${RESET}"
fi

printf '%b' "$parts"
