
start = {}

function start.update()
    if love.keyboard.isScancodeDown('return') then
        selectedScene = scenes.game
    end
end

function start.draw()
    title = love.graphics.newText(titleFont, "Miguel The Patient")
    love.graphics.draw(title, screenWidth/2 - (title:getWidth())/2,screenHeight/2)
end
