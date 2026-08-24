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
E.CanCollide=B
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
local I={}

local function clearHighlights()
for J,K in ipairs(H)do
if K and K.Parent then
K:Destroy()
end
end
H={}
end

local J=false
local K=false

local L=Color3.fromRGB(255,50,50)
local M=Color3.fromRGB(255,255,255)

local N=Color3.fromRGB(0,200,255)
local O=Color3.fromRGB(255,255,255)

local function highlightModel(P,Q)
if not P or P==getLocalCharacter()then return end

local R=P:FindFirstChildOfClass"Humanoid"
if not R then return end

if not P:FindFirstChildOfClass"Highlight"then
if not Q and J then
local S=Instance.new"Highlight"
S.Name="NPCHighlight"
S.Adornee=P
S.FillColor=L
S.FillTransparency=0.5
S.OutlineColor=M
S.OutlineTransparency=0
S.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
S.Parent=P
table.insert(H,S)
elseif Q and K then
local S=Instance.new"Highlight"
S.Name="PlayerHighlight"
S.Adornee=P
S.FillColor=N
S.FillTransparency=0.5
S.OutlineColor=O
S.OutlineTransparency=0
S.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
S.Parent=P
table.insert(H,S)
end
end
end

local function applyHighlights()
clearHighlights()

for P,Q in ipairs(workspace:GetDescendants())do
if Q:IsA"Model"then
local R=a:GetPlayerFromCharacter(Q)~=nil
highlightModel(Q,R)
end
end
end

local function setupAutoHighlighting()
for P,Q in ipairs(I)do
if typeof(Q)=="RBXScriptConnection"then
Q:Disconnect()
end
end
I={}

local function onCharacterAdded(P,Q)
task.wait(0.5)
if P and P.Parent then
highlightModel(P,Q)
end
end

for P,Q in ipairs(a:GetPlayers())do
if Q~=e then
local R=Q.CharacterAdded:Connect(function(R)
onCharacterAdded(R,true)
end)
table.insert(I,R)
if Q.Character then
onCharacterAdded(Q.Character,true)
end
end
end

local P=a.PlayerAdded:Connect(function(P)
if P~=e then
local Q=P.CharacterAdded:Connect(function(Q)
onCharacterAdded(Q,true)
end)
table.insert(I,Q)
if P.Character then
onCharacterAdded(P.Character,true)
end
end
end)
table.insert(I,P)

local Q=workspace.DescendantAdded:Connect(function(Q)
if Q:IsA"Model"and Q:FindFirstChildOfClass"Humanoid"then
local R=a:GetPlayerFromCharacter(Q)~=nil
if(R and K)or(not R and J)then
task.delay(0.2,function()
highlightModel(Q,R)
end)
end
end
end)
table.insert(I,Q)
end

setupAutoHighlighting()

G:CreateSection"Toggles"

G:CreateToggle{
Name="Highlight NPCs",
CurrentValue=false,
Flag="NPCHighlightToggle",
Callback=function(P)
J=P
applyHighlights()
end,
}

G:CreateToggle{
Name="Highlight Players",
CurrentValue=false,
Flag="PlayerHighlightToggle",
Callback=function(P)
K=P
applyHighlights()
end,
}

G:CreateSection"NPC Colors"

G:CreateColorPicker{
Name="NPC Fill Color",
Color=L,
Flag="NPCFillColorPicker",
Callback=function(P)
L=P
applyHighlights()
end,
}

G:CreateColorPicker{
Name="NPC Outline Color",
Color=M,
Flag="NPCOutlineColorPicker",
Callback=function(P)
M=P
applyHighlights()
end,
}

G:CreateSection"Player Colors"

G:CreateColorPicker{
Name="Player Fill Color",
Color=N,
Flag="PlayerFillColorPicker",
Callback=function(P)
N=P
applyHighlights()
end,
}

