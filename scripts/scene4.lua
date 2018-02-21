
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
	kolcell = 25
	
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

	spawntime = {}
	spawntime[1] = {56,119,130,142,146,176,192,199,213,229,230,239,243,247,252,261,263,270,275,280,285,288,290,301,302,308,315,341,355,371,384,397,399,406,408,413,425,431,435,443,443,447,458,460,462,463,470,477,477,478,485,486,490,492,497,499}
	spawntime[2] = {24,48,100,119,130,142,146,176,192,199,201,213,229,230,239,243,252,261,263,270,275,280,285,288,290,301,302,308,315,341,355,371,384,397,399,406,408,413,425,431,435,443,443,447,458,460,462,463,470,477,477,478,485,486,490,492,497,499}
	spawntime[3] = {40,99,119,130,142,146,176,192,199,213,229,230,239,243,247,252,261,263,270,275,280,285,288,290,301,302,308,315,341,355,371,384,397,399,406,408,413,425,431,435,443,444,447,458,461,462,463,470,477,477,478,484,486,490,492,497,498}
	spawntime[4] = {8,57,130,155,168,193,199,230,244,249,251,264,264,281,289,289,302,315,356,381,401,414,444,462,463,471,478,491}
	spawntime[5] = {12,97,130,155,168,193,199,230,244,249,251,264,264,281,289,289,302,315,356,381,401,414,444,463,463,471,478,492}

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
	inv	= {mesh={},t={},image={player[1],player[2],player[3]},price={50,100,150,300,300,300},text={"Звездолет. Атакует противника","Станция. Добывает солнечную энергию","Черная дыра. Поглащает","Усовершенствовать Звездолет","Усовершенствовать Станцию","Усовершенствовать Черную дыру"}}
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

	Level = 4
	NLO 	= 5
	
	addEnergy 		= 25
	bulletSpawnSpeed = 4
	timeBhole 		= 20
	energy		= 350
	
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