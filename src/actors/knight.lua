local spritesheets = {}
spritesheets.idle = love.graphics.newImage("res/SL_Knight/Idle.png")
spritesheets.idleLeft = love.graphics.newImage("res/SL_Knight/IdleLeft.png")
spritesheets.run = love.graphics.newImage("res/SL_Knight/Run.png")
spritesheets.runLeft = love.graphics.newImage("res/SL_Knight/RunLeft.png")
spritesheets.hurt = love.graphics.newImage("res/SL_Knight/Hurt.png")
spritesheets.hurtLeft = love.graphics.newImage("res/SL_Knight/HurtLeft.png")
spritesheets.roll = love.graphics.newImage("res/SL_Knight/Roll.png")
spritesheets.rollLeft = love.graphics.newImage("res/SL_Knight/RollLeft.png")
spritesheets.jump = love.graphics.newImage("res/SL_Knight/Jump.png")
spritesheets.jumpLeft = love.graphics.newImage("res/SL_Knight/JumpLeft.png")
spritesheets.death = love.graphics.newImage("res/SL_Knight/Death.png")
spritesheets.deathLeft = love.graphics.newImage("res/SL_Knight/DeathLeft.png")
spritesheets.attack = love.graphics.newImage("res/SL_Knight/Attack.png")
spritesheets.attackLeft = love.graphics.newImage("res/SL_Knight/AttackLeft.png")

knight = {}

knight.size = {96, 144}
knight.pos = {screenWidth / 2, screenHeight - knight.size[2] - 95}
knight.isLookingRight = true
knight.isRolling = false
knight.isInvencible = false
knight.life = 100
knight.damage = 5
knight.speed = 100
knight.maxSpeed = 600
knight.slowFactor = 45
knight.jumpFactor = -200
knight.reach = 30

knight.correction = {}
knight.correction.centering = 0
knight.correction.width = 0

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


function knight.createAnimationsKnight()
    table.insert(knight.animations, createAnimation(spritesheets.idle,32,48))
    table.insert(knight.animations, createAnimation(spritesheets.idleLeft,32,48))
    table.insert(knight.animations, createAnimation(spritesheets.run, 40, 48))
    table.insert(knight.animations, createAnimation(spritesheets.runLeft, 40, 48))
    table.insert(knight.animations, createAnimation(spritesheets.jump, 40, 56))
    table.insert(knight.animations, createAnimation(spritesheets.jumpLeft, 40, 56))
    table.insert(knight.animations, createAnimation(spritesheets.roll, 32, 32))
    table.insert(knight.animations, createAnimation(spritesheets.rollLeft, 32, 32))
    table.insert(knight.animations, createAnimation(spritesheets.attack, 78, 48))
    table.insert(knight.animations, createAnimation(spritesheets.attackLeft, 104, 48))

end

function knight.setAction(action)
    animation = knight.getAnimation()
    animation.currentTime = 0 --needs to be called before changing animation
    knight.currentAction = action
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
            return knight.animations[5]
        else
            return knight.animations[6]
        end
    elseif knight.currentAction == knight.actions.roll then

        if knight.isLookingRight then
            return knight.animations[7]
        else
            return knight.animations[8]
        end
    elseif knight.currentAction == knight.actions.attack then

        if knight.isLookingRight then
            return knight.animations[9]
        else
            return knight.animations[10]
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
end


--input

function knight.input()
    if(not knight.isRolling) then
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
end



function love.keyreleased(key)
    if key == 'k' then
        knight.roll()
    elseif key == 'l' then
        knight.attack()
    end
end



--actions

function knight.moveRight()
    if not (objects.knight.body:getLinearVelocity() > knight.maxSpeed) then
        objects.knight.body:applyLinearImpulse(knight.speed,0)
        knight.isLookingRight = true
    end
    if knight.currentAction ~= knight.actions.run then
        knight.setAction(knight.actions.run)
    end
end



function knight.moveLeft()
    if not (objects.knight.body:getLinearVelocity() < -knight.maxSpeed) then
        objects.knight.body:applyLinearImpulse(-knight.speed,0)
        knight.isLookingRight = false
    end
    if knight.currentAction ~= knight.actions.run then
        knight.setAction(knight.actions.run)
    end
end



function knight.jump()
    if IsTouching(objects.knight.body, objects.ground.body) then
        objects.knight.body:applyLinearImpulse(0,knight.jumpFactor)
        knight.setAction(knight.actions.jump)
        knight.getAnimation().duration = 2
    end
end



function knight.attack()
    local speedX, speedY = objects.knight.body:getLinearVelocity()
    if not knight.isRolling and (speedX < 60 and speedX > -60)  then
        knight.currentAction = knight.actions.attack
        if knight.isLookingRight then
            knight.correction.width = 150
            knight.correction.centering = 80
            knight.getAnimation().duration = 0.4
        else
            knight.correction.width = 160
            knight.correction.centering = 140
            knight.getAnimation().duration = 0.5
        end

    end
end



function knight.roll()
    if IsTouching(objects.knight.body, objects.ground.body) then

        knight.isRolling = true
        knight.isInvencible = true

        objects.knight.body:setLinearVelocity(0,0)

        if knight.isLookingRight then
            objects.knight.body:applyLinearImpulse(knight.speed * 75,0)
        else
            objects.knight.body:applyLinearImpulse(-knight.speed * 75,0)
        end

        knight.setAction(knight.actions.roll)
        knight.getAnimation().duration = .5

    end
end



function knight.recieveDam()
end



function knight.die()
end



function knight.isStoping()
    local speedX, speedY = objects.knight.body:getLinearVelocity()
    return ((speedX < 40 and speedX > -40) and (speedY < 3 and speedY > -3 and IsTouching(objects.knight.body, objects.ground.body))) and (knight.currentAction ~= knight.actions.idle) and not knight.isRolling and (knight.currentAction ~= knight.actions.attack)
end



function knight.endRoll()
    knight.setAction(knight.actions.idle)
    objects.knight.body:setLinearVelocity(0,0)
    knight.isRolling = false
    knight.isInvencible = false
end



-- knight game functions

function knight.load()
    require 'src.game.animate'
    require 'src.game.physics'
    knight.createAnimationsKnight()
    knight.makeKnightBody()
end



function knight.update(dt)

    knight.input()

    local animation = knight.getAnimation()

    if knight.isStoping() then
        knight.setAction(knight.actions.idle)
    else
        animation.currentTime = animation.currentTime + dt
        if(animation.currentTime > animation.duration) then
            if knight.isRolling then
                knight.endRoll()
            elseif knight.currentAction == knight.actions.attack then
                knight.setAction(knight.actions.idle)
            else
                animation.currentTime = animation.currentTime - animation.duration
            end
        end
    end

end



function knight.draw()

    local animation = knight.getAnimation()
    animation.spriteSheets:setFilter("nearest", "nearest")
    if knight.currentAction == knight.actions.attack then
        drawAnimation(objects.knight.body, knight.size, animation, knight.correction.centering, knight.correction.width)
    else
        drawAnimation(objects.knight.body, knight.size, animation, 0, 0)
    end

end