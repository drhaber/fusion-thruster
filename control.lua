
local function on_init()
    storage.fusionthruster = storage.fusionthruster or {}
    storage.fusionthruster.entities = storage.fusionthruster.entities or {}
    storage.fusionthruster.assem = storage.fusionthruster.assem or {} 
    storage.fusionthruster.unit = storage.fusionthruster.unit or {}
end

local function on_built(event)
    local entity = event.entity
    if not entity then
        return
    end

    if entity.name == "fusion-thruster" then

        local pos = entity.position.x .. " " .. entity.position.y
        local assem_pos = {
            x = entity.position.x ,
            y = entity.position.y ,
        }

        local assem = entity.surface.create_entity {
            name = "fusionthruster-thruster-chamber",
            position = assem_pos,
            force = entity.force,
            direction = entity.direction,
            destructible = false
        }
        storage.fusionthruster.assem[pos .. "_1"] = assem

        storage.fusionthruster.entities[pos] = entity

        if entity.unit_number then
            storage.fusionthruster.unit[entity.unit_number] = {
                entity = entity.unit_number,
                assem = assem.unit_number,
            }
        end

    end
end

local function on_entity_died(event)
    local entity = event.entity
    if not entity then
        return
    end


    local pos = entity.position.x .. " " .. entity.position.y


    if storage.fusionthruster.entities[pos] ~= nil then

        if storage.fusionthruster.assem[pos .. "_1"] then
            storage.fusionthruster.assem[pos .. "_1"].destroy()
            storage.fusionthruster.assem[pos .. "_1"] = nil
        end


        storage.fusionthruster.entities[pos] = nil

        if entity.unit_number then
            storage.fusionthruster.unit[entity.unit_number] = nil
        end
    end
end

local filter = { { filter = "name", name = "fusion-thruster" } }

script.on_init(on_init)
script.on_configuration_changed(on_init)

script.on_event(defines.events.on_robot_built_entity, on_built, filter)
script.on_event(defines.events.on_built_entity, on_built, filter)
script.on_event(defines.events.script_raised_revive, on_built, filter)
script.on_event(defines.events.script_raised_built, on_built, filter)
script.on_event(defines.events.on_space_platform_built_entity, on_built, filter)

script.on_event(defines.events.on_entity_died, on_entity_died, filter)
script.on_event(defines.events.script_raised_destroy, on_entity_died, filter)
script.on_event(defines.events.on_robot_pre_mined, on_entity_died, filter)
script.on_event(defines.events.on_space_platform_mined_entity, on_entity_died, filter)
script.on_event(defines.events.on_pre_player_mined_item, on_entity_died, filter)      