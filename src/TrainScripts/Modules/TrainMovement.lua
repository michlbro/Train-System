local modules = script.Parent
local trainState = require(modules:WaitForChild("TrainStates"))
local trainSensorRaycast = require(modules:WaitForChild("TrainSensorRaycast"))

local tracksFolder = workspace.Tracks--<pathToTracksFolder>

local trainMovement = {}

function trainMovement.Step(direction, _trainConfig, sensors)
    local amount = (direction == trainState.direction.forward) and 1 or (direction == trainState.direction.backward) and -1 or 0
    -- Physics here will change these 1, -1 and 0 values
    -- Using Suvat equations

    -- Check for sensors
    local sensor, sensorType = trainSensorRaycast.CastRay()

    trainMovement.AlignSensors(sensors)
    trainMovement.ApplyMovement(amount, sensors)
end

function trainMovement.IsObjectFacing(object, anotherObject)
    return object.CFrame.LookVector:Dot(anotherObject.CFrame.LookVector) > 0
end

function trainMovement.CalculateMean(sensor, touchingTracks, referencePartNameToAlign)
    local meanPosition = Vector3.zero
    local meanOrientation = Vector3.zero
    local trackCount = 0
    for _, track: BasePart in touchingTracks do
        if not (track.Name == referencePartNameToAlign) then
            continue
        end
        trackCount += 1
        local trackCFrame = sensor.CFrame:ToObjectSpace(track.CFrame)
        meanPosition += trackCFrame.Position
        local currentOrientation = Vector3.new(trackCFrame:ToOrientation())
        if not trainMovement.IsObjectFacing(sensor, track) then -- If track is not facing the right direction:
            currentOrientation = Vector3.new((trackCFrame * CFrame.Angles(0, math.pi, 0)):ToOrientation()) -- Mirror the track
        end
        meanOrientation += currentOrientation
    end
    return trackCount > 0, meanPosition/trackCount, meanOrientation/trackCount
end

function trainMovement.AlignSensors(sensors)
    -- Check if sensors are in contact with TrackPart. If not, respawn player and despawn train (WIP. For now, just let the train teleport back to (0, 0, ~))
    local trackToCheck = "TrackPart"
    for _, sensor in sensors do
        local sensorA = sensor.a
        local sensorB = sensor.b

        -- Align train script
        local trackOverlapParams = OverlapParams.new()
	    trackOverlapParams.FilterType = Enum.RaycastFilterType.Whitelist
	    trackOverlapParams.FilterDescendantsInstances = {tracksFolder}
	
	    -- // Using :GetPartsInParts to get touching tracks.
	    local frontTracks = workspace:GetPartsInPart(sensorA, trackOverlapParams)
	    local backTracks = workspace:GetPartsInPart(sensorB, trackOverlapParams)
        
        local frontTrackIsTouchingTrack, meanFrontPosition, meanFrontOrientation = trainMovement.CalculateMean(sensorA, frontTracks, trackToCheck)
        local backTrackIsTouchingTrack, meanBackPosition, meanBackOrientation = trainMovement.CalculateMean(sensorB, backTracks, trackToCheck)
        if frontTrackIsTouchingTrack then
            sensorA.CFrame *= CFrame.new(meanFrontPosition.X, meanFrontPosition.Y, 0) * CFrame.Angles(meanFrontOrientation.X,meanFrontOrientation.Y, meanFrontOrientation.Z)
        end
        if backTrackIsTouchingTrack then
            sensorB.CFrame *= CFrame.new(meanBackPosition.X, meanBackPosition.Y, 0) * CFrame.Angles(meanBackOrientation.X,meanBackOrientation.Y, meanBackOrientation.Z)
        end
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
            continue
        end
        sensorA.CFrame *= CFrame.new(0,0,amount)
        sensorB.CFrame *= CFrame.new(0,0,amount)
    end
end

return trainMovement