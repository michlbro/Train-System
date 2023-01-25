local raycasts = require(script.raycasts)
local alignTracker = require(script.alignTracker)

local tracker = {}

function tracker:Step()
    self:UpdateSensors()
    self:AlignTracker()
end

function tracker:UpdateSensors()
    local frontSensor, backSensor = raycasts.FindSensors(self.instance, self.sensors)
    self.sensor.back = backSensor
    self.sensor.front = frontSensor
    if self.currentJunction then
        if (frontSensor and frontSensor.Instance == self.junction.target) or (backSensor and backSensor.Instance == self.junction.target)then
            self.currentJunction:Destroy()
            self.currentJunction = nil
            self.junction.target = nil
            self.junction.queried = nil
        end
    end
end

function tracker:AlignTracker()
    local shouldFollowJunction = self.currentJunction
    if shouldFollowJunction then
        local trackparts = raycasts.GetTrackParts(self.instance, self.currentJunction:GetTracks(), self.currentJunction:GetTrackName())
        alignTracker.Align(trackparts, self.instance)
        return
    end
    local trackparts = raycasts.GetTrackParts(self.instance, self.currentJunction and self.currentJunction:GetTracks() or self.trackparts, self.currentJunction and  "TrackParts")
    alignTracker.Align(trackparts, self.instance)
end

function tracker:FollowJunction(junction)
    self.junction = junction
    self.junction.queried = junction:InitalSensor()
    self.junction.target = junction:GetTargetSensor()
end

function tracker:GetSensors()
    return self.raycastObjects.sensor
end

local function new(trackerObject: BasePart, trackParts: Folder, sensors: Folder)
    local newTracker = setmetatable({
        trackParts = trackParts,
        sensors = sensors,
        instance = trackerObject,
        junction = {
            currentJunction = nil,
            queried = nil,
            target = nil
        },
        sensor = {
            back = nil,
            front = nil
        }
    }, {
        __index = tracker
    })

    return newTracker
end

return setmetatable({new = new}, {})
