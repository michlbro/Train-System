local modules = script.Parent
local trainState = require(modules:WaitForChild("TrainStates"))

local trainMovement = {}

function trainMovement.Step(direction, trainConfig, sensors)
    local direction = (direction == trainState.direction.forward) and 1 or (direction == trainState.direction.backward) and -1 or 0
    -- Physics here will change these 1, -1 and 0 values
    -- Using Suvat equations

    trainMovement.AlignSensors(direction, sensors)
    trainMovement.ApplyMovement(direction, sensors)
end

function trainMovement.AlignSensors(sensors)
    -- Check if sensors are in contact with TrackPart. If not, respawn player and despawn train (WIP. For now, just let the train teleport back to (0, 0, ~))
    local trackToCheck = "TrackPart"
    for _, sensor in sensors do
        local sensorA = sensor.a
        local sensorB = sensor.b

        -- Align train script
    end
end

function trainMovement.ApplyMovement(amount, sensors)
    -- For loop through sensors from the back forward then apply amount forward checking that sensor B is not going to go beyond sensor A (vice versa) or that sensor A or B is not going to go further than each other.
    -- WIP check relative distance between sensorB of sensorIndex-1 and current sensorA, check if their distance satisfy criteria. Prevents wagons from colliding with each other??
    for sensorIndex = #sensors, 1, -1 do
        local sensorA = sensors[sensorIndex].a
        local sensorB = sensors[sensorIndex].b
        local relativeDistance = sensors[sensorIndex].distance
        
        local distanceAfterAddition = ((sensorA.Position - sensorB.Position).Magnitude + (amount/2))
        if not distanceAfterAddition <= relativeDistance then -- Allows sensor to catch up with each other incase they aren't even for some reason??
            sensorA.CFrame *= (math.sign(amount) == 1) and CFrame.new(0,0,0) or (math.sign(amount) == -1) and CFrame.new(0,0,amount)
            sensorB.CFrame *= (math.sign(amount) == -1) and CFrame.new(0,0,0) or (math.sign(amount) == 1) and CFrame.new(0,0,amount)
            return
        end
        sensorA.CFrame *= CFrame.new(0,0,amount)
        sensorB.CFrame *= CFrame.new(0,0,amount)
    end
end

return trainMovement