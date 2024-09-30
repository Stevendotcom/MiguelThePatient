
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function startScene()
    title = love.graphics.newText(titleFont, "Miguel The Patient")
    love.graphics.draw(title, screenWidth/2 - (title:getWidth())/2,screenHeight/2)
end

