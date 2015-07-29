--[[
%% autostart
%% properties
%% globals
--]]

local lightsOn = 1927
local lightsOff = 1921
while true do

  local currentTime = tonumber(os.date("%H%M"))
  
  if (currentTime == lightsOn) then
    fibaro:call(64, "pressButton", "1")
    end
  
fibaro:setGlobal("ampPower", fibaro:getValue(4, "power"))
fibaro:sleep(1000)
end