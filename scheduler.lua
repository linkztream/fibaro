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

schedule = {
            {"sunsetHour+30", "22:30", uBel},
            {"17:15", "23:00", "3"},
            {"8:25", "sunsetHour", "2"},
            {"21:15", "21:00", "4"}
            }

-- === funktionsblock ===

function devType(devID)
   -- virtual_device
end


function epochTime(tString)

   local time = os.date("*t")

   if (string.match(tString, "sunriseHour%+%d+")) then
      local hour, min = string.match(sunriseHour, "(%d+):(%d+)")
      epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
      local offset = tonumber(string.match(tString, "%d+$"))
      epTime = epTime + (offset * 60)
      return epTime

   elseif (string.match(tString, "sunriseHour%-%d+")) then
      local hour, min = string.match(sunriseHour, "(%d+):(%d+)")
      epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
      local offset = tonumber(string.match(tString, "%d+$"))
      epTime = epTime - (offset * 60)
      return epTime

   elseif (string.match(tString, "sunsetHour%+%d+")) then
      local hour, min = string.match(sunsetHour, "(%d+):(%d+)")
      epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
      local offset = tonumber(string.match(tString, "%d+$"))
      epTime = epTime + (offset * 60)
      return epTime

   elseif (string.match(tString, "sunsetHour%-%d+")) then
      local hour, min = string.match(sunsetHour, "(%d+):(%d+)")
      epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
      local offset = tonumber(string.match(tString, "%d+$"))
      epTime = epTime - (offset * 60)
      return epTime

   elseif (string.match(tString, "sunsetHour")) then
      local hour, min = string.match(sunsetHour, "(%d+):(%d+)")
      return os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})

   elseif (string.match(tString, "sunriseHour")) then
      local hour, min = string.match(sunriseHour, "(%d+):(%d+)")
      return os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
   else
      local hour, min = string.match(tString, "(%d+):(%d+)")
      return os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
   end
end


function generateschedule(schedarray)
   local compiledSchedule = {}
    
   for i=1,#schedarray do
      schedarray[i][1] = epochTime(schedarray[i][1])
      schedarray[i][2] = epochTime(schedarray[i][2])
      
      -- kolla så att det inte är någon tid som börjar efter den ska sluta.
      if (schedarray[i][1] >= schedarray[i][2]) then
         do break end
      end

      table.insert(compiledSchedule, 
                  {schedarray[i][1], schedarray[i][3], "on"})
      table.insert(compiledSchedule, 
                  {schedarray[i][2], schedarray[i][3], "off"})
   end
   return compiledSchedule
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


function executor(time, dev, command)
   local tDev = dev
   local tCommand = string.lower(command)
   local time = time or os.time()
   time = tonumber(epochTime(time))
   
   if (time > os.time()) then
      fibaro:sleep((time-os.time()*1000))
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

function sleep()
   local midnite = "00:00"
   midnite = epochTime(midnite)
   midnite = midnite + 60
   fibaro:sleep((midnite - os.time()*1000))
end


-- Main loop

runschedule = generateschedule(runschedule)
bubblesort(runschedule)

for i,v in ipairs(runschedule)
   executor(v[1], v[2], v[3])
end

-- Sov till efter midnatt innan nästa körning börjar.
sleep()

end