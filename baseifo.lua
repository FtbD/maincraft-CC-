local m = peripheral.find("monitor")
local sp = peripheral.find("speaker")

if not m then
  print("NO MONITOR")
  return
end

m.setTextScale(0.5)
term.redirect(m)

local angle = 0
local tick = 0
local alertTimer = 0

local logs = {
  "perimeter scan complete",
  "energy grid synchronized",
  "storage index refreshed",
  "drone uplink stable",
  "radar pulse emitted",
  "firewall integrity checked",
  "unknown signal traced",
  "base shield calibrated",
  "thermal sensors nominal",
  "command bus encrypted",
  "security layer armed",
  "auxiliary systems online"
}

local targets = {"ENTITY", "SIGNAL", "UNKNOWN", "DRONE", "PLAYER", "MOTION"}

local function soundStartup()
  if not sp then return end
  sp.playSound("minecraft:block.beacon.activate", 1, 0.45)
  sleep(0.35)
  sp.playSound("minecraft:block.conduit.activate", 0.8, 0.65)
end

local function soundShutdown()
  if not sp then return end
  sp.playSound("minecraft:block.beacon.deactivate", 1, 0.45)
  sleep(0.25)
  sp.playSound("minecraft:block.conduit.deactivate", 0.8, 0.65)
end

local function writeAt(x, y, text, fg, bg)
  term.setCursorPos(x, y)
  term.setTextColor(fg or colors.white)
  term.setBackgroundColor(bg or colors.black)
  term.write(text)
end

local function box(x, y, w, h, col)
  writeAt(x, y, "+" .. string.rep("-", w - 2) .. "+", col)
  for i = 1, h - 2 do
    writeAt(x, y + i, "|" .. string.rep(" ", w - 2) .. "|", col)
  end
  writeAt(x, y + h - 1, "+" .. string.rep("-", w - 2) .. "+", col)
end

local function bar(x, y, w, percent, col)
  writeAt(x, y, "[", colors.gray)
  local fill = math.floor(w * percent / 100)
  for i = 1, w do
    term.setCursorPos(x + i, y)
    term.setBackgroundColor(i <= fill and col or colors.gray)
    term.write(" ")
  end
  writeAt(x + w + 1, y, "] " .. percent .. "%", colors.white)
  term.setBackgroundColor(colors.black)
end

local function drawRadar(cx, cy, W, H)
  writeAt(cx - 7, 5, "TACTICAL RADAR", colors.cyan)

  for r = 6, 28, 6 do
    for d = 0, 360, 8 do
      local x = cx + math.floor(math.cos(math.rad(d)) * r)
      local y = cy + math.floor(math.sin(math.rad(d)) * r * 0.45)
      if x > 2 and x < W and y > 4 and y < H - 16 then
        writeAt(x, y, ".", colors.green)
      end
    end
  end

  for r = 1, 30 do
    local x = cx + math.floor(math.cos(math.rad(angle)) * r)
    local y = cy + math.floor(math.sin(math.rad(angle)) * r * 0.45)
    if x > 2 and x < W and y > 4 and y < H - 16 then
      writeAt(x, y, "*", colors.lime)
    end
  end

  writeAt(cx - 4, cy, "[BASE]", colors.cyan)

  for i = 1, 16 do
    local x = cx + math.random(-30, 30)
    local y = cy + math.random(-13, 13)
    local danger = i % 5 == 0
    writeAt(x, y, danger and "!" or "o", danger and colors.red or colors.orange)
  end
end

local function drawInterface()
  tick = tick + 1

  term.setBackgroundColor(colors.black)
  term.clear()

  local W, H = term.getSize()
  local cx = math.floor(W / 2)
  local cy = math.floor(H / 2) + 2

  box(1, 1, W, H, colors.cyan)

  writeAt(4, 2, "ATM10 BASE COMMAND CENTER", colors.lime)
  writeAt(W - 24, 2, textutils.formatTime(os.time(), true), colors.yellow)

  if alertTimer > 0 then
    writeAt(math.floor(W / 2) - 16, 3, "  WARNING: SIGNAL ANOMALY  ", colors.white, colors.red)
    alertTimer = alertTimer - 1
  else
    writeAt(math.floor(W / 2) - 14, 3, "  SECURE TERMINAL ONLINE  ", colors.gray)
  end

  box(3, 5, 38, 20, colors.gray)
  writeAt(5, 6, "CORE SYSTEMS", colors.cyan)

  writeAt(5, 8, "POWER", colors.white)
  bar(18, 8, 17, math.random(88, 100), colors.lime)

  writeAt(5, 10, "STORAGE", colors.white)
  bar(18, 10, 17, math.random(42, 96), colors.orange)

  writeAt(5, 12, "UPLINK", colors.white)
  bar(18, 12, 17, math.random(70, 100), colors.purple)

  writeAt(5, 14, "SECURITY", colors.white)
  writeAt(18, 14, "ARMED", colors.red)

  writeAt(5, 16, "NETWORK", colors.white)
  writeAt(18, 16, "ENCRYPTED", colors.lime)

  writeAt(5, 18, "DRONES", colors.white)
  writeAt(18, 18, math.random(6, 18) .. " ACTIVE", colors.cyan)

  writeAt(5, 20, "REACTOR", colors.white)
  writeAt(18, 20, "STABLE", colors.green)

  writeAt(5, 22, "FIREWALL", colors.white)
  writeAt(18, 22, "LOCKED", colors.purple)

  drawRadar(cx, cy, W, H)

  box(W - 41, 5, 38, 25, colors.gray)
  writeAt(W - 39, 6, "SIGNAL FEED", colors.cyan)

  for i = 1, 12 do
    local name = targets[math.random(#targets)]
    local dist = math.random(20, 640)
    local col = i % 4 == 0 and colors.red or colors.white
    writeAt(W - 39, 7 + i, name .. "_" .. math.random(100, 999) .. "  " .. dist .. "m", col)
  end

  writeAt(W - 39, 22, "TARGET LOCK", colors.red)
  bar(W - 39, 24, 22, math.random(58, 100), colors.red)

  writeAt(W - 39, 26, "SCAN ANGLE", colors.cyan)
  writeAt(W - 25, 26, angle .. " DEG", colors.yellow)

  box(3, H - 15, W - 6, 12, colors.gray)
  writeAt(5, H - 14, "SYSTEM ACTIVITY LOG", colors.cyan)

  for i = 1, 9 do
    writeAt(5, H - 14 + i, "> " .. logs[math.random(#logs)] .. " ........ OK", colors.lime)
  end

  writeAt(4, H - 1, "CTRL+T STOP // SECURE BASE TERMINAL // RADAR SWEEP ACTIVE", colors.gray)

  if math.random(1, 55) == 1 then
    alertTimer = 10
  end

  angle = (angle + 7) % 360
end

soundStartup()

local ok, err = pcall(function()
  while true do
    drawInterface()
    sleep(0.1)
  end
end)

soundShutdown()

term.setBackgroundColor(colors.black)
term.clear()
print("Base Command Center stopped.")
