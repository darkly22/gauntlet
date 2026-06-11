#!/usr/bin/env bash
#
# GAUNTLET installer — get playing inside Claude Code in one command.
#
#   From scratch:        curl -fsSL https://raw.githubusercontent.com/darkly22/gauntlet/main/install.sh | bash
#   Already cloned:      bash install.sh
#
# What it does:
#   1. Checks for Node 18+ (the engine is zero-dependency, pure Node).
#   2. Clones the game if you don't already have it.
#   3. Installs the Claude Code CLI if it's missing.
#   4. Prints exactly how to start playing.
#
set -euo pipefail

REPO="${GAUNTLET_REPO:-https://github.com/darkly22/gauntlet.git}"
DIR="${GAUNTLET_DIR:-gauntlet}"

bold()  { printf '\033[1m%s\033[0m\n' "$1"; }
ok()    { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn()  { printf '  \033[33m!\033[0m %s\n' "$1"; }
die()   { printf '  \033[31m✗\033[0m %s\n' "$1" >&2; exit 1; }

echo
bold "⚔  GAUNTLET — Pokémon, refereed by Claude Code"
echo

# 1. Node 18+ -----------------------------------------------------------------
command -v node >/dev/null 2>&1 || die "Node.js not found. Install Node 18+ from https://nodejs.org and re-run."
NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
[ "$NODE_MAJOR" -ge 18 ] || die "Node $NODE_MAJOR found, but 18+ is required. Upgrade from https://nodejs.org"
ok "Node $(node -v) (zero dependencies — nothing to npm install)"

# 2. Get the files ------------------------------------------------------------
STARTED_IN_REPO=0
if [ -f "game.js" ]; then
  STARTED_IN_REPO=1
  ok "Game files already here ($(pwd))"
else
  command -v git >/dev/null 2>&1 || die "git not found. Install git, or download the repo zip manually."
  if [ -d "$DIR" ]; then
    warn "$DIR/ already exists — using it as-is"
  else
    echo "  Cloning $REPO ..."
    git clone --depth 1 "$REPO" "$DIR" >/dev/null 2>&1 || die "Clone failed. Check the URL (override with GAUNTLET_REPO=...)."
  fi
  cd "$DIR"
  ok "Game files ready ($(pwd))"
fi

# 3. Claude Code CLI ----------------------------------------------------------
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code CLI found"
else
  warn "Claude Code CLI not found."
  if command -v npm >/dev/null 2>&1; then
    printf "  Install it now with npm? [Y/n] "
    read -r reply </dev/tty 2>/dev/null || reply="y"
    case "${reply:-y}" in
      [Nn]*) warn "Skipped. Install later: npm i -g @anthropic-ai/claude-code" ;;
      *) npm i -g @anthropic-ai/claude-code >/dev/null 2>&1 && ok "Claude Code installed" \
           || warn "Install failed — run manually: npm i -g @anthropic-ai/claude-code" ;;
    esac
  else
    warn "npm not available. Install Claude Code: https://claude.com/claude-code"
  fi
fi

# Done ------------------------------------------------------------------------
echo
bold "Ready. To play:"
echo
[ "$STARTED_IN_REPO" -eq 0 ] && echo "  cd $DIR"
echo "  claude              # open Claude Code in this folder"
echo
echo "  then type:"
echo "    /gauntlet          endless draft battler (arcade)"
echo "    /journey           narrated campaign — Claude is your Game Master"
echo
echo "  Prefer no AI? Play the engine solo:  node game.js start"
echo
