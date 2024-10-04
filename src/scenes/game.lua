game ={}

function game.update(dt)
    knight.update(dt)
    demon.update(dt, objects.knight.body)
end

function game.draw()
    knight.draw()
    demon.draw()
end