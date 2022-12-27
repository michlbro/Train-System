local sensors = workspace.Sensors

local trainSensorRaycast = {}

function trainSensorRaycast.IsASensor(object: BasePart)
    local sensorType = object:FindFirstChildWhichIsA("StringValue")
    return sensorType
end

function trainSensorRaycast.CastRay(direction, trainSensor)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
    raycastParams.FilterDescendantsInstances = {sensors}

    local trainSensorCFrame: CFrame = trainSensor.CFrame
    local rayResult = workspace:Raycast(trainSensorCFrame.Position, trainSensorCFrame.LookVector * 0.9 * direction, raycastParams)

    if rayResult then
        local sensor = rayResult.Instance
        local sensorType = trainSensorRaycast.IsASensor(sensor)
        if not sensorType then
            return
        end
        return sensor, sensorType
    end
end

return trainSensorRaycast