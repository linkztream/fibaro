local fibsim = {}

function fibsim.debug(self, string)
   print(string)
end


function fibsim.call(self, id, op)
   if (op == "turnOn") then
      print("Slår på enhet med ID: " .. id)
   elseif (op == "turnOff") then
      print("Slår av enhet med ID: " .. id)
   elseif (op == "sendPush") then
      print("Skickar pushmeddelande till ID: " .. id)
   elseif (op == "pressButton") then
      print("Trycker på knappen på vUnit " .. id)
   else
      print("Utförde just en: " .. op .. "på enhet: " .. id)
   end
end

function fibsim.countScenes(self, id)
   print("Låtsas att jag räknar antalet scener som körs just nu...")
   return 1
end

function fibsim.abort(self)
   print("Abort skulle stoppa körningen här.")
end

function fibsim.sleep(self, time)
   print("Paus i: " .. time/1000 .. " sekunder")
end

function fibsim.getValue(self)
   return(1500)
end

fibaro = fibsim