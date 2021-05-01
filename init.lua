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

function findCrop()
    for i=2, 5 do
        local isBlock, type = drone.detect(i)
        if type == "passable" then
            return i
        end
    end
end
  
function harvest()

    local direction = findCrop()
    local l, r, tx, tz
    if direction == 2 then l,r,tx,tz = 4,5,0,-1 end
    if direction == 3 then l,r,tx,tz = 5,4,0,1 end
    if direction == 4 then l,r,tx,tz = 3,2,-1,0 end
    if direction == 5 then l,r,tx,tz = 2,3,1,0 end

    drone.use(direction)
    for i=1, row.l do
    move(cx+tx, cy, cz+tz)
    colour("farming")
    drone.use(l)
    drone.use(r)
    if i < tonumber(row.l) then
        drone.use(direction)
    end
    end

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
