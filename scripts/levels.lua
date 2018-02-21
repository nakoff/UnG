dofile("EffectsFX.lua")

Camera = getObject("cam")

button = {mesh={},text={},s={},close={}}
for i=1,6 do 
	button.mesh[i] 	= getObject("m"..i) 
	button.text[i]	= getObject("l"..i)
	button.close[i]	= 1
end
button.close[1]	= 0

for i=1,8 do button.s[i] = getObject("s"..i) 	end

closed = {mesh={},level={}}
for i=1,5 do 
	closed.mesh[i]	= getObject("closed"..i)	
	closed.level[i] 	= 1+i
end


mx,my = 0,0
V1,V2  = 0,0
millisecs=0
secs 	= 0
Level	= 1
effect_count = 1

	local k = 1
	local prop = {}
	function load()
		for i in io.lines("save.an") do  
			if i ~= nil then
				prop[k] = tonumber(i)
				k = k+1
			end
		end
		Level = prop[1]
	end
load()

for i=1,5 do
	if Level > closed.level[i] then 
		deactivate(closed.mesh[i]) 
		button.close[i+1] = 0
	end
end
	
local object,point
local loop = 0
function pick()
	mx 	= getAxis("MOUSE_X")
	my 	= getAxis("MOUSE_Y")
	V1 = getUnProjectedPoint(Camera, vec3(mx, my, 0))
	V2 = getUnProjectedPoint(Camera, vec3(mx, my, 1))
	point, object = rayHit(V1,V2)
	if point then
		for i=1,6 do
			if object == button.mesh[i] then
				if loop == 0 then 
					loop = 1
					playSound(button.s[i])
				end
				rotate(button.mesh[i], {math.cos(millisecs/5), 0, 0}, 1,"local")
				setTextColor(button.text[i],{0.5,1,0.3,1})
				if onKeyUp("MOUSE_BUTTON1") then
					if button.close[i] == 0 then
						select(i)
					else
						playSound(button.s[8])
					end
				end
			else
				
				setTextColor(button.text[i],{0,1,1,1})
			end
		end
	else
		loop = 0
	end
end
local t = 0
function select(n)
	local t = millisecs + 3000000
	local l = 0
	repeat
		if l ==0 then 
			playSound(button.s[7])
			l = 1
		end
		if t <= millisecs then loadLevel("levels/Level"..n..".level") end
		millisecs = millisecs+0.5
	until t < millisecs
end


function Millisecs()
	millisecs = millisecs + 1
	if millisecs >=60 then
		secs = secs + 1
		millisecs = 0
	end
end

local timer = secs +2
function close()
	if timer < secs then
		for i=1,5 do
			if closed.level[i] == Level then
				if isActive(closed.mesh[i]) then
					OKeffectFX[effect_count] = Effect:create(getPosition(closed.mesh[i]), 1,2, {-90,0,-90}, {5,5,5}, 10)
					deactivate(closed.mesh[i])
					button.close[i+1] = 0
				end
			end
		end
	end
end

showCursor()
-- scene update
function onSceneUpdate()
	Millisecs()
	close()
	pick()
	for i=1, #OKeffectFX do OKeffectFX[i]:update() end
end
