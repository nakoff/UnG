
-----------------------------------------------------------------------------------
-- Maratis
-- Jules script test
-----------------------------------------------------------------------------------
dofile("global.lua")

Level = 0

	local k = 1
	local propert = {}
	function loade()
		for i in io.lines("save.an") do  
			if i ~= nil then
				propert[k] = tonumber(i)
			end
			k = k+1
		end
		Level = propert[1]
		Score= propert[2]
	end
loade()
function onInit()
	Snext	= getScene("next")
	ScoreT	= getObject(Snext,"ScoreT")
	setText	(ScoreT,Score)
	NextT	= getObject(Snext,"nextT")
	setText	(NextT," ")

	sound1 	= getObject("s2")
	sound2	= getObject("s1")
	
	star 		= {mesh={}, score={}}
	for i=1,3	do 
		star.mesh[i] = getObject(Snext,"star"..i) 
		setRotation(star.mesh[i],{180,-90,0})
		star.score[i] = 600*i
	end
	millisecs = 0
	secs = 0
	timer = secs + 2
	ms = 0
	effect_count = 1
end	
dofile("EffectsFX.lua")
onInit()


local t = 0
local tt = 0
local starScore = 0
function Star()
	if Score > 0 then
		for i=1,3 do
			if starScore == star.score[i] then 
				local pos = getPosition(star.mesh[i])
				playSound(sound2)
				OKeffectFX[effect_count] = Effect:create({pos[1],pos[2],pos[3]+2}, 1,2, {-90,0,-90}, {3,3,3}, 10) 
				setRotation(star.mesh[i],{90,90,90}) 
			end
		end
		if tt < ms then
			playSound(sound1)
			tt = ms+5
		end
		Score = Score - 3
		starScore = starScore + 3
		setText	(ScoreT,math.floor(Score))
		t = secs + 3
	else
		setText	(ScoreT,0)
		if t < secs then setText(NextT,"Key SPACE to NEXT Level") end
		if onKeyUp("SPACE") then
			loadLevel("levels/levels.level")
		end
	end
end

function Millisecs()
	millisecs = millisecs + 1
	ms = ms+1
	if millisecs >=60 then
		secs = secs + 1
		millisecs = 0
	end
end

function onSceneUpdate()
	Millisecs()
	for i=1, #OKeffectFX do OKeffectFX[i]:update() end
	if timer < secs then Star() end

end