G:CreateColorPicker{
Name="Player Outline Color",
Color=O,
Flag="PlayerOutlineColorPicker",
Callback=function(P)
O=P
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

local P=C:CreateTab("Player & Utility",4483362458)

P:CreateSection"Movement Controls"

P:CreateToggle{
Name="Noclip",
CurrentValue=false,
Flag="NoclipToggle",
Callback=function(Q)
k=Q
B:Notify{Title="Noclip",Content=k and"Enabled"or"Disabled",Duration=2}
end,
}

local Q=P:CreateSlider{
Name="WalkSpeed",
Range={16,250},
Increment=1,
Suffix=" spd",
CurrentValue=16,
Flag="WalkSpeedSlider",
Callback=function(Q)
l=Q
n=(Q~=16)

local R=getLocalCharacter()
if R then
local S=R:FindFirstChildOfClass"Humanoid"
if S then
S.WalkSpeed=Q
end
end
end,
}

local R=P:CreateSlider{
Name="JumpPower",
Range={50,300},
Increment=5,
Suffix=" pwr",
CurrentValue=50,
Flag="JumpPowerSlider",
Callback=function(R)
m=R
o=(R~=50)

local S=getLocalCharacter()
if S then
local T=S:FindFirstChildOfClass"Humanoid"
if T then
T.UseJumpPower=true
T.JumpPower=R
end
end
end,
}

P:CreateButton{
Name="Reset Movement Defaults",
Callback=function()
Q:Set(16)
R:Set(50)
n=false
o=false
B:Notify{Title="Movement",Content="Speed & Jump reset to default.",Duration=2}
end,
}

P:CreateSection"Animation Controls"

P:CreateToggle{
Name="Dynamic Animation Scaling",
CurrentValue=false,
Flag="DynamicAnimToggle",
Callback=function(S)
p=S
if not S then
local T=getLocalCharacter()
if T then
local U=T:FindFirstChildOfClass"Humanoid"
if U then
local V=U:FindFirstChildOfClass"Animator"
if V then
for W,X in ipairs(V:GetPlayingAnimationTracks())do
X:AdjustSpeed(1.0)
end
end
end
end
end
B:Notify{Title="Animations",Content=S and"Dynamic Scaling Enabled"or"Reset to Normal",Duration=2}
end,
}

P:CreateSection"Whistle Loop"

P:CreateToggle{
Name="Auto Whistle",
CurrentValue=false,
Flag="WhistleToggle",
Callback=function(S)
r=S
if S then
startWhistleThread()
else
stopWhistleThread()
end
B:Notify{Title="Whistle",Content=S and"Whistle loop started"or"Whistle loop stopped",Duration=2}
end,
}

P:CreateSlider{
Name="Whistle Delay",
Range={0.45,5.0},
Increment=0.05,
Suffix="s",
CurrentValue=0.45,
Flag="WhistleDelaySlider",
Callback=function(S)
s=math.max(S,0.45)
end,
}

P:CreateSection"Teleportation"

local S
local T={}
local U={}
local V

local function updatePlayerTPList()
T={}
U={}
for W,X in ipairs(a:GetPlayers())do
if X~=e then
local Y=X.DisplayName.." (@"..X.Name..")"
table.insert(U,Y)
T[Y]=X
end
end
if#U==0 then
table.insert(U,"No Players Found")
end
if V then
V:Refresh(U)
S=T[U[1] ]
end
end

updatePlayerTPList()

V=P:CreateDropdown{
Name="Select Player to Teleport",
Options=U,
CurrentOption=U[1]or"No Players Found",
Flag="PlayerTPDropdown",
Callback=function(W)
if type(W)=="table"then W=W[1]end
S=T[W]
end,
}

local W=a.PlayerAdded:Connect(function()
task.wait(0.2)
updatePlayerTPList()
end)
table.insert(I,W)

local X=a.PlayerRemoving:Connect(function()
task.wait(0.1)
updatePlayerTPList()
end)
table.insert(I,X)

P:CreateButton{
Name="Refresh Player List",
Callback=function()
updatePlayerTPList()
B:Notify{Title="Player List",Content="Refreshed active players.",Duration=2}
end,
}

P:CreateButton{
Name="Teleport to Player",
Callback=function()
if S and S.Character then
local Y=S.Character:FindFirstChild"HumanoidRootPart"
local Z=getLocalCharacter()
if Z and Y then
local _=Z:FindFirstChild"HumanoidRootPart"
if _ then
local aa=Y.Position+Vector3.new(0,3,3)
task.spawn(function()
pcall(function()
e:RequestStreamAroundAsync(aa)
end)
task.wait(0.1)
Z:PivotTo(CFrame.new(aa))
B:Notify{Title="Teleported",Content="Arrived at "..S.Name,Duration=2}
end)
end
end
end
end,
}

local aa=C:CreateTab("Chat Mimic",4483362458)

aa:CreateSection"Target & Mode Selection"

aa:CreateDropdown{
Name="Target Player",
Options=U,
CurrentOption=U[1]or"No Players Found",
Flag="MimicTargetDropdown",
Callback=function(Y)
if type(Y)=="table"then Y=Y[1]end
u.TargetPlayer=T[Y]
end,
}

aa:CreateDropdown{
Name="Mimic Mode",
Options={"Glitched","Reverse","Whisper","Delayed","Fake Panic"},
CurrentOption="Glitched",
Flag="MimicModeDropdown",
Callback=function(Y)
if type(Y)=="table"then Y=Y[1]end
u.Mode=Y
end,
}

aa:CreateToggle{
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

aa:CreateSection"Fine-Tuning Settings"

aa:CreateSlider{
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

aa:CreateSlider{
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

local Y=C:CreateTab("Settings",4483362458)

Y:CreateSection"GUI Management"

Y:CreateButton{
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

for Z,_ in ipairs(I)do
if typeof(_)=="RBXScriptConnection"then
_:Disconnect()
end
end
I={}

clearHighlights()

local Z=getLocalCharacter()
if Z then
local _=Z:FindFirstChildOfClass"Humanoid"
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