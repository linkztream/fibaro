local fukthalt = 55
local wStation = 83
local avfuktareOn = 0

if(avfuktareOn == 1 and fukthalt > 55) then
	print("fukthalt h�g, avfuktare p�")
elseif(avfuktareOn ==0 and fukthalt >=55) then
	print("fukthalt h�g, avfuktare av")
elseif(avfuktareOn == 1 and fukthalt <55) then
	print("fukthalt l�g, avfuktare p�")
else
	print("l�g fukthalt, avfuktare av")
end
