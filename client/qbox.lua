RegisterNetEvent('nf-multicharacters:client:createCharacter', function()
    Characters.createdCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(Characters.createdCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    Characters:SetModel("male")

    SetEntityCoords(PlayerPedId(), Config.CreatorCoords.x, Config.CreatorCoords.y, Config.CreatorCoords.z, false, false,
        false, false)
    SetEntityHeading(PlayerPedId(), Config.CreatorCoords.w)

    SetNuiFocus(true, true)
    SendNUIMessage({
        eventName = 'showCreator',
    })
end)

RegisterNetEvent('nf-multicharacters:client:showCharacters', function(characters)
    Characters.createdCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(Characters.createdCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    Characters:SetModel("male")

    SetEntityCoords(PlayerPedId(), Config.CreatorCoords.x, Config.CreatorCoords.y, Config.CreatorCoords.z, false, false,
        false, false)
    SetEntityHeading(PlayerPedId(), Config.CreatorCoords.w)

    Characters:SpawnPeds(characters)

    SetNuiFocus(true, true)
    SendNUIMessage({
        eventName = 'showCharacters',
        payload = characters,
    })
end)

RegisterNetEvent('nf-multicharacters:client:closeMenu', function(menuType)
    Characters:DestroyCamera()
    Characters:DestroyPeds()

    if menuType == 'load_characters' then
        DoScreenFadeOut(0)

        Wait(500)

        TriggerServerEvent('nf-multicharacters:server:showCharacters')
    elseif menuType == 'skin_changer' then
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')

        exports['nf-skin']:OpenCreator(function()
            exports['nf-spawn']:OpenSpawn(true)
        end)
    elseif menuType == 'spawn_menu' then
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')

        exports['nf-spawn']:OpenSpawn()
    end
end)
