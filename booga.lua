--[[  
Recent: 
FINALLY EVERYTHING IS FIXED I THINK 
Fixed: Laggy Aura, Anti Hut 
Finished: CrystalBridge, Hide playerlist 
Added & testing: Pumpkin Esp, No Rain, added no name, gold grinder                         
]]-- 

local Players = game:GetService("Players") 
local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local Character = Players.LocalPlayer.Character 
local hrp = Character:FindFirstChild("HumanoidRootPart").Position  
local heal = "Cooked Meat" 
local mouse = Players.LocalPlayer:GetMouse() 

-- Global Variables (For toggles) 

_G.EatToggle = false 
_G.NoRain = false 
_G.Lighting = false 
_G.PickUpToggle = false 
_G.BreakAura = false 
_G.AutoHarvestFruit = false 
_G.AutoCollectEssence = false 
_G.AutoCoinPress = false 
_G.AutoCoinPressCollect = false 
_G.CrystalBridge = false 
_G.AntiHut = false 
_G.HidePl = false 
_G.PumpkinEsp = false 
_G.GoldNode = false 
_G.Fly = false 
-- Functions 

local function getClosestObject(folder) 
    local distance, part = math.huge, nil 
    local mainPart 
    local Character = Players.LocalPlayer.Character 
    for i,v in pairs(folder:GetChildren()) do 
        if Character:FindFirstChild("HumanoidRootPart") then 
            local HRPPosition = Character:FindFirstChild("HumanoidRootPart").Position 

            for i2,v2 in pairs(v:GetChildren()) do 
                if v2:IsA("BasePart") then 
                    mainPart = v2 
                    break 
                end 
            end 

            if mainPart and not mainPart.Parent:FindFirstChild("Humanoid") and mainPart.Parent:FindFirstChild("Health") then 
                local realDistance = math.abs((HRPPosition - mainPart.Position).Magnitude) 

                if realDistance < distance then 
                    distance = realDistance 
                    part = mainPart 
                end 
            end 
        end 
    end 
    return part 
end 
local function getClosestPickups(folder) 
    local pickups = {} 
    for i,v in pairs(folder:GetChildren()) do 
        if v:FindFirstChild("Pickup") and v:IsA("BasePart") and table.find(pickups,v) == nil and Character:FindFirstChild("HumanoidRootPart") then 
            if (Character.HumanoidRootPart.Position - v.Position).Magnitude <= 30 then 
                table.insert(pickups, v) 
            end 
        end 
    end 
    return pickups 
end 

local function lightingFix() 
    local gl = game.Lighting 
    if _G.Lighting then 
        gl.Brightness = 4 
        gl.FogEnd = 1000000 
        gl.GlobalShadows = false 
        gl.TimeOfDay = 12 
    else   
        gl.Brightness = 2 
        gl.GlobalShadows = true 
        gl.TimeOfDay = 12 
    end 
end 

local function eating() 
    while _G.EatToggle do  
        game:GetService("ReplicatedStorage").Events.UseBagItem:FireServer(heal) 
        wait(180) 
    end 
end 

local function afk() 
    if _G.AFK then 
        local vu = game:GetService("VirtualUser") 
        game:GetService("Players").LocalPlayer.Idled:connect(function() 
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) 
        wait(1) 
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) 
        end) 
    end 
end 

local function autoPickUp() 
    while _G.PickUpToggle do 
        for i,v in pairs(getClosestPickups(workspace)) do 
            game:GetService("ReplicatedStorage").Events.Pickup:FireServer(v) 
        end 
        wait(0.1)  
    end 
end 

local function nolag() 
    local Terrain = workspace:FindFirstChildOfClass('Terrain') 
    local Lighting = game:GetService("Lighting") 
    Terrain.WaterWaveSize = 0 
    Terrain.WaterWaveSpeed = 0 
    Terrain.WaterReflectance = 0 
    Lighting.GlobalShadows = false 
    Lighting.FogEnd = 1000000 
    for i,v in pairs(game:GetDescendants()) do 
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 
            v.Material = "Plastic" 
            v.Reflectance = 0 
        elseif v:IsA("Decal") then 
            v.Transparency = 1 
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then 
            v.Lifetime = NumberRange.new(0) 
        elseif v:IsA("Explosion") then 
            v.BlastPressure = 1 
            v.BlastRadius = 1 
        end 
    end 
    for i,v in pairs(Lighting:GetDescendants()) do 
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then 
            v.Enabled = false 
        end 
    end 
        workspace.DescendantAdded:Connect(function(child) 
        coroutine.wrap(function() 
            if child:IsA('ForceField') then 
                RunService.Heartbeat:Wait() 
                child:Destroy() 
            elseif child:IsA('Sparkles') then 
                RunService.Heartbeat:Wait() 
                child:Destroy() 
            elseif child:IsA('Smoke') or child:IsA('Fire') then 
                RunService.Heartbeat:Wait() 
                child:Destroy() 
            end 
        end)() 
    end) 
