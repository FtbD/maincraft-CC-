local m=peripheral.find("monitor")
local sp=peripheral.find("speaker")
if not m then print("NO MONITOR") return end

m.setTextScale(0.5)
term.redirect(m)

local A=0
local tick=0
local logs={"perimeter scan","energy sync","storage check","drone uplink","radar ping","firewall check","signal trace","base shield"}

local function soundStartup()
 if not sp then return end
 sp.playNote("pling",2,12) sleep(0.12)
 sp.playNote("pling",2,16) sleep(0.12)
 sp.playNote("bell",2,20) sleep(0.18)
 sp.playNote("chime",2,24)
end

local function soundPing()
 if not sp then return end
 sp.playNote("bit",1,18)
 sleep(0.05)
 sp.playNote("bit",1,22)
end

local function soundAlert()
 if not sp then return end
 sp.playNote("bass",3,6)
 sleep(0.12)
 sp.playNote("bass",3,10)
 sleep(0.12)
 sp.playNote("bass",3,6)
end

local function soundShutdown()
 if not sp then return end
 sp.playNote("bell",2,20) sleep(0.12)
 sp.playNote("pling",2,15) sleep(0.12)
 sp.playNote("bass",2,8)
end

local function w(x,y,s,c,b)
 term.setCursorPos(x,y)
 term.setTextColor(c or colors.white)
 term.setBackgroundColor(b or colors.black)
 term.write(s)
end

local function box(x,y,W,H,c)
 w(x,y,"+"..string.rep("-",W-2).."+",c)
 for i=1,H-2 do w(x,y+i,"|"..string.rep(" ",W-2).."|",c) end
 w(x,y+H-1,"+"..string.rep("-",W-2).."+",c)
end

local function bar(x,y,W,p,c)
 w(x,y,"[",colors.gray)
 for i=1,W do
  term.setCursorPos(x+i,y)
  term.setBackgroundColor(i<=math.floor(W*p/100) and c or colors.gray)
  write(" ")
 end
 w(x+W+1,y,"] "..p.."%",colors.white)
 term.setBackgroundColor(colors.black)
end

soundStartup()

local ok,err=pcall(function()
 while true do
  tick=tick+1
  term.setBackgroundColor(colors.black)
  term.clear()
  local W,H=term.getSize()

  box(1,1,W,H,colors.cyan)
  w(4,2,"ATM10 BASE COMMAND CENTER",colors.lime)
  w(W-24,2,textutils.formatTime(os.time(),true),colors.yellow)

  box(3,5,36,18,colors.gray)
  w(5,6,"CORE SYSTEMS",colors.cyan)
  w(5,8,"POWER") bar(17,8,16,math.random(88,100),colors.lime)
  w(5,10,"STORAGE") bar(17,10,16,math.random(40,95),colors.orange)
  w(5,12,"SECURITY") w(17,12,"ARMED",colors.red)
  w(5,14,"NETWORK") w(17,14,"ONLINE",colors.lime)
  w(5,16,"DRONES") w(17,16,math.random(6,18).." ACTIVE",colors.cyan)
  w(5,18,"REACTOR") w(17,18,"STABLE",colors.green)
  w(5,20,"UPLINK") bar(17,20,16,math.random(70,100),colors.purple)

  local cx,cy=math.floor(W/2),math.floor(H/2)+2
  w(cx-6,5,"TACTICAL RADAR",colors.cyan)

  for r=6,24,6 do
   for d=0,360,8 do
    local x=cx+math.floor(math.cos(math.rad(d))*r)
    local y=cy+math.floor(math.sin(math.rad(d))*r*0.45)
    if x>2 and x<W and y>3 and y<H then w(x,y,".",colors.green) end
   end
  end

  for r=1,26 do
   local x=cx+math.floor(math.cos(math.rad(A))*r)
   local y=cy+math.floor(math.sin(math.rad(A))*r*0.45)
   if x>2 and x<W and y>3 and y<H then w(x,y,"*",colors.lime) end
  end

  w(cx-4,cy,"[BASE]",colors.cyan)

  for i=1,14 do
   local x=cx+math.random(-26,26)
   local y=cy+math.random(-12,12)
   w(x,y,i%4==0 and "!" or "o",i%4==0 and colors.red or colors.orange)
  end

  box(W-39,5,36,22,colors.gray)
  w(W-37,6,"SIGNAL FEED",colors.cyan)
  for i=1,10 do
   local n=({"ENTITY","PLAYER","UNKNOWN","DRONE","SIGNAL"})[math.random(5)]
   w(W-37,7+i,n.."_"..math.random(100,999).."  "..math.random(20,500).."m",i%4==0 and colors.red or colors.white)
  end

  w(W-37,20,"TARGET LOCK",colors.red)
  bar(W-37,22,20,math.random(65,100),colors.red)

  box(3,H-14,W-6,11,colors.gray)
  w(5,H-13,"SYSTEM ACTIVITY LOG",colors.cyan)
  for i=1,8 do
   w(5,H-13+i,"> "..logs[math.random(#logs)].." ........ OK",colors.lime)
  end

  if tick%50==0 then soundPing() end

  if math.random(1,45)==1 then
   w(math.floor(W/2)-14,3,"  WARNING: SIGNAL SPIKE  ",colors.white,colors.red)
   soundAlert()
  end

  w(4,H-1,"CTRL+T STOP // SECURE BASE TERMINAL // RADAR "..A.." DEG",colors.gray)

  A=(A+7)%360
  sleep(0.1)
 end
end)

soundShutdown()

term.setBackgroundColor(colors.black)
term.clear()
print("Base Command Center stopped.")
