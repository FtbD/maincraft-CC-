local m=peripheral.find("monitor")
if not m then print("NO MONITOR") return end
m.setTextScale(0.5)
term.redirect(m)

local function t(x,y,s,c,b)
 term.setCursorPos(x,y)
 term.setTextColor(c or colors.white)
 term.setBackgroundColor(b or colors.black)
 term.write(s)
end

local function bar(x,y,w,p,c)
 t(x,y,"[",colors.gray)
 for i=1,w do
  term.setCursorPos(x+i,y)
  term.setBackgroundColor(i<=math.floor(w*p/100) and c or colors.gray)
  term.write(" ")
 end
 t(x+w+1,y,"] "..p.."%",colors.white)
end

local angle=0
while true do
 term.setBackgroundColor(colors.black)
 term.clear()
 local w,h=term.getSize()
 t(3,2,"ATM10 BASE CONTROL CENTER",colors.cyan)
 t(3,3,string.rep("=",w-6),colors.cyan)

 t(4,6,"POWER",colors.yellow) bar(18,6,35,math.random(86,99),colors.lime)
 t(4,8,"STORAGE",colors.yellow) bar(18,8,35,math.random(40,95),colors.orange)
 t(4,10,"DRONES",colors.yellow) t(18,10,math.random(4,16).." ONLINE",colors.cyan)
 t(4,12,"SECURITY",colors.yellow) t(18,12,"ARMED",colors.red)
 t(4,14,"REACTOR",colors.yellow) t(18,14,"STABLE",colors.lime)

 local cx,cy=math.floor(w/2),27
 for r=4,18,4 do
  for a=0,360,15 do
   local x=cx+math.floor(math.cos(math.rad(a))*r)
   local y=cy+math.floor(math.sin(math.rad(a))*r*0.5)
   t(x,y,".",colors.green)
  end
 end

 for r=1,18 do
  local x=cx+math.floor(math.cos(math.rad(angle))*r)
  local y=cy+math.floor(math.sin(math.rad(angle))*r*0.5)
  t(x,y,"*",colors.lime)
 end

 for i=1,8 do
  local x=cx+math.random(-18,18)
  local y=cy+math.random(-8,8)
  t(x,y,"o",colors.red)
 end

 t(cx-4,cy,"[BASE]",colors.cyan)
 t(w-35,6,"RADAR: SCANNING",colors.lime)
 t(w-35,8,"TARGET X: "..math.random(-9999,9999),colors.white)
 t(w-35,9,"TARGET Z: "..math.random(-9999,9999),colors.white)
 t(w-35,11,"SIGNALS: "..math.random(2,9),colors.orange)
 t(w-35,13,"ACCESS: ROOT",colors.red)
 t(4,h-2,"CTRL+T TO STOP",colors.gray)

 angle=(angle+12)%360
 sleep(0.15)
end
