--[[
%%properties
%%globals
]]--

local itemIds = {7,8,9,10,12,13,14,15,18,19,20}

function rfxlightsOut(itemList)
   
   local preString = "/json.htm?type=command&param=switchlight&idx="
   local postString = "&switchcmd=Off&level=0"
   local domo = Net.FHttp("10.0.16.32", 8080)

   for i,v in ipairs(itemList) do
      local cmd = (preString .. v .. postString)
      fibaro:sleep(500)
      local cmd = (preString .. v .. postString)
      response, status, errorCode = domo:GET(cmd)
      fibaro:debug("Släcker enhetsID: " .. v)
      fibaro:sleep(500)
   end
end

rfxlightsOut(itemIds)
