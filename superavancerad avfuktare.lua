--[[
%% autostart
%% properties
83 ui.fuktighet.value
%% globals
--]]

if (fibaro:countScenes() > 1) then
 fibaro:abort()
end

Avfuktare = {}
Avfuktare.__index = Avfuktare

function Avfuktare:new(id)
   t = t or {}
   setmetatable(t, self)
   self.__index = self
   self.id = id or 999
   self.runtime = tonumber(fibaro:getGlobalValue("avfktRuntime")) or 0
   self.expruntime = tonumber(fibaro:getGlobalValue("avfktExpRuntime")) or 0
   self.status, self.mtime = tonumber(fibaro:get(self.id "value"))
   return t
end

function Avfuktare:getExpruntime()
   print(self.expruntime)
end

function Avfuktare:setExpruntime()
   self.expruntime = self.expruntime + self.runtime
   fibaro:setGlobalValue("avfktExpRuntime", self.expruntime)
end

function Avfuktare:setRuntime()
   local startTime = fibaro:getGlobalValue("avfktStart")
   local stopTime = fibaro:getGlobalValue("avfktStop")
   self.runtime = self.runtime + (stopTime - startTime)
   fibaro:setGlobalValue("avfktRuntime", self.runtime)
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
   fibaro:setGlobalValue("avfktStart", os.time())
end

function Avfuktare:stop()
   fibaro:call(self.id, "turnOff")
   fibaro:debug("Stänger av avfuktare")
   fibaro:call(38, "sendPush", "Avfuktare avstängd")
   fibaro:setGlobalValue("avfktStop", os.time())
end

local wStation = 83
local maxFukt = 65
local minFukt = 58
local fukthalt = string.sub(fibaro:getValue(wStation, "ui.fuktighet.value"), 1, 2)

fibaro:debug(fukthalt)

a = Avfuktare:new(69)

if(tonumber(fukthalt) >= maxFukt and a.status == 0) then
  a:start()

elseif(tonumber(fukthalt) >= maxFukt and a.status == 1) then
  fibaro:abort()
   
elseif(tonumber(fukthalt) <= minFukt and a.status == 0) then
  fibaro:abort()

elseif(tonumber(fukthalt) <= minFukt and a.status == 1) then
  a:stop()
end