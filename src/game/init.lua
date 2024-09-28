function InitGame()
    titleFont = love.graphics.newFont("/res/Playwrite/PlaywriteDEGrund-VariableFont_wght.ttf", 60)
    background = love.graphics.newImage("/res/Glacial-mountains/Background.png")
    background:setFilter("nearest", "nearest")
    cave = love.graphics.newImage("/res/CrystalWorld/cave.png")
    cave:setFilter("nearest", "nearest")
    love.graphics.setFont(titleFont)
end