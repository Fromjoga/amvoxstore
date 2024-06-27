local gui = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/z4gs/scripts/master/testtttt.lua"))():AddWindow("Ro-Ghoul", {
    main_color = Color3.fromRGB(0,0,0),
    min_size = Vector2.new(373, 340),
    can_resize = false
})

local get = setmetatable({}, {
    __index = function(a, b)
        return game:GetService(b) or game[b]
    end
})

local tab1, tab2, tab3, tab4 = gui:AddTab("Main"), gui:AddTab("Farm Options"), gui:AddTab("Trainer"), gui:AddTab("Misc")
local btn, btn2, btn3, key, nmc, trainers, labels
local findobj, findobjofclass, waitforobj, fire, invoke = get.FindFirstChild, get.FindFirstChildOfClass, get.WaitForChild, Instance.new("RemoteEvent").FireServer, Instance.new("RemoteFunction").InvokeServer
local player = get.Players.LocalPlayer

repeat wait() until player:FindFirstChild("PlayerFolder")

local team, remotes, stat = player.PlayerFolder.Customization.Team.Value, get.ReplicatedStorage.Remotes, player.PlayerFolder.StatsFunction
local oldtick, farmtick = 0, 0
local camera = workspace.CurrentCamera
local myData = loadstring(game:HttpGet("https://raw.githubusercontent.com/z4gs/scripts/master/Settings.lua"))()("Ro-Ghoul Autofarm", {
    Skills = {
        E = false,
        F = false,
        C = false,
        R = false,
        X = false -- Adicionando a habilidade X
    },
    Boss = {
        ["Gyakusatsu"] = false,
        ["Eto Yoshimura"] = false,
        ["Koutarou Amon"] = false,
        ["Nishiki Nishio"] = false
    },
    DistanceFromNpc = 5,
    DistanceFromBoss = 8,
    TeleportSpeed = 150,
    ReputationFarm = false,
    ReputationCashout = false,
    AutoKickWhitelist = ""
})

local array = {
    boss = {
        ["Gyakusatsu"] = 1250,
        ["Eto Yoshimura"] = 1250,
        ["Koutarou Amon"] = 750,
        ["Nishiki Nishio"] = 250
    },

    npcs = {["Aogiri Members"] = "GhoulSpawns", Investigators = "CCGSpawns", Humans = "HumanSpawns"},

    stages = {"One", "Two", "Three", "Four", "Five", "Six"},

    skills = {
        E = player.PlayerFolder.Special1CD,
        F = player.PlayerFolder.Special3CD,
        C = player.PlayerFolder.SpecialBonusCD,
        R = player.PlayerFolder.Special2CD,
        X = player.PlayerFolder.Special4CD -- Adicionando a habilidade X
    }
}

tab1:AddLabel("Target")

local drop = tab1:AddDropdown("Select", function(opt)
    array.targ = array.npcs[opt]
end)

btn = tab1:AddButton("Start", function()
    if not array.autofarm then
        if key then
            btn.Text, array.autofarm = "Stop", true
            local farmtick = tick()
            while array.autofarm do
                labels("tfarm", "Time elapsed: "..os.date("!%H:%M:%S", tick() - farmtick))
                wait(1)
            end
        else
            player:Kick("Failed to get the Remote key, please try to execute the script again")
        end
    else
        btn.Text, array.autofarm, array.died = "Start", false, false
    end
end)

local function format(number)
    local i, k, j = tostring(number):match("(%-?%d?)(%d*)(%.?.*)")
    return i..k:reverse():gsub("(%d%d%d)", "%1,"):reverse()..j
end

