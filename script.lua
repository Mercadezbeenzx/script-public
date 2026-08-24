local a=game:GetService"Players"
local b=game:GetService"ReplicatedStorage"
local c=game:GetService"RunService"
local d=game:GetService"TextChatService"
local e=a.LocalPlayer

local f=require(b.Modules.GlobalCData)

local g={
DrainRate=0.4,
RegenRate=1.0,
}

local h=f.Stamina or 100
local i=h

local j=task.spawn(function()
while task.wait()do
local j=f.Stamina
if j~=i then
local k=j-i

if k<0 then
local l=k/-0.4
h=math.clamp(h-(g.DrainRate*l),0,f.MaxStamina or 100)
elseif k>0 then
local l=k/1.0
h=math.clamp(h+(g.RegenRate*l),0,f.MaxStamina or 100)
end

f.Stamina=h
i=h
end
end
end)

local k=false
local l=16
local m=50
local n=false
local o=false

local p=false
local q=16

local r=false
local s=0.45
local t

local u={
Enabled=false,
TargetPlayer=nil,
Mode="Glitched",
MimicChance=100,
MinDelay=1,
MaxDelay=2,
DistortionDelay=45
}

local v={}
local w={
"why is it looking at me",
"dont turn around",
"its right behind you",
"do you hear that",
"run",
"stop looking at me"
}

local x
local y
local z
local A

local function getLocalCharacter()
return e.Character or f.Character
end

local function safeReverse(B)
local C={}
for D,E in utf8.codes(B)do
table.insert(C,1,utf8.char(E))
end
return table.concat(C)
end

function sendChatMessage(B)
pcall(function()
if d.ChatVersion==Enum.ChatVersion.TextChatService then
local C=d.TextChannels.RBXGeneral
if C then C:SendAsync(B)end
else
b.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(B,"All")
end
end)
end

local function alterText(B)
if math.random(1,100)>u.MimicChance then return nil end

