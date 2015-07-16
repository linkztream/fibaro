function maxSteam(deg)
   -- returnerar max ånghalt för temp i g/kg luft
   local temp = deg
   local steam = ((4.7815706 + 0.34597292 * temp) +  
                  0.0099365776 * math.pow(temp, 2) + 
                  0.00015612096 * math.pow(temp, 3) + 
                  1.9830825e-6 * math.pow(temp, 4) + 
                  1.5773396e-8 * math.pow(temp, 5))
   return steam
end


function newRH(currentTemp, newTemp, rh)
   --räknar ut nya luftfuktigheten om temperaturen ändras.
   local currentSteam = maxSteam(currentTemp) * (rh / 100)
   local newMaxSteam = maxSteam(newTemp)
   local newRH = (math.ceil((currentSteam / newMaxSteam) * 100) .. " %")
   return newRH
end
