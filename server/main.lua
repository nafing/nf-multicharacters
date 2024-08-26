local function CheckVersion()
    local scriptName = GetCurrentResourceName()

    local currentVersion = GetResourceMetadata(scriptName, "version", 0)

    if not currentVersion then
        return print(("^1Unable to determine current resource version for '%s' ^0"):format(
            scriptName))
    end


    PerformHttpRequest("https://raw.githubusercontent.com/lorewave/versions/main/scripts.json",
        function(status, response)
            if status ~= 200 then return end
            local res = json.decode(response)
            local liveVersion = res[scriptName]

            if currentVersion ~= liveVersion then
                print(("^3%s^0 is ^8outdated^0. Consider updating to version ^2%s^0."):format(
                    scriptName, liveVersion))
            else
                print(("^3%s^0 is ^2up to date^0. Current version: ^2%s^0."):format(
                    scriptName, currentVersion))
            end
        end, "GET")
end
CheckVersion()
