local types = require(script.types)

local trainParams = {}

local function new(params: types.paramsParameter)
    local newTrainParams = setmetatable({
        
    }, {
        __index = trainParams
    })
end

export type params = types.paramsParameter

return setmetatable({
    new = new,
    enum = types.enums
}, {})