# ⚔ GAUNTLET

**Pokémon, refereed by Claude Code.** A complete Pokémon battle engine you play *inside* a Claude Code session. Every stat, move, sprite, and catch rate is pulled live from [PokeAPI](https://pokeapi.co). Zero dependencies — just Node 18+.

Two ways to play:

- **`/gauntlet`** — endless draft battler. Draft a team, fight scaling waves, build a streak. Roguelike.
- **`/journey`** — a narrated campaign where Claude is your Game Master. Travel real Kanto routes, catch wild Pokémon, battle gyms, build a story that persists on disk.

---

## Install

One line:

```sh
curl -fsSL https://raw.githubusercontent.com/darkly22/gauntlet/main/install.sh | bash
```

Or clone and run the installer yourself:

```sh
git clone https://github.com/darkly22/gauntlet.git
cd gauntlet
bash install.sh
```

The installer checks for Node 18+, gets the files, and installs the [Claude Code](https://claude.com/claude-code) CLI if you don't have it.

---

## Play

```sh
cd gauntlet
claude
```

Then type a slash command:

| Command | Mode |
|---|---|
| `/gauntlet` | Endless draft battler (arcade) |
| `/journey`  | Narrated campaign with Claude as Game Master |

Claude reads the game frames and translates what you say into moves — *"use the water attack"*, *"catch it"*, *"swap to slot 2"*. You make every decision; Claude is the referee, never the player.

> **No AI, just the engine?** `node game.js start` plays the arcade in your terminal directly.

---

## Web version (optional)

GAUNTLET also runs as a multiplayer web app where Claude GMs for every visitor:

```sh
npm start            # → http://localhost:7779
```

This needs an `ANTHROPIC_API_KEY` to power the GM narration. See [`CLAUDE.md`](CLAUDE.md) for hosting, Docker, and cost-control details.

---

## How it works

The engine (`game.js`, single file) owns every number — type chart, STAB, crits, accuracy, catch odds, exp curves. Claude never invents mechanics; it calls the engine and relays the result. State lives in `.gauntlet/state.json`, so each command resolves an action and prints the full screen.

Full design notes, commands, and the rules of the run are in [`CLAUDE.md`](CLAUDE.md).

---

## Requirements

- **Node 18+** — that's it for play.
- **[Claude Code](https://claude.com/claude-code)** — for the refereed `/gauntlet` and `/journey` modes (the installer offers to set this up).
- Internet — Pokémon data is fetched live from PokeAPI and cached locally.
