--[[
	       __                                                   __           __  
	  ____/ /___  ____  ____ ___  _____   _________ _____ ___  / /___  _____/ /__
	 / __  / __ \/ __ \/ __ `__ \/ ___/  / ___/ __ `/ __ `__ \/ / __ \/ ___/ //_/
	/ /_/ / /_/ / /_/ / / / / / (__  )  / /__/ /_/ / / / / / / / /_/ / /__/ ,<   
	\__,_/\____/\____/_/ /_/ /_/____/   \___/\__,_/_/ /_/ /_/_/\____/\___/_/|_|  
	-----------------------------------------------------------------------------
	> now a lot faster (thx polar baby:3)
	> lot more customizeable
]]--

local encrypt = loadstring(game:HttpGet('https://raw.githubusercontent.com/dooms-scripts/ui-libraries/main/encrypt-notifications.lua'))()

camlock = {
	enabled = true
}

camlock.config = {
	keybind		= 'q',

	range 		= 250,
	x_prediction 	= 0,
	y_prediction 	= 0,

	notifications   = false,
	predictions     = false,
	highlights      = false,
	borders         = false,
	labels          = false,
	vis_check       = false,

	custom_text	= "doom's camlock",
}

-->> Services
local input_service = game:GetService('UserInputService')
local run_service = game:GetService('RunService')
local starter_gui = game:GetService('StarterGui')
local players = game:GetService('Players')

-->> Variables
local plr = players.LocalPlayer
local char = plr.Character
local root = char:WaitForChild('HumanoidRootPart')
local cam = workspace.CurrentCamera
local cursor = plr:GetMouse()

local locking = false
local target = nil

-->> Functions
function get_distance(obj)
	local distance = (root.Position - obj.Position).Magnitude
	return distance
end

function find_nearest()
	local closest_target = nil
	local closest_distance = 999
	
	local s,error = pcall(function()
		local range = camlock.config.range

		local plr = players.LocalPlayer
		local char = plr.Character or plr.CharacterAdded:Wait()
		local root = char:WaitForChild('HumanoidRootPart')
		local human = char:WaitForChild('Humanoid')

		for _,player in ipairs(game.Players:GetPlayers()) do
			if player.Character and root and player.Name ~= plr.Name and human.Health > 0 then
				local human = player.Character.Humanoid
				if get_distance(human.Parent.HumanoidRootPart) < range then
					local mouse_pos = Vector2.new(cursor.X, cursor.Y)
					local vector, on_screen = cam:WorldToScreenPoint(human.Parent.HumanoidRootPart.Position)
	
					if on_screen then 
						local dist = (mouse_pos - Vector2.new(vector.X, vector.Y)).Magnitude
						if dist < closest_distance then 
							closest_distance = dist closest_target = human.Parent 
						end
					end
				end
			end
		end
	end)

	if error then warn(error) end

	return closest_target
end

function create_label(model)
	local BillboardGui = Instance.new("BillboardGui", model)
	local TextLabel = Instance.new("TextLabel")

	BillboardGui.Name = 'doom#1000_bb'
	BillboardGui.Adornee = model
	BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	BillboardGui.Active = true
	BillboardGui.AlwaysOnTop = true
	BillboardGui.LightInfluence = 1.000
	BillboardGui.Size = UDim2.new(75, 0, 15, 0)

	TextLabel.Parent = BillboardGui
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Font = Enum.Font.Code
	TextLabel.TextColor3 = Color3.fromRGB(158, 40, 208)
	TextLabel.TextSize = 16.000
	TextLabel.TextStrokeTransparency = 0.000
	TextLabel.Text = game.Players[model.Name].DisplayName
end

function create_outline(model)
	local box = Instance.new('SelectionBox', model)

	box.Name = 'doom#1000_sb'
	box.Adornee = model
	box.LineThickness = 0.01
	box.SurfaceTransparency = 0.95

	box.Color3 = Color3.fromRGB(158, 40, 208)
	box.SurfaceColor3 = Color3.fromRGB(158, 40, 208)
end

function create_highlight(model)
	local highlight = Instance.new('Highlight', model)
	highlight.Name = 'doom#1000_hl'
	highlight.Adornee = model
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 0

	highlight.FillColor = Color3.fromRGB(193, 49, 255)
	highlight.OutlineColor = Color3.fromRGB(193, 49, 255)
end

function clear_assets()
	for _,v in ipairs(workspace:GetDescendants()) do if v.Name == 'doom#1000_bb' then v:Destroy() end end
	for _,v in ipairs(workspace:GetDescendants()) do if v.Name == 'doom#1000_hl' then v:Destroy() end end
	for _,v in ipairs(workspace:GetDescendants()) do if v.Name == 'doom#1000_sb' then v:Destroy() end end
end

function notify(title, description, duration)
	game:GetService('StarterGui'):SetCore('SendNotification', 
	{
		Title = title,
		Text = description,
		Duration = duration,
	})
end

function unlock()
	target = nil
	clear_assets()
	if camlock.config.notifications == true then
		encrypt.notify('<font face="Gotham"><font color="rgb(255,12,243)">'..camlock.config.custom_text..'</font></font><font face="SourceSans"><font color="rgb(255,255,255)"> > unlocked camera.</font></font>', 1)
	end
end

-->> Input Handler
input_service.InputBegan:Connect(function(input)
	local focused = input_service:GetFocusedTextBox()
	if focused then return end
		
	if input.KeyCode == Enum.KeyCode[string.upper(camlock.config.keybind)] and camlock.enabled then
		locking = not locking

		if locking == true then 
			target = find_nearest()
			if target == nil then
				unlock()
				if camlock.config.notifications == true then 
					encrypt.notify('<font face="Gotham"><font color="rgb(255,12,243)">'..camlock.config.custom_text..'</font></font><font face="SourceSans"><font color="rgb(255,255,255)"> > Target could not be found</font></font>', 1) 
				end
			elseif target ~= nil then
				clear_assets()		
				if camlock.config.labels == true then create_label(target) end
				if camlock.config.borders == true then create_outline(target) end
				if camlock.config.highlights == true then create_highlight(target) end
				if camlock.config.notifications == true then 
					encrypt.notify('<font face="Gotham"><font color="rgb(255,12,243)">'..camlock.config.custom_text..'</font></font><font face="SourceSans"><font color="rgb(255,255,255)"> > target: '..target.Name..'</font></font>', 1) 
				end
			end
		elseif locking == false then
			unlock()
		end
	end	
end)

-->> Camera Handler
coroutine.wrap(function()
	run_service.Stepped:Connect(function()
		if locking == true and target ~= nil then
			if camlock.config.predictions == true then 
				if target:FindFirstChild('HumanoidRootPart') target:FindFirstChild('Humanoid') then
					local root = target:WaitForChild('HumanoidRootPart')
					local human = target:WaitForChild('Humanoid')
					local move_direction = human.MoveDirection
					cam.CFrame = CFrame.lookAt(workspace.Camera.CFrame.Position, 
					Vector3.new(
						root.Position.X + move_direction.X * camlock.config.x_prediction, 
						root.Position.Y + move_direction.Y * camlock.config.y_prediction, 
						root.Position.Z + move_direction.Z * camlock.config.x_prediction
					))
				end
			else
				if target:FindFirstChild('HumanoidRootPart') target:FindFirstChild('Humanoid') then		
					local root = target:WaitForChild('HumanoidRootPart')
					cam.CFrame = CFrame.lookAt(workspace.Camera.CFrame.Position, root.Position)
				end
			end
		end 
	end)
end)()

warn("doom's camlock loaded v1.4.0")

return camlock
