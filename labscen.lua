--[[
%% properties
97 value
%% globals
--]]

if (fibaro:countScenes() > 1) then
  fibaro:abort()
end


-- tänder lampan i TV-rummet om rörelsesensorn triggar utan att förstärkaren är på.
--[[ local aPower = fibaro:getGlobalValue("ampPower")
if(fibaro:getValue(55, "value") == 1) and (aPower ~= 1)then
  fibaro:call(91, "turnOn")
    while(aPower ~=1) do
      fibaro:setGlobal("ampPower", fibaro:getValue(4, "power"))
      fibaro:sleep(1000)
      aPower = fibaro:getGlobalValue("ampPower")
    end
  fibaro:call(91, "turnOff")
end
--]]

fibaro:debug(fibaro:getValue(89, "energy"))
fibaro:debug(fibaro:getValue(89, "showEnergy"))
fibaro:debug(fibaro:getValue(1, "sunriseHour"))
fibaro:debug(fibaro:countScenes())
mSensorValue = fibaro:getValue(97, "value")

if(mSensorValue == "1") then
  fibaro:call(93, "sendPush", "Det är någon vid dörren!")
  fibaro:debug("Skickat till Pär")
  fibaro:call(59, "sendPush", "Det är någon vid dörren!")
  fibaro:debug("Skickat till Maria")
  fibaro:call(71, "sendPush", "Det är någon vid dörren!")
  fibaro:debug("Skickat till Jojje")
  fibaro:sleep(10*60*1000)
end