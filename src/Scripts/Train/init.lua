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

function trainMethods:StepMovement(trainDirection)
    self.states.direction = trainDirection
    
end

local function new(_trainConfig: {}, tempSensors, tempBody) -- Will be used after junctioning (SILENCED)

    local newTrain = setmetatable({
        trainConfig = {
            maxSpeed = 10,
            speed = 0
        },
        states = {
            movement = trainState.trainMovement.stationary,
            junction = trainState.trainJunction.none,
            direction = trainState.trainDirection.none
        },
        sensors = {{a = tempSensors.a, b = tempSensors.b}}, -- in order { [1] = {a = sensor, b = sensor}, ...} [1] = front of train
        trainBody = {{body = tempBody, sensor = {a = tempSensors.a, b = tempSensors.b}}} -- in order { [1] = { body = {}, sensor = {a = sensor, b = sensor} }, ...} [1] = front of train
    }, {__index = trainMethods})

    RunService.Heartbeat:Connect(function(_)
        newTrain:StepMovement(trainState.trainDirection.forward)
    end)
    return newTrain
end

return setmetatable({new = new}, {__index = trainMethods})