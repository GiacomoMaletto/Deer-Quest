local menu = {}
menu.state = "first"
menu.t = 0
function menu.load(menu)

end

function menu.update(menu, dt, main, input)
  menu.t = menu.t + dt

  if menu.state == "rest" then
    if love.keyboard.isDown("z") then
      menu.state = "toGame"
      menu.t = 0
    end
  elseif menu.state == "toGame" then
    if menu.t < 2 then
    else
      main.state = "game"
      main:resetGame()
    end
  end
end

local title_img = love.graphics.newImage("title.png")
title_img:setFilter("nearest", "nearest")

local titleCanvas = love.graphics.newCanvas()

function menu.draw(menu)
  if menu.state == "first" then
    love.graphics.setCanvas(titleCanvas)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(title_img, 0, 0, 0, 10, 10)

    love.graphics.setFont(smallFont)

    love.graphics.setColor(light_yellow)
    love.graphics.printf("ESC TO QUIT", 0-2, 300, sw-2, "center")
    love.graphics.printf("ARROW KEYS TO MOVE", 0-2, 340, sw-2, "center")
    love.graphics.printf("X TO ROLL", 0-2, 380, sw-2, "center")
    love.graphics.printf("Z TO ATTACK,", 0-2, 420, sw-2, "center")
    love.graphics.printf("TO ADVANCE DIALOGUE AND TO", 0-2, 460, sw-2, "center")

    love.graphics.setColor(dark_yellow)
    love.graphics.printf("ESC TO QUIT", 0, 300, sw, "center")
    love.graphics.printf("ARROW KEYS TO MOVE", 0, 340, sw, "center")
    love.graphics.printf("X TO ROLL", 0, 380, sw, "center")
    love.graphics.printf("Z TO ATTACK,", 0, 420, sw, "center")
    love.graphics.printf("TO ADVANCE DIALOGUE AND TO", 0, 460, sw, "center")
    
    love.graphics.setColor(light_yellow)
    love.graphics.printf("BEGIN YOUR QUEST", 0-2, 500, sw, "center")

    love.graphics.setColor(light_yellow)
    love.graphics.printf("BEGIN YOUR QUEST", 0, 500, sw, "center")

    love.graphics.setCanvas()
    menu.state = "rest"
  end

  if menu.state == "rest" then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(titleCanvas)
  end
end

return menu