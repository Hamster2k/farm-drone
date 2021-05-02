local robot = require("robot");
local sides = require("sides");

local isRunning = true

while isRunning do
    robot.useUp(sides.front)
    robot.turnLeft()
    robot.useUp(sides.front)
    robot.turnRight()
    computer.pullSignal(10)
end
