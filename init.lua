local running = true

local drone = component.proxy(component.list("drone")())

local clock = os.clock

--drone position
local positionX = 0
local positionY = 0

--drone inventory
local inventory = 0

--relative position of the lower left corner of the field
local fieldLowerLeftCornerX = 1
local fieldLowerLeftCornerY = -2

--dimensions of the field
local fieldDimensionX = 2
local fieldDimensionY = 2

--local field coordinates
local fieldCoordinateX = nil
local fieldCoordinateY = nil

function move(targetX, targetY, targetZ)
    drone.move(targetX, targetY, targetZ)
    while drone.getVelocity() > 0 do
      computer.pullSignal(1)
    end
end

function moveHorizontal(x, y)
    move(x, 0, y)
    positionX = positionX + x
    positionY = positionY + y
end

function moveToNextFieldCoordinate()
    if fieldCoordinateX == nil
    then
        fieldCoordinateX = 0
        fieldCoordinateY = 0
        return moveHorizontal(fieldLowerLeftCornerX, fieldLowerLeftCornerY)
    end
    
    if  fieldCoordinateX == fieldDimensionX and fieldCoordinateY == fieldDimensionY
    then
        fieldCoordinateX = 0
        fieldCoordinateY = 0
        return moveHorizontal(-fieldDimensionX, -fieldDimensionY)
    end
    
    if fieldCoordinateX == fieldDimensionX
    then
        fieldCoordinateX = 0
        fieldCoordinateY = fieldCoordinateY + 1
        return moveHorizontal(-fieldDimensionX, 1)
    end
    
    fieldCoordinateX = fieldCoordinateX + 1
    return moveHorizontal(1, 0)
end

function harvest()
    drone.use(0)
    local pickedUpItems = drone.suck(0)
    inventory = inventory + pickedUpItems
end

function dropOffInventory()
    local currentX, currentY = positionX, positionY
    moveHorizontal(-currentX, -currentY)
    drop(0)
    moveHorizontal(currentX, currentY)
end
    
function main()
    while running do
        moveToNextFieldCoordinate()
        harvest()
        if inventory > 128 then
            dropOffInventory(0)
        end
    end
end

main()
