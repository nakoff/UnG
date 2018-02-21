
menu = getScene("menu")
cam = getObject("cam")

local timer 	= 0
local t 	= 0
local t2 	= 0

-- scene update
function onSceneUpdate()
	timer  = timer + 1

	if t < timer then
		if t2 <math.random(50,70) then
			translate(cam,{0,0,math.sin(timer)})
			t2 = t2 +1
		else
			t2 = 0
			t = timer +math.random(5,15)
		end
	end
	if onKeyUp("ESCAPE") then changeScene(menu) end
end
