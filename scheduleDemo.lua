--[[
%% autostart
%% properties
%% globals
--]]

local sourceTrigger = fibaro:getSourceTrigger();
function tempFunc()
local currentDate = os.date("*t");
local startSource = fibaro:getSourceTrigger();
if (
 ( (tonumber(os.date("%H%M")) >= tonumber(string.format("%02d%02d", "10", "49")) and tonumber(os.date("%H%M")) <= tonumber(string.format("%02d%02d", "12", "00"))) and (math.floor(os.time()/60)-math.floor(1435218540/60))%60 == 0 )
)
then
   fibaro:call(42, "turnOn");
end

setTimeout(tempFunc, 60*1000)
end
if (sourceTrigger["type"] == "autostart") then
tempFunc()
else

local currentDate = os.date("*t");
local startSource = fibaro:getSourceTrigger();
if (
startSource["type"] == "other"
)
then
   fibaro:call(42, "turnOn");
end

end

