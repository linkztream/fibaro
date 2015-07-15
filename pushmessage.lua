--[[

%% properties

58 valueSensor

%% globals

--]]

-- change id 58 to what id you want to have for monitoring



local power = fibaro:getValue(58, "valueSensor") -- monitored unit 
local washOn = "washRuns" -- create a variable washRuns
local washDone = "washDone" -- create a variable with name washDone
local push = "washPush" -- variable for push

fibaro:debug("HC2 wash script started: " .. os.date()); 
fibaro:debug("Consumption="..power.." Watt")


if (tonumber(power) > 500) then  -- change to wanted value in watt
    fibaro:setGlobal(washOn, "1")  -- sets variable to 1 if machine is running
  	fibaro:setGlobal(washDone, "0") -- sets variable washDone to 0
  	fibaro:setGlobal(push, "0") -- sets variable push to 0
  	fibaro:debug("Tvättmaskinen går")  -- lite debug text :)

elseif (tonumber(power) < 5) then
  fibaro:debug("Washing machine not running.")
  fibaro:setGlobal(washOn, "0")  
  fibaro:setGlobal(washDone, "1") -- Washing is completed!

end
if (tonumber(power) < 5)  and fibaro:getGlobalValue(washDone) == "1" and fibaro:getGlobalValue(push) == "0" then
  fibaro:setGlobal(push, "1")
  fibaro:debug("Send push message")
  fibaro:call(38,"sendPush","Wash machine is done!")  -- change 22 to your phones ID
end