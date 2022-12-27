local debugging = require(script.Debug)

local remotes = workspace.path
local junctionSensorPath = workspace.sensor.junctions

local junctionTree = {
    possibleJunctionNames = {
        "A", "B", "C"
    },
    mainToXJunction = {
        --[[
            [mainJunction] = {
                aJunction, bJunction, cJunction
            }, ...
        ]]
    },
    xJunction = {
        --[[
            [aJunction] = {
                routes = {}
                slider = sliderA
                main = mainJunction -- TBD: If train is heading from aJunction down to main, we dont want it to do anything with Main other than switch back to TrackParts.
            }, ...
        ]]
    }
}

for _, junction: Model in junctionSensorPath:GetChildren() do
    local mainSensor = junction:FindFirstChild("Main")
    if not mainSensor then
        debugging.warn(junction, "Missing Main Sensor. Will ignore this junction.")
        continue
    end
    local mainJunctionTree = {}

    for _, sensor in junction:GetChildren() do
        if not table.find(junctionTree.possibleJunctionNames, sensor.Name) then
            continue
        end
        -- Find its slider name
        local sensorSlider = junction:FindFirstChild(string.format("Slider%s", sensor.Name))
        if not sensorSlider then
            debugging.warn(sensor, "Missing SliderX. Will ignore this sensorJunction.")
            continue
        end
        -- Get sensor routes
        local routes = {}
        for _, route in sensor:GetChildren() do
            if not route:IsA("NumberValue") then
                continue
            end
            routes[route.Name] = route
        end
        -- Setup table
        junctionTree.xJunction[sensor] = {
            routes = routes,
            slider = sensorSlider,
            main = mainSensor
        }
        table.insert(mainJunctionTree, sensor)
    end
    junctionTree.mainToXJunction[mainSensor] = mainJunctionTree
end

local function OnJunctionInvoke(sensorInvoked)
    return junctionTree.xJunction[sensorInvoked] or junctionTree.mainToXJunction[sensorInvoked]
end

local binableFunction: BindableFunction = remotes:WaitForChild("TrainJunctionInvoke")

binableFunction.OnInvoke = OnJunctionInvoke
