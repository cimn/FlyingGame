local Player = class("Player", function()
	return display.newSprite("#flying1.png")
end)

function Player:ctor()
	self:addAnimationCache()
	local body = cc.PhysicsBody:createBox(self:getContentSize(), cc.PHYSICSBODY_MATERIAL_DEFAULT, 
		cc.p(0, 0))

	self:setPhysicsBody(body)
	self:getPhysicsBody():setGravityEnable(false)
end

function Player:addAnimationCache()
	local animations = {"flying", "drop", "die"}
	local animationFrameNum = {4, 3, 4}

	for i = 1, #animations do
		--1
		local frames = display.newFrames(animations[i].."%d.png", 1, animationFrameNum[i])
		--2
		local animation = display.newAnimation(frames, 0.3 / 4)
		--3
		display.setAnimationCache(animations[i], animation)
	end
end

function Player:flying()
	transition.stopTarget(self)
	transition.playAnimationForever(self, display.getAnimationCache("flying"))
end

function Player:drop()
	transition.stopTarget(self)
	transition.playAnimationForever(self, display.getAnimationCache("drop"))
end

function Player:die()
	transition.stopTarget(self)
	transition.playAnimationForever(self, display.getAnimationCache("die"))	
end

return Player