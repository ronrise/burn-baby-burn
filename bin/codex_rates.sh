# Codex pricing — USD per 1,000,000 tokens. Sourced by `burn`.
# Source: https://developers.openai.com/api/docs/pricing (snapshot: 2026-05)
#
# To add a model, append a `case` branch with: input_rate cached_rate output_rate.

# Compute USD cost for a single Codex call.
# Args: model, input_tokens, cached_input_tokens, output_tokens
# Prints cost (6 decimals) on stdout. Returns 2 if the model has no rates.
codex_cost() {
  local model=$1 inp=$2 cached=$3 out=$4
  local ir cr or_
  case "$model" in
    gpt-5.5)       ir=5.00 cr=0.50  or_=30.00 ;;
    gpt-5.4)       ir=2.50 cr=0.25  or_=15.00 ;;
    gpt-5.4-mini)  ir=0.75 cr=0.075 or_=4.50  ;;
    gpt-5.4-nano)  ir=0.20 cr=0.02  or_=1.25  ;;
    gpt-5.3-codex) ir=1.75 cr=0.175 or_=14.00 ;;
    *) return 2 ;;
  esac
  local non_cached=$((inp - cached))
  ((non_cached < 0)) && non_cached=0
  awk -v nc="$non_cached" -v c="$cached" -v o="$out" \
      -v ir="$ir" -v cr="$cr" -v or_="$or_" \
      'BEGIN { printf "%.6f", (nc*ir + c*cr + o*or_) / 1000000 }'
}

# True (0) if `codex_cost` would succeed for $1; false (1) otherwise.
codex_has_rates() {
  codex_cost "$1" 0 0 0 >/dev/null 2>&1
}
