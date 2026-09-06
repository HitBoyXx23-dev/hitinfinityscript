if HIS_LOADED and not _G.HIS_DEBUG then return end
pcall(function() getgenv().HIS_LOADED = true end)

task.wait(0.5)

if not game:IsLoaded() then game.Loaded:Wait() end

function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)
gethui = missing("function", gethui or get_hidden_gui)
syn = missing("table", syn)
syn_protect_gui = missing("function", syn and syn.protect_gui)
sethidden = missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden = missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
queueteleport = missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
httprequest = missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
everyClipboard = missing("function", setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set))
firetouchinterest = missing("function", firetouchinterest)
waxwritefile, waxreadfile = writefile, readfile
writefile = missing("function", waxwritefile) and function(file, data, safe)
	if safe == true then return pcall(waxwritefile, file, data) end
	waxwritefile(file, data)
end
readfile = missing("function", waxreadfile) and function(file, safe)
	if safe == true then return pcall(waxreadfile, file) end
	return waxreadfile(file)
end
isfile = missing("function", isfile, readfile and function(file)
	local success, result = pcall(function()
		return readfile(file)
	end)
	return success and result ~= nil and result ~= ""
end)
makefolder = missing("function", makefolder)
isfolder = missing("function", isfolder)
waxgetcustomasset = missing("function", getcustomasset or getsynasset)
hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)
getnamecallmethod = missing("function", getnamecallmethod or get_namecall_method)
checkcaller = missing("function", checkcaller, function() return false end)
newcclosure = missing("function", newcclosure, function(f, ...) return f(...) end)
getgc = missing("function", getgc or get_gc_objects)
setthreadidentity = missing("function", setthreadidentity or (syn and syn.set_thread_identity) or syn_context_set or setthreadcontext)
replicatesignal = missing("function", replicatesignal)
getconnections = missing("function", getconnections or get_signal_cons)

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})

Players = Services.Players
UserInputService = Services.UserInputService
TweenService = Services.TweenService
HttpService = Services.HttpService
RunService = Services.RunService
TeleportService = Services.TeleportService
StarterGui = Services.StarterGui
GuiService = Services.GuiService
Lighting = Services.Lighting
ContextActionService = Services.ContextActionService
ReplicatedStorage = Services.ReplicatedStorage
GroupService = Services.GroupService
PathService = Services.PathfindingService
SoundService = Services.SoundService
Teams = Services.Teams
StarterPlayer = Services.StarterPlayer
TextChatService = Services.TextChatService
VoiceChatService = Services.VoiceChatService
SocialService = Services.SocialService
MarketplaceService = Services.MarketplaceService
ProximityPromptService = Services.ProximityPromptService
MaterialService = Services.MaterialService
AvatarEditorService = Services.AvatarEditorService
TextService = Services.TextService
CaptureService = Services.CaptureService
ContentProvider = Services.ContentProvider

