--#region Functions

---Begins animation depending on data type
---@param data table Animation Data
---@param p string Promise
open = false
local function animType(data, p)
    if data then
        if data.disableMovement then
            cfg.animDisableMovement = true
        end
        if data.disableLoop then
            cfg.animDisableLoop = true
        end
        if data.dance then
            Play.Animation(data.dance, data.particle, data.prop, p)
        elseif data.scene then
            Play.Scene(data.scene, p)
        elseif data.expression then
            Play.Expression(data.expression, p)
        elseif data.walk then
            Play.Walk(data.walk, p)
        elseif data.shared then
            Play.Shared(data.shared, p)
        end
    end
end

---Begins cancel key thread
local function enableCancel()
    CreateThread(function()
        while cfg.animActive or cfg.sceneActive do
            if IsControlJustPressed(0, cfg.cancelKey) then
                Load.Cancel()
                break
            end
            Wait(10)
        end
    end)
end

---Finds an emote by command
---@param emoteName table
local function findEmote(emoteName)
    if emoteName then
        local name = emoteName:upper()
        SendNUIMessage({action = 'findEmote', name = name})
    end
end

---Returns the current walking style saved in kvp
---@return string
local function getWalkingStyle(cb)
    local savedWalk = GetResourceKvpString('savedWalk')
    if savedWalk then
        if cb then
            return cb(savedWalk)
        end
        return savedWalk
    end
    if cb then
        return cb(nil)
    end
    return nil
end
--#endregion

--#region NUI callbacks
RegisterNUICallback('changeCfg', function(data, cb)
    if data then
        if data.type == 'movement' then
            cfg.animMovement = not data.state
        elseif data.type == 'loop' then
            cfg.animLoop = not data.state
        elseif data.type == 'settings' then
            cfg.animDuration = tonumber(data.duration) or cfg.animDuration
            cfg.cancelKey = tonumber(data.cancel) or cfg.cancelKey
            cfg.defaultEmote = data.emote or cfg.defaultEmote
            cfg.defaultEmoteKey = tonumber(data.key) or cfg.defaultEmoteKey
        end
    end
    cb({})
end)

RegisterNUICallback('cancelAnimation', function(_, cb)
    Load.Cancel()
    cb({})
end)

RegisterNUICallback('removeProps', function(_, cb)
    Load.PropRemoval('global')
    cb({})
end)

RegisterNUICallback('exitPanel', function(_, cb)
    if cfg.panelStatus then
        controller = false
        open = false
        cfg.panelStatus = false
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        TriggerScreenblurFadeOut(3000)
        SendNUIMessage({action = 'panelStatus', panelStatus = cfg.panelStatus})
    end
    cb({})
end)

RegisterNUICallback('sendNotification', function(data, cb)
    if data then
        Play.Notification(data.type, data.message)
    end
    cb({})
end)

RegisterNUICallback('fetchStorage', function(data, cb)
    if data then
        for _, v in pairs(data) do
            if v == 'loop' then
                cfg.animLoop = true
            elseif v == 'movement' then
                cfg.animMovement = true
            end
        end
        local savedWalk = GetResourceKvpString('savedWalk')
        if savedWalk then -- If someone has a better implementation which works with multichar please share it.
            local p = promise.new()
            Wait(cfg.waitBeforeWalk)
            Play.Walk({style = savedWalk}, p)
            local result = Citizen.Await(p)
            if result.passed then
                Play.Notification('info', 'Volver al estilo predeterminado.')
            end
        end
    end
    cb({})
end)

RegisterNUICallback('beginAnimation', function(data, cb)
    Load.Cancel()
    local animState = promise.new()
    animType(data, animState)
    local result = Citizen.Await(animState)
    if result.passed then
        if not result.shared then
            enableCancel()
        end
        cb({e = true})
        return
    end
    if result.nearby then cb({e = 'nearby'}) return end
    cb({e = false})
end)
--#endregion

--#region Commands

