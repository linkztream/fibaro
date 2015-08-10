local scheduler = {
                  {"7:15", "1", "on"},
                  {"17:15", "3", "off"},
                  {"8:25", "2", "on"},
                  {"21:15", "4", "off"}
                  }

function epochTime(tString)
   local hour, min = string.match(tString, "(%d+):(%d+)")
   local time = os.date("*t")
   return os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
end

 
for i=1,#scheduler do
   scheduler[i][1] = epochTime(scheduler[i][1])
end


function bubblesort(array)
   n = #array -1
   while n > 0 do
      x = 1
      while x < #array do
         if (array[x][1]>array[x+1][1]) then
            a = table.remove(array, x)
            table.insert(array,x+1, a)
            x = x + 1
         else
            x = x + 1
         end
      end
      n = n - 1
   end
end

bubblesort(scheduler)


for i,v in ipairs(scheduler) do
   for ii, iv in ipairs(v) do
      print(iv)
   end
end