PlayerGui = cloneref(Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui"))
COREGUI = Services.CoreGui or PlayerGui
HISMouse = cloneref(Players.LocalPlayer:GetMouse())
PlaceId, JobId = game.PlaceId, game.JobId

IsOnMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

if makefolder and isfolder and writefile and isfile then
	pcall(function()
		for _, folder in {"HIS", "HIS/Plugins"} do
			if not isfolder(folder) then
				makefolder(folder)
			end
		end
	end)
end

currentVersion = "1.0.0"

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

PARENT = nil
MAX_DISPLAY_ORDER = 1.7976931348623157e308

if gethui then
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = gethui()
    PARENT = Main
elseif syn_protect_gui then
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    syn_protect_gui(Main)
    Main.Parent = COREGUI
    PARENT = Main
elseif COREGUI:FindFirstChild("RobloxGui") then
    PARENT = COREGUI.RobloxGui
else
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = COREGUI
    PARENT = Main
end

shade1 = {}
shade2 = {}
shade3 = {}
text1 = {}
text2 = {}
scroll = {}

ScaledHolder = Instance.new("Frame")
ScaledHolder.Name = randomString()
ScaledHolder.Size = UDim2.fromScale(1, 1)
ScaledHolder.BackgroundTransparency = 1
ScaledHolder.Parent = PARENT

Scale = Instance.new("UIScale")
Scale.Name = randomString()
Scale.Parent = ScaledHolder

Holder = Instance.new("Frame")
Holder.Name = randomString()
Holder.Parent = ScaledHolder
Holder.Active = true
Holder.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(0.8, 0, 0.3, 0)
Holder.Size = UDim2.new(0, 320, 0, 400)
Holder.ZIndex = 10
table.insert(shade2,Holder)

Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Holder
Title.Active = true
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0, 320, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Text = "HitInfinityScript v" .. currentVersion
Title.TextColor3 = Color3.new(1, 1, 1)
Title.ZIndex = 10
table.insert(shade1,Title)
table.insert(text1,Title)

Dark = Instance.new("Frame")
Dark.Name = "Dark"
Dark.Parent = Holder
Dark.Active = true
Dark.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
Dark.BorderSizePixel = 0
Dark.Position = UDim2.new(0, 0, 0, 25)
Dark.Size = UDim2.new(0, 320, 0, 375)
Dark.ZIndex = 10
table.insert(shade1,Dark)

Cmdbar = Instance.new("TextBox")
Cmdbar.Name = "Cmdbar"
Cmdbar.Parent = Holder
Cmdbar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Cmdbar.BorderSizePixel = 0
Cmdbar.Position = UDim2.new(0, 5, 0, 28)
Cmdbar.Size = UDim2.new(0, 310, 0, 28)
Cmdbar.Font = Enum.Font.SourceSans
Cmdbar.TextSize = 16
Cmdbar.TextXAlignment = Enum.TextXAlignment.Left
Cmdbar.TextColor3 = Color3.new(1, 1, 1)
Cmdbar.Text = ""
Cmdbar.ZIndex = 10
Cmdbar.PlaceholderText = "Command Bar (.)"

CMDsF = Instance.new("ScrollingFrame")
CMDsF.Name = "CMDs"
CMDsF.Parent = Holder
CMDsF.BackgroundTransparency = 1
CMDsF.BorderSizePixel = 0
CMDsF.Position = UDim2.new(0, 5, 0, 60)
CMDsF.Size = UDim2.new(0, 310, 0, 260)
CMDsF.ScrollBarImageColor3 = Color3.fromRGB(80,80,85)
CMDsF.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
CMDsF.CanvasSize = UDim2.new(0, 0, 0, 0)
CMDsF.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
CMDsF.ScrollBarThickness = 6
CMDsF.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
CMDsF.VerticalScrollBarInset = 'Always'
CMDsF.ZIndex = 10
table.insert(scroll,CMDsF)

cmdListLayout = Instance.new("UIListLayout")
cmdListLayout.Parent = CMDsF
cmdListLayout.SortOrder = Enum.SortOrder.LayoutOrder
cmdListLayout.Padding = UDim.new(0, 2)

SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = Holder
SettingsButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SettingsButton.BorderSizePixel = 0
SettingsButton.Position = UDim2.new(0, 295, 0, 2)
SettingsButton.Size = UDim2.new(0, 22, 0, 22)
SettingsButton.Font = Enum.Font.SourceSansBold
SettingsButton.Text = "⚙"
SettingsButton.TextColor3 = Color3.new(1,1,1)
SettingsButton.TextSize = 16
SettingsButton.ZIndex = 10
table.insert(shade2,SettingsButton)
table.insert(text1,SettingsButton)

ReferenceButton = Instance.new("TextButton")
ReferenceButton.Name = "ReferenceButton"
ReferenceButton.Parent = Holder
ReferenceButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ReferenceButton.BorderSizePixel = 0
ReferenceButton.Position = UDim2.new(0, 270, 0, 2)
ReferenceButton.Size = UDim2.new(0, 22, 0, 22)
ReferenceButton.Font = Enum.Font.SourceSansBold
ReferenceButton.Text = "?"
ReferenceButton.TextColor3 = Color3.new(1,1,1)
ReferenceButton.TextSize = 16
ReferenceButton.ZIndex = 10
table.insert(shade2,ReferenceButton)
table.insert(text1,ReferenceButton)

Example = Instance.new("TextButton")
Example.Name = "Example"
Example.Parent = Holder
Example.BackgroundTransparency = 1
Example.BorderSizePixel = 0
Example.Size = UDim2.new(0, 300, 0, 22)
Example.Visible = false
Example.Font = Enum.Font.SourceSans
Example.TextSize = 14
Example.Text = "Example"
Example.TextColor3 = Color3.new(1, 1, 1)
Example.TextXAlignment = Enum.TextXAlignment.Left
Example.TextWrapped = true
Example.ZIndex = 10
table.insert(text1,Example)

Notification = Instance.new("Frame")
Notification.Name = randomString()
Notification.Parent = ScaledHolder
Notification.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
Notification.BorderSizePixel = 0
Notification.Position = UDim2.new(0.7, 0, 0.8, 0)
Notification.Size = UDim2.new(0, 280, 0, 80)
Notification.ZIndex = 10
table.insert(shade1,Notification)

Title_2 = Instance.new("TextLabel")
Title_2.Name = "Title"
Title_2.Parent = Notification
Title_2.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title_2.BorderSizePixel = 0
Title_2.Size = UDim2.new(0, 280, 0, 20)
Title_2.Font = Enum.Font.SourceSans
Title_2.TextSize = 14
Title_2.Text = "Notification"
Title_2.TextColor3 = Color3.new(1, 1, 1)
Title_2.ZIndex = 10
table.insert(shade2,Title_2)
table.insert(text1,Title_2)

Text_2 = Instance.new("TextLabel")
Text_2.Name = "Text"
Text_2.Parent = Notification
Text_2.BackgroundTransparency = 1
Text_2.BorderSizePixel = 0
Text_2.Position = UDim2.new(0, 5, 0, 22)
Text_2.Size = UDim2.new(0, 270, 0, 55)
Text_2.Font = Enum.Font.SourceSans
Text_2.TextSize = 14
Text_2.Text = ""
Text_2.TextColor3 = Color3.new(1, 1, 1)
Text_2.TextWrapped = true
Text_2.ZIndex = 10
table.insert(text1,Text_2)

CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Notification
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -20, 0, 0)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 14
CloseButton.ZIndex = 10

PinButton = Instance.new("TextButton")
PinButton.Name = "PinButton"
PinButton.Parent = Notification
PinButton.BackgroundTransparency = 1
PinButton.Size = UDim2.new(0, 20, 0, 20)
PinButton.ZIndex = 10
PinButton.Text = "📌"
PinButton.TextColor3 = Color3.new(1, 1, 1)
PinButton.TextSize = 12

Settings = Instance.new("Frame")
Settings.Name = "Settings"
Settings.Parent = Holder
Settings.Active = true
Settings.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
Settings.BorderSizePixel = 0
Settings.Position = UDim2.new(0, 0, 0, 400)
Settings.Size = UDim2.new(0, 320, 0, 300)
Settings.ZIndex = 10
Settings.Visible = false
table.insert(shade1,Settings)

SettingsHolder = Instance.new("ScrollingFrame")
SettingsHolder.Name = "Holder"
SettingsHolder.Parent = Settings
SettingsHolder.BackgroundTransparency = 1
SettingsHolder.BorderSizePixel = 0
SettingsHolder.Size = UDim2.new(1,0,1,0)
SettingsHolder.ScrollBarImageColor3 = Color3.fromRGB(80,80,85)
SettingsHolder.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsHolder.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsHolder.ScrollBarThickness = 6
SettingsHolder.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsHolder.VerticalScrollBarInset = 'Always'
SettingsHolder.ZIndex = 10
table.insert(scroll,SettingsHolder)

function makeSettingsButton(name)
	local button = Instance.new("TextButton")
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	button.BorderSizePixel = 0
	button.Position = UDim2.new(0, 5, 0, 0)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Text = name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 14
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.ZIndex = 10
	table.insert(shade2,button)
	table.insert(text1,button)
	return button
end

ColorsButton = makeSettingsButton("Edit Theme")
ColorsButton.Position = UDim2.new(0, 5, 0, 5)
ColorsButton.Size = UDim2.new(1, -10, 0, 30)
ColorsButton.Name = "Colors"
ColorsButton.Parent = SettingsHolder

Keybinds = makeSettingsButton("Edit Keybinds")
Keybinds.Position = UDim2.new(0, 5, 0, 40)
Keybinds.Size = UDim2.new(1, -10, 0, 30)
Keybinds.Name = "Keybinds"
Keybinds.Parent = SettingsHolder

Aliases = makeSettingsButton("Edit Aliases")
Aliases.Position = UDim2.new(0, 5, 0, 75)
Aliases.Size = UDim2.new(1, -10, 0, 30)
Aliases.Name = "Aliases"
Aliases.Parent = SettingsHolder

