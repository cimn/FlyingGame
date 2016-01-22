
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    display.newSprite("image/main.jpg")
    	:pos(display.cx, display.cy)
    	:addTo(self)
    	--[[
    	标题
    	]]
    local title = display.newSprite("image/title.png")
    	:pos(display.cx , display.cy * 2.8 / 2)
    	:scale(0.9)
    	:addTo(self)

    local move1 = cc.MoveBy:create(0.5, cc.p(0, 5))
    local move2 = cc.MoveBy:create(0.5, cc.p(0, -5))
    local SequneceAction = cc.Sequence:create(move1, move2)
    transition.execute(title, cc.RepeatForever:create(SequneceAction))
    	--[[
    	开始
    	]]
    cc.ui.UIPushButton.new({normal = "image/start1.png", pressed = "image/start2.png"})
    	:onButtonClicked(function()
    			print("start")
                app:enterScene("GameScene", nil, "SLIDEINT", 0.5)
    		end)
    	:pos(display.cx, display.cy / 1.8)
    	:addTo(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene