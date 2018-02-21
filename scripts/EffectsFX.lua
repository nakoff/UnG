-- get objects
fxsobjectList = {} -- array
fxsobjectList[1] = getObject("fx2") -- Explogen
fxsobjectList[2] = getObject("fx1") --Particle Illusion

-----------------------------------------------------CLONES
Effect = {}
effect_count = 1  -- counter fxleLists

function Effect:create(pos, number, anim, rot, scale, speed)

    local fx = {}
	-----------------------------------------------------------------------GET OBJECTS
    fx.object = getClone(fxsobjectList[number])
	-----------------------------------------------------------------------ARGUMENTS
	setPosition(fx.object, pos)
	changeAnimation(fx.object, anim)
	setAnimationSpeed(fx.object, speed) 
    setRotation(fx.object, rot) 
    setScale(fx.object, scale)
	-----------------------------------------------------------------------NEEDED STUFF
    effect_count = effect_count+1
    
    setmetatable(fx,self)
    self.__index = self
    return fx

end


function Effect:update() -- behavior
	if isActive(self.object) then 
		
		if isAnimationOver(self.object) then 
		    deactivate(self.object) 
			self.object = nil
		end
		
	end	
end
OKeffectFX = {}