end 

local function mineAura() 
    while _G.BreakAura do 
        wait(0.1) 
        if Character:FindFirstChild("HumanoidRootPart") then 
            local closestPart = getClosestObject(workspace) 
            local hrp = Character:FindFirstChild("HumanoidRootPart").Position 

            if (hrp - closestPart.Position).Magnitude <= 40 then 
                ReplicatedStorage.Events.SwingTool:FireServer(ReplicatedStorage.RelativeTime.Value, { 
                    [1] = closestPart 
                }) 
            end 
        end 
    end 
end 

local function autoDeath() 
    while _G.AutoDeath do  
        game.Players.LocalPlayer.Character.Humanoid.Health = 0 
        wait(2.5) 
    end 
end 

local function autoHarvestFruit() -- Barley Doesn't work 
    while _G.AutoHarvestFruit and wait(0.1)do 
        for i, v in pairs(game:GetService("Workspace"):GetChildren()) do 
            if v.Name == "Berry Bush" and v.Parent then 
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace["Berry Bush"]) 
            elseif v.Name == "Apple Tree" and v.Parent then 
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace["Apple Tree"]) 
            elseif v.Name == "Banana Tree" and v.Parent then 
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace["Banana Tree"]) 
            elseif v.Name == "Pumpkin Patch Crop" and v.Parent then 
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace["Pumpkin Patch Crop"]) 
            elseif v.Name == "Bloodfruit Bush" and v.Parent then 
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace["Bloodfruit Bush"]) 
            elseif v.Name == "Bluefruit Bush" and v.Parent then 
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace["Bluefruit Bush"]) 
            end 
        end 
    end 
end 

local function autoCollectEssence() 
    while _G.AutoCollectEssence do 
        wait(0.1) 
            for i, v in pairs(game:GetService("Workspace"):GetChildren()) do 
                if v.Name == "Essence" and v.Parent then 
            game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace["Essence"]) 
                end 
            end 
    end 
end 

local function autoCoinPress() 
    while _G.AutoCoinPress do 
        wait(0.1) 
        for i,v in pairs(game:GetService("Workspace").Deployables:GetChildren()) do 
            if v.Name == "Coin Press" and v.Parent then 
                local v1 = game:GetService("Workspace").Deployables["Coin Press"] 
                local v2 = "Gold" 
                local event = game:GetService("ReplicatedStorage").Events.lnteractStructure 

                event:FireServer(v1, v2) 
            end 
        end 
    end 
end  

local function tpvoid() 
    game:GetService("TeleportService"):Teleport(10767870749) 
end 

local function autoCoinPressCollect() 
    while _G.AutoCoinPressCollect do 
        wait(0.1) 
        for i,v in pairs(game:GetService("Workspace").ItemDrops:GetChildren()) do 
            if v.Name == "Coin2" and v.Parent then 
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(workspace.ItemDrops["Coin2"]) 
            end 
        end 
    end 
end 

local function getClosestHut(folder) 
    local distance, part = math.huge, nil 
    local mainPart 
    local Character = Players.LocalPlayer.Character 
    for i,v in pairs(folder:GetChildren()) do 
        if Character:GetDescendants("HumanoidRootPart") then 
            if v.Name == "Hut" or v.Name == "Big Ol' Hut" then 
                for i2,v2 in pairs(v:GetChildren()) do 
                    local hrp = Character:FindFirstChild("HumanoidRootPart").Position  
                    if v2:IsA("BasePart") and v2.Name == "Reference" and (hrp - v2.Position).Magnitude <= 15 then 
                        mainPart = v2 
                        break 
                    end 
                end 
                if mainPart and not mainPart.Parent:FindFirstChild("Humanoid") and mainPart.Parent:FindFirstChild("Health") then 
                    local realDistance = math.abs((hrp - mainPart.Position).Magnitude) 
                    if realDistance < distance then 
                        distance = realDistance 
                        part = mainPart 
                    end 
                end 
            end 
        end 
    end 
    return part  
end 

