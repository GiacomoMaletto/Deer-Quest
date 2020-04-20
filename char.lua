local char = {
  type="char",
  maxHealth=10, maxStamina=10,
  health=10, stamina=10,
  healthRegen=0.5, staminaRegen=8,
  x=0, y=0, z=3,
  state="rest", t=0,
  direction="e",
  v=0,
  scale = 1,
  messages={}
}

char.img = {["rest"]={}, ["walk"]={}, ["attack"]={}, ["hurt"]={}, ["dead"]={}, ["roll"]={}}
char.img["rest"][1] = love.graphics.newImage("char walk 2.png")

char.img["walk"][1] = love.graphics.newImage("char walk 1.png")
char.img["walk"][2] = love.graphics.newImage("char walk 2.png")
char.img["walk"][3] = love.graphics.newImage("char walk 3.png")
char.img["walk"][4] = love.graphics.newImage("char walk 2.png")

char.img["attack"][1] = love.graphics.newImage("char attack 1.png")
char.img["attack"][2] = love.graphics.newImage("char attack 2.png")
char.img["attack"][3] = love.graphics.newImage("char attack 3.png")
char.img["attack"][4] = love.graphics.newImage("char attack 4.png")

char.img["hurt"][1] = love.graphics.newImage("char hurt.png")

char.img["dead"][1] = love.graphics.newImage("char hurt.png")
char.img["dead"][2] = love.graphics.newImage("char dead.png")

char.img["roll"][1] = love.graphics.newImage("char walk 2.png")
char.img["roll"][2] = love.graphics.newImage("char roll 1.png")
char.img["roll"][3] = love.graphics.newImage("char roll 2.png")
char.img["roll"][4] = love.graphics.newImage("char roll 3.png")

char.active_img = 1

function char.mail(char, dt, game)
  for im, m in ipairs(char.messages) do
    if m[1] == "hit by " then
      if char.state ~= "hurt" and char.state ~= "dead" and char.state ~= "roll" then
        game.entity.StateChange(char, "hurt")
        char.health = char.health - 1
        char.dir = game.entity.oppositeDirection(char, m[2])
      end
    end
  end
  char.messages = {}
end

function char.update(char, dt, game, input)
  --print(char.x, char.y)
  local dir = ""
  if love.keyboard.isDown("up") then
    dir = dir .. "n"
  elseif love.keyboard.isDown("down") then
    dir = dir .. "s"
  end
  if love.keyboard.isDown("left") then
    dir = dir .. "w"
  elseif love.keyboard.isDown("right") then
    dir = dir .. "e"
  end


  if char.state == "attack" then
    if dir ~= "" then char.direction = dir end
    if char.t < 0.15 then
      char.active_img = 1
      char.v = 0
    elseif char.t < 0.30 then
      char.active_img = 2
      char.v = 100
    elseif char.t < 0.45 then
      char.active_img = 3
      char.v = 50
    elseif char.t < 0.60 then
      char.active_img = 4
      char.v = 0
    else
      game.entity.StateChange(char, "rest")
    end

    if char.t > 0.15 then
      for ie, e in ipairs(game.entity) do
        if e ~= char then
          if game.entity.Distance(e, char) < 15 then
            e.messages[#e.messages+1] = {"hit by ", char}
          end
        end
      end
    end

  elseif char.state == "rest" then

    char.v = 0
    if dir ~= "" then game.entity.StateChange(char, "walk") end

  elseif char.state == "walk" then

    char.v = 50
    --if input.keyboard.shift>1 then char.v = 500 else char.v = 50 end
    if char.t < 0.2 then
      char.active_img = 1
    elseif char.t < 0.4 then
      char.active_img = 2
    elseif char.t < 0.6 then
      char.active_img = 3
    elseif char.t < 0.8 then
      char.active_img = 4
    else
      char.t = char.t - 0.8
    end
    if dir == "" then game.entity.StateChange(char, "rest")
    else char.direction = dir end
  
  elseif char.state == "hurt" then

    if char.health <= 0 then game.entity.StateChange(char, "dead") end

    char.active_img = 1
    if char.t < 0.1 then
      char.v = -90
    elseif char.t < 0.5 then
      char.v = 0
    else game.entity.StateChange(char, "walk") end

  elseif char.state == "dead" then
    char.z = 1
    char.v = 0
    if char.t < 0.5 then
      char.active_img = 1
    elseif char.t < 2 then
      char.active_img = 2
    else
      game.state = "dead"
    end 

  elseif char.state == "roll" then
    char.v = 100

    if char.t < 0.15 then
      char.active_img = 1
    elseif char.t < 0.30 then
      char.active_img = 2
    elseif char.t < 0.45 then
      char.active_img = 3
    elseif char.t < 0.60 then
      char.active_img = 4
    else
      game.entity.StateChange(char, "rest")
    end

    if dir == "" then
    else char.direction = dir end
  end

  if char.health < char.maxHealth and not game.inCombat then 
    char.health = math.min(char.maxHealth, char.health + char.healthRegen*dt)
  end

  if char.state == "walk" or char.state == "rest" or char.state == "hurt" then
    if char.stamina < char.maxStamina then 
      char.stamina = math.min(char.maxStamina, char.stamina + char.staminaRegen*dt)
    end
  end

  if char.state == "walk" or char.state == "rest" then
    if input.keyboard.z > 0 and char.stamina>=4 then
      game.entity.StateChange(char, "attack")
      char.stamina = char.stamina - 4
    end
  end

  if char.state == "walk" or char.state == "rest" or char.state == "hurt" then
    if input.keyboard.x > 0 and char.stamina >= 3 then
      game.entity.StateChange(char, "roll")
      char.stamina = char.stamina - 3
    end 
  end
end

return char