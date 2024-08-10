lib.addCommand('logout', {
    help = 'Change character',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
            optional = true,
        },
    },
    restricted = 'group.admin'
}, function(source, args)
    exports.qbx_core:Logout(args.target or source)

    TriggerClientEvent('nf-multicharacters:client:closeMenu', args.target or source, 'load_characters')
end)

RegisterNetEvent('nf-multicharacters:server:showCharacters', function()
    local _source = source

    if not _source then
        return
    end

    MySQL.query('SELECT * FROM players WHERE license = ?', {
        exports.qbx_core:GetSource('license')
    }, function(response)
        if not response or not next(response) then
            TriggerClientEvent('nf-multicharacters:client:createCharacter', _source)
            return
        end


        local characters = {}

        for _, v in pairs(response) do
            characters[tostring(v.cid)] = {}
            characters[tostring(v.cid)].citizenid = v.citizenid
            characters[tostring(v.cid)].cid = v.cid
            characters[tostring(v.cid)].charinfo = json.decode(v.charinfo)
            characters[tostring(v.cid)].money = json.decode(v.money)
            characters[tostring(v.cid)].job = json.decode(v.job)
            characters[tostring(v.cid)].gang = json.decode(v.gang)
        end

        TriggerClientEvent('nf-multicharacters:client:showCharacters', _source, characters)
    end)
end)

lib.callback.register('nf-multicharacters:server:getCharacterSkin', function(_, citizenid)
    local row = MySQL.single.await('SELECT * FROM playerskins WHERE citizenid = ?', {
        citizenid
    })

    if not row then
        return nil, nil
    end

    return row.model, json.decode(row.skin)
end)

local function giveStarterItems(source)
    if GetResourceState('ox_inventory') == 'missing' then return end
    while not exports.ox_inventory:GetInventory(source) do
        Wait(100)
    end
    for i = 1, #Config.StarterItems do
        local item = Config.StarterItems[i]
        if item.metadata and type(item.metadata) == 'function' then
            exports.ox_inventory:AddItem(source, item.name, item.amount, item.metadata(source))
        else
            exports.ox_inventory:AddItem(source, item.name, item.amount, item.metadata)
        end
    end
end

RegisterNetEvent('nf-multicharacters:server:deleteCharacter', function(payload)
    local _source = source

    if not _source then
        return
    end

    exports.qbx_core:DeleteCharacter(payload)

    Wait(1000)

    TriggerClientEvent('nf-multicharacters:client:closeMenu', _source, 'load_characters')
end)



RegisterNetEvent('nf-multicharacters:server:createCharacter', function(payload)
    local _source = source

    if not _source then
        return
    end

    local newData = {}
    newData.charinfo = payload
    newData.charinfo.gender = payload.gender == 'male' and 0 or 1

    local success = exports.qbx_core:Login(_source, nil, newData)
    if not success then return end

    giveStarterItems(_source)

    if GetResourceState('nf-spawn') == 'missing' then
        exports.qbx_core:SetPlayerBucket(_source, 0)
    end

    lib.print.info(('%s has created a character'):format(GetPlayerName(_source)))

    TriggerClientEvent('nf-multicharacters:client:closeMenu', _source, 'skin_changer')
end)

RegisterNetEvent('nf-multicharacters:server:selectCharacter', function(citizenId)
    local _source = source

    if not _source then
        return
    end

    local success = exports.qbx_core:Login(_source, citizenId)
    if not success then return end

    lib.print.info(('%s has selected a character'):format(GetPlayerName(_source)))

    TriggerClientEvent('nf-multicharacters:client:closeMenu', _source, 'spawn_menu')
end)