if u.Mode=="Glitched"then
local C={"...","..?","..."," _ "}
return B:sub(1,math.max(1,#B-2))..C[math.random(1,#C)]

elseif u.Mode=="Reverse"then
return safeReverse(B)

elseif u.Mode=="Whisper"then
return"... "..B:lower().." ..."

elseif u.Mode=="Delayed"then
table.insert(v,B)
task.delay(u.DistortionDelay,function()
if#v>0 then
local C=table.remove(v,1)
sendChatMessage("... "..C.." ...")
end
end)
return nil

elseif u.Mode=="Fake Panic"then
return w[math.random(1,#w)]
end

return B
end

local function setCharacterCollisions(B)
local C=getLocalCharacter()
if C then
for D,E in ipairs(C:GetDescendants())do
if E:IsA"BasePart"then
if B then
if E.Name=="HumanoidRootPart"then
E.CanCollide=false
elseif E:IsA"MeshPart"or E.Name=="Head"or E.Name=="Torso"or string.find(E.Name,"Leg")or string.find(E.Name,"Arm")then
E.CanCollide=true
elseif E.Parent:IsA"Accessory"or E.Parent:IsA"Hat"then
E.CanCollide=false
end
else
E.CanCollide=false
end
end
end
end
end

y=c.Stepped:Connect(function()
if k then
setCharacterCollisions(false)
end
end)

z=c.RenderStepped:Connect(function()
local B=getLocalCharacter()
if B then
local C=B:FindFirstChildOfClass"Humanoid"
if C then
if n then
C.WalkSpeed=l
end
if o then
C.UseJumpPower=true
C.JumpPower=m
end
end
end
end)

A=c.Stepped:Connect(function()
if p then
local B=getLocalCharacter()
if B then
local C=B:FindFirstChildOfClass"Humanoid"
local D=B:FindFirstChild"HumanoidRootPart"
if C and D then
local E=(D.AssemblyLinearVelocity*Vector3.new(1,0,1)).Magnitude
local F=E/q
if E<0.1 then
F=1.0
end

local G=C:FindFirstChildOfClass"Animator"
if G then
for H,I in ipairs(G:GetPlayingAnimationTracks())do
I:AdjustSpeed(F)
end
end
end
end
end
end)

local function triggerWhistle()
pcall(function()
local B=b:FindFirstChild"Events"
if B then
local C=B:FindFirstChild"GameMisc"
if C then
C:FireServer{[1]="Whistle"}
end
end
end)
end

local function stopWhistleThread()
if t then
task.cancel(t)
t=nil
end
end

local function startWhistleThread()
stopWhistleThread()
t=task.spawn(function()
while r do
triggerWhistle()
task.wait(math.max(s,0.45))
end
end)
end

local function setupChatMimic()
if x then x:Disconnect()end

local function processIncoming(B,C)
if not u.Enabled or not u.TargetPlayer then return end
if B==u.TargetPlayer then
local D=alterText(C)
if D then
task.wait(math.random(u.MinDelay,u.MaxDelay))
sendChatMessage(D)
end
end
end

if d.ChatVersion==Enum.ChatVersion.TextChatService then
x=d.MessageReceived:Connect(function(B)
if B.TextSource then
local C=a:GetPlayerByUserId(B.TextSource.UserId)
processIncoming(C,B.Text)
end
end)
else
for B,C in ipairs(a:GetPlayers())do
C.Chatted:Connect(function(D)
processIncoming(C,D)
end)
end
end
end

local B=loadstring(game:HttpGet'https://sirius.menu/rayfield')()

local C=B:CreateWindow{
Name="Unseen Liminality",
LoadingTitle="By M00KIE",
LoadingSubtitle="😹✌️",
ConfigurationSaving={Enabled=false},
KeySystem=false
}

local D=C:CreateTab("Stamina Controls",4483362458)

D:CreateSection"Stamina Rates (Per Second)"

local E=D:CreateSlider{
Name="Stamina Loss Rate",
Range={0,50},
Increment=0.5,
Suffix=" /sec",
CurrentValue=g.DrainRate*10,
Flag="StaminaLoss",
Callback=function(E)
g.DrainRate=E/10
end,
}

local F=D:CreateSlider{
Name="Stamina Gain Rate",
Range={0,50},
Increment=0.5,
Suffix=" /sec",
CurrentValue=g.RegenRate*10,
Flag="StaminaGain",
Callback=function(F)
g.RegenRate=F/10
end,
}

D:CreateSection"Quick Actions"

D:CreateButton{
Name="Infinite Sprint (0 Loss)",
Callback=function()
E:Set(0)
B:Notify{Title="Stamina",Content="Infinite Sprint Enabled!",Duration=2}
end,
}

D:CreateButton{
Name="Reset Defaults (4 Loss / 10 Gain)",
Callback=function()
E:Set(4)
F:Set(10)
B:Notify{Title="Stamina",Content="Reset to standard values.",Duration=2}
end,
}

local G=C:CreateTab("Visuals",4483362458)

local H={}

local I=false
local J=false

local K=Color3.fromRGB(255,50,50)
local L=Color3.fromRGB(255,255,255)

local M=Color3.fromRGB(0,200,255)
local N=Color3.fromRGB(255,255,255)

local function getHighlightColor(O,P)
if P then
return M,N
else
return K,L
end
end

local function updateModelHighlight(O,P)
if not O or O==getLocalCharacter()then return end

local Q=O:FindFirstChildOfClass"Humanoid"
if not Q then return end

local R=(P and J)or(not P and I)
local S=O:FindFirstChild"PersistentHighlight"

if R then
local T,U=getHighlightColor(O,P)
if not S then
S=Instance.new"Highlight"
S.Name="PersistentHighlight"
S.Adornee=O
S.FillTransparency=0.5
S.OutlineTransparency=0
S.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
S.Parent=O
end
S.FillColor=T
S.OutlineColor=U
else
if S then
S:Destroy()
end
end
end

local function applyHighlights()
for O,P in ipairs(workspace:GetDescendants())do
if P:IsA"Model"and P:FindFirstChildOfClass"Humanoid"then
local Q=a:GetPlayerFromCharacter(P)~=nil
updateModelHighlight(P,Q)
end
end
end

local function setupAutoHighlighting()
for O,P in ipairs(H)do
if typeof(P)=="RBXScriptConnection"then
P:Disconnect()
end
end
H={}

local function trackModel(O)
local P=O:FindFirstChildOfClass"Humanoid"
if P then
local Q=a:GetPlayerFromCharacter(O)~=nil
updateModelHighlight(O,Q)

local R
R=O.AncestryChanged:Connect(function(S,T)
if not T then
if R then R:Disconnect()end
end
end)
table.insert(H,R)
end
end

local O=workspace.DescendantAdded:Connect(function(O)
if O:IsA"Model"then
task.delay(0.3,function()
if O and O.Parent then
trackModel(O)
end
end)
end
end)
table.insert(H,O)

for P,Q in ipairs(workspace:GetDescendants())do
if Q:IsA"Model"then
trackModel(Q)
end
end
end

setupAutoHighlighting()

G:CreateSection"Toggles"

G:CreateToggle{
Name="Highlight NPCs",
CurrentValue=false,
Flag="NPCHighlightToggle",
Callback=function(O)
I=O
applyHighlights()
end,
}

G:CreateToggle{
Name="Highlight Players",
CurrentValue=false,
Flag="PlayerHighlightToggle",
Callback=function(O)
J=O
applyHighlights()
end,
}

G:CreateSection"NPC Colors"

G:CreateColorPicker{
Name="NPC Fill Color",
Color=K,
Flag="NPCFillColorPicker",
Callback=function(O)
K=O
applyHighlights()
end,
}

G:CreateColorPicker{
Name="NPC Outline Color",
Color=L,
Flag="NPCOutlineColorPicker",
Callback=function(O)
L=O
applyHighlights()
end,
}

G:CreateSection"Player Colors"

G:CreateColorPicker{
Name="Player Fill Color",
Color=M,
Flag="PlayerFillColorPicker",
Callback=function(O)
M=O
applyHighlights()
end,
}

G:CreateColorPicker{
Name="Player Outline Color",
Color=N,
Flag="PlayerOutlineColorPicker",
Callback=function(O)
N=O
applyHighlights()
end,
}

G:CreateSection"Controls"

G:CreateButton{
Name="Refresh Highlights",
Callback=function()
applyHighlights()
B:Notify{Title="Visuals",Content="Refreshed highlights.",Duration=2}
end,
}

local O=C:CreateTab("Player & Utility",4483362458)

O:CreateSection"Movement Controls"

O:CreateToggle{
Name="Noclip",
CurrentValue=false,
Flag="NoclipToggle",
Callback=function(P)
k=P
if not P then
setCharacterCollisions(true)
end
B:Notify{Title="Noclip",Content=k and"Enabled"or"Disabled",Duration=2}
end,
}

local P=O:CreateSlider{
Name="WalkSpeed",
Range={16,250},
Increment=1,
Suffix=" spd",
CurrentValue=16,
Flag="WalkSpeedSlider",
Callback=function(P)
l=P
n=(P~=16)

local Q=getLocalCharacter()
if Q then
local R=Q:FindFirstChildOfClass"Humanoid"
if R then
R.WalkSpeed=P
end
end
end,
}

local Q=O:CreateSlider{
Name="JumpPower",
Range={50,300},
Increment=5,
Suffix=" pwr",
CurrentValue=50,
Flag="JumpPowerSlider",
Callback=function(Q)
m=Q
o=(Q~=50)

local R=getLocalCharacter()
if R then
local S=R:FindFirstChildOfClass"Humanoid"
if S then
S.UseJumpPower=true
S.JumpPower=Q
end
end
end,
}

O:CreateButton{
Name="Reset Movement Defaults",
Callback=function()
P:Set(16)
Q:Set(50)
n=false
o=false
B:Notify{Title="Movement",Content="Speed & Jump reset to default.",Duration=2}
end,
}

O:CreateSection"Animation Controls"

O:CreateToggle{
Name="Dynamic Animation Scaling",
CurrentValue=false,
Flag="DynamicAnimToggle",
Callback=function(R)
p=R
if not R then
local S=getLocalCharacter()
if S then
local T=S:FindFirstChildOfClass"Humanoid"
if T then
local U=T:FindFirstChildOfClass"Animator"
if U then
for V,W in ipairs(U:GetPlayingAnimationTracks())do
W:AdjustSpeed(1.0)
end
end
end
end
end
B:Notify{Title="Animations",Content=R and"Dynamic Scaling Enabled"or"Reset to Normal",Duration=2}
end,
}

O:CreateSection"Whistle Loop"

O:CreateToggle{
Name="Auto Whistle",
CurrentValue=false,
Flag="WhistleToggle",
Callback=function(R)
r=R
if R then
startWhistleThread()
else
stopWhistleThread()
end
B:Notify{Title="Whistle",Content=R and"Whistle loop started"or"Whistle loop stopped",Duration=2}
end,
}

O:CreateSlider{
Name="Whistle Delay",
Range={0.45,5.0},
Increment=0.05,
Suffix="s",
CurrentValue=0.45,
Flag="WhistleDelaySlider",
Callback=function(R)
s=math.max(R,0.45)
end,
}

O:CreateSection"Teleportation"

local R
local S={}
local T={}
local U

local function updatePlayerTPList()
S={}
T={}
for V,W in ipairs(a:GetPlayers())do
if W~=e then
local X=W.DisplayName.." (@"..W.Name..")"
table.insert(T,X)
S[X]=W
end
end
if#T==0 then
table.insert(T,"No Players Found")
end
if U then
U:Refresh(T)
R=S[T[1] ]
end
end

updatePlayerTPList()

U=O:CreateDropdown{
Name="Select Player to Teleport",
Options=T,
CurrentOption=T[1]or"No Players Found",
Flag="PlayerTPDropdown",
Callback=function(V)
if type(V)=="table"then V=V[1]end
R=S[V]
end,
}

local V=a.PlayerAdded:Connect(function()
task.wait(0.2)
updatePlayerTPList()
end)
table.insert(H,V)

local W=a.PlayerRemoving:Connect(function()
task.wait(0.1)
updatePlayerTPList()
end)
table.insert(H,W)

O:CreateButton{
Name="Refresh Player List",
Callback=function()
updatePlayerTPList()
B:Notify{Title="Player List",Content="Refreshed active players.",Duration=2}
end,
}

O:CreateButton{
Name="Teleport to Player",
Callback=function()
if R and R.Character then
local X=R.Character:FindFirstChild"HumanoidRootPart"
local Y=getLocalCharacter()
if Y and X then
local Z=Y:FindFirstChild"HumanoidRootPart"
if Z then
local _=X.Position+Vector3.new(0,3,3)
task.spawn(function()
pcall(function()
e:RequestStreamAroundAsync(_)
end)
task.wait(0.1)
Y:PivotTo(CFrame.new(_))
B:Notify{Title="Teleported",Content="Arrived at "..R.Name,Duration=2}
end)
end
end
end
end,
}

local X=C:CreateTab("Chat Mimic",4483362458)

X:CreateSection"Target & Mode Selection"

X:CreateDropdown{
Name="Target Player",
Options=T,
CurrentOption=T[1]or"No Players Found",
Flag="MimicTargetDropdown",
Callback=function(Y)
if type(Y)=="table"then Y=Y[1]end
u.TargetPlayer=S[Y]
end,
}

X:CreateDropdown{
Name="Mimic Mode",
Options={"Glitched","Reverse","Whisper","Delayed","Fake Panic"},
CurrentOption="Glitched",
Flag="MimicModeDropdown",
Callback=function(Y)
if type(Y)=="table"then Y=Y[1]end
u.Mode=Y
end,
}

X:CreateToggle{
Name="Enable Chat Mimic",
CurrentValue=false,
Flag="MimicToggle",
Callback=function(Y)
u.Enabled=Y
if Y then
setupChatMimic()
B:Notify{Title="Chat Mimic",Content="Mimic Active.",Duration=2}
else
if x then x:Disconnect()end
B:Notify{Title="Chat Mimic",Content="Mimic Disabled.",Duration=2}
end
end,
}

X:CreateSection"Fine-Tuning Settings"

X:CreateSlider{
Name="Mimic Trigger Chance",
Range={10,100},
Increment=5,
Suffix="%",
CurrentValue=100,
Flag="MimicChanceSlider",
Callback=function(Y)
u.MimicChance=Y
end,
}

X:CreateSlider{
Name="Distortion Delay (Delayed Mode)",
Range={15,120},
Increment=5,
Suffix="s",
CurrentValue=45,
Flag="MimicDistortionSlider",
Callback=function(Y)
u.DistortionDelay=Y
end,
}

local Y=C:CreateTab("Info",4483362458)

Y:CreateSection"Feature Guide"

Y:CreateParagraph{Title="Stamina Controls",Content="Adjusts your sprint drain and gain rates in real-time, or gives you infinite sprint."}
Y:CreateParagraph{Title="Visuals (ESP)",Content="Highlights players and NPCs through walls with customizable colors and outline modes."}
Y:CreateParagraph{Title="Player & Utility",Content="Includes Noclip, custom WalkSpeed/JumpPower, smooth animation speed scaling, an auto-whistle loop, and player teleports."}
Y:CreateParagraph{Title="Chat Mimic",Content="Monitors a target player's chat and repeats their messages with creepy distortions like reverse text or fake panic."}

local Z=C:CreateTab("Settings",4483362458)

Z:CreateSection"GUI Management"

Z:CreateButton{
Name="Unload GUI",
Callback=function()
r=false
stopWhistleThread()

u.Enabled=false
if x then x:Disconnect()end

if j then task.cancel(j)end
if y then y:Disconnect()end
if z then z:Disconnect()end
if A then A:Disconnect()end

for _,aa in ipairs(H)do
if typeof(aa)=="RBXScriptConnection"then
aa:Disconnect()
end
end
H={}

for aa,_ in ipairs(workspace:GetDescendants())do
if _:IsA"Highlight"and _.Name=="PersistentHighlight"then
_:Destroy()
end
end

local aa=getLocalCharacter()
if aa then
local _=aa:FindFirstChildOfClass"Humanoid"
if _ then
local ab=_:FindFirstChildOfClass"Animator"
if ab then
for ac,ad in ipairs(ab:GetPlayingAnimationTracks())do
ad:AdjustSpeed(1.0)
end
end
end
end

setCharacterCollisions(true)
B:Destroy()
end,
}