Positions = makeSettingsButton("Edit/Goto Waypoints")
Positions.Position = UDim2.new(0, 5, 0, 110)
Positions.Size = UDim2.new(1, -10, 0, 30)
Positions.Name = "Waypoints"
Positions.Parent = SettingsHolder

Plugins = makeSettingsButton("Manage Plugins")
Plugins.Position = UDim2.new(0, 5, 0, 145)
Plugins.Size = UDim2.new(1, -10, 0, 30)
Plugins.Name = "Plugins"
Plugins.Parent = SettingsHolder

EventBind = makeSettingsButton("Edit Event Binds")
EventBind.Position = UDim2.new(0, 5, 0, 180)
EventBind.Size = UDim2.new(1, -10, 0, 30)
EventBind.Name = "EventBinds"
EventBind.Parent = SettingsHolder

StayOpen = Instance.new("TextLabel")
StayOpen.Name = "StayOpen"
StayOpen.Parent = SettingsHolder
StayOpen.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
StayOpen.BorderSizePixel = 0
StayOpen.Position = UDim2.new(0, 5, 0, 215)
StayOpen.Size = UDim2.new(1, -10, 0, 30)
StayOpen.Font = Enum.Font.SourceSans
StayOpen.TextSize = 14
StayOpen.Text = "Keep Menu Open"
StayOpen.TextColor3 = Color3.new(1, 1, 1)
StayOpen.TextXAlignment = Enum.TextXAlignment.Left
StayOpen.ZIndex = 10
table.insert(shade2,StayOpen)
table.insert(text1,StayOpen)

Button = Instance.new("Frame")
Button.Name = "Button"
Button.Parent = StayOpen
Button.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(1, -26, 0, 5)
Button.Size = UDim2.new(0, 20, 0, 20)
Button.ZIndex = 10
table.insert(shade3,Button)

On = Instance.new("TextButton")
On.Name = "On"
On.Parent = Button
On.BackgroundColor3 = Color3.fromRGB(150, 150, 151)
On.BackgroundTransparency = 1
On.BorderSizePixel = 0
On.Position = UDim2.new(0, 2, 0, 2)
On.Size = UDim2.new(0, 16, 0, 16)
On.Font = Enum.Font.SourceSans
On.FontSize = Enum.FontSize.Size14
On.Text = ""
On.TextColor3 = Color3.new(0, 0, 0)
On.ZIndex = 10

Prefix = Instance.new("TextLabel")
Prefix.Name = "Prefix"
Prefix.Parent = SettingsHolder
Prefix.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Prefix.BorderSizePixel = 0
Prefix.Position = UDim2.new(0, 5, 0, 250)
Prefix.Size = UDim2.new(1, -10, 0, 30)
Prefix.Font = Enum.Font.SourceSans
Prefix.TextSize = 14
Prefix.Text = "Prefix"
Prefix.TextColor3 = Color3.new(1, 1, 1)
Prefix.TextXAlignment = Enum.TextXAlignment.Left
Prefix.ZIndex = 10
table.insert(shade2,Prefix)
table.insert(text1,Prefix)

PrefixBox = Instance.new("TextBox")
PrefixBox.Name = "PrefixBox"
PrefixBox.Parent = Prefix
PrefixBox.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
PrefixBox.BorderSizePixel = 0
PrefixBox.Position = UDim2.new(1, -30, 0, 5)
PrefixBox.Size = UDim2.new(0, 25, 0, 20)
PrefixBox.Font = Enum.Font.SourceSansBold
PrefixBox.TextSize = 14
PrefixBox.Text = "."
PrefixBox.TextColor3 = Color3.new(0, 0, 0)
PrefixBox.ZIndex = 10
table.insert(shade3,PrefixBox)
table.insert(text2,PrefixBox)

