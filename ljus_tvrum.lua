--[[
%% properties
55 value
%% globals
ampPower
--]]

if (fibaro:countScenes() > 1) then
  fibaro:abort()
end


local isLampLit = fibaro:getValue(91, "value")
local ampIsOn = fibaro:getGlobalValue("ampPower")

if (isLampLit == "0" and ampIsOn == "0") then
   fibaro:call(91, "turnOn")
elseif (isLampLit == "1" and ampIsOn == "1")
   then
   fibaro:call(91, "turnOff")
else
   fibaro:abort()
end
