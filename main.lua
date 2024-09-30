screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

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


function love.load()

    love.physics.setMeter(8)

   require 'src.game.init'
   require 'src.game.ui'
   require 'src.game.sceneManager'
   require 'src.scenes.start'
   require 'src.actors.knight'

   InitGame()
   makeGround()
   makeWalls()
   makeRoof()

   knight.load()

end


function love.keyreleased( key )

 end

function love.update(dt)
    if love.keyboard.isDown("right") then
        if not (objects.knight.body:getLinearVelocity() > knight.maxSpeed) then
            objects.knight.body:applyLinearImpulse(knight.speed,0)
        end
    elseif love.keyboard.isDown("left") then
        if not (objects.knight.body:getLinearVelocity() < -knight.maxSpeed) then
            objects.knight.body:applyLinearImpulse(-knight.speed,0)
        end
    else
        if objects.knight.body:getLinearVelocity() > 0 then
            objects.knight.body:applyLinearImpulse(-knight.slowFactor,0)
        elseif objects.knight.body:getLinearVelocity() < 0 then
            objects.knight.body:applyLinearImpulse(knight.slowFactor,0)
        end
    end

    world:update(dt)
    knight.update(dt)
end



function love.draw()

   love.graphics.draw(background, 0, 0, 0, screenWidth/background:getWidth(),screenHeight/background:getHeight())
   if selectedScene == start then
   startScene()
   end
   knight.draw()
   drawUI()

   drawDebug()
end

