
-----------------------------------------------------------------------------------
-- Maratis
-- Jules script test
-----------------------------------------------------------------------------------
dofile("global.lua")
nscene	= 1
function onInit()
	gr 	= getWindowScale()
	GW 	= gr[1]
	GH	= gr[2]
	kolcell = 15
	
	--get sound
	exSound = {}
	for i=1,13 do
		exSound[i] = getObject("s"..i)
	end
	
	Camera    	= getObject("1Camera0")
	cam		= {minpos = 120, maxpos = -80} 
	campos 	= getPosition(Camera)

	player	= {getObject("1players"),getObject("1energyship"),getObject("1bhole")}
	deactivate	(player[1]); deactivate	(player[2]); deactivate	(player[3])
	
	enemy	= {getObject("1enemy1"),getObject("1enemy2"),getObject("1enemy3")}
	deactivate	(enemy[1]); deactivate	(enemy[2]); deactivate	(enemy[3])
	enemymesh	= {getObject("enemys1"),getObject("enemys2")}

	--spawn enemy ship
	spawntime = {}
	spawntime[1] = {11,73,102,113,126,132,143,158,183,189,194,204,220,222,230,236,242,247,251,265,269,277,282,290,293,308,308,320,338,350,361,367,380,396,403,411,426,426,435,444,459,463,472,472,474,474,479,481}
	spawntime[2] = {36,91,96,113,120,126,132,143,158,170,171,183,191,196,204,220,222,230,242,247,251,267,269,277,290,293,312,320,338,350,361,367,380,396,418,426,435,444,451,469,472,472,474,474,479,481}
	spawntime[3] = {44,100,113,126,132,143,158,183,189,194,204,206,213,220,224,230,234,242,247,251,265,269,277,290,293,310,320,328,339,350,355,359,361,367,380,386,396,403,411,426,429,435,436,444,451,457,458,469,472,472,474,474,479,481}
	
	animesh	= getObject("1animesh") -- player rocket
	bar 	= getObject("1bar") --healthbar

	earch	= {mesh,health}
	earch	.mesh	= getObject("1Earch")
	earch	.text		= getObject("1helthp")
	earch.health	= 100

	--get Cell
	cell	= {mesh={},state={}}
	for i=1,kolcell do
		cell.mesh[i] = getObject("1cell"..i)
		cell.state[i] = 0
	end

	-- ICONS Ship
	inv	= {mesh={},t={},image={player[1],player[2],player[3]},price={50,100,150,200,200,200},text={"The spaceship. Attacking your opponent","The Space Station. Produces solar energy","The black hole. Absorbs enemies and enemy missiles.","improve the Spaceship","improve the Space Station","improve the black hole"}}
	for i=1,6 do
		inv.mesh[i] = getObject("1inv"..i)
		inv.t[i]	= getObject("invt"..i)
	end
	deactivate(inv.mesh[3]) --bhole
	deactivate(inv.mesh[6]) --price bhole
	
	cursor	= getObject("1cursor")
	collcursor 	= getObject("1collcursor")

	--get Text
	WinT	 	= getObject("1WinT")
	setText 	(WinT," ")
	scoreT 	= getObject("1Text0")
	energyt	= getObject("1energy")
	setText	(energyt,energy)
	setText	(scoreT,"SCORE = "..Score)
	helpT		= getObject("helpt")
	setParent	(helpT,collcursor)	
	textMenu 	= getObject("tmenu")
	deactivate	(textMenu)
	
	--*********** GLOBAL VIRABLE*************
	State_Game = 1

	Level = 1
	NLO = 3
	
	addEnergy 		= 25
	bulletSpawnSpeed = 4
	timeBhole 		= 20
	energy		= 300
	
	crs = nil
	oo = nil

	mx 	= 0
	my	= 0
	V1	= 0
	V2	= 0

	--COUNTS
	effect_count = 1
	kp 	= 1
	kbp	= 1
	kn	= 1
	knb	= 1
end
onInit()

--************* INCLUDES ************
dofile("functions.lua")
dofile("player.lua")
dofile("EffectsFX.lua")
dofile("nlo.lua")
dofile("millisecs.lua")

hideCursor()
function onSceneUpdate()
	pause     ()
	movecam()
	mx 	= getAxis("MOUSE_X")
	my 	= getAxis("MOUSE_Y")
	campos = getPosition(Camera)
	
	if State_Game == 1 then -- If Game Run
		if earch.health 	<=0 then Over() 	end
		if NLO == 0 then Wine() end
		Millisecs()

		rotate(earch.mesh, {0, 0, 1}, 0.02, "local")
		proj()
		
		for i=1,#pl 	do 	pl[i]	:update() 	end
		for i=1,#bul	do 	bul[i]	:update() 	end
		for i=1, #OKeffectFX do OKeffectFX[i]:update() end
		for i=1,#nlo	do 	nlo[i]	:update() 	end
		for i=1,#nloship	do 	nloship[i]	:update() 	end
		for i=1,#nlobull	do 	nlobull[i]	:update() 	end
	else	-- If Pause
		if onKeyUp("R") then 
			free() 	--deactivate objects
			onInit()	--reload
		elseif onKeyUp("M") then 
			loadLevel("levels/menu.level")
		end
	end
end