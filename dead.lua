local dead = {}
dead.state = "first"
dead.t = 0
function dead.load(dead)

end

function dead.update(dead, dt, main, input)
  dead.t = dead.t + dt

  if dead.state == "rest" then
    if love.keyboard.isDown("z") then
      main:resetToSave()
      main.state = "game"
    end
  end
end

local title_img = love.graphics.newImage("dead.png")
title_img:setFilter("nearest", "nearest")

local titleCanvas = love.graphics.newCanvas()

function dead.draw(dead)
  if dead.state == "first" then
    love.graphics.setCanvas(titleCanvas)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(title_img, 0, 0, 0, 10, 10)

    love.graphics.setFont(bigFont)

    love.graphics.setColor(dark_red)
    love.graphics.print("PRESS Z TO RETRY", 146, 500)

    love.graphics.setColor(light_red)
    love.graphics.print("PRESS Z TO RETRY", 150, 500)


    love.graphics.setCanvas()
    dead.state = "rest"
  end

  if dead.state == "rest" then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(titleCanvas)
  end
end

return dead