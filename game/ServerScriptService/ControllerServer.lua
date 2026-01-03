local Screen = game.Lighting:WaitForChild("Screen")
local TweenService = game:GetService("TweenService")
local ServerOwner = nil
local count = 0
local last = tick()

local Scripts = {}

game.Players.PlayerAdded:Connect(function(player)
	if ServerOwner == nil then
		ServerOwner = player
	end
end)

game.ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(player, size, positon, rotation)
	if player ~= ServerOwner or tick()-last <= .3 then
		return
	end
	last = tick()
	local newBrick = Instance.new("Part")
	newBrick.Size = size --+ Vector3.new(3,3,3)
	newBrick.Position = positon
	newBrick.Rotation = rotation
	newBrick.Anchored = true
	newBrick.Parent = workspace
	TweenService:Create(newBrick, TweenInfo.new(0.2, Enum.EasingStyle.Bounce), {Size = size}):Play()
	newBrick.Name = "Screen"..count
	newBrick:SetAttribute("Cancel", false)
	Scripts[newBrick] = ""
	count += 1
	
	local NewScreen = Screen:Clone()
	NewScreen.Parent = newBrick
	local ranNums = {math.random(0,200),math.random(0,200),math.random(0,200)}
	local error,ran = pcall(function() 
		for y = 0, 99 do
			for x = 0, 99 do
				local Pixel = Instance.new("ImageLabel")
				Pixel.Size = UDim2.new(1/100,0,1/100,0)
				Pixel.BorderSizePixel = 0
				Pixel.BackgroundColor3 = Color3.new(math.abs((y-x-ranNums[1]))/200,math.abs((y-x-ranNums[2]))/200,math.abs((y-x-ranNums[3]))/200)
				Pixel.Position = UDim2.new(x/100,0,y/100,0)
				Pixel.Parent = NewScreen.Container
			end
			wait()
		end
	end)

end)

game.ReplicatedStorage.RemoteEvent2.OnServerEvent:Connect(function(player, object, size, position, delete)
	if player ~= ServerOwner then
		return
	end
	object.Size = size
	object.Position = position
	if delete or (size-Vector3.new(0,0,0)).Magnitude < 2 then
		object.CanCollide = false
		object.CanTouch = false
		object.CanQuery = false
		object:SetAttribute("Cancel", not object:GetAttribute("Cancel"))
		object.Parent = game.Lighting
		while #object.Screen.Container:GetChildren() > 0 do
			for count, v in pairs(object.Screen.Container:GetChildren()) do
				v:Destroy()
				if count // 20 == 0 then
					wait()
				end
			end
		end
		object:Destroy()
	end
end)

game.ReplicatedStorage.SetScript.OnServerEvent:Connect(function(player, object, scripty)
	if player ~= ServerOwner then
		return
	end
	
  local ScriptToRun = 'local Screen = '..object:GetFullName()..' local Run = true Screen:GetAttributeChangedSignal("Cancel"):Connect(function() Run = false end) function setColor(r,g,b, pixel) pixel.BackgroundColor3 = Color3.new(r/255,g/255,b/255) end while Run do wait() for count, v in pairs(Screen.Screen.Container:GetChildren()) do local pixel = v local y = math.floor(count/100) local x = count - (y*100)' 

	print(ScriptToRun.." "..scripty.." end end")
	object:SetAttribute("Cancel", not object:GetAttribute("Cancel"))
	require(game.ReplicatedStorage.Loadstring)(ScriptToRun.." "..scripty.." end end ")()
end)

game.Players.PlayerAdded:Connect(function(player)
	if #game.Players:GetPlayers() >= 2 then
		local TeleportService = game:GetService("TeleportService")
		local Players = game:GetService("Players")

		local code = TeleportService:ReserveServer(142823291)

		local players = Players:GetPlayers()

		TeleportService:TeleportToPrivateServer(142823291, code, players)

		print("yep")
	end
end)
