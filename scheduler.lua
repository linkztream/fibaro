--[[
%% autostart
%% properties
%% globals
--]]

<<<<<<< HEAD
while true do

if (fibaro:countScenes() > 1) then
 fibaro:abort()
end

-- THE scheduler.

local uBel = {21, 101}
local mysBel = {4, 22, 23, 26}
local singleDev = 3
local sunriseHour = fibaro:getValue(1, "sunriseHour")
local sunsetHour = fibaro:getValue(1, "sunsetHour")

--[[
local schedule = {"sunsetHour" = "uBel, on",
                  "19:30" = "mysBel, on",
                  "22:30" = "mysBel, off",
                  "23:00" = "uBel, off",}
]]--

-- === funktionsblock ===

function devType(devID)
   -- virtual_device
end


function epochTime(tString)
   local hour, min = string.match(tString, "(%d+):(%d+)")
   local time = os.date("*t")
   return os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
end


function executor(dev, command, time)
   local tDev = dev
   local tCommand = string.lower(command)
   local time = time or nil
   time = tonumber(epochTime(time))
   
   if (time > os.time()) then
      fibaro:sleep(time-os.time())
   end

   if (type(tDev) == "table") then
      for i, v in ipairs(tDev) do
         if (tCommand == "on") then
            fibaro:call(v, "turnOn")
         else
            fibaro:call(v, "turnOff")
      end
   else
   end
end

-- Main loop

executor(uBel, on, sunsetHour)
executor(uBel, off, "22:00")


=======
local lightsOn = 1927
local lightsOff = 1921
local timer = 0
while true do

  local currentTime = tonumber(os.date("%H%M"))
  
  if (currentTime == lightsOn) then
    fibaro:call(64, "pressButton", "1")
    end
  
fibaro:setGlobal("ampPower", fibaro:getValue(4, "power"))
fibaro:sleep(1000)
timer = timer + 1


if (timer >= 60) then
   timer = 0
end

>>>>>>> 41cad6d577cc471b137b3c80817cf502b9d6c6d5
end