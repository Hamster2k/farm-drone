local running = true

local drone = component.proxy(component.list("drone")())

local clock = os.clock

function sleep(timeout)
    checkArg(1, timeout, "number", "nil")
    local deadline = computer.uptime() + (timeout or 0)
    repeat
        event.pull(deadline - computer.uptime())
    until computer.uptime() >= deadline
end

function moveOne()
    drone.setAcceleration(1)
    while drone.getOffset() > 0 do
        sleep(1)
    end
    drone.setAcceleration(0)
end

function drone.north()
    drone.move(0, -1, 0)
    moveOne()
end

function drone.east()
    drone.move(1, 0, 0)
    moveOne()
end

function drone.south()
    drone.move(0, 1, 0)
    moveOne()
end

function drone.west()
    drone.move(-1, 0, 0)
    moveOne()
end

while running do
    drone.north()
    drone.east()
    --south()
    --west()
end
