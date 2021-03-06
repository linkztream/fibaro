sunsetHour = "20:58"
sunriseHour = "05:03"
scheduler = {
                  {"sunsetHour+25", "22:00", "1", "on"},
                  {"17:15", "23:00", "3", "off"},
                  {"8:25", "sunsetHour", "2", "on"},
                  {"21:15", "21:00", "4", "off"}
                  }


  
function epochTime(tString)
   local time = os.date("*t")
   local epTime = 0

   if (string.match(tString, "sun.+")) then
      if (string.match(tString, "rise")) then
            local hour, min = string.match(sunriseHour, "(%d+):(%d+)")
            epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
         else
            local hour, min = string.match(sunsetHour, "(%d+):(%d+)")
            epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
         end
      if string.match(tString, "[%+%-]%d+$") then
         local offset = (tonumber(string.match(tString, "%d+$"))) * 60
         if (string.match(tString, "%+")) then
            epTime = epTime + offset
         else
            epTime = epTime - offset
         end
      end
   elseif (string.match(tString, "(%d+):(%d+)")) then
      local hour, min = string.match(tString, "(%d+):(%d+)")
      epTime = os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
   end
   return epTime

end


function generateschedule(schedarray)
   local compiledSchedule = {}
    
   for i=1,#schedarray do
      schedarray[i][1] = epochTime(schedarray[i][1])
      schedarray[i][2] = epochTime(schedarray[i][2])

      -- kolla så att det inte är någon tid som börjar efter den ska sluta.
      if (schedarray[i][1] >= schedarray[i][2]) then
         do break end
      end

      table.insert(compiledSchedule, {schedarray[i][1], schedarray[i][3], "on"})
      table.insert(compiledSchedule, {schedarray[i][2], schedarray[i][3], "off"})
   end
   return compiledSchedule
end


function bubblesort(array)
   local n = #array -1
   while n > 0 do
      x = 1
      while x < #array do
         if (array[x][1] > array[x+1][1]) then
            a = table.remove(array, x)
            table.insert(array, x+1, a)
            x = x + 1
         else
            x = x + 1
         end
      end
      n = n - 1
   end
end

newArray = generateschedule(scheduler)

bubblesort(newArray)


for i,v in ipairs(newArray) do
   print(v[1] .. " " .. v[2] .. " " .. v[3] .. " ")
   -- for ii,iv in ipairs(v) do
   --    print(iv)
   -- end
end
