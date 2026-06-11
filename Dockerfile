# GAUNTLET — hosted Pokémon GM. Engine + web UI + Claude Code agent GM.
FROM node:22-slim
RUN npm install -g @anthropic-ai/claude-code
WORKDIR /app
COPY game.js server.js gm-prompt.md package.json ./
COPY web ./web
# campaigns/ holds all per-visitor worlds — mount a volume to persist them
VOLUME /app/campaigns
ENV PORT=7779
EXPOSE 7779
# Required at runtime: -e ANTHROPIC_API_KEY=sk-ant-...
CMD ["node", "server.js"]
