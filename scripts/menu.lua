Camera 	= getObject("cam")
credits	= getScene("credits")
sound 	= getObject("s1")

button 	= {mesh={},text={}}
for i=1,3 do 
	button.mesh[i] 	= getObject("menu"..i) 
	button.text[i]	= getObject("menut"..i)
end

mx,my 	= 0,0
V1,V2  	= 0,0
millisecs	=0
	
local object,point
local l = 0
function pick()
	mx 	= getAxis("MOUSE_X")
	my 	= getAxis("MOUSE_Y")
	V1 = getUnProjectedPoint(Camera, vec3(mx, my, 0))
	V2 = getUnProjectedPoint(Camera, vec3(mx, my, 1))
	point, object = rayHit(V1,V2)
	if point then
		--print("Cool!")
		
		for i=1,3 do
			rotate(button.mesh[i], {0, math.cos(millisecs/2), 0}, 1)
			if object == button.mesh[i] then
				if l == 0 then 
					playSound(sound)
					l = 1
				end
				setTextColor(button.text[i],{0.5,1,0.3,1})
				if onKeyUp("MOUSE_BUTTON1") then
					select(i)
				end
			else
				setTextColor(button.text[i],{0.8,0.7,0.6,1})
			end
		end
	else
		l = 0
	end
end

function select(n)
	if n==1 then loadLevel("levels/levels.level") end
	if n==2 then changeScene(credits) end
	if n==3 then quit() end
end

showCursor()
-- scene update
function onSceneUpdate()
	pick()
	millisecs = millisecs+1

end
