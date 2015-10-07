--[[
%% properties

%% globals
--]]

fibaro:debug("Startar schemaläggaren...")

if (fibaro:countScenes() > 1) then
 fibaro:abort()
end

local nattlampor = {8, 9, 12, 13}

local sunriseHour = fibaro:getValue(1, "sunriseHour")
local sunsetHour = fibaro:getValue(1, "sunsetHour")

schedule = {
            {"sunsetHour+30", "22:30", uBel},
            {"sunsetHour-15", "22:00", mysBel},
            }

function epochTime(tString)
   local time = os.date("*t")
   local epTime = 0

   if (string.match(tString, "sun.+")) then
      if (string.match(tString, "rise")) then
            local hour, min = string.match(sunriseHour, "(%d+):(%d+)")
            epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
         else
            local hour, min = string.match(sunsetHour, "(%d+):(%d+)")
            epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
      end
      
      if string.match(tString, "[%+%-]%d+$") then
         local offset = (tonumber(string.match(tString, "%d+$"))) * 60
         if (string.match(tString, "%+")) then
            epTime = epTime + offset
         else
            epTime = epTime - offset
         end
      end

   elseif (string.match(tString, "(%d+):(%d+)")) then
      local hour, min = string.match(tString, "(%d+):(%d+)")
      epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
   end
   return epTime

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


function power_rfx(devID, command)
   -- Slå av/på rfx-grejor.
   
   trigger = 0
   devID = tostring(devID)
   capCom = firstToUpper(command)
   fibaro:debug("Enhet: " .. devID .. " och kommando: " .. capCom .. " skickas.")

   while (trigger < 3)
      do
         updateDevice(devID)
         fibaro:sleep(750)
         trigger = trigger + 1
      end
end


function power_fib(devID, command)
   -- Slå av/på vanliga fibaro-prylar
   if (command == "on") then
      fibaro:call(devID, "turnOn")
      fibaro:debug("Slår på " .. fibaro:getName(devID))
   else
      fibaro:call(devID, "turnOff")
      fibaro:debug("Slår av " .. fibaro:getName(devID))
   end
end


function executor(time, dev, command)
   local tDev = dev
   local tCommand = string.lower(command)
   local time = tonumber(time) or os.time()
   
   if (time > os.time()) then
      local sleeptime = time - os.time()
      fibaro:debug(os.date("%d/%m/%Y") .. ": Vilar i: " .. sleeptime .. " sekunder")
      fibaro:sleep(sleeptime*1000)
   end

   if (type(tDev) == "table") then
      for i, v in ipairs(tDev) do
         if (string.match(v, "rfx")) then
           rfxid = tonumber(string.match(v, "%d+"))
           power_rfx(rfxid, tCommand)
           fibaro:debug("skickar kommando: " .. rfxid .. " " .. tCommand)          
         else
            fibid = tonumber(v)
            power_fib(fibid, tCommand)
            fibaro:debug("skickar kommando: " .. fibid .. " " .. tCommand) 
         end
      end
   end
end


function sleep()
   -- sätt tiden till en minut innan midnatt för att vara säker på att den
   -- inte tar tiden från i morse.
   local midnite = "23:59"
   midnite = epochTime(midnite)
   -- lägg på 90 sekunder för att komma över på nästa dygn
   midnite = midnite + 90
   fibaro:debug(os.date("%d/%m/%Y").. ": Påbörjar vila till nästa dygn. \nKommer sova i: " .. (midnite-os.time()) .. " sekunder.")
   fibaro:sleep((midnite - os.time())*1000)
end

function firstToUpper(str)
   return (str:gsub("^%l", string.upper))
end


local function updateDevice(deviceId, successCallback, errorCallback)

local http = net.HTTPClient()

http:request('http://10.0.16.32:8080/json.htm?type=command&param=switchlight&idx=' .. deviceId .. '&switchcmd=On&level=0', {
options = {
method = 'GET'
},
success = successCallback,
error = errorCallback
})
fibaro:debug("Kör HTTPClient-ID: " .. deviceId)
end

runschedule = generateschedule(schedule)
bubblesort(runschedule)

fibaro:debug("Kör httpclient")
for i,v in ipairs(nattlampor) do
   updateDevice(v)
end

fibaro:debug("Kör executorn!")
for i,v in ipairs(runschedule) do
   executor(v[1], v[2], v[3])
end

--[[
local srHour = fibaro:getValue(1, "sunriseHour")
local ssHour = fibaro:getValue(1, "sunsetHour")
fibaro:debug(srHour)
fibaro:debug(ssHour)

local dType = fibaro:getType(78)
fibaro:debug(dType)

fibaro:debug(fibaro:getValue(4, "power"))
fibaro:debug(fibaro:getValue(4, "power"))

fibaro:debug(fibaro:getName(42))

--]]