local robot = require("robot");
local sides = require("sides");
local computer = require("computer");

local locationX, locationY, locationZ = 0, 0, 0

local north = 0
local east = 1
local south = 2
local west = 3

local direction = north

local radius = 5

local coordinateArray = {}

function move(x, y, z)
    deltaX = locationX - x
    deltaY = locationY - y
    deltaZ = locationZ - z

    if deltaX > 0 then
        traverse(north, deltaX)
    end
    if deltaY > 0 then
        traverse(east, deltaY)
    end
    if deltaX < 0 then
        traverse(south, -deltaX)
    end
    if deltaY < 0 then
        traverse(west, -deltaY)
    end
    if deltaZ > 0 then 
        for i = 0, deltaZ, 1 do
            robot.up()
        end
    else
        for i = 0, deltaZ, -1 do
            robot.down()
        end
    end

    locationX, locationY, locationZ = x, y, z
end

function traverse(newDirection, amount)
    if direction ~= newDirection then
        turnTowards(newDirection)
    end

    for i = 0, 10, 1 do
        robot.forward()
    end
end

function turnTowards(newDirection)
    while direction ~= newDirection do
        robot.turnRight()
        direction = (direction + 1) % 4
    end
end

function compareBlocks()
    robot.select(16)
    local isBlock = robot.detect(sides.down)
    computer.beep()
    robot.select(1)
    return isBlock
end

function initializeCoordinateArray()
    for x = -radius, radius, 1 do
        for y = -radius, radius, 1 do
            for z = -radius, radius, 1 do
                if ((x * x) + (y * y) + (z * z)) <= radius * 2 then
                    table.insert(coordinateArray, {x, y, z})
                end
            end
        end
    end
end

function main()
    initializeCoordinateArray()
    while true do
        for i, v in ipairs(coordinateArray) do
            move(v[1], v[2], v[3])
            if compareBlocks() then
                robot.swingDown()
            end
        end
    end
end

main()
