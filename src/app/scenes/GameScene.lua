
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

function GameScene:ctor()

    local backgroundLayer = BackgroundLayer.new()
        :addTo(self)
end

function GameScene:onEnter()
    print("GameScene onEnter")
end

function GameScene:onExit()
end

return GameScene