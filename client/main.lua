Characters = {
    isLoaded = false,
    pedsSpawned = false,

    createdCamera = nil,
    createdPeds = {},
}

RegisterNuiCallback('isLoaded', function(_, cb)
    if Characters.isLoaded then
        cb({
            isLoaded = false,
        })
    else
        Characters.isLoaded = true

        DoScreenFadeOut(0)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()


        Config.UI.maxCharacters = Config.MaxCharacters

        cb({
            isLoaded = true,
            config = Config.UI,
        })

        TriggerServerEvent('nf-multicharacters:server:showCharacters')
    end
end)

function InitLoad(cb)
    local coords = Config.CreatorCoords
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(playerPed, coords.w)
    local interiorId = GetInteriorAtCoords(coords.x, coords.y, coords.z)
    local isReady = lib.waitFor(function()
        if Characters.isLoaded and Characters.pedsSpawned and IsInteriorReady(interiorId) then
            return true
        end
    end, "Error", false)

    if isReady then
        cb()
    end
end

RegisterNuiCallback('setActiveCharacter', function(payload, cb)
    DoScreenFadeOut(150)
    Citizen.Wait(150)

    Characters:SetCamera(payload, function()
        Citizen.Wait(150)
        DoScreenFadeIn(150)
    end)

    cb(0)
end)

RegisterNuiCallback('setGender', function(payload, cb)
    Characters:SetModel(payload)

    cb(0)
end)

RegisterNuiCallback('deleteCharacter', function(payload, cb)
    cb(0)

    TriggerServerEvent('nf-multicharacters:server:deleteCharacter', payload)
end)

RegisterNuiCallback('createCharacter', function(payload, cb)
    cb(0)

    SetNuiFocus(false, false)
    TriggerServerEvent('nf-multicharacters:server:createCharacter', payload)
end)

RegisterNuiCallback('selectCharacter', function(payload, cb)
    cb(0)

    SetNuiFocus(false, false)
    TriggerServerEvent('nf-multicharacters:server:selectCharacter', payload)
end)

function Characters:SetCamera(payload, cb)
    if not payload then
        SetCamCoord(self.createdCamera, Config.DefaultCamera.coords.x, Config.DefaultCamera.coords.y,
            Config.DefaultCamera.coords.z)
        SetCamRot(self.createdCamera, Config.DefaultCamera.rotation.x, Config.DefaultCamera.rotation.y,
            Config.DefaultCamera.rotation.z, 2)
        SetCamFov(self.createdCamera, Config.DefaultCamera.fov)
    elseif payload == 'default' then
        local playerCoords = GetEntityCoords(cache.ped)
        local playerFront = GetEntityForwardVector(cache.ped)
        local playerRot = GetEntityRotation(cache.ped, 2)

        local merged = vector3(playerCoords.x + playerFront.x * 2, playerCoords.y + playerFront.y * 2,
            playerCoords.z)

        SetCamCoord(self.createdCamera, merged.x, merged.y, merged.z)
        SetCamRot(self.createdCamera, playerRot.x, playerRot.y, playerRot.z - 180, 2)
        SetCamFov(self.createdCamera, 50.0)
    else
        local pedId = self.createdPeds[payload]

        local playerCoords = GetEntityCoords(pedId)
        local playerFront = GetEntityForwardVector(pedId)
        local playerRot = GetEntityRotation(pedId, 2)

        local merged = vector3(playerCoords.x + playerFront.x * 2, playerCoords.y + playerFront.y * 2,
            playerCoords.z)

        local offset = vector3(merged.x + Config.SpawnCharacters[payload].offset.x,
            merged.y + Config.SpawnCharacters[payload].offset.y, merged.z + Config.SpawnCharacters[payload].offset.z)

        SetCamCoord(self.createdCamera, offset.x, offset.y, offset.z)
        SetCamRot(self.createdCamera, playerRot.x, playerRot.y, playerRot.z - 180, 2)
        SetCamFov(self.createdCamera, Config.SpawnCharacters[payload].fov)
    end

    if cb then
        cb()
    end
end

function Characters:DestroyCamera()
    if Characters.createdCamera then
        DestroyCam(Characters.createdCamera, false)
        RenderScriptCams(false, false, 0, true, true)
        Characters.createdCamera = nil
    end
end

function Characters:SetModel(payload)
    local model = payload == 'female' and 'mp_f_freemode_01' or 'mp_m_freemode_01'
    local skin = payload == 'female' and Config.SkinFemale or Config.SkinMale

    exports['nf-skin']:SetPedModel(model, function(playerPed)
        exports['nf-skin']:SetPedAppearance(
            playerPed,
            skin
        )
    end)
end

function Characters:SpawnPeds(characters)
    local randomPeds = {
        `mp_m_freemode_01`,
        `mp_f_freemode_01`,
    }

    for k, v in pairs(Config.SpawnCharacters) do
        local model, skin = nil, nil

        if characters[k] then
            model, skin = lib.callback.await('nf-multicharacters:server:getCharacterSkin', false,
                characters[k].citizenid)
        end

        model = model or randomPeds[math.random(1, #randomPeds)]
        skin = skin or (model == 'mp_m_freemode_01' and Config.SkinMale or Config.SkinFemale)

        local pedId = Characters:CreatePreviewPed({
            model = model,
            x = v.pedCoords.x,
            y = v.pedCoords.y,
            z = v.pedCoords.z,
            w = v.pedCoords.w,
        })

        Characters.createdPeds[k] = pedId
        exports['nf-skin']:SetPedAppearance(pedId, skin)

        if v.anim then
            lib.requestAnimDict(v.anim[1])
            TaskPlayAnim(pedId, v.anim[1], v.anim[2], 8.0, 8.0, -1, 1, 0, false, false, false)
            RemoveAnimDict(v.anim[1])
        end
    end

    Characters.pedsSpawned = true
end

function Characters:CreatePreviewPed(payload, cb)
    lib.requestModel(payload.model)
    local createdPed = CreatePed(4, payload.model, payload.x, payload.y, payload.z, payload.w, false, false)
    SetEntityAsMissionEntity(createdPed, true, true)
    SetBlockingOfNonTemporaryEvents(createdPed, true)
    FreezeEntityPosition(createdPed, true)
    SetEntityInvincible(createdPed, true)
    SetModelAsNoLongerNeeded(payload.model)

    if cb then
        cb(createdPed)
    end

    return createdPed
end

function Characters:DestroyPeds()
    for _, v in pairs(Characters.createdPeds) do
        DeleteEntity(v)
    end

    Characters.createdPeds = {}
    Characters.pedsSpawned = false
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    Characters:DestroyCamera()
    Characters:DestroyPeds()
end)
