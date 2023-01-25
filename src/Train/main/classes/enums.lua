--!strict

export type EnumsTable = {
    [number]: string
}

export type EnumObject = {
    name: string,
    value: number
}

export type EnumsList = {
    [string]: EnumObject
}

local enum = {}

function enum.__eq(self, value)
    return (value.value and value.name) and ((self.value == value.value) and (self.name == value.name)) or (self.name == value)
end

local function new(name: string, value: number): EnumObject
    local newEnum = setmetatable({
        name = name,
        value = value
    } :: any, enum) :: EnumObject
    return newEnum
end

local function setup(enumsTable: EnumsTable): EnumsList
    local enumsCreated = {}
    for index, name in enumsTable do
        enumsCreated[name] = new(name, index)
    end
    return enumsCreated
end

return setmetatable({setup = setup, new = new}, {})