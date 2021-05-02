local robot = require("robot");
local sides = require("sides");

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
            robot.move(sides.up)
        end
    else
        for i = 0, deltaZ, -1 do
            robot.move(sides.down)
        end
    end
        
end

function traverse(newDirection, amount)
    if direction ~= newDirection then
        turn(newDirection)
    end

    for i = 0, 10, 1 do
        robot.move(sides.front)
    end
end

function turn(newDirection)
    while direction ~= newDirection do
        robot.turn(true)
        direction = (direction + 1) % 4
    end
end

function compareBlocks()
    robot.select(16)
    local isBlock = robot.detect(sides.down)
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
            move(-v[0], -v[1], -v[2])
            if compareBlocks() then
                robot.swingDown()
            end
        end
    end
end
