local fibsim = {}

function fibsim.debug(self, string)
   print(string)
end


function fibsim.call(self, id, op)
   if (op == "turnOn") then
      print("Slår på enhet med ID: " .. id)
   elseif (op == "turnOff")
      print("Slår av enhet med ID: " .. id)
   elseif (op == "sendPush")
      print("Skickar pushmeddelande till ID: " .. id)
   elseif (op == "pressButton")
      print("Trycker på knappen på vUnit " .. id)
   else
      print("Utförde just en: " .. op .. "på enhet: " .. id)
   end
end


function fibsim.sleep(self, time)
   print("Paus i: " .. time/1000 .. " sekunder")
end


fibaro = fibsim

fibaro:debug("test")
fibaro:call(5, "turnOn")
fibaro:sleep(4500)