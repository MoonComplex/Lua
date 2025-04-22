local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local controlHeld = false

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.LeftControl then
		controlHeld = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		controlHeld = false
	end
end)

local function ComplexTweenTo(position)
	local currentPos = root.Position
	local targetPos = Vector3.new(position.X, currentPos.Y, position.Z)
	local distance = (targetPos - currentPos).Magnitude
	local duration = distance / 4

	local intermediate1 = root.CFrame:Lerp(CFrame.new((currentPos + targetPos) / 2 + Vector3.new(0, 8, 0)), 0.3)
	local intermediate2 = CFrame.new(targetPos + Vector3.new(3, 5, -3))
	local finalTarget = CFrame.new(targetPos, targetPos + root.CFrame.LookVector)

	local tweenInfo1 = TweenInfo.new(duration * 0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
	local tweenInfo2 = TweenInfo.new(duration * 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tweenInfo3 = TweenInfo.new(duration * 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	local tween1 = TweenService:Create(root, tweenInfo1, {CFrame = intermediate1})
	local tween2 = TweenService:Create(root, tweenInfo2, {CFrame = intermediate2})
	local tween3 = TweenService:Create(root, tweenInfo3, {CFrame = finalTarget})

	tween1:Play()
	tween1.Completed:Connect(function()
		tween2:Play()
		tween2.Completed:Connect(function()
			tween3:Play()
		end)
	end)
end

mouse.Button1Down:Connect(function()
	if not controlHeld then return end
	local targetPos = mouse.Hit.Position
	ComplexTweenTo(targetPos)
end)
