local archer = {
  type = "archer",
  health=3,
  x=30, y=-30, z=2,
  state="wait", t=0, arrow=false,
  direction="se",
  v=50,
  scale=1.2,
  messages={}
}

archer.img = {["rest"]={}, ["walk"]={}, ["attack"]={}, ["hurt"]={}, ["dead"]={}, ["wait"]={}}
archer.img["rest"][1] = love.graphics.newImage("archer walk 2.png")

archer.img["walk"][1] = love.graphics.newImage("archer walk 1.png")
archer.img["walk"][2] = love.graphics.newImage("archer walk 2.png")
archer.img["walk"][3] = love.graphics.newImage("archer walk 3.png")
archer.img["walk"][4] = love.graphics.newImage("archer walk 2.png")

archer.img["attack"][1] = love.graphics.newImage("archer attack 1.png")
archer.img["attack"][2] = love.graphics.newImage("archer attack 2.png")
archer.img["attack"][3] = love.graphics.newImage("archer attack 3.png")
archer.img["attack"][4] = love.graphics.newImage("archer attack 4.png")

archer.img["hurt"][1] = love.graphics.newImage("archer hurt.png")

archer.img["dead"][1] = love.graphics.newImage("archer hurt.png")
archer.img["dead"][2] = love.graphics.newImage("archer dead.png")

archer.img["wait"][1] = love.graphics.newImage("archer walk 2.png")

archer.active_img = 1

function archer.mail(archer, dt, game)
  for im, m in ipairs(archer.messages) do
    if m[1] == "hit by " then
      if archer.state ~= "hurt" and archer.state ~= "dead"
      and m[2].type == "char" then
        game.entity.StateChange(archer, "hurt")
        archer.dir = game.entity.oppositeDirection(archer, m[2])
        archer.health = archer.health - 1
      end
    end
  end
  archer.messages = {}
end

function archer.update(archer, dt, game)
  if game.entity.Distance(archer, game.char) > 10 
  and (archer.state == "walk" or archer.state == "rest" or archer.state == "attack") then
    archer.direction = game.entity.oppositeDirection(archer, game.char)
  end

  if game.entity.Distance(archer, game.char) < 80 and archer.state=="walk" then
    game.entity.StateChange(archer, "attack")
  end

  if archer.state=="attack" then
    archer.v = 0
    if archer.t < 0.3 then
      archer.arrow = false
      archer.active_img = 1
    elseif archer.t < 1 then
      archer.active_img = 2
    elseif archer.t < 1.3 then
      if not archer.arrow then
        game.entity:newArrow(archer, game.char)
        archer.arrow = true
      end
      archer.active_img = 3
    elseif archer.t < 1.5 then
      archer.active_img = 4
    else
      game.entity.StateChange(archer, "rest")
    end

  elseif archer.state=="rest" then

    archer.v = 0
    archer.active_img = 1
    if archer.t < 2 then 
    else game.entity.StateChange(archer, "walk") end
  
  elseif archer.state == "walk" then
    
    archer.v = 50
    if archer.t < 0.2 then
      archer.active_img = 1
    elseif archer.t < 0.4 then
      archer.active_img = 2
    elseif archer.t < 0.6 then
      archer.active_img = 3
    elseif archer.t < 0.8 then
      archer.active_img = 4
    else
      archer.t = archer.t - 0.8
    end

  elseif archer.state == "hurt" then

    archer.active_img = 1
    if archer.t < 0.1 then
      archer.v = -90
    elseif archer.t < 0.5 then
      archer.v = 0
    else game.entity.StateChange(archer, "walk") end

    if archer.health <= 0 then game.entity.StateChange(archer, "dead") end

  elseif archer.state == "dead" then

    archer.z = 1
    archer.v = 0
    if archer.t < 0.5 then
      archer.active_img = 1
    else
      archer.active_img = 2
    end

  elseif archer.state == "wait" then
    archer.z = 1
    archer.v = 0
    archer.active_img = 1
  end
end

return archer