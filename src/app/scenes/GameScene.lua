local Player = require("app.objects.Player")

local GameScene = class("GameScene", function()
    return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()

    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0,-200))
   
    -- self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)  --元素可视化

    self.backgroundLayer = BackgroundLayer.new()
        :addTo(self)

    self.player = Player.new()
    self.player:setPosition(-20, display.height * 2 / 3)
    self:addChild(self.player)
    self:playFlyToScene()

    self:addCollision()
    self.player:createProgress() 
end

function GameScene:playFlyToScene()

    local function startDrop()
        self.player:getPhysicsBody():setGravityEnable(true)
        self.player:drop()
        self.backgroundLayer:startGame()

        self.backgroundLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:onTouch(event.name, event.x, event.y)
        end)
        self.backgroundLayer:setTouchEnabled(true)
    end

    local animation = display.getAnimationCache("flying")
    transition.playAnimationForever(self.player, animation)

    local action = transition.sequence({
        cc.MoveTo:create(2, cc.p(display.cx, display.height * 2 / 3)), 
        cc.CallFunc:create(startDrop)
        })
    self.player:runAction(action)
end

function GameScene:addCollision()
    local function contactLogic( node )
        if node:getTag() == HEART_TAG then
            local emitter = cc.ParticleSystemQuad:create("particles/stars.plist")
            emitter:setBlendAdditive(false)
            emitter:setPosition(node:getPosition())
            self.backgroundLayer.map:addChild(emitter)
            if self.player.blood < 100 then

                self.player.blood = self.player.blood + 2
                self.player:setProPercentage(self.player.blood)
            end
            audio.playSound("sound/heart.mp3")
            --todo
            node:removeFromParent()
        elseif node:getTag() == GROUND_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 20
            self.player:setProPercentage(self.player.blood)
            audio.playSound("sound/ground.mp3")
            --todo
        elseif node:getTag() == AIRSHIP_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 10
            self.player:setProPercentage(self.player.blood)
            audio.playSound("sound/hit.mp3")
            --todo
        elseif node:getTag() == BIRD_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 5
            self.player:setProPercentage(self.player.blood)
            audio.playSound("sound/hit.mp3")
            --todo
        end
    end

    local function onContactBegin( contact )
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()

        contactLogic(a)
        contactLogic(b)

        return true
    end
    local function onContactSeperate(contact)   
        -- 在这里检测当玩家的血量减少是否为0，游戏是否结束。
        if self.player.blood <= 0 then 
            self.backgroundLayer:unscheduleUpdate()
            self.player:die()

            local over = display.newSprite("image/over.png")
                :pos(display.cx, display.cy)
                :addTo(self)

            cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()
        end
    end

    -- 注册监听
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(contactListener, 1)
end

function GameScene:onTouch(event, x, y)
    if event == "began" then
        self.player:flying()
        self.player:getPhysicsBody():setVelocity(cc.p(0, 120))

        return true
    -- elseif event == "moved" then
        --todo
    elseif event == "ended" then
        self.player:drop()
    -- elseif event == "cancelled" then
        --todo
    end
end

function GameScene:onEnter()
    print("GameScene onEnter")
end

function GameScene:onExit()
end

return GameScene