local junction = {}

function junction:GetTracks()
    return self.tracks
end

function junction:GetTrackName()
    return self.trackName
end

function junction:Destroy()
    self.route = nil
    self.trackName = nil
    self.startingSensor = nil
    self.targetSensor = nil
end

function junction:InitialSensor()
    return self.startingSensor
end

function junction:GetTargetSensor()
    return self.targetSensor
end

local function new(sensorFound: BasePart, route: string)
    local newJunction = setmetatable({
        route = route,
        trackName = "",
        startingSensor = sensorFound,
        targetSensor = nil,
        tracks = {}
    }, {})
    -- setup junction here.
    -- calculate the track route here.
    return newJunction
end

return setmetatable({new = new}, {})