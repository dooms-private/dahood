__=[[ 
		888    888                                 888               888                           
		888    888                                 888               888                          
		888    888                                 888               888                         
		888888 88888b.  888  888  .d88b.  .d8888b  88888b.   8888b.  888  888  .d88b.  888d888    
		888    888 "88b 888  888 d88P"88b 88K      888 "88b     "88b 888 .88P d8P  Y8b 888P"      
		888    888  888 888  888 888  888 "Y8888b. 888  888 .d888888 888888K  88888888 888        
		Y88b.  888  888 Y88b 888 Y88b 888      X88 888  888 888  888 888 "88b Y8b.     888         
		 "Y888 888  888  "Y88888  "Y88888  88888P' 888  888 "Y888888 888  888  "Y8888  888         
									  888                                                                               
								Y8b d88P                                                                               
								"Y88P"                                                                    
[[---------------------------------------------------------------------------------------------------------------------------]]

--[ Wait for the game to load ]-------------------------------
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild('FULLY_LOADED_CHAR')

--[ Variables ]-----------------------------------------------
local plr = game.Players.LocalPlayer
local backpack = plr.Backpack
local money = plr:WaitForChild('DataFolder').Currency

local toggle_keybind = 'X'

--[ Toggles ]-------------------------------------------------
local tasers_muted	 = false
local chat_spy		 = false
local cash_aura		 = false

local noclip		 = false
local noclipping	 = false

local cframe_walk    = false
local cframe_enabled = false
local cframe_key	 = 'y'
local cframe_speed	 = 2

local desync		 = false
local resolver	 	 = false
local anti_lock		 = false
local strafing 		 = false

local target         = nil

--[ Services ]------------------------------------------------
local input_service = game:GetService('UserInputService')
local run_service = game:GetService('RunService')
local tp_service = game:GetService('TeleportService')

--[ Tables ]--------------------------------------------------
local autobuy = {
	{ category = "guns", items = { 
		'Revolver', 
		'Double-Barrel SG', 
		'Drum-Shotgun', 
		'TacticalShotgun', 
		'Shotgun', 
		'DrumGun', 
		'SilencerAR', 
		'Silencer', 
		'Glock', 
		'Rifle', 
		'AK47', 
		'AUG', 
		'SMG', 
		'LMG', 
		'P90', 
		'AR' 
	}},

	{ category = "supers", items = { 
		'Flamethrower', 
		'GrenadeLauncher', 
		'RPG' 
	}},

	{ category = "armor", items = { 
		'Fire Armor', 
		'Medium Armor', 
		'High-Medium Armor',
	}},

	{ category = "melee", items = { 
		'SledgeHammer', 
		'Pitchfork', 
		'StopSign', 
		'Shovel', 
		'Pencil', 
		'Knife',
		'Bat', 
	}},

	{ category = "food", items = { 
		'Taco', 
		'Pizza', 
		'Hamburger', 
		'HotDog', 
		'Chicken', 
		'Popcorn', 
		'Meat', 
		'Lettuce', 
		'Donut', 
		'Starblox Latte', 
		'Da Milk', 
		'Cranberry', 
		'Lemonade' 
	}},

	{ category = "other", items = { 
		'Grenade', 
		'Flashbang', 
		'Crossbow', 
		'PepperSpray', 
		'TearGas', 
		'Taser' 
	}},

	{ category = "random", items = { 
		'LockPicker', 
		'Riot Mask', 
		'Skull Mask', 
		'Ninja Mask', 
		'Hockey Mask', 
		'Breathing Mask', 
		'Paintball Mask', 
		'Weights', 
		'HeavyWeights', 
		'Money Gun', 
		'Flowers', 
		'Basketball', 
		'BrownBag', 
		'Flashlight' 
	}},

	{ category = "ammo", items = {} },
}

--[ Functions ]-----------------------------------------------
function distance_check(object)
	local distance = 0

	local char = plr.Character or plr.CharacterAdded:Wait()
	local root = char:WaitForChild('HumanoidRootPart') 
	if root then
		distance = (object.Position - root.Position).Magnitude
	end

	return distance
end

function get_root(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local root = nil

	if player.Character then
		local root = character.HumanoidRootPart or character:WaitForChild('HumanoidRootPart')
	elseif player.Character == nil then
		return warn('Could not find root of player: ' .. player.Name)
	end
	
	return root
end

function toggle_chatspy(bool)
	local chat = plr.PlayerGui:WaitForChild('Chat')
	local chat_box = chat.Frame.ChatChannelParentFrame
	local chat_bar = chat.Frame.ChatBarParentFrame
	chat_box.Visible = bool
	
	if bool then
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = '[ thugshaker v2 ] > chat spy enabled';
			Font = Enum.Font.GothamBold;
			Color = Color3.fromRGB(158, 40, 208);
			FontSize = Enum.FontSize.Size96;
			RichText = true;	
		})

		chat_bar.AnchorPoint = Vector2.new(0, 1)
		chat_bar.Position = UDim2.new(0, 0, 1, 0)
	elseif not bool then
		chat_bar.AnchorPoint = Vector2.new(0, 0)
		chat_bar.Position = UDim2.new(0, 0, 0, 0)
	end
end

--[ Loading UI library ]--------------------------------------
local repo = 'https://raw.githubusercontent.com/dooms-scripts/ui-libraries/main/encrypt/'

local encrypt       = loadstring(game:HttpGet(repo .. 'encrypt.lua'))()
local notifications = loadstring(game:HttpGet(repo .. 'encrypt-notifications.lua'))()
local esp			= loadstring(game:HttpGet(repo .. 'encrypt-esp.lua'))()

local camlock = loadstring(game:HttpGet('https://raw.githubusercontent.com/dooms-private/dahood/main/camlock'))()

--[ Configuration ]-------------------------------------------
local notification_format = '<font face="Gotham"><font color="rgb(255,12,243)">thugshaker v2</font></font><font face="SourceSans"><font color="rgb(255,255,255)"> > '
camlock.config.custom_text = 'thugshaker v2'
encrypt.colors.main_color = Color3.fromRGB(215, 70, 255)

--[ Create window ]-------------------------------------------
local window = encrypt.new_window({ title_text = 'thugshaker v2'})

--[ Create tabs ]---------------------------------------------
local main_tab	   = window.new_tab('main')
local teleport_tab = window.new_tab('teleport')
local autobuy_tab  = window.new_tab('autobuy')
local aimlock_tab  = window.new_tab('aimlock')
local esp_tab	   = window.new_tab('esp')

------------------------------------------------------
----	88888b.d88b.   8888b.  888 88888b.        ----
----	888 "888 "88b     "88b 888 888 "88b       ----
------------------------------------------------------
group1 = main_tab.new_group('group1')
group2 = main_tab.new_group('group2')

gui_category	= group1.new_category('GUI')
game_category	= group1.new_category('game')
player_category = group1.new_category('local player')
target_category = group2.new_category('target')

--[ COROUTINES ]----------------------------------------------
local threads = {}
threads.cash_aura = coroutine.create(function()
	while cash_aura do
		task.wait(0.1)
		local char = plr.Character or plr.CharacterAdded:Wait()
		local root = char:WaitForChild('HumanoidRootPart')
		for _, money in ipairs(workspace.Ignored.Drop:GetChildren()) do
			if money.Name == 'MoneyDrop' and distance_check(money) < 16 then
				local s, err = pcall(function()
					fireclickdetector(money.ClickDetector)
				end)

				if err then warn('err') end
			end
		end
	end
end)

threads.mute_tasers = coroutine.create(function()
	while task.wait() do
		if tasers_muted then
			for _, taser in ipairs(game:GetDescendants()) do
				if taser.Name == '[Taser]' then
					taser.Handle.Sound.Volume = 0
				end
			end
		elseif not tasers_muted then
			for _, taser in ipairs(game:GetDescendants()) do
				if taser.Name == '[Taser]' then
					taser.Handle.Sound.Volume = 1
				end
			end
		end
	end
end)

threads.cframe_walk_thread = coroutine.wrap(function()
	run_service.Stepped:Connect(function()
		task.wait()
		if cframe_walk then
			local char = plr.Character or plr.CharacterAdded:Wait()
			local root = char:WaitForChild('HumanoidRootPart')
			root.CFrame = root.CFrame + char.Humanoid.MoveDirection * cframe_speed
		end
	end)
end)()

threads.noclip_thread = coroutine.wrap(function()
	run_service.Stepped:Connect(function()
		task.wait()
		if noclipping then
			local char = plr.Character or plr.CharacterAdded:Wait()
			for _, basePart in ipairs(char:GetDescendants()) do
				if basePart:IsA('BasePart') then
					if basePart.Name == 'RootRigAttachment' then return end
					basePart.CanCollide = false
				end
			end
		end

		if not noclipping then
			local char = plr.Character or plr.CharacterAdded:Wait()
			for _, basePart in ipairs(char:GetDescendants()) do
				if basePart:IsA('BasePart') and basePart.Name == 'UpperTorso' or 'LowerTorso' or 'HumanoidRootPart'  then
					if basePart.Name == 'RootRigAttachment' then return end
					basePart.CanCollide = true
				end
			end
		end
	end)
end)()

coroutine.wrap(function()
    local count = 0
    local speed = 15
    local radius = 15
    run_service.Stepped:Connect(function()
        if strafing and target then
            local char = plr.Character or plr.CharacterAdded:Wait()
            local root = char.HumanoidRootPart or char:WaitForChild('HumanoidRootPart')
            local target_char = target.Character or target.CharacterAdded:Wait()
            local target_root = target_char.HumanoidRootPart or target_char:WaitForChild('HumanoidRootPart')

            if target_char and target_root then
                count += 1

                local rad = math.rad(count * speed)
                local angles = Vector3.new(math.cos(rad) * radius, 0, math.sin(rad) * radius)

                root.CFrame = CFrame.new(target_root.Position + angles + Vector3.new(0, 3, 0), root.Position)
            end
        end
    end)
end)()

--[ UI ELEMENTS ]---------------------------------------------
gui_category.new_keybind({ text = 'toggle gui', default_key = 'x', callback = function()  encrypt:toggle() end})
gui_category.new_button({ text = 'exit', callback = function()  encrypt:exit()  end})

game_category.new_toggle({ text = 'chat spy', callback = function()
	chat_spy = not chat_spy
	-- notifications.notify(string.format('%s chat spy: %s </font></font>', notification_format, tostring(chat_spy)), 3)

	toggle_chatspy(chat_spy)
end})

game_category.new_toggle({ text = 'mute tasers', callback = function()
	tasers_muted = not tasers_muted
	coroutine.resume(threads.mute_tasers)
	-- notifications.notify(string.format('%s tasers muted: %s </font></font>',  notification_format, tostring(tasers_muted)), 3)
end})

game_category.new_toggle({ text = 'cash aura', callback = function()
	cash_aura = not cash_aura
	coroutine.resume(threads.cash_aura)
	-- notifications.notify(string.format('%s cash aura: %s </font></font>',  notification_format, tostring(cash_aura)), 3)
end})

game_category.new_button({ text = 'rejoin server', callback = function()
	tp_service:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end})

player_category.new_label({ text = 'cframe walk'}).alignment('center')

cframe_walk_toggle = player_category.new_toggle({ text = 'cframe walk', callback = function() 
	cframe_enabled = not cframe_enabled 
end})

cframe_walk_speed = player_category.new_textbox({ text = 'cframe speed', placeholder_text = '2', callback = function() 
	cframe_speed = tonumber(cframe_walk_speed.text) 
end})

cframe_walk_keybind = player_category.new_keybind({ text = 'cframe keybind', keybind = 'E', callback = function()
	if cframe_enabled then 	
		cframe_walk = not cframe_walk 

		notifications.notify(string.format('%s toggled cframe speed </font></font>',  notification_format), 3)
	end
end})

player_category.new_label({ text = 'noclip'}).alignment('center')

noclip_toggle = player_category.new_toggle({ text = 'noclip', callback = function() 
	noclip = not noclip 
end})

noclip_keybind = player_category.new_keybind({ text = 'noclip keybind', callback = function()
	if noclip_enabled then noclipping = not noclipping end
	notifications.notify(string.format('%s toggled noclip </font></font>',  notification_format), 3)
end})

target_box = target_category.new_textbox({ text = 'target', placeholder_text = 'user', callback = function(input)
    target = game.Players[input]
end})

target_keybind = target_category.new_keybind({ text = 'change target', callback = function()
    -- print('no workie yet')
    function find_nearest()
        local players = game:GetService('Players')
        local cursor = plr:GetMouse()

        local closest_target = nil
        local closest_distance = 999
    
        local s,error = pcall(function()
            local plr = players.LocalPlayer
            local char = plr.Character or plr.CharacterAdded:Wait()
            local root = char:WaitForChild('HumanoidRootPart')
            local human = char:WaitForChild('Humanoid')
    
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character and root and player.Name ~= plr.Name then
                    local human = player.Character.Humanoid
                    local mouse_pos = Vector2.new(cursor.X, cursor.Y)
                    local vector, on_screen = workspace.CurrentCamera:WorldToScreenPoint(human.Parent.HumanoidRootPart.Position)

                    if on_screen then 
                        local dist = (mouse_pos - Vector2.new(vector.X, vector.Y)).Magnitude
                        if dist < closest_distance then 
                            closest_distance = dist 
                            closest_target = human.Parent 
                        end
                    end
                end
            end
        end)
    
        if error then warn(error) end
    
        return closest_target
    end

    nearest = find_nearest()
    target = game.Players[nearest.Name]

    target_box.update(nearest.Name)
end})

strafe_toggle = target_category.new_toggle({ text = 'strafe', callback = function()
    strafing = not strafing
end})

view_toggle = target_category.new_toggle({ text = 'view', callback = function(value)
    if value then
        workspace.CurrentCamera.CameraSubject = target.Character:WaitForChild('Humanoid')
    elseif not value then
        workspace.CurrentCamera.CameraSubject = plr.Character:WaitForChild('Humanoid')
    end
end})

target_category.new_button({ text = 'go to', callback = function()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local root = char:WaitForChild('HumanoidRootPart')

    local target_char = target.Character or target.CharacterAdded:Wait()
    local target_root = target_char.HumanoidRootPart or target_char:WaitForChild('HumanoidRootPart')

    root.CFrame = target.Character.HumanoidRootPart.CFrame
end})

target_category.new_button({ text = 'target random', callback = function()
    players = game:GetService('Players')
    random = math.random(1, #players:GetChildren())

    target = players:GetChildren()[random]
end})

---- ------------------------------------------------------                          
----	▄▀█ █░█ ▀█▀ █▀█ █▄▄ █░█ █▄█                    ----
----	█▀█ █▄█ ░█░ █▄█ █▄█ █▄█ ░█░                    ----
-----------------------------------------------------------

group1 = autobuy_tab.new_group('group1')
group2 = autobuy_tab.new_group('group2')

local guns_category	  = group1.new_category('guns')
local supers_category = group1.new_category('supers')
local ammo_category	  = group1.new_category('ammo')
local melee_category  = group1.new_category('melee')
local armor_category  = group2.new_category('armor')
local food_category   = group2.new_category('food')
local other_category  = group2.new_category('other')
local random_category = group2.new_category('random')

--[ FUNCTIONS ]--------------------------------------------
function owns_item(item_name)
	local plr = game.Players.LocalPlayer
	local char = plr.Character or plr.CharacterAdded:Wait()
	local owns = false
	if char:FindFirstChild(item_name) then owns = true end
	if plr.Backpack:FindFirstChild(item_name) then owns = true end
	return owns
end

function get_shop(filter)
	local shop = nil
	for _, s in ipairs(workspace.Ignored.Shop:GetChildren()) do
		if string.match(s.Name, 'Ammo') ==  'Ammo' then
		else
			if string.match(s.Name, "%[(.-)%]") == filter and s:FindFirstChild('Head') then
				shop = s
			end
		end
	end
	return shop
end

function buy_item(shop, item_name)
	if item_name == nil then item_name = '' end

	local char = plr.Character or plr.CharacterAdded:Wait()
	local root = char.HumanoidRootPart or char:WaitForChild('HumanoidRootPart')
	local old_position = root.Position
	local old_money = money.Value

	root.CFrame = CFrame.new(shop.Head.Position)
	task.wait(.15)
	repeat task.wait() fireclickdetector(shop.ClickDetector) until money.Value < old_money or backpack:FindFirstChild(item_name)

	task.wait()
	root.CFrame = CFrame.new(old_position)
end

for _, data in ipairs(autobuy) do
	if data.category == 'guns' then
		for _, item_name in ipairs(data.items) do
			local shop = get_shop(item_name)
			local filtered_name = shop.Name:match('%[(.-)%]')
			local formatted_name = '['..item_name..']'
		
			guns_category.new_button({ text = string.lower(filtered_name), callback = function() if shop ~= nil and owns_item(formatted_name) == false then buy_item(shop, formatted_name) end end})
		end
	end

	if data.category == 'supers' then
		for _, item_name in ipairs(data.items) do
			local shop = get_shop(item_name)
			local filtered_name = shop.Name:match('%[(.-)%]')
			local formatted_name = '['..item_name..']'
		
			supers_category.new_button({ text = string.lower(filtered_name), callback = function() if shop ~= nil and owns_item(formatted_name) == false then buy_item(shop, formatted_name) end end})
		end
	end

	if data.category == 'ammo' then
		for _, shop in ipairs(workspace.Ignored.Shop:GetChildren()) do
			if shop.Name:match('Ammo') and shop:FindFirstChild('Head') then
				local filtered_name = shop.Name:match('%[(.-)%]')
				local gun_name = '['..filtered_name:gsub(' Ammo','')..']'

				ammo_category.new_button({ text = string.lower(filtered_name), callback = function()
					warn('Buying ammo for: '..gun_name)
					if owns_item(gun_name) == false then 
						return warn('You do not own the gun you are attempting to buy ammo for.') 
					end

					buy_item(shop)
				end})
			end
		end
	end

	if data.category == 'melee' then
		for _, item_name in ipairs(data.items) do
			local shop = get_shop(item_name)
			local filtered_name = shop.Name:match('%[(.-)%]')
			local formatted_name = '['..item_name..']'
		
			melee_category.new_button({ text = string.lower(filtered_name), callback = function() if shop ~= nil and owns_item(formatted_name) == false then buy_item(shop, formatted_name) end end})
		end
	end

	if data.category == 'armor' then
		for _, item_name in ipairs(data.items) do
			local shop = get_shop(item_name)
			local filtered_name = shop.Name:match('%[(.-)%]')
			local formatted_name = '['..item_name..']'
		
			armor_category.new_button({ text = string.lower(filtered_name), callback = function() if shop ~= nil and owns_item(formatted_name) == false then buy_item(shop, formatted_name) end end})
		end
	end

	if data.category == 'food' then
		for _, item_name in ipairs(data.items) do
			local shop = get_shop(item_name)
			local filtered_name = shop.Name:match('%[(.-)%]')
			local formatted_name = '['..item_name..']'
		
			food_category.new_button({ text = string.lower(filtered_name), callback = function() if shop ~= nil and owns_item(formatted_name) == false then buy_item(shop, formatted_name) end end})
		end
	end

	if data.category == 'other' then
		for _, item_name in ipairs(data.items) do
			local shop = get_shop(item_name)
			local filtered_name = shop.Name:match('%[(.-)%]')
			local formatted_name = '['..item_name..']'
		
			other_category.new_button({ text = string.lower(filtered_name), callback = function() if shop ~= nil and owns_item(formatted_name) == false then buy_item(shop, formatted_name) end end})
		end
	end

	if data.category == 'random' then
		for _, item_name in ipairs(data.items) do
			local shop = get_shop(item_name)
			local filtered_name = shop.Name:match('%[(.-)%]')
			local formatted_name = '['..item_name..']'
		
			random_category.new_button({ text = string.lower(filtered_name), callback = function() if shop ~= nil and owns_item(formatted_name) == false then buy_item(shop, formatted_name) end end})
		end
	end
end

--[[                                
		▄▀█ █ █▀▄▀█ █   █▀█ █▀▀ █▄▀    ▀█▀ ▄▀█ █▄▄
		█▀█ █ █░▀░█ █▄▄ █▄█ █▄▄ █░█    ░█░ █▀█ █▄█
]]--

--[ CAMLOCK CATEGORY ]--------------------------------
camlock_auto_pred = false
camlock.enabled = false

--[ UI ELEMENTS ]-------------------------------------
group1 = aimlock_tab.new_group('group1')
group2 = aimlock_tab.new_group('group2')
camlock_category = group1.new_category('camlock')
aimbot_category = group2.new_category('aimlock')

toggle_camlock	 = camlock_category.new_toggle({ text = 'camlock',			  callback = function() camlock.enabled = not camlock.enabled end})
borders			 = camlock_category.new_toggle({ text = 'borders',			  callback = function() camlock.config.borders = not camlock.config.borders end})
labels			 = camlock_category.new_toggle({ text = 'labels',			  callback = function() camlock.config.labels = not camlock.config.labels end})
higlights		 = camlock_category.new_toggle({ text = 'highlights', 		  callback = function() camlock.config.highlights = not camlock.config.highlights end})
notifications	 = camlock_category.new_toggle({ text = 'notifications', 	  callback = function() camlock.config.notifications = not camlock.config.notifications end})
predictions		 = camlock_category.new_toggle({ text = 'predictions', 		  callback = function() camlock.config.predictions = not camlock.config.predictions end})
auto_predictions = camlock_category.new_toggle({ text = 'auto prediction', 	  callback = function() camlock_auto_pred = not camlock_auto_pred  end})
keybind			 = camlock_category.new_keybind({ text = 'keybind', 'Q',	  callback = function() camlock.config.keybind = keybind.key end})
x_prediction	 = camlock_category.new_textbox({ text = 'x prediction',  placeholder_text = '0',	callback = function() camlock.config.x_prediction = tonumber(x_prediction.text) end})
y_prediction	 = camlock_category.new_textbox({ text = 'y prediction',  placeholder_text = '0', 	callback = function() camlock.config.y_prediction = tonumber(y_prediction.text) end})
range			 = camlock_category.new_textbox({ text = 'range', 		  placeholder_text = '250', 	callback = function() camlock.config.range = tonumber(range.text) end})
importc			 = camlock_category.new_textbox({ text = 'custom config', placeholder_text = 'code here', callback = function() end})

--[ COROUTINES ]--------------------------------------
coroutine.wrap(function()
    function autopred(ping)
        local starter = 0.1
        local pred = (0.1 + (0.000698800 * ping - 0.000001))*10

        return pred
    end

    run_service.Stepped:Connect(function()
        if camlock_auto_pred then
		    local ping = plr:GetNetworkPing() * 2000
		    camlock.config.x_prediction = autopred(ping)
		    camlock.config.y_prediction = autopred(ping) * 1.25

            x_prediction:disable()
            y_prediction:disable()

            x_prediction.update(tostring(camlock.config.x_prediction):sub(1, 5))
            y_prediction.update(tostring(camlock.config.y_prediction):sub(1, 5))
        elseif not camlock_auto_pred then
            x_prediction:enable()
            y_prediction:enable()

            -- x_prediction.update('0')
            -- y_prediction.update('0')
        end
    end)
end)()

camlock_category.new_button({ text = 'export config', callback = function() 
	local config_export = [[
-- thugshakerv2 config export testing
camlock.config = {
	keybind = %s,
	range = %s,
	prediction = %s,
	notifications   = %s,
	predictions     = %s,
	highlights      = %s,
	borders         = %s,
	labels          = %s,
	vis_check       = %s,
}
	]]

	local formatted = (string.format(config_export, 
		tostring(camlock.config.keybind), 
		tostring(camlock.config.range),
		tostring(camlock.config.prediction),
		tostring(camlock.config.notifications), 
		tostring(camlock.config.predictions), 
		tostring(camlock.config.highlights), 
		tostring(camlock.config.borders), 
		tostring(camlock.config.labels), 
		tostring(camlock.config.vis_check)
	))

	setclipboard(formatted)
end})

-->> Antilock Category

-- ESP
group1 = esp_tab.new_group('group1')
esp_category = group1.new_category('ESP')

box_toggle = esp_category.new_toggle({ text = 'boxes', callback = function()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player and player.Character and player ~= plr then
			esp.new_box(player)
		end
	end
end})

tracer_toggle = esp_category.new_toggle({ text = 'tracers', callback = function()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player and player.Character and player ~= plr then
			esp.new_tracer(player)
		end
	end
end})

text_toggle = esp_category.new_toggle({ text = 'names', callback = function()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player and player.Character and player ~= plr then
			esp.new_text(player)
		end
	end
end}) 

warn('thugshaker v2; beta release loaded')
