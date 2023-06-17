ESX = nil Citizen.CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end end)

local Time = nil
local LastWeather = nil
local Weather = nil

RegisterNetEvent("AR-Time:WeatherChange")
AddEventHandler("AR-Time:WeatherChange", function(GivenWeather, GivenTime)
    Time = GivenTime
    Weather = GivenWeather
end)

function Normalisoi(GivenTime)
    local remaining = GivenTime % 86400
    local hour = math.floor(remaining/3600)
    remaining = remaining % 3600
    local minute = math.floor(remaining/60)
    remaining = remaining % 60
    local sec = remaining
    return hour, minute, sec
end

Citizen.CreateThread(function()
    while not ESX do
        Wait(1100)
    end

    ESX.TriggerServerCallback("AR-Time:GetTime", function(GivenWeather, GivenTime)
        Time = GivenTime
        Weather = GivenWeather
    end)

    while not Time do
        Wait(1100)
    end

    while true do
        local Hour, Minute, Second = Normalisoi(Time)

        NetworkOverrideClockTime(Hour, Minute, Second)

        if not LastWeather == Weather then
            LastWeather = Weather
            SetWeatherTypeOverTime(Weather, 15.0)
        end

        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(LastWeather)
        SetWeatherTypeNow(LastWeather)
        SetWeatherTypeNowPersist(LastWeather)

        local Xmas = LastWeather == 'XMAS'
        SetForceVehicleTrails(Xmas)
        SetForcePedFootstepsTracks(Xmas)

        Time = Time + 1

        Citizen.Wait(1000)
    end

end)