BackgroundLayer = class("BackgroundLayer", function()
	return display.newLayer()
end)

function BackgroundLayer:ctor()

	self.distanceBg = {}
	self.nearbyBg = {}
	self.tiledMapBg = {}

	self:createBackgrounds()

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
	self:scheduleUpdate()
end

function BackgroundLayer:createBackgrounds()	
	-- 创建UIBG
	local bg = display.newSprite("image/bj1.jpg")
		:pos(display.cx, display.cy)
		:addTo(self, -4)

	--创建远景BG
	local bg1 = display.newSprite("image/b2.png")
		:align(display.BOTTOM_LEFT, display.left, display.bottom + 10)
		:addTo(self, -3)
	local bg2 = display.newSprite("image/b2.png")
		:align(display.BOTTOM_LEFT, display.left + bg1:getContentSize().width, display.bottom + 10)
		:addTo(self, -3)

		table.insert(self.distanceBg, bg1)
		table.insert(self.distanceBg, bg2)
	--创建近景BG
	local bg3 = display.newSprite("image/b1.png")
		:align(display.BOTTOM_LEFT, display.left, display.bottom)
		:addTo(self, -2)
	local bg4 = display.newSprite("image/b1.png")
		:align(display.BOTTOM_LEFT, display.left + bg3:getContentSize().width, display.bottom)
		:addTo(self, -2)

		table.insert(self.nearbyBg, bg3)
		table.insert(self.nearbyBg, bg4)

	self.map = cc.TMXTiledMap:create("image/map.tmx")
		:align(display.BOTTOM_LEFT, display.left, display.bottom)
		:addTo(self, -1)
	
end

function BackgroundLayer:scrollBackgrounds(dt)

	if self.distanceBg[2]:getPositionX() <= 0 then
		self.distanceBg[1]:setPositionX(0)
	end

	local x1 = self.distanceBg[1]:getPositionX() - 40*dt
	local x2 = x1 + self.distanceBg[1]:getContentSize().width

	self.distanceBg[1]:setPositionX(x1)
	self.distanceBg[2]:setPositionX(x2)

	if self.nearbyBg[2]:getPositionX() <= 0 then
        self.nearbyBg[1]:setPositionX(0)
    end

    local x3 = self.nearbyBg[1]:getPositionX() - 80*dt
    local x4 = x3 + self.nearbyBg[1]:getContentSize().width 

    self.nearbyBg[1]:setPositionX(x3)
    self.nearbyBg[2]:setPositionX(x4)

    if self.map:getPositionX() <= display.width - self.map:getContentSize().width then
    	self.unscheduleUpdate()
    end

    local x5 = self.map:getPositionX() - 120 * dt
    self.map:setPositionX(x5)
end

return BackgroundLayer