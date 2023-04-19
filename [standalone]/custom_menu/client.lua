local MYX = nil

Citizen.CreateThread(function()
	while MYX == nil do
		TriggerEvent('myx:getSharedObject', function(obj) MYX = obj end)
		Citizen.Wait(0)
	end
end)

local custom_menu_data = {}

RegisterNetEvent("myx_custom_menu:show")
RegisterNetEvent("myx_custom_menu:update")
RegisterNetEvent("myx_custom_menu:action")

AddEventHandler("myx_custom_menu:show", function(data, control_buttons)
    custom_menu_data = data
    TriggerEvent('interface:custom_menu:show', data)
    setControlButtons(control_buttons)
end)

AddEventHandler("myx_custom_menu:update", function(data)
    custom_menu_data = data
    TriggerEvent('interface:custom_menu:update', data)
end)

AddEventHandler("myx_custom_menu:action", function(category, item)
    custom_menu_data.categories[category].items[item].action()
    if custom_menu_data.close_after_action then
        TriggerEvent('interface:custom_menu:hide')
    end
end)

function setControlButtons(control_buttons)
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        while exports.interfaceForas:getCustomMenuState() do
            Citizen.Wait(0)
            if isButtonPressed(control_buttons.close_menu) then
                TriggerEvent('interface:custom_menu:hide')
            elseif IsControlJustReleased(0, control_buttons.left) then
                TriggerEvent("interface:custom_menu:pressKey", 'arrowLeft')
            elseif IsControlJustReleased(0, control_buttons.right) then
                TriggerEvent("interface:custom_menu:pressKey", 'arrowRight')
            elseif IsControlPressed(0, control_buttons.up) then
                TriggerEvent("interface:custom_menu:pressKey", 'arrowUp')
                Citizen.Wait(70)
            elseif IsControlPressed(0, control_buttons.down) then
                TriggerEvent("interface:custom_menu:pressKey", 'arrowDown')
                Citizen.Wait(70)
            elseif IsControlJustReleased(0, control_buttons.select) then
                TriggerEvent("interface:custom_menu:pressKey", 'enter')
            elseif isButtonPressed(control_buttons.go_back) then
                TriggerEvent("interface:custom_menu:pressKey", 'escape')
            end
        end
    end)
end

function isButtonPressed(buttons)
    for k, button in pairs(buttons) do
        if IsControlPressed(0, button) then
            return true
        end
    end
    return false
end

