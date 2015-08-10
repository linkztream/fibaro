--[[
%% autostart
%% properties
%% globals
--]]

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


for i=1,#schedule do
   schedule[i][1] = epochTime(schedule[i][1])
end


function bubblesort(array)
   n = #array -1
   while n > 0 do
      x = 1
      while x < #array do
         if (array[x][1]>array[x+1][1]) then
            a = table.remove(array, x)
            table.insert(array,x+1, a)
            x = x + 1
         else
            x = x + 1
         end
      end
      n = n - 1
   end
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


end