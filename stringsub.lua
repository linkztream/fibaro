local fukt = "80 %"

fukthalt = tonumber((string.sub(fukt,1,2)))
print(fukthalt)

if(fukthalt >= 59) then
	print("Fukthalten �r " ..fukthalt)
	while(fukthalt >= 55) do
		print(fukthalt)
		fukthalt = (fukthalt -1)
		end
	print("Det h�r ska komma n�r loopen �r klar!")
	else
		print("Det �r inte fuktigt nog ("..fukthalt.."%)")
end



