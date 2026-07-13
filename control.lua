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
            quality = entity.quality,
            direction = entity.direction,
            destructible = false
        }
        storage.fusionthruster.assem[assem.unit_number] = assem

        storage.fusionthruster.entities[entity.unit_number] = entity

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

    if entity.unit_number then
        if storage.fusionthruster.entities[entity.unit_number] ~= nil then
            local assem_unit_number = storage.fusionthruster.unit[entity.unit_number].assem
            if storage.fusionthruster.assem[assem_unit_number] then
                storage.fusionthruster.assem[assem_unit_number].destroy()
                storage.fusionthruster.assem[assem_unit_number] = nil
            end

            storage.fusionthruster.entities[entity.unit_number] = nil
            storage.fusionthruster.unit[entity.unit_number] = nil
        else 
            local entities = entity.surface.find_entities({{entity.position.x - 3, entity.position.y - 3},{entity.position.x + 3, entity.position.y + 3}})

            for i = 1, #entities do
                local assem_unit_number = storage.fusionthruster.unit[entity.unit_number].assem
                if entities[i].unit_number == assem_unit_number then
                    entities[i].destroy()
                    if entity.unit_number then
                        storage.fusionthruster.unit[entity.unit_number] = nil
                    end
                    break
                end
            end
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
