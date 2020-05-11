local running = true

local drone = component.proxy(component.list("drone")())

local clock = os.clock

local cx, cy, cz = 0, 0, 0

local radius = 12

function sleep(timeout)
    checkArg(1, timeout, "number", "nil")
    local deadline = computer.uptime() + (timeout or 0)
    while deadline > computer.uptime()
    do
    end
end

function move(tx, ty, tz)
    local dx = tx - cx
    local dy = ty - cy
    local dz = tz - cz
    drone.move(dx, dy, dz)
    while drone.getOffset() > 0.7 or drone.getVelocity() > 0.7 do
      computer.pullSignal(0.2)
    end
    cx, cy, cz = tx, ty, tz
  end

function main()
    while running do
        local i = 0
        while i < radius do
            move(i, 0, 0)
            move(0, 0, i)
            i = 0 + 1
            move(-i, 0, 0)
            move(0, 0, -i)
            i = 0 + 1
        end

        while i > 0 do
            move(i, 0, 0)
            move(0, 0, i)
            i = 0 - 1
            move(-i, 0, 0)
            move(0, 0, -i)
            i = 0 - 1
        end
    end
end

main()
