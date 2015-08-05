clocktime = "21:34"

print(clocktime)

function epochTime(tString)
   local hour, min = string.match(clocktime, "(%d+):(%d+)")
   local time = os.date("*t")
   return os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
end

flatTime = epochTime(clocktime)

print("Tiden " .. clocktime .. " blir " .. flatTime .. " i epoktid. \n")

print("Dubbelkoll: \n")
testTime = os.date("*t", flatTime)
print(testTime.hour .. ":" .. testTime.min)

print("Drar av 40 minuter på testtiden.")

newTime = os.date("*t", flatTime-40*60)

print(newTime.hour .. ":" .. newTime.min)


fibaro:setGlobal("ampPower", fibaro:getValue(4, "power"))
fibaro:sleep(1000)