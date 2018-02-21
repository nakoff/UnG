local transl = 0
function movecam()	 
	transl = 0
	if 	getAxis("MOUSE_X") < 0.05 then
		if campos[2] < cam.minpos then
			transl = transl - 1.8
		end
	elseif getAxis("MOUSE_X") > 0.95 then
		if campos[2] > cam.maxpos then
			transl = transl + 1.8
		end	
	end
	translate(Camera,{transl,0,0},"local")
end

function pause()
	if onKeyUp("ESCAPE") then
		if State_Game == 1 then
			showCursor()
			activate(textMenu)
			State_Game = 2
		else
			hideCursor()
			deactivate(textMenu)
			State_Game = 1
		end
	end
	
end

do -- GAME WIN
	local t = 0
	function Wine()
		if t == 0 then
			free()
			t = secs+5
			setTextColor(WinT,{0,1,0,1})
			setText(WinT,"GAME WIN!!!!")
		else
			if t < secs then
				save()
				free()				
				setText(WinT," ")
				loadLevel("levels/score.level")
				t = 0
			end
		end
	end
end
do -- GAME OVER
	local t = 0
	function Over()
		if t == 0 then
			free()
			t = secs+5
			setTextColor(WinT,{1,0,0,1})
			setText(WinT,"GAME OVER")
		else
			if t < secs then
				free()				
				setText(WinT," ")
				loadLevel("levels/levels.level")
				t = 0
			end
		end
	end
end


do -- SAVE and LOADE
	function save()
		io.output(io.open("save.an","w+"))
		io.write((Level+1).."\n")
		io.write(Score.."\n")
		io.close()
	end
	local k = 1
	local propert = {}
	function load()
		for i in io.lines("save.an") do  
			if i ~= nil then
				propert[k] = tonumber(i)
			end
			k = k+1
		end
		--look!
		--for i=1,#propert do print(propert[i]) end
	end
end

--load()
	
do -- SELECT 
	local cursor3d, mz,point, object,price
	function proj()
		mz = 0.995 --speed of cursor
		cursor3d = getUnProjectedPoint(Camera, vec3(mx, my, mz))

		point, object = rayHit(getPosition(cursor), getPosition(collcursor))
		setPosition(collcursor,{0.98,cursor3d[2],cursor3d[3]})
		hideCursor()
		
		for i=1,kolcell do 
			if isCollisionTest(cell.mesh[i]) then
				--close CELL
			else
				cell.state[i] = 0 -- open CELL
				setScale(cell.mesh[i],{5.19,4.24,4.47})
			end
		end
		if point then
			if onKeyUp("MOUSE_BUTTON1") then
				for i=1,kolcell do --CELL
					if object==cell.mesh[i] then
						if crs ~= nil and cell.state[i] == 0 and energy >=inv.price[price] then
							pl[kp] = player_class:new(crs,animesh,1,getPosition(cell.mesh[i]))
							cell.state[i] = 1 --close Cell
							setScale(cell.mesh[i],{0.1,0.1,0.1})
						end
					end
				end
			end
			setText(helpT," ") -- hide text
			for ii=1,6 do --ICONS Ship
				if object==inv.mesh[ii] then
					if helpT ~= nil then setText(helpT,inv.text[ii]) end
					if onKeyUp("MOUSE_BUTTON1") then
						if ii <=3 then
							if crs then deactivate(oo) end
							oo = getClone(inv.image[ii])
							activate(oo)
							setParent(oo,collcursor)
							setPosition(oo,{-50,0,55})
							crs = inv.image[ii]
						elseif ii==4 and energy >=inv.price[ii] then
							if bulletSpawnSpeed <=2 then 
								deactivate(inv.mesh[ii]) 
								deactivate(inv.t[ii])	
							end
							bulletSpawnSpeed = bulletSpawnSpeed- 1
							energy = energy - inv.price[ii]
							setText(energyt,energy)
						elseif ii==5 and energy >=inv.price[ii] then
							deactivate(inv.mesh[ii])
							deactivate(inv.t[ii])
							addEnergy = addEnergy + 20
							energy = energy - inv.price[ii]
							setText(energyt,energy)
						elseif ii==6 and energy >=inv.price[ii] then
							timeBhole = timeBhole + 20 
							energy = energy - inv.price[ii]
							setText(energyt,energy)
						end
						price = ii
					end
				end
			end
		end
		if oo~= nil and onKeyUp("MOUSE_BUTTON3") then
			deactivate(oo)
			oo = nil
			crs= nil
		end
	end
end

function free() --Deactivate Objects
	if isActive(oo) then deactivate(oo) end
	for e=1,#pl			do pl[e].health 	= 0 			end
	for i=1,#bul		do bul[i].health	= 0				end
	for i=1,#nlo		do nlo[i].health	= 0 			end
	for i=1,#nloship	do nloship[i].health=0				end
	for i=1,#nlobull	do nlobull[i].health =0				end
	for i=1,#OKeffectFX do deactivate(OKeffectFX[i].object) end	
end


--[[
function spawn()
	if onKeyUp("Q") then
		nloship[kn] = nloship_class:new(enemymesh[math.random(1,2)],1,getPosition(enemy[1]),10)
		io.output(io.open("spawn1.an","a+"))
		io.write(secs..",")
		io.close()
	end
	
	if onKeyUp("W") then
		nloship[kn] = nloship_class:new(enemymesh[math.random(1,2)],1,getPosition(enemy[2]),10)
		io.output(io.open("spawn2.an","a+"))
		io.write(secs..",")
		io.close()
	end
	
	if onKeyUp("E") then
		nloship[kn] = nloship_class:new(enemymesh[math.random(1,2)],1,getPosition(enemy[3]),10)
		io.output(io.open("spawn3.an","a+"))
		io.write(secs..",")
		io.close()
	end
	if onKeyUp("A") then
		nloship[kn] = nloship_class:new(enemymesh[math.random(1,2)],1,getPosition(enemy[4]),10)
		io.output(io.open("spawn4.an","a+"))
		io.write(secs..",")
		io.close()
	end
	if onKeyUp("D") then
		nloship[kn] = nloship_class:new(enemymesh[math.random(1,2)],1,getPosition(enemy[5]),10)
		io.output(io.open("spawn5.an","a+"))
		io.write(secs..",")
		io.close()
	end
end

do
local k = {1,1,1,1,1,1,1,1,1}

function loadSpawn(n)
	for i=1, n do
		for j in io.lines("spawn"..i..".an") do  
			spawntime[i][k[i] ] = tonumber(j)
			k[i] = k[i]+1
		end
	end
end
end
]]