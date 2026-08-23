local a=game:GetService"Players"
local b=game:GetService"ReplicatedStorage"
local c=game:GetService"RunService"
local d=a.LocalPlayer

local e=require(b.Modules.GlobalCData)


local f={
DrainRate=0.4,
RegenRate=1.0,
}

local g=e.Stamina or 100
local h=g

local i=task.spawn(function()
while task.wait()do
local i=e.Stamina
if i~=h then
local j=i-h

if j<0 then
local k=j/-0.4
g=math.clamp(g-(f.DrainRate*k),0,e.MaxStamina or 100)
elseif j>0 then
local k=j/1.0
g=math.clamp(g+(f.RegenRate*k),0,e.MaxStamina or 100)
end

e.Stamina=g
h=g
end
end
end)


local j=false
local k=16
local l=50
local m=false
local n=false


local o=false
local p=16


local q=false
local r=0.45
local s

local t
local u
local v

local function getLocalCharacter()
return d.Character or e.Character
end

t=c.Stepped:Connect(function()
if j then
local w=getLocalCharacter()
if w then
for x,y in ipairs(w:GetDescendants())do
if y:IsA"BasePart"then
y.CanCollide=false
end
end
end
end
end)

u=c.RenderStepped:Connect(function()
local w=getLocalCharacter()
if w then
local x=w:FindFirstChildOfClass"Humanoid"
if x then
if m then
x.WalkSpeed=k
end
if n then
x.UseJumpPower=true
x.JumpPower=l
end
end
end
end)

v=c.Stepped:Connect(function()
if o then
local w=getLocalCharacter()
if w then
local x=w:FindFirstChildOfClass"Humanoid"
local y=w:FindFirstChild"HumanoidRootPart"
if x and y then
local z=(y.AssemblyLinearVelocity*Vector3.new(1,0,1)).Magnitude
local A=z/p
if z<0.1 then
A=1.0
end

local B=x:FindFirstChildOfClass"Animator"
if B then
for C,D in ipairs(B:GetPlayingAnimationTracks())do
D:AdjustSpeed(A)
end
end
end
end
end
end)


local function stopWhistleThread()
if s then
task.cancel(s)
s=nil
end
end

local function startWhistleThread()
stopWhistleThread()
s=task.spawn(function()
while q do
pcall(function()
local w=b:FindFirstChild"Events"
if w then
local x=w:FindFirstChild"GameMisc"
if x then
x:FireServer{[1]="Whistle"}
end
end
end)
task.wait(math.max(r,0.45))
end
end)
end


local w=loadstring(game:HttpGet'https://sirius.menu/rayfield')()

local x=w:CreateWindow{
Name="Unseen Liminality",
LoadingTitle="By M00KIE",
LoadingSubtitle="😹✌️",
ConfigurationSaving={Enabled=false},
KeySystem=false
}


local y=x:CreateTab("Stamina Controls",4483362458)

y:CreateSection"Stamina Rates (Per Second)"

local z=y:CreateSlider{
Name="Stamina Loss Rate",
Range={0,50},
Increment=0.5,
Suffix=" /sec",
CurrentValue=f.DrainRate*10,
Flag="StaminaLoss",
Callback=function(z)
f.DrainRate=z/10
end,
}

local A=y:CreateSlider{
Name="Stamina Gain Rate",
Range={0,50},
Increment=0.5,
Suffix=" /sec",
CurrentValue=f.RegenRate*10,
Flag="StaminaGain",
Callback=function(A)
f.RegenRate=A/10
end,
}

y:CreateSection"Quick Actions"

y:CreateButton{
Name="Infinite Sprint (0 Loss)",
Callback=function()
z:Set(0)
w:Notify{Title="Stamina",Content="Infinite Sprint Enabled!",Duration=2}
end,
}

y:CreateButton{
Name="Reset Defaults (4 Loss / 10 Gain)",
Callback=function()
z:Set(4)
A:Set(10)
w:Notify{Title="Stamina",Content="Reset to standard values.",Duration=2}
end,
}


local B=x:CreateTab("Visuals",4483362458)

local C={}
local D={}

local function clearHighlights()
for E,F in ipairs(C)do
if F and F.Parent then
F:Destroy()
end
end
C={}
end

local E=false
local F=false