local controler = false
RegisterCommand(cfg.commandName, function()
    cfg.panelStatus = not cfg.panelStatus
    if cfg.focus then
        TriggerScreenblurFadeIn(3000)
    end
    if cfg.panelStatus then
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        open = true
        Citizen.CreateThread(function()
            while open do
                -- if not cfg.panelStatus then
                --     open = false
                -- end
                -- if IsControlJustReleased(0, 19) then
                --     if controler then
                --         controler = false
                --     else
                --         controler = true
                --     end
                -- end
                -- if controler then
                --     SetNuiFocus(true, true)
                -- else
                --     SetNuiFocus(false, false)
                -- end
                DisableControlAction(0, 1, true)
                DisableControlAction(0, 2, true)
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 25, true) -- Aim
                DisableControlAction(0, 263, true) -- Melee Attack 1
    
                DisableControlAction(0, 45, true) -- Reload
                DisableControlAction(0, 21, true) -- left shift
                DisableControlAction(0, 22, true) -- Jump
                DisableControlAction(0, 44, true) -- Cover
                DisableControlAction(0, 37, true) -- Select Weapon
    
                DisableControlAction(0, 288,  true) -- Disable phone
                DisableControlAction(0, 245,  true) -- Disable chat
                DisableControlAction(0, 289, true) -- Inventory
                DisableControlAction(0, 170, true) -- Animations
                DisableControlAction(0, 167, true) -- Job
                DisableControlAction(0, 244, true) -- Ragdoll
                DisableControlAction(0, 303, true) -- Car lock
    
                DisableControlAction(0, 29, true) -- B ile işaret
                DisableControlAction(0, 81, true) -- B ile işaret
                DisableControlAction(0, 26, true) -- Disable looking behind
                DisableControlAction(0, 73, true) -- Disable clearing animation
                DisableControlAction(2, 199, true) -- Disable pause screen
    
                -- DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                -- DisableControlAction(0, 72, true) -- Disable reversing in vehicle
    
                DisableControlAction(2, 36, true) -- Disable going stealth
    
                DisableControlAction(0, 47, true)  -- Disable weapon
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                Citizen.Wait(0)
            end
            controller = false
        end)
        SendNUIMessage({action = 'panelStatus',panelStatus = cfg.panelStatus})
    else
        controller = false
        open = false
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        TriggerScreenblurFadeOut(3000)
        SendNUIMessage({action = 'panelStatus', panelStatus = cfg.panelStatus})
    end
end)


RegisterNUICallback('sendControl', function(data, cb)
    if data.status then
        SetNuiFocusKeepInput(false)
    else
        SetNuiFocusKeepInput(true)
    end
    cb({e = false})
end)


RegisterCommand(cfg.commandNameEmote, function(_, args)
    if args and string.lower(args[1]) == 'c' then
        return EmoteCancel()
    end
    if args and args[1] then
        return findEmote(args[1])
    end
    Play.Notification('info', 'No emote name set...')
end)

RegisterCommand(cfg.defaultCommand, function()
    if cfg.defaultEmote then
        findEmote(cfg.defaultEmote)
    end
end)

if cfg.defaultEmoteUseKey then
    CreateThread(function()
        while cfg.defaultEmoteKey do
            if IsControlJustPressed(0, cfg.defaultEmoteKey) then
                findEmote(cfg.defaultEmote)
            end
            Wait(5)
        end
    end)
end

if cfg.keyActive then
    RegisterKeyMapping(cfg.commandName, cfg.keySuggestion, 'keyboard', cfg.keyLetter)
end
--#endregion

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() == name then
        Load.Cancel()
    end
end)

---Event for updating cfg from other resource
---@param _cfg table
---@param result any
---@return any
AddEventHandler('anims:updateCfg', function(_cfg, result)
    if GetCurrentResourceName() == GetInvokingResource() then
        CancelEvent()
        return print('Cannot use this event from the same resource!')
    end
    if type(_cfg) ~= "table" then
        print(GetInvokingResource() .. ' tried to update anims cfg but it was not a table')
        CancelEvent()
        return
    end
    local oldCfg = cfg
    for k, v in pairs(_cfg) do
        if cfg[k] and v then
            cfg[k] = v
        end
    end
    print(GetInvokingResource() .. ' updated anims cfg!')
    if result then
        print('Old:' .. json.encode(oldCfg) .. '\nNew: ' .. json.encode(cfg))
    end
end)

exports('PlayEmote', findEmote)
exports('GetWalkingStyle', getWalkingStyle)

-- function EmoteCancel()
--     ClearPedTasks(GetPlayerPed(-1))
--     IsInAnimation = false
--   end