local raycasts = {}

function raycasts.GetTrackParts(tracker: BasePart, tracks: Folder, trackName: string)
    local overlapParams = OverlapParams.new()
    overlapParams.FilterDescendantsInstances = {tracks}
    overlapParams.FilterType = Enum.RaycastFilterType.Whitelist

    local objectsFound = workspace:GetPartsInPart(tracker, overlapParams)
    local trackParts = {}
    for _, trackPart in objectsFound do
        if trackPart.Name ~= trackName then
            continue
        end
        table.insert(trackParts, trackPart)
    end
    return trackParts
end

function raycasts.FindSensors(tracker: BasePart, sensors: Folder)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {sensors}
    raycastParams.FilterType = Enum.RaycastFilterType.Whitelist

    local trackerCFrame = tracker.CFrame
    local distance = 1
    local raycastDirection = trackerCFrame.LookVector
    local origin = trackerCFrame.Position + Vector3.new(0,0,0)

    local frontResult = workspace:Raycast(origin, raycastDirection * distance, raycastParams)
    local backResult = workspace:Raycast(origin, -raycastDirection * distance, raycastParams)
    return frontResult, backResult
end

return raycasts