labels = setmetatable({
    text = {label = tab1:AddLabel("")},
    tfarm = {label = tab1:AddLabel("")},
    space = {label = tab1:AddLabel("")},
    Quest = {prefix = "Current Quest: ", label = tab1:AddLabel("Current Quest: None")},
    Yen = {prefix = "Yen: ", label = tab1:AddLabel("Yen: 0"), value = 0, oldval = player.PlayerFolder.Stats.Yen.Value},
    RC = {prefix = "RC: ", label = tab1:AddLabel("RC: 0"), value = 0, oldval = player.PlayerFolder.Stats.RC.Value},
    Kills = {prefix = "Kills: ", label = tab1:AddLabel("Kills: 0"), value = 0} 
}, {
    __call = function (self, typ, newv, oldv)
        if typ and newv then
            local object = self[typ]
            if type(newv) == "number" then
                object.value = object.value + newv
                object.label.Text = object.prefix..format(object.value)
                if oldv then
                    object.oldval = oldv
                end
            elseif object.prefix then
                object.label.Text = object.prefix..newv
            else
                object.label.Text = newv
            end
            return
        end
        for i,v in pairs(labels) do
            v.value = 0
            v.label.Text = v.prefix.."0"
        end
    end
})

local function getLabel(la)
    return labels[la].value and labels[la].value or labels[la].label.Text
end

btn3 = tab1:AddButton("Reset", function() labels() end)

if team == "CCG" then tab2:AddLabel("Quinque Stage") else tab2:AddLabel("Kagune Stage") end

local drop2 = tab2:AddDropdown("[ 1 ]", function(opt)
    array.stage = array.stages[tonumber(opt)]
end)

array.stage = "One"

tab2:AddSwitch("Reputation Farm", function(bool) 
    myData.ReputationFarm = bool
end):Set(myData.ReputationFarm)

tab2:AddSwitch("Auto Reputation Cashout", function(bool)
    myData.ReputationCashout = bool
end):Set(myData.ReputationCashout)

for i,v in pairs(array.boss) do
    tab2:AddSwitch(i.." Boss Farm ".."(".."lvl "..v.."+)", function(bool)
        myData.Boss[i] = bool
    end):Set(myData.Boss[i])
end

tab2:AddSlider("TP Speed", function(x)
    myData.TeleportSpeed = x
end, {min = 90, max = 250}):Set(55)

tab2:AddSlider("Distance from NPC", function(x)
    myData.DistanceFromNpc = x * -1
end, {min = 0, max = 8}):Set(65)

tab2:AddSlider("Distance from Bosses", function(x)
    myData.DistanceFromBoss = x * -1
end, {min = 0, max = 15}):Set(55)

labels.p = {label = tab3:AddLabel("Current trainer: "..player.PlayerFolder.Trainers[team.."Trainer"].Value)}

local progress = tab3:AddSlider("Progress", nil, {min = 0, max = 100, readonly = true})

progress:Set(player.PlayerFolder.Trainers[player.PlayerFolder.Trainers[team.."Trainer"].Value].Progress.Value)

player.PlayerFolder.Trainers[team.."Trainer"].Changed:connect(function()
    labels("p", "Current trainer: "..player.PlayerFolder.Trainers[team.."Trainer"].Value)
    progress:Set(player.PlayerFolder.Trainers[player.PlayerFolder.Trainers[team.."Trainer"].Value].Progress.Value)
end)