function dragGUI(gui)
	task.spawn(function()
		local dragging = false
		local dragInput = nil
		local dragStart = Vector3.new(0,0,0)
		local startPos = nil
		
		local function update(input)
			local delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
		end
		
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		
		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

dragGUI(Holder)

function ViewportTextBox_convert(textbox)
	local view = Instance.new("Frame")
	view.BackgroundTransparency = textbox.BackgroundTransparency
	view.BackgroundColor3 = textbox.BackgroundColor3
	view.BorderSizePixel = textbox.BorderSizePixel
	view.BorderColor3 = textbox.BorderColor3
	view.Position = textbox.Position
	view.Size = textbox.Size
	view.ClipsDescendants = true
	view.Name = textbox.Name
	view.ZIndex = 10
	textbox.BackgroundTransparency = 1
	textbox.Position = UDim2.new(0, 4, 0, 0)
	textbox.Size = UDim2.new(1, -8, 1, 0)
	textbox.TextXAlignment = Enum.TextXAlignment.Left
	textbox.Name = "Input"
	view.Parent = textbox.Parent
	textbox.Parent = view
	return {View = view, TextBox = textbox}
end

ViewportTextBox_convert(Cmdbar)

function writefileExploit()
	if writefile then return true end
	return false
end

function readfileExploit()
	if readfile then return true end
	return false
end

function isNumber(str)
	if tonumber(str) ~= nil or str == "inf" then return true end
	return false
end

function vtype(o, t)
	if o == nil then return false end
	if type(o) == "userdata" then return typeof(o) == t end
	return type(o) == t
end

function getRoot(char)
	if char and char:FindFirstChildOfClass("Humanoid") then
		return char:FindFirstChildOfClass("Humanoid").RootPart
	end
	return nil
end

function getPlayer(list, speaker)
	if list == nil then return {speaker.Name} end
	local found = {}
	local players = Players:GetPlayers()
	for _, v in pairs(players) do
		if string.lower(v.Name):find(string.lower(list)) or string.lower(v.DisplayName):find(string.lower(list)) then
			table.insert(found, v.Name)
		end
	end
	if #found == 0 then
		for _, v in pairs(players) do
			if string.lower(v.Name):sub(1, #list) == string.lower(list) then
				table.insert(found, v.Name)
			end
		end
	end
	return found
end

function getstring(begin, args)
	return table.concat(args or {}, " ", begin)
end

function splitString(str, delim)
	delim = delim or ","
	local broken = {}
	for w in string.gmatch(str, "[^" .. delim .. "]+") do
		table.insert(broken, w)
	end
	return broken
end

function Match(name, str)
	str = str:gsub("%W", "%%%1")
	return name:lower():find(str:lower()) and true
end

function notify(text, text2, length)
	task.spawn(function()
		if text2 then
			Title_2.Text = text
			Text_2.Text = text2
		else
			Title_2.Text = "Notification"
			Text_2.Text = text
		end
		Notification.Visible = true
		wait(length or 5)
		Notification.Visible = false
	end)
end

function toClipboard(txt)
	if everyClipboard then
		everyClipboard(tostring(txt))
		notify("Clipboard", "Copied to clipboard")
	else
		notify("Clipboard", "Your exploit doesn't have the ability to use the clipboard")
	end
end

function chatMessage(str)
	if not isLegacyChat then
		TextChatService.TextChannels.RBXGeneral:SendAsync(tostring(str))
	else
		ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(tostring(str), "All")
	end
end

function execCmd(cmdStr, speaker, store)
	cmdStr = cmdStr:gsub("%s+$", "")
	task.spawn(function()
		local args = splitString(cmdStr, " ")
		local cmdName = args[1]
		table.remove(args, 1)
		local cmd = findCmd(cmdName)
		if cmd then
			pcall(cmd.FUNC, args, speaker or Players.LocalPlayer)
		end
	end)
end

function addcmd(name, alias, func, plgn)
	cmds[#cmds+1] = {
		NAME = name,
		ALIAS = alias or {},
		FUNC = func,
		PLUGIN = plgn
	}
end

function findCmd(cmd_name)
	for i, v in pairs(cmds) do
		if v.NAME:lower() == cmd_name:lower() then
			return v
		end
		for _, alias in pairs(v.ALIAS) do
			if alias:lower() == cmd_name:lower() then
				return v
			end
		end
	end
	return nil
end

function addcmdtext(text, name, desc)
	local newcmd = Example:Clone()
	newcmd.Parent = CMDsF
	newcmd.Visible = false
	newcmd.Text = text
	newcmd.Name = "PLUGIN_" .. name
	newcmd:SetAttribute("Title", text)
	newcmd:SetAttribute("Desc", desc or "")
	newcmd.MouseButton1Down:Connect(function()
		if newcmd.Visible and newcmd.TextTransparency == 0 then
			Cmdbar:CaptureFocus()
			autoComplete(newcmd.Text)
			maximizeHolder()
		end
	end)
	table.insert(text1, newcmd)
end

function autoComplete(str, curText)
	curText = curText or Cmdbar.Text
	local subPos = 0
	local pos = 1
	local findRes = string.find(curText, "\\", pos)
	while findRes do
		subPos = findRes
		pos = findRes + 1
		findRes = string.find(curText, "\\", pos)
	end
	Cmdbar.Text = curText:sub(1, subPos) .. str .. " "
	RunService.RenderStepped:Wait()
	Cmdbar.CursorPosition = #Cmdbar.Text + 1
end

function maximizeHolder()
	Holder:TweenPosition(UDim2.new(0.8, 0, 0.3, 0), "InOut", "Quart", 0.2, true, nil)
end

function minimizeHolder()
	Holder:TweenPosition(UDim2.new(0.8, 0, 0.3, -350), "InOut", "Quart", 0.5, true, nil)
end

IndexContents = function(str, bool)
	CMDsF.CanvasPosition = Vector2.new(0, 0)
	topCommand = nil
	for i, v in pairs(CMDsF:GetChildren()) do
		if v:IsA("TextButton") and v.Name ~= "Example" then
			if bool and str ~= "" then
				if Match(v.Text, str) then
					v.Visible = true
					if topCommand == nil then
						topCommand = v.Text
					end
				else
					v.Visible = false
				end
			else
				v.Visible = true
				if topCommand == nil then
					topCommand = v.Text
				end
			end
		end
	end
	local contentY = cmdListLayout.AbsoluteContentSize.Y
	CMDsF.CanvasSize = UDim2.new(0, 0, 0, math.max(0, contentY))
	if str == "" or bool == false then
		minimizeHolder()
	else
		maximizeHolder()
	end
end

cmdListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	local contentY = cmdListLayout.AbsoluteContentSize.Y
	CMDsF.CanvasSize = UDim2.new(0, 0, 0, math.max(0, contentY))
end)

CMDs = {}

CMDs[#CMDs + 1] = {NAME = 'guiscale [number]', DESC = 'Changes the size of the gui (0.4 - 2.0)'}
CMDs[#CMDs + 1] = {NAME = 'console', DESC = 'Opens the Roblox console'}
CMDs[#CMDs + 1] = {NAME = 'explorer / dex', DESC = 'Opens Dex Explorer'}
CMDs[#CMDs + 1] = {NAME = 'moondex / mdex', DESC = 'Opens DEX by Moon'}
CMDs[#CMDs + 1] = {NAME = 'remotespy / rspy', DESC = 'Opens Remote Spy'}
CMDs[#CMDs + 1] = {NAME = 'simplespy / sspy', DESC = 'Opens Simple Spy'}
CMDs[#CMDs + 1] = {NAME = 'audiologger / alogger', DESC = 'Opens Audio Logger'}
CMDs[#CMDs + 1] = {NAME = 'serverinfo / info', DESC = 'Shows server information'}
CMDs[#CMDs + 1] = {NAME = 'rejoin / rj', DESC = 'Rejoins the game'}
CMDs[#CMDs + 1] = {NAME = 'serverhop / shop', DESC = 'Teleports to another server'}
CMDs[#CMDs + 1] = {NAME = 'antiidle / antiafk', DESC = 'Prevents AFK kick'}
CMDs[#CMDs + 1] = {NAME = 'noclip', DESC = 'Toggles noclip'}
CMDs[#CMDs + 1] = {NAME = 'fly [speed]', DESC = 'Enables flight'}
CMDs[#CMDs + 1] = {NAME = 'unfly', DESC = 'Disables flight'}
CMDs[#CMDs + 1] = {NAME = 'flyspeed [num]', DESC = 'Sets fly speed'}
CMDs[#CMDs + 1] = {NAME = 'goto [player]', DESC = 'Teleports to a player'}
CMDs[#CMDs + 1] = {NAME = 'tweengoto [player]', DESC = 'Tween to a player'}
CMDs[#CMDs + 1] = {NAME = 'clientbring / cbring [player]', DESC = 'Brings a player to you'}
CMDs[#CMDs + 1] = {NAME = 'freeze / fr [player]', DESC = 'Freezes a player'}
CMDs[#CMDs + 1] = {NAME = 'thaw / unfr [player]', DESC = 'Unfreezes a player'}
CMDs[#CMDs + 1] = {NAME = 'tpposition / tppos [X Y Z]', DESC = 'Teleports to coordinates'}
CMDs[#CMDs + 1] = {NAME = 'offset [X Y Z]', DESC = 'Offsets your position'}
CMDs[#CMDs + 1] = {NAME = 'thru [num]', DESC = 'Teleports forward'}
CMDs[#CMDs + 1] = {NAME = 'waypoints', DESC = 'Opens waypoints menu'}
CMDs[#CMDs + 1] = {NAME = 'setwaypoint / swp [name]', DESC = 'Sets a waypoint'}
CMDs[#CMDs + 1] = {NAME = 'waypoint / wp [name]', DESC = 'Teleports to waypoint'}
CMDs[#CMDs + 1] = {NAME = 'deletewaypoint / dwp [name]', DESC = 'Deletes a waypoint'}
CMDs[#CMDs + 1] = {NAME = 'clearwaypoints / cwp', DESC = 'Clears all waypoints'}
CMDs[#CMDs + 1] = {NAME = 'esp', DESC = 'Toggles ESP'}
CMDs[#CMDs + 1] = {NAME = 'noesp / unesp', DESC = 'Disables ESP'}
CMDs[#CMDs + 1] = {NAME = 'chams', DESC = 'Toggles Chams'}
CMDs[#CMDs + 1] = {NAME = 'nochams / unchams', DESC = 'Disables Chams'}
CMDs[#CMDs + 1] = {NAME = 'locate [player]', DESC = 'Locates a player'}
CMDs[#CMDs + 1] = {NAME = 'nolocate / unlocate [player]', DESC = 'Removes locate'}
CMDs[#CMDs + 1] = {NAME = 'spectate / view [player]', DESC = 'Spectates a player'}
CMDs[#CMDs + 1] = {NAME = 'unview / unspectate', DESC = 'Stops spectating'}
CMDs[#CMDs + 1] = {NAME = 'freecam / fc', DESC = 'Enables freecam'}
CMDs[#CMDs + 1] = {NAME = 'unfreecam / unfc', DESC = 'Disables freecam'}
CMDs[#CMDs + 1] = {NAME = 'firstp', DESC = 'First person camera'}
CMDs[#CMDs + 1] = {NAME = 'thirdp', DESC = 'Third person camera'}
CMDs[#CMDs + 1] = {NAME = 'fov [num]', DESC = 'Changes Field of View'}
CMDs[#CMDs + 1] = {NAME = 'reset', DESC = 'Resets character'}
CMDs[#CMDs + 1] = {NAME = 'respawn', DESC = 'Respawns character'}
CMDs[#CMDs + 1] = {NAME = 'god', DESC = 'God mode'}
CMDs[#CMDs + 1] = {NAME = 'invisible / invis', DESC = 'Makes you invisible'}
CMDs[#CMDs + 1] = {NAME = 'visible / vis', DESC = 'Makes you visible'}
CMDs[#CMDs + 1] = {NAME = 'speed / ws [num]', DESC = 'Changes walkspeed'}
CMDs[#CMDs + 1] = {NAME = 'jumppower / jp [num]', DESC = 'Changes jump power'}
CMDs[#CMDs + 1] = {NAME = 'gravity [num]', DESC = 'Changes gravity'}
CMDs[#CMDs + 1] = {NAME = 'sit', DESC = 'Makes you sit'}
CMDs[#CMDs + 1] = {NAME = 'dance', DESC = 'Makes you dance'}
CMDs[#CMDs + 1] = {NAME = 'undance', DESC = 'Stops dancing'}
CMDs[#CMDs + 1] = {NAME = 'animation / anim [id]', DESC = 'Plays an animation'}
CMDs[#CMDs + 1] = {NAME = 'btools', DESC = 'Gives building tools'}
CMDs[#CMDs + 1] = {NAME = 'tools', DESC = 'Gives tools from game'}
CMDs[#CMDs + 1] = {NAME = 'notools / removetools', DESC = 'Removes all tools'}
CMDs[#CMDs + 1] = {NAME = 'chat / say [text]', DESC = 'Sends a chat message'}
CMDs[#CMDs + 1] = {NAME = 'spam [text]', DESC = 'Spams chat'}
CMDs[#CMDs + 1] = {NAME = 'unspam', DESC = 'Stops spam'}
CMDs[#CMDs + 1] = {NAME = 'whisper / pm [player] [text]', DESC = 'Whispers a player'}
CMDs[#CMDs + 1] = {NAME = 'logs', DESC = 'Opens logs'}
CMDs[#CMDs + 1] = {NAME = 'chatlogs / clogs', DESC = 'Enables chat logging'}
CMDs[#CMDs + 1] = {NAME = 'joinlogs / jlogs', DESC = 'Enables join logging'}
CMDs[#CMDs + 1] = {NAME = 'addalias [cmd] [alias]', DESC = 'Adds a command alias'}
CMDs[#CMDs + 1] = {NAME = 'removealias [alias]', DESC = 'Removes an alias'}
CMDs[#CMDs + 1] = {NAME = 'exit / shutdown', DESC = 'Exits the game'}
CMDs[#CMDs + 1] = {NAME = 'discord / support', DESC = 'Gets Discord invite'}

for i = 1, #CMDs do
	local newcmd = Example:Clone()
	newcmd.Parent = CMDsF
	newcmd.Visible = false
	newcmd.Text = CMDs[i].NAME
	newcmd.Name = "CMD"
	newcmd:SetAttribute("Title", CMDs[i].NAME)
	newcmd:SetAttribute("Desc", CMDs[i].DESC)
	newcmd.MouseButton1Down:Connect(function()
		if not IsOnMobile and newcmd.Visible and newcmd.TextTransparency == 0 then
			Cmdbar:CaptureFocus()
			autoComplete(newcmd.Text)
			maximizeHolder()
		end
	end)
	table.insert(text1, newcmd)
end

IndexContents("", false)

cmds = {}
customAlias = {}

addcmd("guiscale", {}, function(args, speaker)
	if args[1] and isNumber(args[1]) then
		local scale = tonumber(args[1])
		if scale >= 0.4 and scale <= 2 then
			Scale.Scale = scale
		end
	else
		Scale.Scale = 1
	end
end)

addcmd("console", {}, function(args, speaker)
	StarterGui:SetCore("DevConsoleVisible", true)
end)

addcmd("explorer", {"dex"}, function(args, speaker)
	notify("Loading", "Loading Dex Explorer...")
	loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
end)

addcmd("moondex", {"mdex"}, function(args, speaker)
	notify("Loading", "Loading DEX by Moon...")
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)

addcmd("remotespy", {"rspy", "cobalt", "cspy"}, function(args, speaker)
	notify("Loading", "Loading Remote Spy...")
	loadstring(game:HttpGet("https://gitlab.com/upio/cobalt/-/releases/permalink/latest/downloads/Cobalt.luau"))()
end)

addcmd("simplespy", {"sspy"}, function(args, speaker)
	notify("Loading", "Loading Simple Spy...")
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end)

addcmd("audiologger", {"alogger"}, function(args, speaker)
	notify("Loading", "Loading Audio Logger...")
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/audiologger.lua"))()
end)

addcmd("serverinfo", {"info"}, function(args, speaker)
	local players = Players:GetPlayers()
	local asset = MarketplaceService:GetProductInfo(PlaceId)
	notify("Server Info", "Place: " .. asset.Name .. "\nPlayers: " .. #players .. "/" .. Players.MaxPlayers .. "\nPing: " .. math.round(speaker:GetNetworkPing() * 1000) .. "ms")
end)

addcmd("rejoin", {"rj"}, function(args, speaker)
	if #Players:GetPlayers() <= 1 then
		Players.LocalPlayer:Kick("Rejoining...")
		task.wait(0.3)
		TeleportService:Teleport(PlaceId, Players.LocalPlayer)
	else
		TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
	end
end)

addcmd("serverhop", {"shop"}, function(args, speaker)
	local servers = {}
	local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
	local body = HttpService:JSONDecode(req)
	if body and body.data then
		for i, v in next, body.data do
			if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
				table.insert(servers, 1, v.id)
			end
		end
	end
	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
	else
		notify("Serverhop", "Couldn't find another server.")
	end
end)

addcmd("antiidle", {"antiafk"}, function(args, speaker)
	if getconnections then
		for _, c in getconnections(speaker.Idled) do
			pcall(function() c:Disable() end)
		end
	end
	notify("Anti Idle", "Anti AFK enabled")
end)

addcmd("noclip", {}, function(args, speaker)
	local char = speaker.Character
	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
		notify("Noclip", "Enabled")
	end
end)

addcmd("unnoclip", {"clip"}, function(args, speaker)
	local char = speaker.Character
	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
		notify("Noclip", "Disabled")
	end
end)

FLYING = false
flySpeed = 20

addcmd("fly", {}, function(args, speaker)
	if args[1] and isNumber(args[1]) then
		flySpeed = tonumber(args[1])
	end
	if FLYING then return end
	FLYING = true
	local char = speaker.Character
	local root = getRoot(char)
	local bg = Instance.new("BodyGyro")
	local bv = Instance.new("BodyVelocity")
	bg.P = 9e4
	bg.Parent = root
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bv.Parent = root
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	task.spawn(function()
		while FLYING and root and root.Parent do
			local cam = workspace.CurrentCamera
			local move = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
			if move.Magnitude > 0 then
				bv.Velocity = move.Unit * flySpeed * 50
			else
				bv.Velocity = Vector3.new(0, 0, 0)
			end
			bg.CFrame = cam.CFrame
			task.wait()
		end
		bg:Destroy()
		bv:Destroy()
	end)
	notify("Fly", "Enabled (Speed: " .. flySpeed .. ")")
end)

addcmd("unfly", {}, function(args, speaker)
	FLYING = false
	notify("Fly", "Disabled")
end)

addcmd("flyspeed", {"flysp"}, function(args, speaker)
	if args[1] and isNumber(args[1]) then
		flySpeed = tonumber(args[1])
		notify("Fly Speed", "Set to " .. flySpeed)
	end
end)

addcmd("goto", {"to"}, function(args, speaker)
	if not args[1] then return end
	local plrs = getPlayer(args[1], speaker)
	for _, v in pairs(plrs) do
		local target = Players[v]
		if target and target.Character and getRoot(target.Character) then
			local root = getRoot(speaker.Character)
			if root then
				root.CFrame = getRoot(target.Character).CFrame + Vector3.new(3, 0, 0)
				break
			end
		end
	end
end)

addcmd("tweengoto", {"tgoto", "tto"}, function(args, speaker)
	if not args[1] then return end
	local plrs = getPlayer(args[1], speaker)
	for _, v in pairs(plrs) do
		local target = Players[v]
		if target and target.Character and getRoot(target.Character) then
			local root = getRoot(speaker.Character)
			if root then
				TweenService:Create(root, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = getRoot(target.Character).CFrame + Vector3.new(3, 0, 0)}):Play()
				break
			end
		end
	end
end)

addcmd("clientbring", {"cbring"}, function(args, speaker)
	if not args[1] then return end
	local plrs = getPlayer(args[1], speaker)
	for _, v in pairs(plrs) do
		local target = Players[v]
		if target and target.Character and getRoot(target.Character) then
			getRoot(target.Character).CFrame = getRoot(speaker.Character).CFrame + Vector3.new(3, 0, 0)
		end
	end
end)

addcmd("freeze", {"fr"}, function(args, speaker)
	if not args[1] then return end
	local plrs = getPlayer(args[1], speaker)
	for _, v in pairs(plrs) do
		local target = Players[v]
		if target and target.Character then
			for _, part in pairs(target.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = true
				end
			end
		end
	end
end)

addcmd("thaw", {"unfr"}, function(args, speaker)
	if not args[1] then return end
	local plrs = getPlayer(args[1], speaker)
	for _, v in pairs(plrs) do
		local target = Players[v]
		if target and target.Character then
			for _, part in pairs(target.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = false
				end
			end
		end
	end
end)

addcmd("tpposition", {"tppos"}, function(args, speaker)
	if not args[1] or not args[2] or not args[3] then return end
	local root = getRoot(speaker.Character)
	if root then
		root.CFrame = CFrame.new(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
	end
end)

addcmd("offset", {}, function(args, speaker)
	if not args[1] or not args[2] or not args[3] then return end
	local root = getRoot(speaker.Character)
	if root then
		root.CFrame = root.CFrame + Vector3.new(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
	end
end)

addcmd("thru", {}, function(args, speaker)
	local num = tonumber(args[1]) or 5
	local root = getRoot(speaker.Character)
	if root then
		root.CFrame = root.CFrame + root.CFrame.LookVector * num
	end
end)

addcmd("waypoints", {"positions"}, function(args, speaker)
	Settings.Visible = not Settings.Visible
end)

addcmd("setwaypoint", {"swp", "spos"}, function(args, speaker)
	if not args[1] then return end
	local name = getstring(1, args)
	local root = getRoot(speaker.Character)
	if root then
		WayPoints[#WayPoints + 1] = {NAME = name, COORD = {root.Position.X, root.Position.Y, root.Position.Z}}
		notify("Waypoint", "Created: " .. name)
	end
end)

addcmd("waypoint", {"wp", "loadpos"}, function(args, speaker)
	if not args[1] then return end
	local name = getstring(1, args)
	for _, v in pairs(WayPoints) do
		if v.NAME:lower() == name:lower() then
			local root = getRoot(speaker.Character)
			if root then
				root.CFrame = CFrame.new(v.COORD[1], v.COORD[2], v.COORD[3])
			end
			break
		end
	end
end)

addcmd("deletewaypoint", {"dwp", "dpos"}, function(args, speaker)
	if not args[1] then return end
	local name = getstring(1, args)
	for i, v in pairs(WayPoints) do
		if v.NAME:lower() == name:lower() then
			table.remove(WayPoints, i)
			notify("Waypoint", "Deleted: " .. name)
			break
		end
	end
end)

addcmd("clearwaypoints", {"cwp", "cpos"}, function(args, speaker)
	WayPoints = {}
	notify("Waypoints", "Cleared all waypoints")
end)

ESPenabled = false
addcmd("esp", {}, function(args, speaker)
	ESPenabled = true
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= speaker then
			task.spawn(function()
				while ESPenabled and v and v.Character do
					local parts = {}
					for _, part in pairs(v.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							table.insert(parts, part)
						end
					end
					for _, part in pairs(parts) do
						local box = Instance.new("BoxHandleAdornment")
						box.Parent = part
						box.Adornee = part
						box.AlwaysOnTop = true
						box.ZIndex = 10
						box.Size = part.Size
						box.Transparency = 0.3
						box.Color3 = v.TeamColor or Color3.new(1, 0, 0)
						task.wait()
					end
					wait(0.5)
				end
			end)
		end
	end
	notify("ESP", "Enabled")
end)

addcmd("noesp", {"unesp"}, function(args, speaker)
	ESPenabled = false
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BoxHandleAdornment") then
			v:Destroy()
		end
	end
	notify("ESP", "Disabled")
end)

addcmd("spectate", {"view"}, function(args, speaker)
	if not args[1] then return end
	local plrs = getPlayer(args[1], speaker)
	for _, v in pairs(plrs) do
		local target = Players[v]
		if target and target.Character then
			workspace.CurrentCamera.CameraSubject = target.Character
			notify("Spectate", "Viewing " .. v)
			break
		end
	end
end)

addcmd("unview", {"unspectate"}, function(args, speaker)
	workspace.CurrentCamera.CameraSubject = speaker.Character
	notify("Spectate", "Stopped")
end)

addcmd("firstp", {}, function(args, speaker)
	speaker.CameraMode = "LockFirstPerson"
end)

addcmd("thirdp", {}, function(args, speaker)
	speaker.CameraMode = "Classic"
end)

addcmd("fov", {}, function(args, speaker)
	if args[1] and isNumber(args[1]) then
		workspace.CurrentCamera.FieldOfView = tonumber(args[1])
	end
end)

addcmd("reset", {}, function(args, speaker)
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.Health = 0
	end
end)

addcmd("respawn", {}, function(args, speaker)
	speaker.Character:BreakJoints()
end)

addcmd("god", {}, function(args, speaker)
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.Health = hum.MaxHealth
		hum.BreakJointsOnDeath = false
		notify("God", "Enabled")
	end
end)

addcmd("invisible", {"invis"}, function(args, speaker)
	local char = speaker.Character
	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 1
			end
		end
		notify("Invisible", "Enabled")
	end
end)

addcmd("visible", {"vis"}, function(args, speaker)
	local char = speaker.Character
	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 0
			end
		end
		notify("Invisible", "Disabled")
	end
end)

addcmd("speed", {"ws"}, function(args, speaker)
	local speed = tonumber(args[1]) or 16
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.WalkSpeed = speed
		notify("Speed", "Set to " .. speed)
	end
end)

addcmd("jumppower", {"jp", "jpower"}, function(args, speaker)
	local power = tonumber(args[1]) or 50
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.JumpPower = power
		notify("Jump Power", "Set to " .. power)
	end
end)

addcmd("gravity", {"grav"}, function(args, speaker)
	local grav = tonumber(args[1]) or 196.2
	workspace.Gravity = grav
	notify("Gravity", "Set to " .. grav)
end)

addcmd("sit", {}, function(args, speaker)
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.Sit = true
	end
end)

addcmd("dance", {}, function(args, speaker)
	local dances = {"27789359", "30196114", "248263260"}
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. dances[math.random(1, #dances)]
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		local track = hum:LoadAnimation(anim)
		track:Play()
		track.Looped = true
	end
end)

addcmd("undance", {}, function(args, speaker)
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		for _, track in pairs(hum:GetPlayingAnimationTracks()) do
			track:Stop()
		end
	end
end)

addcmd("animation", {"anim"}, function(args, speaker)
	if not args[1] then return end
	local anim = Instance.new("Animation")
	local id = args[1]
	if not id:find("rbxassetid://") then
		id = "rbxassetid://" .. id
	end
	anim.AnimationId = id
	local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		local track = hum:LoadAnimation(anim)
		track:Play()
	end
end)

addcmd("btools", {}, function(args, speaker)
	for i = 1, 4 do
		local tool = Instance.new("HopperBin")
		tool.BinType = i
		tool.Parent = speaker:FindFirstChildWhichIsA("Backpack")
	end
	notify("BTools", "Gave building tools")
end)

addcmd("tools", {"gears"}, function(args, speaker)
	for _, v in pairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("Tool") then
			v:Clone().Parent = speaker:FindFirstChildWhichIsA("Backpack")
		end
	end
	for _, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Tool") then
			v:Clone().Parent = speaker:FindFirstChildWhichIsA("Backpack")
		end
	end
	notify("Tools", "Copied tools from game")
end)

addcmd("notools", {"removetools"}, function(args, speaker)
	local bp = speaker:FindFirstChildWhichIsA("Backpack")
	if bp then
		for _, v in pairs(bp:GetChildren()) do
			if v:IsA("Tool") or v:IsA("HopperBin") then
				v:Destroy()
			end
		end
	end
	if speaker.Character then
		for _, v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("Tool") or v:IsA("HopperBin") then
				v:Destroy()
			end
		end
	end
	notify("Tools", "Removed all tools")
end)

addcmd("chat", {"say"}, function(args, speaker)
	local msg = getstring(1, args)
	if msg and msg ~= "" then
		chatMessage(msg)
	end
end)

addcmd("spam", {}, function(args, speaker)
	local msg = getstring(1, args)
	if not msg or msg == "" then return end
	spamming = true
	task.spawn(function()
		while spamming do
			chatMessage(msg)
			wait(0.5)
		end
	end)
	notify("Spam", "Started")
end)

addcmd("unspam", {}, function(args, speaker)
	spamming = false
	notify("Spam", "Stopped")
end)

addcmd("whisper", {"pm"}, function(args, speaker)
	if not args[1] then return end
	local plrs = getPlayer(args[1], speaker)
	local msg = getstring(2, args)
	for _, v in pairs(plrs) do
		chatMessage("/w " .. v .. " " .. msg)
	end
end)

addcmd("logs", {}, function(args, speaker)
	logsEnabled = true
	notify("Logs", "Enabled")
end)

addcmd("chatlogs", {"clogs"}, function(args, speaker)
	logsEnabled = true
	notify("Chat Logs", "Enabled")
end)

addcmd("joinlogs", {"jlogs"}, function(args, speaker)
	jLogsEnabled = true
	notify("Join Logs", "Enabled")
end)

addcmd("addalias", {}, function(args, speaker)
	if not args[1] or not args[2] then return end
	local cmd = args[1]
	local alias = args[2]
	for _, v in pairs(cmds) do
		if v.NAME:lower() == cmd:lower() then
			table.insert(v.ALIAS, alias)
			notify("Alias", "Added " .. alias .. " -> " .. cmd)
			break
		end
	end
end)

addcmd("removealias", {}, function(args, speaker)
	if not args[1] then return end
	local alias = args[1]
	for _, v in pairs(cmds) do
		for i, a in pairs(v.ALIAS) do
			if a:lower() == alias:lower() then
				table.remove(v.ALIAS, i)
				notify("Alias", "Removed " .. alias)
				break
			end
		end
	end
end)

addcmd("exit", {"shutdown", "leave"}, function(args, speaker)
	game:Shutdown()
end)

addcmd("discord", {"support", "help"}, function(args, speaker)
	toClipboard("discord.gg/78ZuWSq")
	notify("Discord", "Invite copied to clipboard!")
end)

currentShade1 = Color3.fromRGB(36, 36, 40)
currentShade2 = Color3.fromRGB(45, 45, 50)
currentShade3 = Color3.fromRGB(80, 80, 85)
currentText1 = Color3.new(1, 1, 1)
currentText2 = Color3.new(0, 0, 0)
currentScroll = Color3.fromRGB(80, 80, 85)

updateColors = function(color, ctype)
	if ctype == shade1 then
		for _, v in pairs(shade1) do v.BackgroundColor3 = color end
		currentShade1 = color
	elseif ctype == shade2 then
		for _, v in pairs(shade2) do v.BackgroundColor3 = color end
		currentShade2 = color
	elseif ctype == shade3 then
		for _, v in pairs(shade3) do v.BackgroundColor3 = color end
		currentShade3 = color
	elseif ctype == text1 then
		for _, v in pairs(text1) do v.TextColor3 = color end
		currentText1 = color
	elseif ctype == text2 then
		for _, v in pairs(text2) do v.TextColor3 = color end
		currentText2 = color
	elseif ctype == scroll then
		for _, v in pairs(scroll) do v.ScrollBarImageColor3 = color end
		currentScroll = color
	end
end

updateColors(currentShade1, shade1)
updateColors(currentShade2, shade2)
updateColors(currentShade3, shade3)
updateColors(currentText1, text1)
updateColors(currentText2, text2)
updateColors(currentScroll, scroll)

cmdHistory = {}
spamming = false
logsEnabled = false
jLogsEnabled = false
WayPoints = {}
StayOpen = false
prefix = "."
Scale.Scale = 1

Cmdbar.PlaceholderText = "Command Bar (" .. prefix .. ")"

Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	if Cmdbar:IsFocused() then
		IndexContents(Cmdbar.Text, true)
	end
end)

Cmdbar.FocusLost:Connect(function(enterpressed)
	if enterpressed then
		local cmdbarText = Cmdbar.Text:gsub("^" .. prefix, "")
		execCmd(cmdbarText, Players.LocalPlayer, true)
		Cmdbar.Text = ""
	end
	wait()
	if not Cmdbar:IsFocused() then
		IndexContents("", false)
	end
end)

Cmdbar.Focused:Connect(function()
	IndexContents("", true)
end)

HISMouse.KeyDown:Connect(function(Key)
	if Key == prefix then
		RunService.RenderStepped:Wait()
		Cmdbar:CaptureFocus()
		maximizeHolder()
	end
end)

SettingsButton.MouseButton1Click:Connect(function()
	Settings.Visible = not Settings.Visible
end)

On.MouseButton1Click:Connect(function()
	StayOpen = not StayOpen
	On.BackgroundTransparency = StayOpen and 0 or 1
end)

PrefixBox:GetPropertyChangedSignal("Text"):Connect(function()
	prefix = PrefixBox.Text
	Cmdbar.PlaceholderText = "Command Bar (" .. prefix .. ")"
end)

ReferenceButton.MouseButton1Click:Connect(function()
	notify("HitInfinityScript", "Version " .. currentVersion .. "\nPrefix: " .. prefix .. "\nCommands: " .. #cmds .. "\nDiscord: discord.gg/78ZuWSq")
end)

if IsOnMobile then
	local QuickCapture = Instance.new("TextButton")
	QuickCapture.Name = randomString()
	QuickCapture.Parent = PARENT
	QuickCapture.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	QuickCapture.BackgroundTransparency = 0.2
	QuickCapture.Position = UDim2.new(0.47, 0, 0, 0)
	QuickCapture.Size = UDim2.new(0, 40, 0, 40)
	QuickCapture.Font = Enum.Font.SourceSansBold
	QuickCapture.Text = "HIS"
	QuickCapture.TextColor3 = Color3.fromRGB(255, 255, 255)
	QuickCapture.TextSize = 16
	QuickCapture.ZIndex = 10
	QuickCapture.Draggable = true
	QuickCapture.MouseButton1Click:Connect(function()
		Cmdbar:CaptureFocus()
		maximizeHolder()
	end)
	table.insert(shade1, QuickCapture)
	table.insert(text1, QuickCapture)
end

task.spawn(function()
	task.wait(2)
	notify("HitInfinityScript", "Type .help for commands!\nPrefix: " .. prefix)
end)

minimizeHolder()
