
function createAnimation(spritesheet, width, height, duration)
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