local G=Color3.fromRGB(255,50,50)
local H=Color3.fromRGB(255,255,255)

local I=Color3.fromRGB(0,200,255)
local J=Color3.fromRGB(255,255,255)

local function highlightModel(K,L)
if not K or K==getLocalCharacter()then return end

local M=K:FindFirstChildOfClass"Humanoid"
if not M then return end

if not L and E then
local N=Instance.new"Highlight"
N.Name="NPCHighlight"
N.Adornee=K
N.FillColor=G
N.FillTransparency=0.5
N.OutlineColor=H
N.OutlineTransparency=0
N.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
N.Parent=K
table.insert(C,N)
elseif L and F then
local N=Instance.new"Highlight"
N.Name="PlayerHighlight"
N.Adornee=K
N.FillColor=I
N.FillTransparency=0.5
N.OutlineColor=J
N.OutlineTransparency=0
N.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
N.Parent=K
table.insert(C,N)
end
end

local function applyHighlights()
clearHighlights()

for K,L in ipairs(workspace:GetDescendants())do
if L:IsA"Model"then
local M=a:GetPlayerFromCharacter(L)~=nil
highlightModel(L,M)
end
end
end


local function setupAutoHighlighting()
for K,L in ipairs(D)do
L:Disconnect()
end
D={}

local function onCharacterAdded(K,L)
task.wait(0.5)
if F then
highlightModel(K,true)
end
end

local function onPlayerAdded(K)
local L=K.CharacterAdded:Connect(function(L)
onCharacterAdded(L,K)
end)
table.insert(D,L)
if K.Character then
onCharacterAdded(K.Character,K)
end
end

for K,L in ipairs(a:GetPlayers())do
if L~=d then
onPlayerAdded(L)
end
end

local K=a.PlayerAdded:Connect(onPlayerAdded)
table.insert(D,K)
end

setupAutoHighlighting()

B:CreateSection"Toggles"

B:CreateToggle{
Name="Highlight NPCs",
CurrentValue=false,
Flag="NPCHighlightToggle",
Callback=function(K)
E=K
applyHighlights()
end,
}

B:CreateToggle{
Name="Highlight Players",
CurrentValue=false,
Flag="PlayerHighlightToggle",
Callback=function(K)
F=K
applyHighlights()
end,
}

B:CreateSection"NPC Colors"

B:CreateColorPicker{
Name="NPC Fill Color",
Color=G,
Flag="NPCFillColorPicker",
Callback=function(K)
G=K
applyHighlights()
end,
}

B:CreateColorPicker{
Name="NPC Outline Color",
Color=H,
Flag="NPCOutlineColorPicker",
Callback=function(K)
H=K
applyHighlights()
end,
}

B:CreateSection"Player Colors"

B:CreateColorPicker{
Name="Player Fill Color",
Color=I,
Flag="PlayerFillColorPicker",
Callback=function(K)
I=K
applyHighlights()
end,
}

B:CreateColorPicker{
Name="Player Outline Color",
Color=J,
Flag="PlayerOutlineColorPicker",
Callback=function(K)
J=K
applyHighlights()
end,
}

B:CreateSection"Controls"

B:CreateButton{
Name="Refresh Highlights",
Callback=function()
applyHighlights()
w:Notify{Title="Visuals",Content="Refreshed highlights.",Duration=2}
end,
}


local K=x:CreateTab("Player & Utility",4483362458)

K:CreateSection"Movement Controls"

K:CreateToggle{
Name="Noclip",
CurrentValue=false,
Flag="NoclipToggle",
Callback=function(L)
j=L
w:Notify{Title="Noclip",Content=j and"Enabled"or"Disabled",Duration=2}
end,
}

local L=K:CreateSlider{
Name="WalkSpeed",
Range={16,250},
Increment=1,
Suffix=" spd",
CurrentValue=16,
Flag="WalkSpeedSlider",
Callback=function(L)
k=L
m=(L~=16)

local M=getLocalCharacter()
if M then
local N=M:FindFirstChildOfClass"Humanoid"
if N then
N.WalkSpeed=L
end
end
end,
}