local function antihut() -- FIXED BUGS LMK IF THERE ARE ANY OTHERS (sometimes it will lag back rarely* but just wait another 0.5 seconds and you should be fine) 
    if game:GetService("Workspace"):FindFirstChild("Deployables") then 
        while _G.AntiHut do 
            wait(0.5)  
            local closestPart = getClosestHut(game:GetService("Workspace").Deployables) 
            if Character:FindFirstChild("HumanoidRootPart") and closestPart ~= nil then 
                local hrp = Character:FindFirstChild("HumanoidRootPart").Position  
                if game:GetService("Workspace").Deployables:GetChildren("Big Ol' Hut") and closestPart.Parent.Name == game:GetService("Workspace").Deployables["Big Ol' Hut"].Name and (hrp - closestPart.Position).Magnitude <= 15 then 
                    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(game.Players.LocalPlayer.Character.Head.Position.x, game.Players.LocalPlayer.Character.Head.Position.y + 20, game.Players.LocalPlayer.Character.Head.Position.z)) 

                elseif game:GetService("Workspace").Deployables:GetChildren("Hut") and closestPart.Parent.Name == game:GetService("Workspace").Deployables["Hut"].Name and (hrp - closestPart.Position).Magnitude <= 10 then 
                    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(game.Players.LocalPlayer.Character.Head.Position.x, game.Players.LocalPlayer.Character.Head.Position.y + 20, game.Players.LocalPlayer.Character.Head.Position.z)) 
                end 
            end 
        end 
    end 
end 

local function crystalBridge() 
    if _G.CrystalBridge then 
        game:GetService("Workspace").CrystalBridge.CanCollide = true 
        game:GetService("Workspace").CrystalBridge.Transparency = 0 
    else  
        game:GetService("Workspace").CrystalBridge.CanCollide = false 
        game:GetService("Workspace").CrystalBridge.Transparency = 1 
    end 
end 

local function hidePL() 
    if _G.HidePl then 
        game.Players.LocalPlayer.PlayerGui.SecondaryGui.PlayerList.Visible = false 
    else  
        game.Players.LocalPlayer.PlayerGui.SecondaryGui.PlayerList.Visible = true 
    end 
end 

local function pumpkinEsp() 
    local hl = Instance.new("Highlight") 
    if _G.PumpkinEsp then 
        for i,v in pairs(game:GetService("Workspace").pumpkins:GetChildren()) do  
            if v:IsA("Model") then 
                for i2,v2 in pairs(v:GetChildren()) do  
                    if v2:IsA("BasePart") and v2.Name == "Reference" then  
                        local part = v2;  
                        local a = Instance.new("BoxHandleAdornment") 
                        a.Name = part.Name:lower().."_PESP" 
                        a.Parent = part 
                        a.Adornee = part 
                        a.AlwaysOnTop = true 
                        a.ZIndex = 0 
                        a.Size = part.Size * 2 
                        a.Transparency = 0.2 
                        a.Color = BrickColor.new("Lime Green") 
                    end 
                end 
            end 
        end 
    end 
end 

local function noRain() 
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do  
        if v:IsA("BasePart") and  v.Name == "RainPart" then  
            v:Destroy()         
        end             
    end 
end 

local function goldNode() 
    while _G.GoldNode and wait(0.1) do 
        local TweenService = game:GetService("TweenService") 
        local part = getClosestObject(workspace) 
        local HRPPosition = Players.LocalPlayer.Character.HumanoidRootPart.Position 
        local realDistance = math.round(math.abs((HRPPosition - part.Position).Magnitude)) 
        if part.Parent.Name == "Ice Chunk" or part.Parent.Name == "Gold Node" then 
        ReplicatedStorage.Events.SwingTool:FireServer(ReplicatedStorage.RelativeTime.Value, { 
            [1] = part 
        }) 
        for i,v in pairs(getClosestPickups(workspace)) do 
            game:GetService("ReplicatedStorage").Events.Pickup:FireServer(v) 
        end 
        wait(0.1) 
        if part.Position.Y <= 50 then 
            TweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(realDistance/10, Enum.EasingStyle.Linear), {CFrame=part.CFrame + Vector3.new(0,part.Size.Y + 5,0)}):Play() 
            task.wait(realDistance/10) 
        end 
        end 
    end 
end 

_G.FLYING = false 
_G.iyflyspeed = 0.27 
_G.vehicleflyspeed = 0.27 

