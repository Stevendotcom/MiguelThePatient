function InitGame()
    titleFont = love.graphics.newFont("/res/Playwrite/PlaywriteDEGrund-VariableFont_wght.ttf", 60)

    background = love.graphics.newImage("/res/Glacial-mountains/Background.png")
    background:setFilter("nearest", "nearest")

    cave = love.graphics.newImage("/res/CrystalWorld/cave.png")
    cave:setFilter("nearest", "nearest")
    love.graphics.setFont(titleFont)

    love.physics.setMeter(32)
    world = love.physics.newWorld(0, 9.81*32, true)

    objects = {}
end