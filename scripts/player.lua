player_class = {}
function player_class:new(obj,bullet,damage,pos)
	local o = {}
	o.t		= secs+2
	o.mesh 	= getClone(obj)
	activate	(o.mesh)
	setPosition	(o.mesh,pos)
	o.damage 	= damage
	o.bullet	= bullet
	o.m 		= 1
	setmetatable(o,self)
	self.__index = self
	if obj == inv.image[1] then -- ship 1
		o.hbar	= getClone(bar)
		setParent	(o.hbar,o.mesh)
		setPosition(o.hbar,{0,-5,10})
		energy = energy - inv.price[1]
		setText(energyt,energy) 
		o.health = 5
		o.v = 1
	elseif obj == inv.image[2] then --ship 2
		o.hbar	= getClone(bar)
		setParent	(o.hbar,o.mesh)
		setPosition(o.hbar,{0,-5,10})
		energy = energy - inv.price[2]
		setText(energyt,energy)
		o.health = 10
		o.v = 2
	elseif obj == inv.image[3] then --bhole
		energy = energy - inv.price[3]
		setText(energyt,energy)
		o.v = 3
		o.tt = secs+ timeBhole
		o.health = 100
	end
	kp = kp+1
	return o
end
function player_class:update()
	if isActive(self.mesh) then
		self.m = self.m +0.05
		rotate(self.mesh, {0, 0.1, 0}, (math.cos(self.m))/4)
		if self.v == 1 then -- ship 1
			setScale(self.hbar,{0.3,self.health/2.5,0.4})
			for i=1,#nloship do
				if isCollisionBetween(self.mesh,nloship[i].mesh) then
					self.health = 0
				end
			end
			if self.t < secs then 
				playSound(exSound[12])
				bul[kbp]= bullet_class:new(self.bullet,self.damage,getPosition(self.mesh)) 
				self.t = secs+bulletSpawnSpeed
			end
		elseif self.v == 2 then -- ship 2
			setScale(self.hbar,{0.3,self.health/2.5,0.4})
			for i=1,#nloship do
				if isCollisionBetween(self.mesh,nloship[i].mesh) then
					self.health = 0
				end
			end
			if self.t <= secs then 
				energy = energy + addEnergy
				setText(energyt,"ENERGY = "..energy)
				self.t = secs + 15
			end
		else -- bhole
			for i=1,#nloship do
				if isCollisionBetween(self.mesh,nloship[i].mesh) then
					OKeffectFX[effect_count] = Effect:create(getPosition(nloship[i].mesh), 2,0, {0,0,-90}, {8,8,8}, 10)
					deactivate(nloship[i].mesh)
				end
			end
			if self.tt > secs then
				rotate(self.mesh, {0, 0, 1}, 2,"local")
			else
				OKeffectFX[effect_count] = Effect:create(getPosition(self.mesh), 2,0, {0,0,-90}, {8,8,8}, 10)
				deactivate(self.mesh)
			end
		end
		if self.health <= 0 then 
			playSound(exSound[math.random(1,10)])
			OKeffectFX[effect_count] = Effect:create(getPosition(self.mesh), 1,2, {0,0,-90}, {8,8,8}, 10)
			deactivate	(self.mesh)
			deactivate	(self.hbar)
		end
	else
		self.mesh 	= nil
	end
end
pl = {}

--*****************************************************************
bullet_class = {}
function bullet_class:new(obj,damage,pos,health)
	local o = {}
	o.mesh 	= getClone(obj)
	setPosition(o.mesh,pos)
	o.health 	= health or 1
	o.damage 	= damage
	o.t		= secs+ 10

	setmetatable(o,self)
	self.__index = self
	if obj == animesh then 
		kbp = kbp+1
	end 
	return o
end
function bullet_class:update()
	if isActive(self.mesh) then
			translate(self.mesh,{0,-1,0},-1,"local")
			for i=1,#nloship do
				if isCollisionBetween(self.mesh,nloship[i].mesh) then
					nloship[i].health = nloship[i].health - self.damage
					self.health = self.health - nloship[i].damage
				end
			end
			if self.health <= 0 then 
				playSound(exSound[11])
				OKeffectFX[effect_count] = Effect:create(getPosition(self.mesh), 1,2, {0,0,-90}, {2,2,2}, 10)
				deactivate	(self.mesh)
			end
			if self.t < secs then self.health = 0 end
	else
		self.mesh 	= nil
	end
end
bul = {}
