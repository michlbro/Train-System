local junction = {}

local function new(sensorFound: BasePart, route: string)
    local newJunction = setmetatable({
        startingSensor = sensorFound
    }, {})
end

return setmetatable({new = new}, {})