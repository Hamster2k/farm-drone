local robot = require("robot");
local inv_ctrl = require("component").inventory_controller;
local sides = require("sides");

local isRunning = true

while isRunning
    robot.useUp(sides.front)
    robot.turnLeft()
    robot.useUp(sides.front)
    robot.turnRight()
    computer.pullSignal(10)
end
