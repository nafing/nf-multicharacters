local characterDataTables = require '@qbx_core.config.server'.characterDataTables
local starterItems = require '@qbx_core.config.shared'.starterItems

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
    for i = 1, #starterItems do
        local item = starterItems[i]
        if item.metadata and type(item.metadata) == 'function' then
            exports.ox_inventory:AddItem(source, item.name, item.amount, item.metadata(source))
        else
            exports.ox_inventory:AddItem(source, item.name, item.amount, item.metadata)
        end
    end
end


local function doesTableExist(tableName)
    local tbl = MySQL.single.await(('SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_NAME = \'%s\' AND TABLE_SCHEMA in (SELECT DATABASE())')
        :format(tableName))
    return tbl['COUNT(*)'] > 0
end

local function deletePlayer(citizenId)
    local query = 'DELETE FROM %s WHERE %s = ?'
    local queries = {}

    for i = 1, #characterDataTables do
        local data = characterDataTables[i]
        local tableName = data[1]
        local columnName = data[2]
        if doesTableExist(tableName) then
            queries[#queries + 1] = {
                query = query:format(tableName, columnName),
                values = {
                    citizenId,
                }
            }
        else
            warn(('Table %s does not exist in database, please remove it from qbx_core/config/server.lua or create the table')
                :format(tableName))
        end
    end

    local success = MySQL.transaction.await(queries)
    return not not success
end


RegisterNetEvent('nf-multicharacters:server:deleteCharacter', function(citizenId)
    local _source = source

    if not _source then
        return
    end

    if deletePlayer(citizenId) then
        lib.print.info(('%s has deleted a character'):format(GetPlayerName(_source)))
        TriggerClientEvent('nf-multicharacters:client:closeMenu', _source, 'load_characters')
    end
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
