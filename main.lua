
function love.load()

   local init = require 'src.game.init'
   local ui = require 'src.game.ui'
   local start = require 'src.scenes.start'
   InitGame()

end



function love.update(dt)

end



function love.draw()

   love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth()/background:getWidth(), love.graphics.getHeight()/background:getHeight())

   startScene()

   drawUI()

end