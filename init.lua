local running = true

local drone = component.proxy(component.list("drone")())

local clock = os.clock

function sleep(timeout)
    checkArg(1, timeout, "number", "nil")
    local deadline = computer.uptime() + (timeout or 0)
    while deadline > computer.uptime()
    do
    end
end

function moveOne()
    drone.setAcceleration(1)
    while drone.getOffset() > 0.5 do
        sleep(1)
    end
end

function drone.north()
    drone.move(0, -1, 0)
end

function drone.east()
    drone.move(1, 0, 0)
end

function drone.south()
    drone.move(0, 1, 0)
end

function drone.west()
    drone.move(-1, 0, 0)
end

function drone.up()
    drone.move(0, 0, 1)
end

drone.up()
drone.north()
drone.setAcceleration(1)
while drone.getOffset() > 0.5 do
    sleep(1)
end
drone.setAcceleration(0)
