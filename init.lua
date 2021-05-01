local running = true

local drone = component.proxy(component.list("drone")())

local clock = os.clock

--drone position
local positionX = 0
local positionY = 0

--relative position of the lower left corner of the field
local fieldLowerLeftCornerX = 3
local fieldLowerLeftCornerY = 2

--dimensions of the field
local fieldDimensionX = 3
local fieldDimensionY = 3

--local field coordinates
local fieldCoordinateX = nil
local fieldCoordinateY = nil

function sleep(timeout)
    checkArg(1, timeout, "number", "nil")
    local deadline = computer.uptime() + (timeout or 0)
    while deadline > computer.uptime()
    do
    end
end

function move(targetX, targetY, targetZ)
    drone.move(targetX, targetY, targetZ)
    while drone.getVelocity() > 0 do
      computer.pullSignal(0.2)
    end
end

function moveHorizontal(x, y)
    move(x, 0, z)
    positionX = positionX + x
    positionY = positionY + y
end

function moveToNextFieldCoordinate()
    if fieldCoordinateX == nil
        fieldCoordinateX = 0
        fieldCoordinateY = 0
        return moveHorizontal(fieldLowerLeftCornerX, fieldLowerLeftCornerY)
    
    if  fieldCoordinateX == fieldDimensionX and fieldCoordinateY == fieldDimensionY
        fieldCoordinateX = 0
        fieldCoordinateY = 0
        return moveHorizontal(-fieldDimensionX, -fieldDimensionY)
    
    if fieldCoordinateX == fieldDimensionX
        fieldCoordinateX = 0
        fieldCoordinateY = fieldCoordinateY + 1
        return moveHorizontal(-fieldDimensionX, 1)
    
    fieldCoordinateX = fieldCoordinateX + 1
        return moveHorizontal(1, 0)
    

function main()
    while running do
        moveToNextFieldCoordinate()
    end
end

main()
