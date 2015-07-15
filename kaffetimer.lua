--[[
%% properties
82 value
%% globals
--]]

if (fibaro:countScenes() > 1) then
  fibaro:abort()
end

local pSwitchId = 82
local powerState, timestamp = fibaro:get(pSwitchId, "value")

if (powerState == "1") then
  while (os.time() - timestamp <= (1 * 60)) do
    fibaro:sleep(5000)
    fibaro:debug(os.time() - timestamp)
   end
end
 fibaro:call(pSwitchId, "turnOff")