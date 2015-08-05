-- THE scheduler.

local uBel = {3, 12, 23, 55}
local mysBel = {4, 22, 23, 26}
local singleDev = 3
local sunriseHour = "04:45"
local sunsetHour = "21:15"

---[[
local schedule = {"sunsetHour" = "uBel, on",
                  "19:30" = "mysBel, on",
                  "22:30" = "mysBel, off",
                  "23:00" = "uBel, off",}
]]--

-- === funktionsblock ===


function executor(dev, command, offset)
   local tDev = dev
   local tCommand = string.lower(command)
   local toffset = offset or nil

   if (type(tDev) == "table") then
      for i, v in ipairs(tDev) do
         print(v)
      end
   else
      print(type(dev))
   end
   print(toffset)
   print(tCommand)
end


function devType(devID)
   -- virtual_device
end


function epochTime(tString)
   local hour, min = string.match(tString, "(%d+):(%d+)")
   local time = os.date("*t")
   return os.time({year=time.year, month = time.month, day = time.day, hour = hour, min = min})
end


function prepSchedule(schedule)
   local sortedSchedule = {}
   for i, v in pairs(schedule) do
      if string.match(i, "(sun[a-z]*Hour)([+-])(%d+)") then
         local sun, mod, mins = string.match(i, "(sun[a-z]*Hour)([+-])(%d+)")
      elseif string.match(i, "(sun[a-z]*Hour)") then
         local sun = string.match(i, "(sun[a-z]*Hour)")
         sun = epochTime(sun)
         sortedSchedule[sun] = v
      end

   -- läs in schedule och omvandla till epoktid.
end


mod, amount = string.match(offset, "([-+])(%d+)")