#!/bin/bash
input=$(cat)

current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
rate_5h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0' | cut -d. -f1)
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)
rate_7d_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0' | cut -d. -f1)

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
MAGENTA='\033[35m'
RESET='\033[0m'

display_dir="${current_dir/#$HOME/~}"

# Branch with truncation
branch=$(git -C "$current_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
branch_part=""
if [ -n "$branch" ]; then
	staged=$(git -C "$current_dir" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
	modified=$(git -C "$current_dir" diff --numstat 2>/dev/null | wc -l | tr -d ' ')

	if [ "$staged" -gt 0 ]; then
		branch_part="${GREEN}${branch}${RESET}"
	elif [ "$modified" -gt 0 ]; then
		branch_part="${YELLOW}${branch}${RESET}"
	else
		branch_part="${branch}"
	fi
fi

# Context usage
if [ "$used_percentage" -ge 70 ]; then
	ctx_part="${RED}ctx:${used_percentage}%${RESET}"
elif [ "$used_percentage" -ge 45 ]; then
	ctx_part="${YELLOW}ctx:${used_percentage}%${RESET}"
else
	ctx_part="${GREEN}ctx:${used_percentage}%${RESET}"
fi

# Rate limits
rate5h_remaining=""
if [ "$rate_5h_resets" -gt 0 ]; then
	now=$(date +%s)
	diff_sec=$((rate_5h_resets - now))
	if [ "$diff_sec" -gt 0 ]; then
		diff_min=$(((diff_sec + 59) / 60))
		if [ "$diff_min" -ge 60 ]; then
			rate5h_remaining="$((diff_min / 60))h$((diff_min % 60))m"
		else
			rate5h_remaining="${diff_min}m"
		fi
	fi
fi

rate5h_label="5h:${rate_5h}%"
if [ -n "$rate5h_remaining" ]; then
	rate5h_label="5h:${rate_5h}%(${rate5h_remaining})"
fi

if [ "$rate_5h" -ge 80 ]; then
	rate5h_part="${RED}${rate5h_label}${RESET}"
elif [ "$rate_5h" -ge 50 ]; then
	rate5h_part="${YELLOW}${rate5h_label}${RESET}"
else
	rate5h_part="${GREEN}${rate5h_label}${RESET}"
fi

rate7d_remaining=""
if [ "$rate_7d_resets" -gt 0 ]; then
	now="${now:-$(date +%s)}"
	diff_sec=$((rate_7d_resets - now))
	if [ "$diff_sec" -gt 0 ]; then
		diff_days=$(((diff_sec + 86399) / 86400))
		rate7d_remaining="${diff_days}d"
	fi
fi

rate7d_label="7d:${rate_7d}%"
if [ -n "$rate7d_remaining" ]; then
	rate7d_label="7d:${rate_7d}%(${rate7d_remaining})"
fi

if [ "$rate_7d" -ge 80 ]; then
	rate7d_part="${RED}${rate7d_label}${RESET}"
elif [ "$rate_7d" -ge 50 ]; then
	rate7d_part="${YELLOW}${rate7d_label}${RESET}"
else
	rate7d_part="${GREEN}${rate7d_label}${RESET}"
fi

# Model (last)
model_part=""
if [ -n "$model" ] && [ "$model" != "null" ]; then
	model_lower=$(echo "$model" | tr '[:upper:]' '[:lower:]')
	case "$model_lower" in
	*opus*) model_color="$MAGENTA" ;;
	*sonnet*) model_color="$YELLOW" ;;
	*haiku*) model_color="$CYAN" ;;
	*) model_color="$GREEN" ;;
	esac
	model_part="${model_color}${model}${RESET}"
fi

# Line 1: dir|branch
line1="$display_dir"
if [ -n "$branch_part" ]; then
	line1="$line1|$branch_part"
fi

# Line 2: ctx|5h|7d|model|style
line2=""
for p in "$ctx_part" "$rate5h_part" "$rate7d_part" "$model_part"; do
	if [ -n "$p" ]; then
		if [ -n "$line2" ]; then
			line2="$line2|$p"
		else
			line2="$p"
		fi
	fi
done

printf '%b\n%b' "$line1" "$line2"
