local fukt = "80 %"

fukthalt = tonumber((string.sub(fukt,1,2)))
print(fukthalt)

if(fukthalt >= 59) then
	print("Fukthalten är " ..fukthalt)
	while(fukthalt >= 55) do
		print(fukthalt)
		fukthalt = (fukthalt -1)
		end
	print("Det här ska komma när loopen är klar!")
	else
		print("Det är inte fuktigt nog ("..fukthalt.."%)")
end



