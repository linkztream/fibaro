a = {status = 1, power = 50, running = 0}

function a:checkstatus()
    local running = (a.status == 1 and a.power > 25)
    return running
end

for i, v in pairs(a) do
    print(i, v)
end