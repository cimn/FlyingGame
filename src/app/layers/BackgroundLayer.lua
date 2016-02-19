local Heart = require("app.objects.Heart")
local Airship = require("app.objects.Airship")
local Bird = require("app.objects.Bird")

BackgroundLayer = class("BackgroundLayer", function()
	return display.newLayer()
end)

function BackgroundLayer:ctor()

	self.distanceBg = {}
	self.nearbyBg = {}
	self.tiledMapBg = {}

	self:createBackgrounds()
	self:startGame()
	self:addBody("heart", Heart)
    self:addBody("airship", Airship)
    self:addBody("bird", Bird)

	local width = self.map:getContentSize().width
	local height1 = self.map:getContentSize().height * 9.5 / 10
	local height2 = self.map:getContentSize().height * 2 / 16

	local sky = display.newNode()
	local bodyTop = cc.PhysicsBody:createEdgeSegment(cc.p(0, height1), cc.p(width, height1))
	sky:setPhysicsBody(bodyTop)
	self:addChild(sky)

	local ground = display.newNode()
	local bodyBottom = cc.PhysicsBody:createEdgeSegment(cc.p(0, height2), cc.p(width, height2))
	ground:setPhysicsBody(bodyBottom)
	self:addChild(ground)

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

function BackgroundLayer:startGame()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
    self:scheduleUpdate()
end

function BackgroundLayer:addBody(objectGroupName,class)
	-- 1
	local objects = self.map:getObjectGroup(objectGroupName):getObjects()
	-- 2
	local dict = nil
	local i = 0
	local len = table.getn(objects)
	-- 3
	for i = 0, len - 1, 1 do
		dict = objects[i + 1]
		-- 4
		if dict == nil then
			break
		end
		-- 5 取出相应的属性值，即对象坐标。因为对象组中的对象在TMX 文件中是以键值对的形式存在的，所以我们可以通过它的 key 得到相应的 value
		local key = "x"
		local x = dict["x"]
		local key = "y"
		local y = dict["y"]
		-- 6
		local sprite = class.new(x, y)
		self.map:addChild(sprite)
	end
end

return BackgroundLayer