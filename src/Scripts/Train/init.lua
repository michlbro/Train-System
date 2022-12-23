-- Services
local RunService = game:GetService("RunService")


-- Folders
local train = script.Parent.Parent
local _remotes = train:WaitForChild("Remotes") -- Will be done after junctioning (SILENCED)
local modules = train.Scripts:WaitForChild("Modules")

-- Modules
local trainState = require(modules:WaitForChild("TrainStates"))
local trainMovement = require(modules:WaitForChild("TrainMovement"))
local _trainAttachment = require(modules:WaitForChild("TrainAttachment")) -- Will be done after physics and junctioning (SILENCED)


local trainMethods = {}

function trainMethods:Step()
    if self.states.movement == trainState.movement.mobile then
        trainMovement.Step(self.states.direction, self.trainConfig)
    end
end

local function new(_trainConfig: {}, tempSensors, tempBody) -- Will be used after junctioning (SILENCED)

    local newTrain = setmetatable({
        trainConfig = {
            maxSpeed = 10,
            setSpeed = 0,
            currentSpeed = 0
        },
        states = {
            movement = trainState.trainMovement.stationary,
            junction = trainState.trainJunction.none,
            direction = trainState.trainDirection.none
        },
        sensors = {{a = tempSensors.a, b = tempSensors.b, distance = 10}}, -- in order { [1] = {a = sensor, b = sensor, distance = number}, ...} [1] = front of train
        trainBody = {{body = tempBody, sensor = {a = tempSensors.a, b = tempSensors.b}}} -- in order { [1] = { body = {}, sensor = {a = sensor, b = sensor}, distance = number}, ...} [1] = front of train
    }, {__index = trainMethods})
    
    -- TESTING
    newTrain.trainConfig.setSpeed = 5
    RunService.Heartbeat:Connect(function(_)
        newTrain:Step()
    end)
    return newTrain
end

return setmetatable({new = new}, {__index = trainMethods})