-- i love stealing features from infinite yield and adding them to my script :sunglasses: 
function sFLY(vfly) 
    repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character.HumanoidRootPart and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") 
    repeat wait() until mouse 
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end 

    local T = Players.LocalPlayer.Character.HumanoidRootPart 
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0} 
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0} 
    local SPEED = 0 

    local function FLY() 
        _G.FLYING = true 
        local BG = Instance.new('BodyGyro') 
        local BV = Instance.new('BodyVelocity') 
        BG.P = 9e4 
        BG.Parent = T 
        BV.Parent = T 
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9) 
        BG.cframe = T.CFrame 
        BV.velocity = Vector3.new(0, 0, 0) 
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9) 
        task.spawn(function() 
            repeat wait() 
                if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then 
                    Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true 
                end 
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then 
                    SPEED = 50 
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then 
                    SPEED = 0 
                end 
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then 
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED 
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R} 
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then 
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED 
                else 
                    BV.velocity = Vector3.new(0, 0, 0) 
                end 
                BG.cframe = workspace.CurrentCamera.CoordinateFrame 
            until not _G.FLYING 
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0} 
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0} 
            SPEED = 0 
            BG:Destroy() 
            BV:Destroy() 
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then 
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false 
            end 
        end) 
    end 
    flyKeyDown = mouse.KeyDown:Connect(function(KEY) 
        if KEY:lower() == 'w' then 
            CONTROL.F = (vfly and _G.vehicleflyspeed or _G.iyflyspeed) 
        elseif KEY:lower() == 's' then 
            CONTROL.B = - (vfly and _G.vehicleflyspeed or _G.iyflyspeed) 
        elseif KEY:lower() == 'a' then 
            CONTROL.L = - (vfly and _G.vehicleflyspeed or _G.iyflyspeed) 
        elseif KEY:lower() == 'd' then  
            CONTROL.R = (vfly and _G.vehicleflyspeed or _G.iyflyspeed) 
        elseif QEfly and KEY:lower() == 'e' then 
            CONTROL.Q = (vfly and _G.vehicleflyspeed or _G.iyflyspeed)*2 
        elseif QEfly and KEY:lower() == 'q' then 
            CONTROL.E = -(vfly and _G.vehicleflyspeed or _G.iyflyspeed)*2 
        end 
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end) 
    end) 
    flyKeyUp = mouse.KeyUp:Connect(function(KEY) 
        if KEY:lower() == 'w' then 
            CONTROL.F = 0 
        elseif KEY:lower() == 's' then 
            CONTROL.B = 0 
        elseif KEY:lower() == 'a' then 
            CONTROL.L = 0 
        elseif KEY:lower() == 'd' then 
            CONTROL.R = 0 
        elseif KEY:lower() == 'e' then 
            CONTROL.Q = 0 
        elseif KEY:lower() == 'q' then 
            CONTROL.E = 0 
        end 
    end) 
    FLY() 
end 

function NOFLY() 
    _G.FLYING = false 
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end 
    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then 
        Players.LocalPlayer.Character.Humanoid.PlatformStand = false 
    end 
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end) 
end 

-- Gui Making 

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()  -- RayField UI Library 
local Window = Library:CreateWindow({ 
    Name = "Shamen Hub", 
    LoadingTitle = "Shamen Hub", 
    LoadingSubtitle = "By Shadow & Lumen", -- Authors or Rblx name or discord tag or neither 
--[[    KeySystem = false,  -- Set this to true to use key system  
        KeySettings = { 
        Title = "Shamen Hub", 
        Subtitle = "Key System", 
        Note = "Join the discord (discord.gg/boogabooga)", 
        Key = "ABCDEF"} ]]-- 
}) 

local mainTab = Window:CreateTab("Main") 

local playerTab = Window:CreateTab("Player") 

local combatTab = Window:CreateTab("Combat")  

local visualTab = Window:CreateTab("Visuals") 

local farmingTab = Window:CreateTab("Farming") 

mainTab:CreateToggle({ 
        Name = "Fly", 
        Callback = function(Value) 
        if Value then 
        Players.LocalPlayer.Character:SetPrimaryPartCFrame(Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,60))  
        sFLY(true) 
    else 
        NOFLY() 
        end 
end, 
}) 

mainTab:CreateToggle({ 
        Name = "Mine Aura", 
        Callback = function(Value) 
                _G.BreakAura = Value 
        mineAura() 
        end, 
}) 

mainTab:CreateToggle({ 
        Name = "Auto PickUp", 
        Callback = function(Value) 
                _G.PickUpToggle = Value 
        autoPickUp() 
        end, 
}) 

mainTab:CreateToggle({ 
        Name = "Auto Death (Raw Meat Farm)", 
        Callback = function(Value) 
                _G.AutoDeath = Value 
        wait(5) 
        autoDeath() 
        end, 
}) 

