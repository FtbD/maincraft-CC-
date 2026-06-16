local m=peripheral.find("monitor")
if not m then print("NO MONITOR") return end
m.setTextScale(0.5)
term.redirect(m)

local logs={
 "uplink established","grid sync complete","scanning perimeter",
 "drone signal stable","unknown signal detected","storage indexed",
 "security layer armed","radar pulse emitted","target lost","target acquired"
}

local function wr(x,y,s,c,b)
 term.setCursorPos(x,y)
 term.setTextColor(c or colors.white)
 term.setBackgroundColor(b or colors.black)
 term.write(s)
end

local function bar(x,y,w,p,c)
 wr(x,y,"[",colors.gray)
 for i=1,w do
  term.setCursorPos(x+i,y)
  term.setBackgroundColor(i<=math.floor(w*p/100) and c or colors.gray)
  write(" ")
 end
 wr(x+w+1,y,"] "..p.."%",colors.white)
 term.setBackgroundColor(colors.black)
end

local function box(x,y,w,h,c)
 wr(x,y,"+"..string.rep("-",w-2).."+",c)
 for i=1,h-2 do wr(x,y+i,"|"..string.rep(" ",w-2).."|",c) end
 wr(x,y+h-1,"+"..string.rep("-",w-2).."+",c)
end

local a=0
while true do
 term.setBackgroundColor(colors.black)
 term.clear()
 local W,H=term.getSize()

 box(2,1,W-2,H-1,colors.cyan)
 wr(5,2,"ATM10 TACTICAL COMMAND CENTER // ALMAZ CORE",colors.lime)
 wr(W-28,2,textutils.formatTime(os.time(),true),colors.yellow)

 box(4,5,38,16,colors.gray)
 wr(6,6,"SYSTEM STATUS",colors.cyan)
 wr(6,8,"POWER")   bar(18,8,18,math.random(88,100),colors.lime)
 wr(6,10,"STORAGE") bar(18,10,18,math.random(45,96),colors.orange)
 wr(6,12,"DRONES")  wr(18,12,math.random(6,18).." ONLINE",colors.cyan)
 wr(6,14,"SECURITY")wr(18,14,"ARMED",colors.red)
 wr(6,16,"REACTOR") wr(18,16,"STABLE",colors.lime)
 wr(6,18,"NETWORK") wr(18,18,"ENCRYPTED",colors.purple)

 local cx,cy=math.floor(W/2),27
 wr(cx-5,6,"RADAR ARRAY",colors.cyan)

 for r=5,20,5 do
  for deg=0,360,10 do
   local x=cx+math.floor(math.cos(math.rad(deg))*r)
   local y=cy+math.floor(math.sin(math.rad(deg))*r*0.45)
   if x>2 and x<W and y>2 and y<H then wr(x,y,".",colors.green) end
  end
 end

 for r=1,22 do
  local x=cx+math.floor(math.cos(math.rad(a))*r)
  local y=cy+math.floor(math.sin(math.rad(a))*r*0.45)
  if x>2 and x<W and y>2 and y<H then wr(x,y,"*",colors.lime) end
 end

 wr(cx-3,cy,"BASE",colors.cyan)

 for i=1,10 do
  local x=cx+math.random(-22,22)
  local y=cy+math.random(-10,10)
  wr(x,y,i%3==0 and "!" or "o",i%3==0 and colors.red or colors.orange)
 end

 box(W-40,5,36,20,colors.gray)
 wr(W-38,6,"TARGET FEED",colors.cyan)
 for i=1,8 do
  local name=({"UNKNOWN","PLAYER","SIGNAL","DRONE","ENTITY"})[math.random(5)]
  wr(W-38,7+i,name.."_"..math.random(10,99).."  "..math.random(20,420).."m",i%3==0 and colors.red or colors.white)
 end

 box(4,H-13,W-8,10,colors.gray)
 wr(6,H-12,"SYSTEM LOG",colors.cyan)
 for i=1,7 do
  wr(6,H-12+i,"> "..logs[math.random(#logs)].." ... OK",colors.lime)
 end

 if math.random(1,8)==1 then
  wr(math.floor(W/2)-12,4," !!! ALERT: SIGNAL SPIKE !!! ",colors.white,colors.red)
 end

 wr(5,H-2,"CTRL+T TO STOP  //  ATM10 SECURE TERMINAL  //  RADAR SWEEP "..a.." DEG",colors.gray)

 a=(a+8)%360
 sleep(0.12)
end
