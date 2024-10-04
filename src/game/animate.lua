
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

function drawAnimation(body, size, animation, correctionCenteringWidth, correctionCenteringHeight, correctionWidth, correctionHeight , orientation)
    local frame = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(
        animation.spriteSheets,
        animation.quads[frame],
        body:getX() - (size[1]/2 + correctionCenteringWidth),
        body:getY() - (size[2]/2 + correctionCenteringHeight),
        0,
       (( size[1] + correctionWidth)/animation.frameSize[1]) * orientation,
       (size[2] + correctionHeight)/animation.frameSize[2]
        )
end