screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()
events = {}
events.knightAttacked = 1
events.demonAttacked = 2

function drawDebug()
   for _, body in pairs(world:getBodies()) do
      for _, fixture in pairs(body:getFixtures()) do
          local shape = fixture:getShape()

          if shape:typeOf("CircleShape") then
              local cx, cy = body:getWorldPoints(shape:getPoint())
              love.graphics.circle("fill", cx, cy, shape:getRadius())
          elseif shape:typeOf("PolygonShape") then
              love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
          else
              love.graphics.line(body:getWorldPoints(shape:getPoints()))
          end
      end
  end
end



function makeGround()
    objects.ground = {}
    objects.ground.body =  love.physics.newBody(world, screenWidth/2, screenHeight - 45)
    objects.ground.shape = love.physics.newRectangleShape(screenWidth, 90)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
    objects.ground.fixture:setFriction(1)

end

function makeWalls()

    objects.wallLeft = {}
    objects.wallLeft.body =  love.physics.newBody(world, 25, screenHeight/2 - 45)
    objects.wallLeft.shape = love.physics.newRectangleShape(50, screenHeight - 88)
    objects.wallLeft.fixture = love.physics.newFixture(objects.wallLeft.body, objects.wallLeft.shape)

    objects.wallRight = {}
    objects.wallRight.body =  love.physics.newBody(world, screenWidth - 25, screenHeight/2 - 45)
    objects.wallRight.shape = love.physics.newRectangleShape(50, screenHeight - 88)
    objects.wallRight.fixture = love.physics.newFixture(objects.wallRight.body, objects.wallRight.shape)

end

function makeRoof()
    objects.roof = {}
    objects.roof.body =  love.physics.newBody(world, screenWidth/2, 10)
    objects.roof.shape = love.physics.newRectangleShape(screenWidth, 20)
    objects.roof.fixture = love.physics.newFixture(objects.roof.body, objects.roof.shape)
end



function handleEvents(event, damage)
    local distance = 0

    if objects.demon.body:getX() < objects.knight.body:getX() then
        distance = objects.knight.body:getX() - objects.demon.body:getX()
    else
        distance = objects.demon.body:getX() - objects.knight.body:getX()
    end

    if event == events.knightAttacked and distance < knight.reach and distance > 0 then
        demon.receiveDamage(damage)
    end

    if event == events.demonAttacked and distance < demon.range and distance > 0 then
        knight.recieveDam(damage)
    end

end

function love.load()

    love.physics.setMeter(8)

    require 'src.game.init'
    require 'src.game.ui'
    require 'src.game.sceneManager'
    require 'src.scenes.start'
    require 'src.scenes.game'
    require 'src.actors.knight'
    require 'src.actors.demon'

    InitGame()
    makeGround()
    makeWalls()
    makeRoof()

   knight.load()
   demon.load()

end



function love.update(dt)

    world:update(dt)
    if selectedScene == scenes.start then
        start.update()
    elseif selectedScene == scenes.game then
        game.update(dt)
    end
end



function love.draw()

   love.graphics.draw(background, 0, 0, 0, screenWidth/background:getWidth(),screenHeight/background:getHeight())

   if selectedScene == scenes.start then
       start.draw()
   elseif selectedScene == scenes.game then
       game.draw()
   end

   drawUI()
   
end