local M=K:CreateSlider{
Name="JumpPower",
Range={50,300},
Increment=5,
Suffix=" pwr",
CurrentValue=50,
Flag="JumpPowerSlider",
Callback=function(M)
l=M
n=(M~=50)

local N=getLocalCharacter()
if N then
local O=N:FindFirstChildOfClass"Humanoid"
if O then
O.UseJumpPower=true
O.JumpPower=M
end
end
end,
}

K:CreateButton{
Name="Reset Movement Defaults",
Callback=function()
L:Set(16)
M:Set(50)
m=false
n=false
w:Notify{Title="Movement",Content="Speed & Jump reset to default.",Duration=2}
end,
}

K:CreateSection"Animation Controls"

K:CreateToggle{
Name="Dynamic Animation Scaling",
CurrentValue=false,
Flag="DynamicAnimToggle",
Callback=function(N)
o=N
if not N then
local O=getLocalCharacter()
if O then
local P=O:FindFirstChildOfClass"Humanoid"
if P then
local Q=P:FindFirstChildOfClass"Animator"
if Q then
for R,S in ipairs(Q:GetPlayingAnimationTracks())do
S:AdjustSpeed(1.0)
end
end
end
end
end
w:Notify{Title="Animations",Content=N and"Dynamic Scaling Enabled"or"Reset to Normal",Duration=2}
end,
}

K:CreateSection"Whistle Loop"

K:CreateToggle{
Name="Auto Whistle",
CurrentValue=false,
Flag="WhistleToggle",
Callback=function(N)
q=N
if N then
startWhistleThread()
else
stopWhistleThread()
end
w:Notify{Title="Whistle",Content=N and"Whistle loop started"or"Whistle loop stopped",Duration=2}
end,
}

K:CreateSlider{
Name="Whistle Delay",
Range={0.45,5.0},
Increment=0.05,
Suffix="s",
CurrentValue=0.45,
Flag="WhistleDelaySlider",
Callback=function(N)
r=math.max(N,0.45)
end,
}

K:CreateSection"Teleportation"

local N
local O={}
local P={}
local Q

local function updatePlayerTPList()
O={}
P={}
for R,S in ipairs(a:GetPlayers())do
if S~=d then
local T=S.DisplayName.." (@"..S.Name..")"
table.insert(P,T)
O[T]=S
end
end
if#P==0 then
table.insert(P,"No Players Found")
end
if Q then
Q:Refresh(P)
end
end

updatePlayerTPList()

Q=K:CreateDropdown{
Name="Select Player to Teleport",
Options=P,
CurrentOption=P[1]or"No Players Found",
Flag="PlayerTPDropdown",
Callback=function(R)
if type(R)=="table"then R=R[1]end
N=O[R]
end,
}


local R=a.PlayerAdded:Connect(function()
task.wait(0.5)
updatePlayerTPList()
end)
table.insert(D,R)

local S=a.PlayerRemoving:Connect(function()
task.wait(0.1)
updatePlayerTPList()
end)
table.insert(D,S)

K:CreateButton{
Name="Refresh Player List",
Callback=function()
updatePlayerTPList()
end,
}

K:CreateButton{
Name="Teleport to Player",
Callback=function()
if N and N.Character then
local T=N.Character:FindFirstChild"HumanoidRootPart"
local U=getLocalCharacter()
if U and T then
local V=U:FindFirstChild"HumanoidRootPart"
if V then
local W=T.Position+Vector3.new(0,2,3)
task.spawn(function()
d:RequestStreamAroundAsync(W)
V.CFrame=CFrame.new(W)
w:Notify{Title="Teleported",Content="Arrived at "..N.Name,Duration=2}
end)
end
end
end
end,
}


local T=x:CreateTab("Settings",4483362458)

T:CreateSection"GUI Management"

T:CreateButton{
Name="Unload GUI",
Callback=function()
q=false
stopWhistleThread()

if i then task.cancel(i)end
if t then t:Disconnect()end
if u then u:Disconnect()end
if v then v:Disconnect()end

for U,V in ipairs(D)do
V:Disconnect()
end
D={}

clearHighlights()

local U=getLocalCharacter()
if U then
local V=U:FindFirstChildOfClass"Humanoid"
if V then
local W=V:FindFirstChildOfClass"Animator"
if W then
for X,Y in ipairs(W:GetPlayingAnimationTracks())do
Y:AdjustSpeed(1.0)
end
end
end
end

w:Destroy()
end,
}