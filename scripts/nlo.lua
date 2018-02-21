class_nlo = {}
function class_nlo:new(mesh, num)
	local o = {}
	o.mesh = getObject(scene[nscene],mesh)
	o.num   = num
	o.h 	   = 100 --health
	o.k 	   = 1
	o.text   = getObject("nloh"..num)
	o.n 	   = {{20,21,22},{20,21,22},{20,21,22}}--,
	o.t 	   =spawntime[o.num][o.k]
	setmetatable(o,self)
	self.__index = self
	return o
end

function class_nlo:update()
	if isActive(self.mesh) then
		rotate(self.mesh, {0, math.cos(millisecs/10), 0}, 0.02, "local")
		if self.t < secs and spawntime[self.num][self.k+1]~= nil then
			self.k = self.k + 1
			nloship[kn] = nloship_class:new(enemymesh[math.random(1,2)],1,getPosition(enemy[self.num]),10)
			self.t = spawntime[self.num][self.k]
		end
		for i=1,#bul do
			if isCollisionBetween(self.mesh,bul[i].mesh) then
				self.h = self.h - 1
				setText(self.text,self.h)
				bul[i].health = 0
			end
		end
		if self.h < 1 then
			OKeffectFX[effect_count] = Effect:create(getPosition(self.mesh), 2, 0, {0,0,-90}, {15,15,15}, 10) 
			OKeffectFX[effect_count] = Effect:create(getPosition(self.mesh), 1, 2, {0,0,-90}, {10,10,10}, 10)
			deactivate(self.mesh)
			deactivate(self.text)
			NLO = NLO - 1
		end
	end
end

nlo = {}
for i=1,NLO do nlo[i] = class_nlo:new("1nlo"..i,i) end

nloship_class = {}
function nloship_class:new(obj,damage,pos,health)
	local o = {}
	o.mesh 	= getClone(obj)
	setPosition(o.mesh,pos)
	o.health 	= health or 5
	o.damage 	= damage
	o.m	= 0
	setmetatable(o,self)
	self.__index = self
	kn = kn+1
	if obj == enemymesh[1] then	--enemy ship 1
		o.v = 1
	else					--enemy ship 2
		o.v = 2
		o.t = secs + 1
		o.health = 3
	end 
	return o
end
function nloship_class:update()
	if isActive(self.mesh) then
			translate(self.mesh,{0,0.1,0},-1,"local")
			self.m = self.m+0.04
			rotate(self.mesh, {0, 0.1, 0}, (math.cos(self.m))/4)
			if self.health <= 0 then 
				playSound(exSound[math.random(1,10)])
				Score = Score + 20
				setText(scoreT,"SCORE = "..Score)
				local pos = getPosition(self.mesh)
				OKeffectFX[effect_count] = Effect:create({pos[1]-3,pos[2],pos[3]}, 1,2, {0,5,-95}, {7/self.v,7/self.v,7/self.v}, 10) 
				deactivate	(self.mesh)
			end 
			if isCollisionBetween(self.mesh,earch.mesh) then
				Score = Score - 50
				setText(scoreT,"SCORE = "..Score)
				self.health = 0
				earch.health = earch.health - 10
				setText(earch.text,earch.health.."%")
			end
			if self.v ==2 then --enemy ship 2
				if self.t < secs then
					playSound(exSound[12])
					nlobull[knb] = nlobull_class:new(1,getPosition(self.mesh))
					self.t = secs + 3
				end
			end
	else
		self.mesh 	= nil
	end
end
nloship = {}

nlobull_class = {}
function nlobull_class:new(damage,pos)
	local o = {}
	o.mesh 	= getClone(getObject("nlobullet"))
	setPosition(o.mesh,pos)
	o.damage 	= damage
	o.health = 1

	setmetatable(o,self)
	self.__index = self
	knb = knb+1
	return o
end
function nlobull_class:update()
	if isActive(self.mesh) then
			translate(self.mesh,{0,0.8,0},-1,"local")
			rotate(self.mesh, {0, 0.1, 0}, 1)
			for i=1,#pl do
				if isCollisionBetween(self.mesh,pl[i].mesh) then
					pl[i].health = pl[i].health - self.damage
					self.health = 0
				end
			end
			if isCollisionBetween(self.mesh,earch.mesh) then
				Score = Score - 5
				setText(scoreT,"SCORE = "..Score)
				self.health = 0
				earch.health = earch.health - 1
				setText(earch.text,earch.health.."%")
			end
			if self.health <= 0 then 
				playSound(exSound[11])
				OKeffectFX[effect_count] = Effect:create(getPosition(self.mesh), 1,1, {0,0,-90}, {2,2,2}, 10)
				deactivate	(self.mesh)
			end 
	else
		self.mesh 	= nil
	end
end
nlobull = {}