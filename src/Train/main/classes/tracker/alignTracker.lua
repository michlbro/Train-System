local alignTracker = {}

local function IsTrackPartSameOrientation(trackerCFrame: CFrame, trackPartCFrame: CFrame): boolean
    return trackerCFrame.LookVector:Dot(trackPartCFrame.LookVector) >= 0
end

function alignTracker.Align(trackParts: {BasePart}, tracker: BasePart)
    local trackerCFrame = tracker.CFrame
    local meanLocalPostion = Vector3.zero
    local meanLocalOrientation = Vector3.zero

    local count = 0
    for index, track in trackParts do
        local trackCFrame = track.CFrame
        local localTrackCFrame = trackCFrame:ToObjectSpace(trackerCFrame)
        local isSameOrientation = IsTrackPartSameOrientation(trackerCFrame, trackCFrame)

        meanLocalPostion += localTrackCFrame.Position
        meanLocalOrientation += isSameOrientation and Vector3.new(localTrackCFrame:ToOrientation()) or Vector3.new((localTrackCFrame * CFrame.Angles(0, math.pi, 0)):ToOrientation())
        count = index
    end

    meanLocalPostion /= count > 0 and count or 1
    meanLocalOrientation /= count > 0 and count or 1
    trackerCFrame *= CFrame.Angles(meanLocalOrientation.X, meanLocalOrientation.Y, meanLocalOrientation.Z)
    trackerCFrame *= CFrame.new(meanLocalPostion.X, meanLocalPostion.Y, 0)
    tracker.CFrame = trackerCFrame
end

return alignTracker