--[[
%% properties
%% globals
]]--

local function timeCount(numSec)
   local nSeconds = numSec
   if nSeconds == 0 then

      coolTime.text = "00:00:00";
   else
      local nHours = string.format("%02.f", math.floor(nSeconds/3600));
      local nMins = string.format("%02.f", math.floor(nSeconds/60 - (nHours*60)));
      local nSecs = string.format("%02.f", math.floor(nSeconds - nHours*3600 - nMins *60));
      
      coolTime.text =  nHours..":"..nMins..":"..nSecs

   end
end