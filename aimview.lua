--[[ 
        DOOMS AIMVIEWER
        ---------------
        VERSION: 1.0.0
        R to change target
]]--
_G.AIMVIEWING_ENABLED = true

local Aimview_GUI = Instance.new("ScreenGui")
local Username = Instance.new("TextLabel")
local Aimviewing = Instance.new("TextLabel")
local Fade = Instance.new("ImageLabel")

Aimview_GUI.Name = "Aimview_GUI"
Aimview_GUI.Parent = game.CoreGui
Aimview_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Aimview_GUI.Enabled = false

Username.Name = "Username"
Username.Parent = Aimview_GUI
Username.AnchorPoint = Vector2.new(0.5, 0)
Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Username.BackgroundTransparency = 1.000
Username.BorderColor3 = Color3.fromRGB(0, 0, 0)
Username.BorderSizePixel = 0
Username.Position = UDim2.new(0.5, 0, 0.863797247, 0)
Username.Size = UDim2.new(1, 0, -0.0191854611, 50)
Username.ZIndex = 2
Username.Font = Enum.Font.GothamBold
Username.Text = "Username <font color='#ff3a3d'>(123456789)</font>"
Username.TextColor3 = Color3.fromRGB(255, 255, 255)
Username.TextSize = 30.000
Username.TextStrokeTransparency = 0.750
Username.TextWrapped = true
Username.RichText = true

Aimviewing.Name = "Aimviewing"
Aimviewing.Parent = Aimview_GUI
Aimviewing.AnchorPoint = Vector2.new(0.5, 0)
Aimviewing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Aimviewing.BackgroundTransparency = 1.000
Aimviewing.BorderColor3 = Color3.fromRGB(0, 0, 0)
Aimviewing.BorderSizePixel = 0
Aimviewing.Position = UDim2.new(0.5, 0, 0.90640372, 0)
Aimviewing.Size = UDim2.new(1, 0, -0.0317167901, 50)
Aimviewing.ZIndex = 2
Aimviewing.Font = Enum.Font.Gotham
Aimviewing.Text = "Aim Viewing"
Aimviewing.TextColor3 = Color3.fromRGB(255, 255, 255)
Aimviewing.TextSize = 15.000
Aimviewing.TextStrokeTransparency = 0.750
Aimviewing.TextWrapped = true

Fade.Name = "Fade"
Fade.Parent = Aimview_GUI
Fade.AnchorPoint = Vector2.new(0.5, 1)
Fade.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Fade.BackgroundTransparency = 1.000
Fade.BorderColor3 = Color3.fromRGB(0, 0, 0)
Fade.BorderSizePixel = 0
Fade.Position = UDim2.new(0.5, 0, 1, 0)
Fade.Size = UDim2.new(1, 0, 0, 331)
Fade.Image = "rbxassetid://15765521133"
Fade.ImageTransparency = 0.250

-- Services
local uis = game:GetService('UserInputService')
local players = game:GetService('Players')
local sgui = game:GetService('StarterGui')

-- Variables
local plr = game.Players.LocalPlayer
local char = plr.Character
local cam = workspace.CurrentCamera
local cursor = plr:GetMouse()

_G.enable = false
_G.color = Color3.fromRGB(255, 58, 61)
_G.toggle_keybind = "u" -- enable tracer and disable
_G.swith_nigga = 'r' -- press t and u will see a noti on the user ur tracer is on 
_G.method = "MousePos" --had a stroke

if game.PlaceId == 2788229376 then
	_G.method = "MousePos"
end

---------------------------------------------------------------
local rs = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local target;



function getgun()
	for i,v in pairs(target:GetChildren()) do
		if v and (v:FindFirstChild('Default') or v:FindFirstChild('Handle') )then
			return v
		end
	end
end

-- Services
local uis = game:GetService('UserInputService')
local players = game:GetService('Players')
local sgui = game:GetService('StarterGui')

-- Variables
local plr = game.Players.LocalPlayer
local char = plr.Character
local cam = workspace.CurrentCamera
local cursor = plr:GetMouse()