btn2 = tab3:AddButton("Start", function()
    if not array.trainer then
        array.trainer, btn2.Text = true, "Stop"
        local connection, time

        while array.trainer do
            if connection and connection.Connected then
                connection:Disconnect()
            end
            
            local tkey, result

            connection = player.Backpack.DescendantAdded:Connect(function(obj)
                if tostring(obj) == "TSCodeVal" and obj:IsA("StringValue") then
                    tkey = obj.Value
                end
            end)
            
            result = invoke(remotes.Trainers.RequestTraining)

            if result == "TRAINING" then
                for i,v in pairs(workspace.TrainingSessions:GetChildren()) do
                    if waitforobj(v, "Player").Value == player then
                        fire(waitforobj(v, "Comm"), "Finished", tkey, false)
                        break
                    end
                end
            elseif result == "TRAINING COMPLETE" then
                labels("time", "Switching to other trainer...")
                for i,v in pairs(player.PlayerFolder.Trainers:GetDescendants()) do
                    if table.find(trainers, v.Name) and findobj(v, "Progress") and tonumber(v.Progress.Value) < 100 and tonumber(player.PlayerFolder.Trainers[player.PlayerFolder.Trainers[team.."Trainer"].Value].Progress.Value) == 100 then
                        invoke(remotes.Trainers.ChangeTrainer, v.Name)
                        local function killBoss(npc)
    labels("text", "Moving to: " .. npc.Name)

    tp(npc.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, 0) + Vector3.new(0, myData.DistanceFromBoss, 0))
    labels("text", "Killing: " .. npc.Name)

    while findobj(findobj(npc.Parent, npc.Name), "Head") and player.Character.Humanoid.Health > 0 and array.autofarm do
        if not findobj(player.Character, "Kagune") and not findobj(player.Character, "Quinque") then
            pressKey(array.stage)
        end
        for x, y in pairs(myData.Skills) do
            if player.PlayerFolder.CanAct.Value and y and array.skills[x].Value ~= "DownTime" then
                pressKey(x)
            end
        end
        pressKey("X")
        player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, 0) + Vector3.new(0, myData.DistanceFromBoss, 0)
        if player.PlayerFolder.CanAct.Value then
            pressKey("Mouse1")
        end
        task.wait()
    end

    if npc.Name == "Gyakusatsu" then
        player.Character.Humanoid.Health = 0
    end

    if array.autofarm and player.Character.Humanoid.Health > 0 then
        labels("Kills", 1)
        if npc.Name ~= "Eto Yoshimura" and not findobj(npc.Parent, "Gyakusatsu") and npc.Name ~= "Gyakusatsu" then
            labels("text", "Collecting corpse...")
            collect(npc)
        end
    end
end

while true do
    if array.autofarm then
        pcall(function()
            if player.Character.Humanoid.Health > 0 and player.Character.HumanoidRootPart and player.Character.Remotes.KeyEvent then
                if not findobj(player.Character, "Kagune") and not findobj(player.Character, "Quinque") then
                    pressKey(array.stage)
                end
                if myData.ReputationFarm and (not findobj(player.PlayerFolder.CurrentQuest.Complete, "Aogiri Member") or player.PlayerFolder.CurrentQuest.Complete["Aogiri Member"].Value == player.PlayerFolder.CurrentQuest.Complete["Aogiri Member"].Max.Value) then
                    getQuest(true)
                    return
                elseif myData.ReputationCashout and tick() - oldtick > 7200 then
                    getQuest()
                end

                local npc = getNPC()

                if npc then
                    array.found = false
                    local reached = false

                    coroutine.wrap(function()
                        while not reached do
                            if npc ~= getNPC() then
                                array.found = true
                                break
                            end
                            wait()
                        end
                    end)()

                    if myData.Boss[npc.Name] or npc.Parent.Name == "GyakusatsuSpawn" then
                        killBoss(npc)
                    else
                        tp(npc.HumanoidRootPart.CFrame + npc.HumanoidRootPart.CFrame.lookVector * myData.DistanceFromNpc)
                        labels("text", "Killing: " .. npc.Name)
                        
                        reached = true

                        if not array.found then
                            while findobj(findobj(npc.Parent, npc.Name), "Head") and player.Character.Humanoid.Health > 0 and array.autofarm do
                                if not findobj(player.Character, "Kagune") and not findobj(player.Character, "Quinque") then
                                    pressKey(array.stage)
                                end
                                pressKey("X")
                                player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + npc.HumanoidRootPart.CFrame.lookVector * myData.DistanceFromNpc 
                                if player.PlayerFolder.CanAct.Value then
                                    pressKey("Mouse1")
                                end
                                task.wait()
                            end

                            if npc.Name == "Gyakusatsu" then
                                player.Character.Humanoid.Health = 0
                            end

                            if array.autofarm and player.Character.Humanoid.Health > 0 then
                                labels("Kills", 1)
                                if npc.Name ~= "Eto Yoshimura" and not findobj(npc.Parent, "Gyakusatsu") and npc.Name ~= "Gyakusatsu" then
                                    labels("text", "Collecting corpse...")
                                    collect(npc)
                                end
                            end
                        end
                    end
                else
                    labels("text", "Target not found, waiting...")
                end
            else
                labels("text", "Waiting for character to respawn")
                array.died = true
            end
        end)
    else
        labels("text", "")
    end
    wait()
end