local enum = require(script.Parent.Parent.enums)

export type paramObject = {
    trainName: string
}

export type paramsParameter = {
    owners: {Player},
    trainName: string,
    route: string,
    trainType: enum.EnumObject
}

return {
    enums = {
        trainType = enum.setup({
            "Diesel", "Electric"
        })
    }
}