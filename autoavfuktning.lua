--[[
%% properties
83 ui.fuktighet.value
%% globals
--]]

if (fibaro:countScenes() > 1) then
	fibaro:abort()
end

local wStation = 83
local avfuktare = 69
local maxFukt = 65
local minFukt = 60
local avfktOn, avfktTime = fibaro:get(avfuktare, "value")
local fukthalt = string.sub(fibaro:getValue(wStation, "ui.fuktighet.value"), 1, 2)
fibaro:debug(fukthalt)

if(tonumber(fukthalt) >= maxFukt and avfktOn == 0) then
  fibaro:call(avfuktare, "turnOn")
  fibaro:debug("Startar avfuktare")
  fibaro:call(38, "sendPush", "Avfuktare startad!")

elseif(tonumber(fukthalt) >= maxFukt and avfktOn == 1) then
  fibaro:abort()
	
elseif(tonumber(fukthalt) <= minFukt and avfktOn == 0) then
  fibaro:abort()

elseif(tonumber(fukthalt) <= minFukt and avfktOn == 1) then
  fibaro:call(avfuktare, "turnOff")
  fibaro:debug("Stoppar avfuktare och vilar i 8 minuter")
  fibaro:sleep(8*60*1000)
end