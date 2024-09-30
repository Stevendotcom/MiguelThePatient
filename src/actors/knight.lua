local spritesheets = {}
spritesheets.idle = love.graphics.newImage("res/SL_Knight/Idle.png")
spritesheets.idleLeft = love.graphics.newImage("res/SL_Knight/IdleLeft.png")
spritesheets.run = love.graphics.newImage("res/SL_Knight/Run.png")
spritesheets.runLeft = love.graphics.newImage("res/SL_Knight/RunLeft.png")
spritesheets.hurt = love.graphics.newImage("res/SL_Knight/Hurt.png")
spritesheets.hurtLeft = love.graphics.newImage("res/SL_Knight/HurtLeft.png")
spritesheets.roll = love.graphics.newImage("res/SL_Knight/Roll.png")
spritesheets.rollLeft = love.graphics.newImage("res/SL_Knight/RollLeft.png")
spritesheets.death = love.graphics.newImage("res/SL_Knight/Death.png")
spritesheets.deathLeft = love.graphics.newImage("res/SL_Knight/DeathLeft.png")

knight = {}

knight.size = {96, 144}
knight.pos = {screenWidth / 2, screenHeight - knight.size[2] - 95}
knight.isLookingRight = true
knight.life = 100
knight.damage = 5
knight.speed = 100
knight.maxSpeed = 600
knight.slowFactor = 45
knight.jumpFactor = 200
knight.animations = {}

knight.actions = {}

knight.actions.idle = 1
knight.actions.run = 2
knight.actions.hurt = 3
knight.actions.roll = 4
knight.actions.jump = 5
knight.actions.death = 6

knight.currentAction = {}

--animations
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
    table.insert(knight.animations, knight.createAnimation(spritesheets.idle,32,48))
    table.insert(knight.animations, knight.createAnimation(spritesheets.idleLeft,32,48))
    table.insert(knight.animations,  knight.createAnimation(spritesheets.run, 40, 48))
    table.insert(knight.animations,  knight.createAnimation(spritesheets.runLeft, 40, 48))

end

function knight.getAnimation()
    if knight.currentAction == knight.actions.idle then
        if knight.isLookingRight then
            return knight.animations[knight.actions.idle]
        else
            return knight.animations[2]
        end
    elseif knight.currentAction == knight.actions.run then
        if knight.isLookingRight then
            return knight.animations[3]
        else
            return knight.animations[4]
        end
    elseif knight.currentAction == knight.actions.jump then
        if knight.isLookingRight then
            return knight.animations[knight.actions.jump]
        else
            return knight.animations[knight.actions.run + 1]
        end
    else
        return knight.animations[knight.actions.idle]
    end
end


--physics
function knight.makeKnightBody()
    objects.knight = {}
    objects.knight.body =  love.physics.newBody(world, knight.pos[1] + knight.size[1]/2, knight.pos[2]+ knight.size[2]/2, "dynamic")
    objects.knight.shape = love.physics.newRectangleShape(knight.size[1], knight.size[2])
    objects.knight.fixture = love.physics.newFixture(objects.knight.body, objects.knight.shape, 1)
    objects.ground.fixture:setFriction(1)
end
function knight.IsTouching(other)
    -- iterate contacts
    local contacts = objects.knight.body:getContacts()
    for i, contact in ipairs(contacts) do
        -- look for a specific body
        local f1, f2 = contact:getFixtures()
        if f1:getBody() == other or f2:getBody() == other then
            return true
        end
    end
    return false
end
--input
function knight.input()
    if love.keyboard.isScancodeDown('d') then
        knight.moveRight()
    elseif love.keyboard.isScancodeDown('a') then
        knight.moveLeft()
    elseif love.keyboard.isScancodeDown('w') then
        knight.jump()
    else
        if objects.knight.body:getLinearVelocity() > 0 then
            objects.knight.body:applyLinearImpulse(-knight.slowFactor,0)
        elseif objects.knight.body:getLinearVelocity() < 0 then
            objects.knight.body:applyLinearImpulse(knight.slowFactor,0)
        end
    end
end

--actions
function knight.moveRight()
    if not (objects.knight.body:getLinearVelocity() > knight.maxSpeed) then
        objects.knight.body:applyLinearImpulse(knight.speed,0)
        knight.isLookingRight = true
        knight.currentAction = knight.actions.run
    end
end
function knight.moveLeft()
    if not (objects.knight.body:getLinearVelocity() < -knight.maxSpeed) then
        objects.knight.body:applyLinearImpulse(-knight.speed,0)
        knight.isLookingRight = false
        knight.currentAction = knight.actions.run
    end
end
function knight.jump()
    if knight.IsTouching(objects.ground.body) then
        objects.knight.body:applyLinearImpulse(0,knight.jumpFactor)
        print("jump")
        knight.currentAction = knight.actions.jump
    end
end
function knight.attack()
end
function knight.recieveDam()
end
function knight.die()
end





-- knight game functions

function knight.load()
    knight.createAnimationsKnight()
    knight.makeKnightBody()
end



function knight.update(dt)
    knight.input()
    local speed = objects.knight.body:getLinearVelocity()
    if (speed < 40 and speed > -40) then
        knight.currentAction = knight.actions.idle
    end

    local animation = knight.getAnimation()
    animation.currentTime = animation.currentTime + dt
    if(animation.currentTime > animation.duration) then
        animation.currentTime = animation.currentTime - animation.duration
    end

end

function knight.draw()
    local animation = knight.getAnimation()
    animation.spriteSheets:setFilter("nearest", "nearest")
    local frame = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(
        animation.spriteSheets,
        animation.quads[frame],
        objects.knight.body:getX() - knight.size[1]/2,
        objects.knight.body:getY() - knight.size[2]/2,
        0,
        knight.size[1]/animation.frameSize[1],
        knight.size[2]/animation.frameSize[2]
        )
end