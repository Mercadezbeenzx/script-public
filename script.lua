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
FontType="FullWidth",
MimicChance=100,
MinDelay=1,
MaxDelay=2,
DistortionDelay=45,
CorruptIntensity=3
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

local x={
FullWidth={a=
"ａ",b="ｂ",c="ｃ",d="ｄ",e="ｅ",f=
"ｆ",g="ｇ",h="ｈ",i="ｉ",j="ｊ",k=
"ｋ",l="ｌ",m="ｍ",n="ｎ",o="ｏ",p=
"ｐ",q="ｑ",r="ｒ",s="ｓ",t="ｔ",u=
"ｕ",v="ｖ",w="ｗ",x="ｘ",y="ｙ",z="ｚ"
},
SmallCaps={a=
"ᴀ",b="ʙ",c="ᴄ",d="ᴅ",e="ᴇ",f=
"ꜰ",g="ɢ",h="ʜ",i="ɪ",j="ᴊ",k=
"ᴋ",l="ʟ",m="ᴍ",n="ɴ",o="ᴏ",p=
"ᴘ",q="ǫ",r="ʀ",s="s",t="ᴛ",u=
"ᴜ",v="ᴠ",w="ᴡ",x="x",y="ʏ",z="ᴢ"
},
Subscript={a=
"ₐ",b="b",c="c",d="d",e="ₑ",f=
"f",g="g",h="ₕ",i="ᵢ",j="ⱼ",k=
"ₖ",l="ₗ",m="ₘ",n="ₙ",o="ₒ",p=
"ₚ",q="q",r="ᵣ",s="ₛ",t="ₜ",u=
"ᵤ",v="ᵥ",w="w",x="ₓ",y="y",z="z"
}
}

local y
local z
local A
local B

local function getLocalCharacter()
return e.Character or f.Character
end

local function applyFont(C,D)
local E=x[D]
if not E then return C end

local F=""
for G=1,#C do
local H=C:sub(G,G):lower()
F=F..(E[H]or C:sub(G,G))
end
return F
end

function sendChatMessage(C)
pcall(function()
if d.ChatVersion==Enum.ChatVersion.TextChatService then
local D=d.TextChannels.RBXGeneral
if D then D:SendAsync(C)end
else
b.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(C,"All")
end
end)
end

local function alterText(C)
if math.random(1,100)>u.MimicChance then return nil end

