local win = {}
win.state = "first"
win.t = 0
function win.load(win)

end

function win.update(win, dt, main, input)
  win.t = win.t + dt
end

local title_img = love.graphics.newImage("win.png")
title_img:setFilter("nearest", "nearest")

local titleCanvas = love.graphics.newCanvas()

function win.draw(win)
  if win.state == "first" then
    love.graphics.setCanvas(titleCanvas)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(title_img, 0, 0, 0, 10, 10)

    love.graphics.setFont(bigFont)

    love.graphics.setColor(dark_red)
    love.graphics.printf("THANK YOU FOR PLAYING!", -2, 500, sw-2, "center")

    love.graphics.setColor(light_red)
    love.graphics.printf("THANK YOU FOR PLAYING!", 0, 500, sw, "center")

    love.graphics.setCanvas()
    win.state = "rest"
  end

  if win.state == "rest" then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(titleCanvas)
  end
end

return win