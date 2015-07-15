--[[
%% autostart
%% properties
83 ui.fuktighet.value
%% globals
--]]

if (fibaro:countScenes() > 1) then
    fibaro:abort()
end


-- Sätt alla börvärden och variabler som behövs.
local wStation = 83
local maxFukt = 63
local minFukt = 58
local pushDev = 93
local fukthalt = tonumber(string.sub(fibaro:getValue(wStation, "ui.fuktighet.value"), 1, 2))


avfuktare = {  id = 69, 
               runtime = tonumber(fibaro:getGlobalValue("avfktRuntime")) or 0, 
               expruntime = tonumber(fibaro:getGlobalValue("avfktExpRuntime")) or 0,
               status = 0,
               mtime = 0,
            }


function avfuktare.getStatus()
    avfuktare.status, avfuktare.mtime = fibaro:get(avfuktare.id, "value")
    avfuktare.power = math.floor(fibaro:get(avfuktare.id, "power"))
    avfuktare.running = (avfuktare.power > 100)
end


function avfuktare.updateRuntime()
    local runtime = tonumber(fibaro:getGlobalValue("avfktRuntime"))
    local modtime = tonumber(fibaro:getGlobalModificationTime("avfktRuntime"))
    local startTime = tonumber(fibaro:getGlobalModificationTime("avfktStart"))
    if (avfuktare.running) then
        if (startTime > modtime) then
            runtime = runtime + (os.time() - startTime)
        else
            runtime = runtime + (os.time() - modtime)
        end
    end
    fibaro:debug("Ny körtid satt till: ".. runtime)
    fibaro:setGlobal("avfktRuntime", runtime)
end


function avfuktare.updateExpruntime()
    local expruntime = tonumber(fibaro:getGlobalValue("avfktExpRuntime"))
    local runtime = tonumber(fibaro:getGlobalValue("avfktRuntime"))
    expruntime = math.ceil((expruntime + runtime)/2)
    fibaro:setGlobal("avfktExpRuntime", expruntime)
    fibaro:debug("Uppdaterar förväntad körtid med ".. expruntime)
    fibaro:setGlobal("avfktRuntime", 0)
end


function avfuktare.pushNotify(devid, message)
    fibaro:call(devid, "sendPush", message)
end


function avfuktare.start()
    local minSleep = 480
    local startDelay = minSleep - (os.time() - avfuktare.mtime)
    if startDelay > 0 then
        fibaro:debug("För nära föregående start. Vilar " .. startDelay .. " sekunder.")
        fibaro:sleep(startDelay * 1000)
    end
    fibaro:call(avfuktare.id, "turnOn")
    fibaro:setGlobal("avfktStart", os.time())
    avfuktare.pushNotify(pushDev, "Avfuktare startad!")
    fibaro:call("Startar avfuktare")
end


function avfuktare.stop()
    fibaro:call(avfuktare.id, "turnOff")
    fibaro:setGlobal("avfktStop", os.time())
    avfuktare.pushNotify(pushDev, "Avfuktare avstängd!")
    fibaro:debug("Stänger av avfuktare")
end

function avfuktare.full()
    if (avfuktare.status == "1" and avfuktare.power < 50) then
        -- Kolla så att den verkligen är idle och inte bara växlar läge.
        local c = 0
        while c < 5 do
            fibaro:sleep(5000)
            avfuktare.getStatus()
            if avfuktare.power > 300 then
                fibaro:abort()
            end
            c = c + 1
        end

        avfuktare.pushNotify(pushDev, "Avfuktaren är full!")
        while avfuktare.power < 300 do
            fibaro:sleep(5000)
            avfuktare.getStatus()
        end
        fibaro:setGlobal("avfktStart", os.time())
        avfuktare.updateExpruntime()
    end
end

avfuktare.getStatus()
avfuktare.updateRuntime()
avfuktare.full()

if (fukthalt >= maxFukt) then
    if (avfuktare.status == "0") then
        avfuktare.start()
    end

    elseif (fukthalt <= minFukt) then
        if (avfuktare.status == "1") then
            avfuktare.stop()
        end
    else
        fibaro:abort()
end