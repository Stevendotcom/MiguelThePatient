local spritesheets = {}
spritesheets.idle = love.graphics.newImage("res/SL_Knight/Idle.png")
spritesheets.run = love.graphics.newImage("res/SL_Knight/Run.png")

knight = {}

knight.size = {96, 144}
knight.pos = {screenWidth / 2, screenHeight - knight.size[2] - 95}
knight.life = 100
knight.damage = 5
knight.speed = 100
knight.maxSpeed = 600
knight.slowFactor = 45
knight.animations = {}

function knight.createAnimation(spritesheet, width, height, duration)
    local animation = {}
    animation.spriteSheets = spritesheet
    animation.quads = {}
    animation.frameSize = {width,height}

    for y = 0, spritesheet:getHeight() - height, height  do
        for x = 0, spritesheet:getWidth() - width , width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, spritesheet:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0
    return animation
end


function knight.createAnimationsKnight()
    table.insert(knight.animations, knight.createAnimation(spritesheets.idle,32,48, 1))
    table.insert(knight.animations,  knight.createAnimation(spritesheets.run, 150, 200))

end

function knight.makeKnightBody()
    objects.knight = {}
    objects.knight.body =  love.physics.newBody(world, knight.pos[1] + knight.size[1]/2, knight.pos[2]+ knight.size[2]/2, "dynamic")
    objects.knight.shape = love.physics.newRectangleShape(knight.size[1], knight.size[2])
    objects.knight.fixture = love.physics.newFixture(objects.knight.body, objects.knight.shape, 1)
    objects.ground.fixture:setFriction(1)
end

function knight.load()
    knight.createAnimationsKnight()
    knight.makeKnightBody()
end

function knight.input()

end



function knight.update(dt)
    knight.animations[1].currentTime = knight.animations[1].currentTime + dt
    if(knight.animations[1].currentTime > knight.animations[1].duration) then
        knight.animations[1].currentTime = knight.animations[1].currentTime - knight.animations[1].duration
    end
end

function knight.draw()
    knight.animations[1].spriteSheets:setFilter("nearest", "nearest")
    local frame = math.floor(knight.animations[1].currentTime / knight.animations[1].duration * #knight.animations[1].quads) + 1
    love.graphics.draw(
        knight.animations[1].spriteSheets,
        knight.animations[1].quads[frame],
        objects.knight.body:getX() - knight.size[1]/2,
        objects.knight.body:getY() - knight.size[2]/2,
        0,
        knight.size[1]/knight.animations[1].frameSize[1],
        knight.size[2]/knight.animations[1].frameSize[2]
        )
end