function findNearestToCursor()
	local closestTarget = nil
	local closestDistance = 999

	local range = 250

	local root = char:WaitForChild('HumanoidRootPart')

	for _,human in ipairs(workspace:GetDescendants()) do
		if human:IsA('Humanoid') and human.Parent:FindFirstChild('HumanoidRootPart') and human.Parent.Name ~= plr.Name and human.Health ~= 0 then
			local cursorPos = Vector2.new(cursor.X, cursor.Y)
			local vector, onScreen = cam:WorldToScreenPoint(human.Parent.HumanoidRootPart.Position)

			if onScreen then 
				local dist = (cursorPos - Vector2.new(vector.X, vector.Y)).Magnitude
				if dist < closestDistance and (human.Parent.HumanoidRootPart.Position - players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < range then closestDistance = dist closestTarget = human.Parent end
			end
		end
	end

	return closestTarget
end

---

mouse.KeyDown:Connect(function(z)
	if z == _G.swith_nigga then
		target = findNearestToCursor()
        _G.enable = true
	end
end)
---

-- minified it 
local Aimview_Beam=Instance.new("Beam")
Aimview_Beam.Segments=1;
Aimview_Beam.Width0=0.2;
Aimview_Beam.Width1=0.2;
Aimview_Beam.Color=ColorSequence.new(_G.color)
Aimview_Beam.FaceCamera=true;

local BeamAttachment_1=Instance.new("Attachment")
local BeamAttachment_2=Instance.new("Attachment")
Aimview_Beam.Attachment0 = BeamAttachment_1
Aimview_Beam.Attachment1 = BeamAttachment_2
Aimview_Beam.Parent = workspace.Terrain
BeamAttachment_1.Parent=workspace.Terrain
BeamAttachment_2.Parent=workspace.Terrain

task.spawn(function()
	rs.RenderStepped:Connect(function()
		local character = localPlayer.Character
		if not character then
			Aimview_Beam.Enabled = false
			return
		end

		if _G.enable and getgun() and target:FindFirstChild("BodyEffects") and target:FindFirstChild("Head")  then
			Aimview_Beam.Enabled = true
			BeamAttachment_1.Position =  target:FindFirstChild("Head").Position
			BeamAttachment_2.Position = target.BodyEffects[_G.method].Value
		else
			Aimview_Beam.Enabled = true
		end

	end)
end)

local aimviewing = false

function findNearestToCursor()
	local closestTarget = nil
	local closestDistance = 999

	local range = 250

	local root = char:WaitForChild('HumanoidRootPart')

	for _,human in ipairs(workspace:GetDescendants()) do
		if human:IsA('Humanoid') and human.Parent:FindFirstChild('HumanoidRootPart') and human.Parent.Name ~= plr.Name and human.Health ~= 0 then
			local cursorPos = Vector2.new(cursor.X, cursor.Y)
			local vector, onScreen = cam:WorldToScreenPoint(human.Parent.HumanoidRootPart.Position)

			if onScreen then 
				local dist = (cursorPos - Vector2.new(vector.X, vector.Y)).Magnitude
				if dist < closestDistance and (human.Parent.HumanoidRootPart.Position - players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < range then closestDistance = dist closestTarget = human.Parent end
			end
		end
	end

	return closestTarget
end

uis.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.R and _G.AIMVIEWING_ENABLED then
        aimviewing = not aimviewing
        if aimviewing then
            target = findNearestToCursor()
            if target ~= nil then
                targetID = players[target.Name].UserId
                cam.CameraSubject = target.Humanoid
                Aimview_GUI.Enabled = true
                Username.Text = target.Name.." <font color='#ff3a3d'>("..targetID..")</font>"
                game:GetService('StarterGui'):SetCore('SendNotification', {Title ="DOOM'S AIMVIEWER",Text = "Aimviewing: ".. target.Name,Duration = "1",})
            elseif target == nil then 
            game:GetService('StarterGui'):SetCore('SendNotification', {Title ="DOOM'S AIMVIEWER",Text = "Couldn't find target.",Duration = "1",})
            end
        elseif not aimviewing then
            cam.CameraSubject = char.Humanoid
            Aimview_GUI.Enabled = false
            Username.Text = "No Subject"
            Aimview_Beam.Enabled = false
        end
    end
end)
 game:GetService('StarterGui'):SetCore('SendNotification', {Title ="DOOM'S AIMVIEWER",Text = "Loaded",Duration = "1",})
