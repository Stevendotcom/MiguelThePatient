local spritesheets = {}
spritesheets.idle = love.graphics.newImage("res/demon/01_demon_idle/Idle.png")
spritesheets.walk = love.graphics.newImage("res/demon/02_demon_walk/Walk.png")
spritesheets.cleaveRaise = love.graphics.newImage("res/demon/03_demon_cleave/CleaveRaise.png")
spritesheets.cleaveLower = love.graphics.newImage("res/demon/03_demon_cleave/CleaveLower.png")
spritesheets.takeHit = love.graphics.newImage("res/demon/04_demon_take_hit/TakeHit.png")
spritesheets.death = love.graphics.newImage("res/demon/05_demon_death/Death.png")

demon = {}
demon.pos = { 50, screenHeight /2}
demon.size = { 200, 200}
demon.speed = 30
demon.range = 130
demon.life = 1000
demon.slowness = 1
demon.attackTime = 0
demon.damage = 15
demon.isLookingRight = true

demon.actions = {}
demon.actions.idle = 1
demon.actions.walk = 2
demon.actions.cleaveRaise = 3
demon.actions.cleaveLower = 4
demon.actions.takeHit = 5
demon.actions.death = 6

demon.currentAction = demon.actions.walk

demon.animations = {}


--animatons and actions

function demon.createAnimations()
    table.insert(demon.animations, createAnimation(spritesheets.idle,32,48))
    table.insert(demon.animations, createAnimation(spritesheets.walk, 288, 160, 2))
    table.insert(demon.animations, createAnimation(spritesheets.cleaveRaise, 288, 160, demon.slowness))
    table.insert(demon.animations, createAnimation(spritesheets.cleaveLower, 288, 160))
    table.insert(demon.animations, createAnimation(spritesheets.takeHit, 40, 48))
    table.insert(demon.animations, createAnimation(spritesheets.death, 40, 56))
end



function demon.setAction(action)
    local animation = demon.getAnimation()
    animation.currentTime = 0 --needs to be called before changing animation
    demon.currentAction = action
end



function demon.getAnimation()
    if demon.currentAction == demon.actions.idle then

        return demon.animations[1]

    elseif demon.currentAction == demon.actions.walk then

        return demon.animations[2]

    elseif demon.currentAction == demon.actions.cleaveRaise then

        return demon.animations[3]

    elseif demon.currentAction == demon.actions.cleaveLower then

        return demon.animations[4]

    elseif demon.currentAction == demon.actions.takeHit then

        return demon.animations[5]

    elseif demon.currentAction == demon.actions.death then

        return demon.animations[6]
    else
        print("No Action with that name")
        os.exit()
    end
end


--physics

function demon.makeBody()
    objects.demon = {}
    objects.demon.body =  love.physics.newBody(world, demon.pos[1] + demon.size[1]/2, demon.pos[2]+ demon.size[2]/2, "dynamic")
    objects.demon.shape = love.physics.newRectangleShape(demon.size[1], demon.size[2])
    objects.demon.fixture = love.physics.newFixture(objects.demon.body, objects.demon.shape, 1)
    objects.demon.fixture:setCategory(2)
    objects.demon.fixture:setMask(2)
end


-- demon interactions

function demon.recieveDam(damage)
    demon.life = demon.life - damage
    if demon.live < 0 then
        demon.die()
    end
end

function demon.die()
    demon.setAction(demon.actions.death)
end

function demon.enemyIsHittable(enemy)
    return math.abs(enemy:getX() - objects.demon.body:getX()) < demon.range
end

function demon.attack(dt)
    demon.attackTime = demon.attackTime + dt

    if demon.attackTime < demon.slowness and demon.currentAction ~= demon.actions.cleaveRaise then
        demon.setAction(demon.actions.cleaveRaise)
    elseif demon.attackTime >= demon.slowness and demon.currentAction == demon.actions.cleaveRaise then
        demon.setAction(demon.actions.cleaveLower)
        handleEvents(events.demonAttacked, demon.damage)
    elseif demon.attackTime > demon.slowness + 1 and demon.currentAction == demon.actions.cleaveLower then
        demon.attackTime = 0
        demon.setAction(demon.actions.walk)
    end

end



function demon.move(dt, enemy)
    x,y = objects.demon.body:getPosition()
    if enemy:getX() < x then
        demon.isLookingRight = true
        objects.demon.body:setPosition(x - (demon.speed * dt), y)
    else
        demon.isLookingRight = false
        objects.demon.body:setPosition(x + (demon.speed * dt), y)
    end

end



-- demon main funcs

function demon.load()
    require 'src.game.animate'
    require 'src.game.physics'

    demon.createAnimations()
    demon.makeBody()
end



function demon.update(dt, enemy)

    local animation = demon.getAnimation()

    animation.currentTime = animation.currentTime + dt

    if(animation.currentTime > animation.duration) then
        animation.currentTime = animation.currentTime - animation.duration
    end

    if demon.enemyIsHittable(enemy) then
        demon.attack(dt)
    elseif demon.currentAction ~= demon.actions.walk then
        demon.attackTime = 0
        demon.setAction(demon.actions.walk)
    end

    if demon.currentAction == demon.actions.walk then
        demon.move(dt, enemy)
    end
end



function demon.draw()

    local animation = demon.getAnimation()
    animation.spriteSheets:setFilter("nearest", "nearest")

    if demon.isLookingRight then
        drawAnimation(objects.demon.body, demon.size, animation, 200, 200, 400, 200, 1)
    else
        drawAnimation(objects.demon.body, demon.size, animation, -400, 200, 400, 200, -1)

    end
end