if u.Mode=="Glitched"then
local D={"...","..?","..."," _ "}
return applyFont(C:sub(1,math.max(1,#C-2))..D[math.random(1,#D)],u.FontType)

elseif u.Mode=="Reverse"then
return applyFont(C:reverse(),u.FontType)

elseif u.Mode=="Whisper"then
return applyFont("... "..C:lower().." ...",u.FontType)

elseif u.Mode=="Corrupted Echo"then
local D={".","_","/","~","-"}
local E={}
for F=1,#C do
table.insert(E,C:sub(F,F))
end
for F=1,u.CorruptIntensity do
if#E>0 then
local G=math.random(1,#E)
E[G]=D[math.random(1,#D)]
end
end
return applyFont(table.concat(E),u.FontType)

elseif u.Mode=="Delayed Distortion"then
table.insert(v,C)
task.delay(u.DistortionDelay,function()
if#v>0 then
local D=table.remove(v,1)
sendChatMessage(applyFont("... "..D.." ...",u.FontType))
end
end)
return nil

elseif u.Mode=="Fake Panic"then
local D=w[math.random(1,#w)]
return applyFont(D,u.FontType)
end

return C
end

local function setCharacterCollisions(C)
local D=getLocalCharacter()
if D then
for E,F in ipairs(D:GetDescendants())do
if F:IsA"BasePart"then
F.CanCollide=C
end
end
end
end

z=c.Stepped:Connect(function()
if k then
setCharacterCollisions(false)
end
end)

A=c.RenderStepped:Connect(function()
local C=getLocalCharacter()
if C then
local D=C:FindFirstChildOfClass"Humanoid"
if D then
if n then
D.WalkSpeed=l
end
if o then
D.UseJumpPower=true
D.JumpPower=m
end
end
end
end)

B=c.Stepped:Connect(function()
if p then
local C=getLocalCharacter()
if C then
local D=C:FindFirstChildOfClass"Humanoid"
local E=C:FindFirstChild"HumanoidRootPart"
if D and E then
local F=(E.AssemblyLinearVelocity*Vector3.new(1,0,1)).Magnitude
local G=F/q
if F<0.1 then
G=1.0
end

local H=D:FindFirstChildOfClass"Animator"
if H then
for I,J in ipairs(H:GetPlayingAnimationTracks())do
J:AdjustSpeed(G)
end
end
end
end
end
end)

local function triggerWhistle()
pcall(function()
local C=b:FindFirstChild"Events"
if C then
local D=C:FindFirstChild"GameMisc"
if D then
D:FireServer{[1]="Whistle"}
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
if y then y:Disconnect()end

local function processIncoming(C,D)
if not u.Enabled or not u.TargetPlayer then return end
if C==u.TargetPlayer then
local E=alterText(D)
if E then
task.wait(math.random(u.MinDelay,u.MaxDelay))
sendChatMessage(E)
end
end
end

if d.ChatVersion==Enum.ChatVersion.TextChatService then
y=d.MessageReceived:Connect(function(C)
if C.TextSource then
local D=a:GetPlayerByUserId(C.TextSource.UserId)
processIncoming(D,C.Text)
end
end)
else
for C,D in ipairs(a:GetPlayers())do
D.Chatted:Connect(function(E)
processIncoming(D,E)
end)
end
end
end

local C=loadstring(game:HttpGet'https://sirius.menu/rayfield')()

local D=C:CreateWindow{
Name="Unseen Liminality",
LoadingTitle="By M00KIE",
LoadingSubtitle="😹✌️",
ConfigurationSaving={Enabled=false},
KeySystem=false
}

local E=D:CreateTab("Stamina Controls",4483362458)

E:CreateSection"Stamina Rates (Per Second)"

local F=E:CreateSlider{
Name="Stamina Loss Rate",
Range={0,50},
Increment=0.5,
Suffix=" /sec",
CurrentValue=g.DrainRate*10,
Flag="StaminaLoss",
Callback=function(F)
g.DrainRate=F/10
end,
}

local G=E:CreateSlider{
Name="Stamina Gain Rate",
Range={0,50},
Increment=0.5,
Suffix=" /sec",
CurrentValue=g.RegenRate*10,
Flag="StaminaGain",
Callback=function(G)
g.RegenRate=G/10
end,
}

E:CreateSection"Quick Actions"

E:CreateButton{
Name="Infinite Sprint (0 Loss)",
Callback=function()
F:Set(0)
C:Notify{Title="Stamina",Content="Infinite Sprint Enabled!",Duration=2}
end,
}

E:CreateButton{
Name="Reset Defaults (4 Loss / 10 Gain)",
Callback=function()
F:Set(4)
G:Set(10)
C:Notify{Title="Stamina",Content="Reset to standard values.",Duration=2}
end,
}

local H=D:CreateTab("Visuals",4483362458)

local I={}
local J={}

local function clearHighlights()
for K,L in ipairs(I)do
if L and L.Parent then
L:Destroy()
end
end
I={}
end

local K=false
local L=false

local M=Color3.fromRGB(255,50,50)
local N=Color3.fromRGB(255,255,255)

local O=Color3.fromRGB(0,200,255)
local P=Color3.fromRGB(255,255,255)

local function highlightModel(Q,R)
if not Q or Q==getLocalCharacter()then return end

local S=Q:FindFirstChildOfClass"Humanoid"
if not S then return end

if not R and K then
local T=Instance.new"Highlight"
T.Name="NPCHighlight"
T.Adornee=Q
T.FillColor=M
T.FillTransparency=0.5
T.OutlineColor=N
T.OutlineTransparency=0
T.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
T.Parent=Q
table.insert(I,T)
elseif R and L then
local T=Instance.new"Highlight"
T.Name="PlayerHighlight"
T.Adornee=Q
T.FillColor=O
T.FillTransparency=0.5
T.OutlineColor=P
T.OutlineTransparency=0
T.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
T.Parent=Q
table.insert(I,T)
end
end

local function applyHighlights()
clearHighlights()

for Q,R in ipairs(workspace:GetDescendants())do
if R:IsA"Model"then
local S=a:GetPlayerFromCharacter(R)~=nil
highlightModel(R,S)
end
end
end

local function setupAutoHighlighting()
for Q,R in ipairs(J)do
R:Disconnect()
end
J={}

local function onCharacterAdded(Q,R)
task.wait(0.5)
if L then
highlightModel(Q,true)
end
end

local function onPlayerAdded(Q)
local R=Q.CharacterAdded:Connect(function(R)
onCharacterAdded(R,Q)
end)
table.insert(J,R)
if Q.Character then
onCharacterAdded(Q.Character,Q)
end
end

for Q,R in ipairs(a:GetPlayers())do
if R~=e then
onPlayerAdded(R)
end
end

local Q=a.PlayerAdded:Connect(onPlayerAdded)
table.insert(J,Q)
end

setupAutoHighlighting()

H:CreateSection"Toggles"

H:CreateToggle{
Name="Highlight NPCs",
CurrentValue=false,
Flag="NPCHighlightToggle",
Callback=function(Q)
K=Q
applyHighlights()
end,
}

H:CreateToggle{
Name="Highlight Players",
CurrentValue=false,
Flag="PlayerHighlightToggle",
Callback=function(Q)
L=Q
applyHighlights()
end,
}

H:CreateSection"NPC Colors"

H:CreateColorPicker{
Name="NPC Fill Color",
Color=M,
Flag="NPCFillColorPicker",
Callback=function(Q)
M=Q
applyHighlights()
end,
}

H:CreateColorPicker{
Name="NPC Outline Color",
Color=N,
Flag="NPCOutlineColorPicker",
Callback=function(Q)
N=Q
applyHighlights()
end,
}

H:CreateSection"Player Colors"

H:CreateColorPicker{
Name="Player Fill Color",
Color=O,
Flag="PlayerFillColorPicker",
Callback=function(Q)
O=Q
applyHighlights()
end,
}

H:CreateColorPicker{
Name="Player Outline Color",
Color=P,
Flag="PlayerOutlineColorPicker",
Callback=function(Q)
P=Q
applyHighlights()
end,
}

H:CreateSection"Controls"

H:CreateButton{
Name="Refresh Highlights",
Callback=function()
applyHighlights()
C:Notify{Title="Visuals",Content="Refreshed highlights.",Duration=2}
end,
}

local Q=D:CreateTab("Player & Utility",4483362458)

Q:CreateSection"Movement Controls"

Q:CreateToggle{
Name="Noclip",
CurrentValue=false,
Flag="NoclipToggle",
Callback=function(R)
k=R
C:Notify{Title="Noclip",Content=k and"Enabled"or"Disabled",Duration=2}
end,
}

local R=Q:CreateSlider{
Name="WalkSpeed",
Range={16,250},
Increment=1,
Suffix=" spd",
CurrentValue=16,
Flag="WalkSpeedSlider",
Callback=function(R)
l=R
n=(R~=16)

local S=getLocalCharacter()
if S then
local T=S:FindFirstChildOfClass"Humanoid"
if T then
T.WalkSpeed=R
end
end
end,
}

local S=Q:CreateSlider{
Name="JumpPower",
Range={50,300},
Increment=5,
Suffix=" pwr",
CurrentValue=50,
Flag="JumpPowerSlider",
Callback=function(S)
m=S
o=(S~=50)

local T=getLocalCharacter()
if T then
local U=T:FindFirstChildOfClass"Humanoid"
if U then
U.UseJumpPower=true
U.JumpPower=S
end
end
end,
}

Q:CreateButton{
Name="Reset Movement Defaults",
Callback=function()
R:Set(16)
S:Set(50)
n=false
o=false
C:Notify{Title="Movement",Content="Speed & Jump reset to default.",Duration=2}
end,
}

Q:CreateSection"Animation Controls"

Q:CreateToggle{
Name="Dynamic Animation Scaling",
CurrentValue=false,
Flag="DynamicAnimToggle",
Callback=function(T)
p=T
if not T then
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
end
C:Notify{Title="Animations",Content=T and"Dynamic Scaling Enabled"or"Reset to Normal",Duration=2}
end,
}

Q:CreateSection"Whistle Loop"

Q:CreateToggle{
Name="Auto Whistle",
CurrentValue=false,
Flag="WhistleToggle",
Callback=function(T)
r=T
if T then
startWhistleThread()
else
stopWhistleThread()
end
C:Notify{Title="Whistle",Content=T and"Whistle loop started"or"Whistle loop stopped",Duration=2}
end,
}

Q:CreateSlider{
Name="Whistle Delay",
Range={0.45,5.0},
Increment=0.05,
Suffix="s",
CurrentValue=0.45,
Flag="WhistleDelaySlider",
Callback=function(T)
s=math.max(T,0.45)
end,
}

Q:CreateSection"Teleportation"

local T
local U={}
local V={}
local W

local function updatePlayerTPList()
U={}
V={}
for X,Y in ipairs(a:GetPlayers())do
if Y~=e then
local Z=Y.DisplayName.." (@"..Y.Name..")"
table.insert(V,Z)
U[Z]=Y
end
end
if#V==0 then
table.insert(V,"No Players Found")
end
if W then
W:Refresh(V)
end
end

updatePlayerTPList()

W=Q:CreateDropdown{
Name="Select Player to Teleport",
Options=V,
CurrentOption=V[1]or"No Players Found",
Flag="PlayerTPDropdown",
Callback=function(X)
if type(X)=="table"then X=X[1]end
T=U[X]
end,
}

local X=a.PlayerAdded:Connect(function()
task.wait(0.5)
updatePlayerTPList()
end)
table.insert(J,X)

local Y=a.PlayerRemoving:Connect(function()
task.wait(0.1)
updatePlayerTPList()
end)
table.insert(J,Y)

Q:CreateButton{
Name="Refresh Player List",
Callback=function()
updatePlayerTPList()
end,
}

Q:CreateButton{
Name="Teleport to Player",
Callback=function()
if T and T.Character then
local Z=T.Character:FindFirstChild"HumanoidRootPart"
local _=getLocalCharacter()
if _ and Z then
local aa=_:FindFirstChild"HumanoidRootPart"
if aa then
local ab=Z.Position+Vector3.new(0,3,3)
task.spawn(function()
pcall(function()
e:RequestStreamAroundAsync(ab)
end)
task.wait(0.1)
_:PivotTo(CFrame.new(ab))
C:Notify{Title="Teleported",Content="Arrived at "..T.Name,Duration=2}
end)
end
end
end
end,
}

local aa=D:CreateTab("Chat Mimic",4483362458)

aa:CreateSection"Target & Mode Selection"

aa:CreateDropdown{
Name="Target Player",
Options=V,
CurrentOption=V[1]or"No Players Found",
Flag="MimicTargetDropdown",
Callback=function(ab)
if type(ab)=="table"then ab=ab[1]end
u.TargetPlayer=U[ab]
end,
}

aa:CreateDropdown{
Name="Mimic Mode",
Options={"Glitched","Reverse","Whisper","Corrupted Echo","Delayed Distortion","Fake Panic"},
CurrentOption="Glitched",
Flag="MimicModeDropdown",
Callback=function(ab)
if type(ab)=="table"then ab=ab[1]end
u.Mode=ab
end,
}

aa:CreateDropdown{
Name="Unicode Font Style",
Options={"FullWidth","SmallCaps","Subscript","None"},
CurrentOption="FullWidth",
Flag="MimicFontDropdown",
Callback=function(ab)
if type(ab)=="table"then ab=ab[1]end
u.FontType=ab
end,
}

aa:CreateToggle{
Name="Enable Chat Mimic",
CurrentValue=false,
Flag="MimicToggle",
Callback=function(ab)
u.Enabled=ab
if ab then
setupChatMimic()
C:Notify{Title="Chat Mimic",Content="Mimic Active.",Duration=2}
else
if y then y:Disconnect()end
C:Notify{Title="Chat Mimic",Content="Mimic Disabled.",Duration=2}
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
Callback=function(ab)
u.MimicChance=ab
end,
}

aa:CreateSlider{
Name="Corrupt Intensity (Corrupted Mode)",
Range={1,10},
Increment=1,
Suffix=" chars",
CurrentValue=3,
Flag="MimicCorruptSlider",
Callback=function(ab)
u.CorruptIntensity=ab
end,
}

aa:CreateSlider{
Name="Distortion Delay (Delayed Mode)",
Range={15,120},
Increment=5,
Suffix="s",
CurrentValue=45,
Flag="MimicDistortionSlider",
Callback=function(ab)
u.DistortionDelay=ab
end,
}

local ab=D:CreateTab("Settings",4483362458)

ab:CreateSection"GUI Management"

ab:CreateButton{
Name="Unload GUI",
Callback=function()
r=false
stopWhistleThread()

u.Enabled=false
if y then y:Disconnect()end

if j then task.cancel(j)end
if z then z:Disconnect()end
if A then A:Disconnect()end
if B then B:Disconnect()end

for Z,_ in ipairs(J)do
_:Disconnect()
end
J={}

clearHighlights()

local Z=getLocalCharacter()
if Z then
local _=Z:FindFirstChildOfClass"Humanoid"
if _ then
local ac=_:FindFirstChildOfClass"Animator"
if ac then
for ad,ae in ipairs(ac:GetPlayingAnimationTracks())do
ae:AdjustSpeed(1.0)
end
end
end
end

setCharacterCollisions(true)
C:Destroy()
end,
}