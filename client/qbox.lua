RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('nf-multicharacters:server:showCharacters')
end)

RegisterNetEvent('nf-multicharacters:client:createCharacter', function()
    Characters.createdCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(Characters.createdCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    Characters:SetModel('male')

    SetEntityCoords(PlayerPedId(), Config.CreatorCoords.x, Config.CreatorCoords.y, Config.CreatorCoords.z, false, false,
        false, false)
    SetEntityHeading(PlayerPedId(), Config.CreatorCoords.w)

    SetNuiFocus(true, true)
    SendNUIMessage({
        eventName = 'showCreator',
    })
end)

RegisterNetEvent('nf-multicharacters:client:showCharacters', function(payload)
    DoScreenFadeOut(0)
    Characters:SetModel('male')
    Characters:SpawnPeds(payload)

    InitLoad(function()
        Characters.createdCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(Characters.createdCamera, true)
        RenderScriptCams(true, false, 0, true, true)

        SetNuiFocus(true, true)
        SendNUIMessage({
            eventName = 'showCharacters',
            payload = payload,
        })
    end)
end)

RegisterNetEvent('nf-multicharacters:client:closeMenu', function(menuType)
    DoScreenFadeOut(0)
    Characters:DestroyCamera()
    Characters:DestroyPeds()

    if menuType == 'load_characters' then
        TriggerServerEvent('nf-multicharacters:server:showCharacters')
    elseif menuType == 'skin_changer' then
        DoScreenFadeIn(0)
        exports['nf-skin']:OpenCreator(function()
            DoScreenFadeOut(0)
            exports['nf-spawn']:OpenSpawn(true)
        end)
    elseif menuType == 'spawn_menu' then
        exports['nf-spawn']:OpenSpawn()
    end
end)
