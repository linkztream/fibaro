--[[
%% autostart
%% properties
83 ui.fuktighet.value
%% globals
--]]

if (fibaro:countScenes() > 1) then
 fibaro:abort()
end

Avfuktare =   {id = 69, 
               runtime = tonumber(fibaro:getGlobalValue("avfktRuntime")) or 0, 
               expruntime = tonumber(fibaro:getGlobalValue("avfktExpRuntime")) or 0,
               status = 0,
               mtime = 0,
            }
function Avfuktare:GetStatus()
   Avfuktare.status, Avfuktare.mtime = fibaro:get(Avfuktare.id, "value")
end

function Avfuktare:getExpruntime()
   print(self.expruntime)
end

function Avfuktare:setExpruntime()
   self.expruntime = self.expruntime + self.runtime
   fibaro:setGlobal("avfktExpRuntime", self.expruntime)
end

function Avfuktare:setRuntime()
   local startTime = fibaro:getGlobalValue("avfktStart")
   local stopTime = fibaro:getGlobalValue("avfktStop")
   self.runtime = self.runtime + (stopTime - startTime)
   fibaro:setGlobal("avfktRuntime", self.runtime)
end

function Avfuktare:start()
   -- Kolla att det har gått minst 8 minuter sen den gick sist.
   local minSleep = 480
   local startDelay = minSleep - (os.time() - tonumber(fibaro:getGlobalValue("avfktStop")))
   
   if (startDelay > 0) then
      fibaro:debug("För tidigt att starta, vilar " .. startDelay .. " sekunder.")
      fibaro:sleep(startDelay * 1000)
   end

   fibaro:call(self.id, "turnOn")
   fibaro:debug("Startar avfuktare")
   fibaro:call(38, "sendPush", "Avfuktare startad!")
   fibaro:setGlobal("avfktStart", os.time())
end

function Avfuktare:stop()
   fibaro:call(self.id, "turnOff")
   fibaro:debug("Stänger av avfuktare")
   fibaro:call(38, "sendPush", "Avfuktare avstängd")
   fibaro:setGlobal("avfktStop", os.time())
end

function Avfuktare:power()
   local power = tonumber(fibaro:getValue(self.id, "power"))
   return power <= 75
end

local wStation = 83
local maxFukt = 65
local minFukt = 58
local fukthalt = string.sub(fibaro:getValue(wStation, "ui.fuktighet.value"), 1, 2)

fibaro:debug(fukthalt)

Avfuktare:GetStatus()
fibaro:debug(Avfuktare.status)

if(tonumber(fukthalt) >= maxFukt and Avfuktare.status == "0") then
 Avfuktare:start()

elseif(tonumber(fukthalt) >= maxFukt and Avfuktare.status == "1") then
   if not Avfuktare:power() then
      fibaro:abort()
   else
      fibaro:setGlobal("avfktStop", os.time())
      Avfuktare:setRuntime()
      while Avfuktare:power() do
         fibaro:sleep(5000)
      end
      fibaro:setGlobal("avfktStart", os.time())
      fibaro:abort()
   end
   
elseif(tonumber(fukthalt) <= minFukt and Avfuktare.status == "0") then
  fibaro:abort()

elseif(tonumber(fukthalt) <= minFukt and Avfuktare.status == "1") then
  Avfuktare:stop()
end