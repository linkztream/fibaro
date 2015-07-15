--[[
%% autostart
%% properties
83 ui.fuktighet.value
%% globals
--]]

if (fibaro:countScenes() > 1) then
 fibaro:abort()
end

-- Sätter upp variabler som kommer användas
local sourceTrigger = fibaro:getSourceTrigger()
local wStationID = 83
local avfuktare = {["ID"] = 69, ["runTime"] = tonumber(fibaro:getGlobalValue("avfktRuntime")), 
                  ["expRuntime"] = tonumber(fibaro:getGlobalValue("avfktExpRuntime"))}
local maxFukt = 65
local minFukt = 60
avfuktare.Status, avfuktare.Tid = fibaro:get(avfuktare.ID, "value")
local fukthalt = string.sub(fibaro:getValue(wStationID, "ui.fuktighet.value"), 1, 2)

-- Funktioner som kommer användas definieras här:

-- Funktion för att räkna hur länge avfuktaren gått sen senaste tömning.
function countRuntime(action)
   local runTime = {}
   
   if(action == "start") then
      runTime.start = os.time()
   
   elseif(action == "stop") then
      runTime.stop = os.time()
      avfuktare.runTime = avfuktare.runTime + (runTime.stop - runTime.start)
      fibaro:setGlobal("avfktRuntime", avfuktare.runTime)
   end
end

-- Funktion för att sätta förväntad körtid mellan tömningar.
function setExpRuntime()
   if(avfuktare.expRuntime == 0) then
      local newRuntime = avfuktare.runTime
   else
      local newRuntime = (avfuktare.expRuntime + avfuktare.runTime) / 2
      fibaro:setGlobal("avfktExpRuntime", newRuntime)
   end
end

function isRunning()
   -- Kolla om avfuktaren borde går eller inte.
   -- fibaro:getValue(35, "power")
end

function powerOn()
   -- Kolla att det har gått minst 8 minuter sen den gick sist.
   local minSleep = 480
   local startDelay = minSleep - (os.time() - avfuktare.Tid)
   
   if (startDelay > 0) then
      fibaro:debug("För tidigt att starta, vilar " .. startDelay .. " sekunder.")
      fibaro:sleep(startDelay * 1000)
   end

   -- fibaro:call(avfuktare.ID, "turnOn")
   fibaro:debug("Startar avfuktare")
   fibaro:call(38, "sendPush", "Avfuktare startad!")
   countRuntime("start")

end

function powerOff()
   -- fibaro:call(avfuktare.ID, "turnOff")
   fibaro:debug("Stänger av avfuktare")
   fibaro:call(38, "sendPush", "Avfuktare avstängd!")
   countRunTime("stop")
end

--[[  TODO: Räkna upp runTime och sätt till globala variabeln.
      När avfuktaren fått gå till den fylls och stänger av automatiskt,
      sätt globala avfktExpRuntime till (avfktExpRuntime + runTime)/2 och nolla sen runTime

      Skicka push när <50W (dvs, fullt tråg).

      Uppdatera en global variabel med "Uppskattad tid till fullt tråg" i formatet "HH:MM:SS"

      Gör funktioner av det här. ]]-- 

if(sourceTrigger["type"] == "property") then

elseif(sourceTrigger["type"] == "global") then

elseif(sourceTrigger["type"] == "other") then
   -- Startad manuellt
else
   fibaro:debug("Unknown trigger")
   fibaro:abort()
end
