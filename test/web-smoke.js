const { JSDOM } = require("/home/claude/gauntlet-cli/node_modules/jsdom");
(async () => {
const dom = await JSDOM.fromURL("http://localhost:7779/", {
  runScripts: "dangerously", resources: "usable", pretendToBeVisual: true,
  beforeParse(window){
    window.fetch = (url, opts) => fetch(new URL(url, "http://localhost:7779/").href, opts);
  },
});
const { window } = dom;
const $ = s => window.document.querySelector(s);
const $$ = s => [...window.document.querySelectorAll(s)];
const sleep = ms => new Promise(r => setTimeout(r, ms));

await sleep(1200);
console.log("PROBE:", $("#gm-probe")?.textContent.trim());
$("#tn").value = "Webber";
$("#begin").click();
for (let i=0; i<80 && $$("[data-pick]").length===0; i++) await sleep(500);
console.log("STARTERS:", $$(".mon-card .nm").map(e=>e.textContent).join(", "));
$$("[data-pick]")[0].click();
// pick triggers a GM beat (stub) — wait for narration
for (let i=0; i<40 && !$(".gm-msg"); i++) await sleep(400);
console.log("GM NARRATION:", $(".gm-msg") ? $(".gm-msg").textContent.replace("game master","").trim().slice(0,70)+"…" : "MISSING");
console.log("TOOL LINES:", $$(".tool-msg").map(e=>e.textContent).join(" | ") || "none");

// travel via say box
$("#say").value = "go viridian-forest";
$("#say-btn").click();
for (let i=0; i<40 && !window.document.body.textContent.includes("Arrived: viridian-forest"); i++) await sleep(400);
console.log("TRAVEL:", window.document.body.textContent.includes("Arrived: viridian-forest") ? "ok" : "FAILED");

// explore → battle
for (let i=0; i<20; i++){ const b = $$(".act").find(x=>x.textContent.includes("EXPLORE")); if (b){ b.click(); break; } await sleep(300); }
for (let i=0; i<60 && !$("#foe-sprite"); i++) await sleep(500);
console.log("BATTLE:", $(".battle-flag")?.textContent.trim() || "FAILED");
console.log("MOVES:", $$(".act.move .mn").map(e=>e.textContent).join(", "));
$$(".act.move")[0]?.click();
await sleep(3000);
console.log("ENGINE LOG:", $$(".engine-msg").slice(-2).map(e=>e.textContent).join(" | "));
console.log("WEBCC SMOKE PASS");
process.exit(0);
})().catch(e => { console.error("FAIL:", e.message); process.exit(1); });
