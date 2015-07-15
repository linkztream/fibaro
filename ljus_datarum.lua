--[[
%% properties
74 value
%% globals
--]]

local mSenseId = 74

if (fibaro:countScenes() > 1) then
 fibaro:abort()
end

local sVal, mTime = fibaro:get(mSenseId, "value")
local sLamp = fibaro:getValue(42, "value")

while(os.time()-mTime <= 300) do
  sVal, mTime = fibaro:get(mSenseId, "value")
  if(tonumber(sLamp) == 0) then
    fibaro:call(42, "turnOn")
    fibaro:call(99, "turnOn")
    fibaro:call(78, "pressButton", "3")
  end
  fibaro:debug(os.time()-mTime)
  sLamp = fibaro:getValue(42, "value")
  fibaro:sleep(1000)
end

fibaro:call(42, "turnOff")
fibaro:call(99, "turnOn")
fibaro:call(78, "pressButton", "4")