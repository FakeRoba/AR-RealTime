ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Weather = ""

GetResponse = function(Url)
    local Ready = nil

    PerformHttpRequest(Url, function(Error, Body, Report)
        Ready = Body
    end)

    while not Ready do
        Wait(1100)
    end

    return Ready
end

GetGTAWeather = function(GivenData)
    return SAR.Settings.Weathers[GivenData] or "CLEAR"
end

Citizen.CreateThread(function()
    while true do

        local Response = json.decode(GetResponse("https://api.openweathermap.org/data/2.5/weather?lat=60.19&lon=24.94&appid="..SAR.Settings.WeatherApiKey))

        Weather = GetGTAWeather(Response["weather"][1]["main"])

        TriggerClientEvent("AR-Time:WeatherChange", -1, Weather, os.time())

        Citizen.Wait(1000 * 60 * 60)
    end
end)

ESX.RegisterServerCallback("AR-Time:GetTime", function(Source, Cb)
    return Cb(Weather, os.time())
end)