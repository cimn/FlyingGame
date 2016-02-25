local Heart = class("Heart", function ()
	return display.newSprite("image/heart.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Heart:ctor(x, y)

	local heartBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2,
			MATERIAL_DEFAULT)
	self:setPhysicsBody(heartBody)
	self:getPhysicsBody():setGravityEnable(false)

	self:setPosition(x, y)

	heartBody:setCategoryBitmask(0x0001)
	heartBody:setContactTestBitmask(0x0100)
	heartBody:setCollisionBitmask(0x0001)

	self:setTag(HEART_TAG)
end

return Heart