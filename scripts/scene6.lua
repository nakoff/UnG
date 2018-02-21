
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
	kolcell = 30
	
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
	
	enemy	= {getObject("1enemy1"),getObject("1enemy2"),getObject("1enemy3"),getObject("1enemy4"),getObject("1enemy5")}
	deactivate	(enemy[1]); deactivate	(enemy[2]); deactivate	(enemy[3])
	enemymesh	= {getObject("enemys1"),getObject("enemys2")}

	--spawn enemy ship
	spawntime = {}
	spawntime[1] = {36,79,102,128,133,143,159,163,181,182,189,190,191,192,205,207,221,240,240,259,264,268,279,281,290,291,291,302,315,315,330,330,337,338}
	spawntime[2] = {79,102,128,133,143,159,163,181,182,189,190,191,192,205,207,221,240,240,259,264,268,279,280,290,291,291,302,315,315,330,330,337,338}
	spawntime[3] = {79,102,128,133,143,159,163,181,182,189,190,192,192,205,207,221,240,240,259,264,268,279,281,290,291,291,302,315,315,330,330,337,338}
	spawntime[4] = {45,79,102,128,133,143,148,160,162,166,181,181,189,190,192,193,193,195,205,205,207,222,224,225,226,230,231,231,232,240,241,259,263,279,291,291,292,302,315,315,329,330,338,338}
	spawntime[5] = {21,72,79,102,128,133,143,148,160,162,166,181,182,189,190,192,193,193,195,205,205,207,222,224,225,226,230,231,231,232,240,241,259,263,280,291,291,292,302,315,315,330,330,338,338}

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
	inv	= {mesh={},t={},image={player[1],player[2],player[3]},price={50,100,150,200,200,200},text={"Звездолет. Атакует противника","Станция. Добывает солнечную энергию","Черная дыра. Поглащает","Усовершенствовать Звездолет","Усовершенствовать Станцию","Усовершенствовать Черную дыру"}}
	for i=1,6 do
		inv.mesh[i] = getObject("1inv"..i)
		inv.t[i]	= getObject("invt"..i)
	end
	
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

	Level = 5
	NLO 	= 5
	
	addEnergy 		= 25
	bulletSpawnSpeed= 4
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