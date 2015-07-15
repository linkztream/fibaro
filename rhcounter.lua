function maxSteam(deg)
   -- returnerar max ånghalt för temp i g/kg luft
   local temp = deg
   local steam = ((4.7815706 + 0.34597292 * temp) +  
                  0.0099365776 * math.pow(temp, 2) + 
                  0.00015612096 * math.pow(temp, 3) + 
                  math.exp(1.9830825, -6) * math.pow(temp, 4) + 
                  math.exp(1.5773396, -8) * math.pow(temp, 5))
end