mainTab:CreateButton({ 
        Name = "Teleport to Void", 
        Callback = function() 
        tpvoid() 
          end,     
}) 

mainTab:CreateButton({ 
        Name = "Anti Afk", 
        Callback = function() 
        afk()     
          end, 
})  


mainTab:CreateToggle({ 
    Name = "Auto Coin Press", 
    Callback = function(value) 
        _G.AutoCoinPress = value 
        autoCoinPress() 
        end, 
}) 

--AUTO FARM TAB 

farmingTab:CreateToggle({ 
    Name = "Gold nodes Grinder", 
    Callback = function(value) 
        _G.GoldNode = value 
        goldNode() 
        _G.EatToggle = value 
        eating() 
        _G.autoPickUp = value 
        autoPickUp() 
        end, 
}) 

farmingTab:CreateToggle({ 
        Name = "Auto Eat (Cooked Meat)", 
        Callback = function(Value) 
                _G.EatToggle = Value 
        eating() 
        end, 
}) 

farmingTab:CreateToggle({ 
    Name = "Auto Harvest Fruit", 
    Callback = function(value) 
        _G.AutoHarvestFruit = value 
        autoHarvestFruit() 
    end, 
}) 

farmingTab:CreateToggle({ 
    Name = "Auto Collect Essence", 
    Callback = function(value) 
        _G.AutoCollectEssence = value 
        autoCollectEssence() 
    end, 
}) 

farmingTab:CreateToggle({ 
    Name = "Coin Press Collect", 
    Callback = function(value) 
        _G.AutoCoinPressCollect = value 
        autoCoinPressCollect() 
    end, 
}) 

-- VISUALS TAB 

visualTab:CreateToggle({ 
    Name = "Crystal Bridge (client sided)", 
    Callback = function(value) 
        _G.CrystalBridge = value 
        crystalBridge() 
        end, 
}) 

visualTab:CreateToggle({ 
    Name = "Hide PlayerList", 
    Callback = function(value) 
        _G.HidePl = value 
        hidePL() 
        end, 
}) 

visualTab:CreateToggle({ 
        Name = "Lighting Fix", 
        Callback = function(value) 
        _G.Lighting = value 
        lightingFix() 
          end,     
}) 

visualTab:CreateButton({ 
        Name = "No lag", 
        Callback = function() 
        nolag() 
          end,     
}) 

visualTab:CreateToggle({ 
        Name = "Pumpkin Esp", 
        Callback = function(value) 
        _G.PumpkinEsp = value  
        pumpkinEsp() 
    end,     
}) 

visualTab:CreateToggle({ 
    Name = "No Rain", 
    Callback = function(value) 
        _G.NoRain = value 
        noRain() 
        end, 
}) 
-- Combat Tab  

combatTab:CreateToggle({ 
    Name = "Anti Hut", 
    Callback = function(value) 
        _G.AntiHut = value 
        antihut() 
    end, 
}) 

-- Player Tab 

playerTab:CreateSlider({ 
    Name = "Jump Power", 
    Range = {50, 74}, 
    Increment = 1, 
    CurrentValue = 50,  
    Callback = function(value) -- value is the slider num  
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value 
    end, 
}) 

playerTab:CreateSlider({ 
    Name = "Max Slope Climber", 
    Range = {46, 89.9}, 
    Increment = 1, 
    Suffix = "Not Sure",  
    CurrentValue = 50,  
    Callback = function(value) -- value is the slider num  
        game.Players.LocalPlayer.Character.Humanoid.MaxSlopeAngle = value 
    end, 
}) 

playerTab:CreateSlider({ 
    Name = "Hip-Height", 
    Range = {2, 5}, 
    Increment = 1, 
    CurrentValue = 2,  
    Callback = function(value) -- value is the slider num  
        game.Players.LocalPlayer.Character.Humanoid.HipHeight = value 
    end, 
}) 

playerTab:CreateSlider({ 
    Name = "Speed", 
    Range = {16, 20}, 
    Increment = 1, 
    CurrentValue = 16,  
    Callback = function(value) -- value is the slider num  
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value 
    end, 
}) 

playerTab:CreateButton({ 
    Name = "No Name", 
    Callback = function() 
        for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetDescendants()) do 
            if v:IsA("BillboardGui") then 
                v:Destroy() 
            end 
        end 
    end, 
}) 

-- game:GetService("ReplicatedStorage").Events.DropBagItem:FireServer("Leaves") -- (Event for drop item)