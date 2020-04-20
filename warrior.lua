local warrior = {
  type = "warrior",
  health=4,
  x=30, y=-30, z=2,
  state="wait", t=0,
  direction="se",
  v=50,
  scale=1.2,
  messages={}
}

warrior.img = {["rest"]={}, ["walk"]={}, ["attack"]={}, ["hurt"]={}, ["dead"]={}, ["wait"]={}}
warrior.img["rest"][1] = love.graphics.newImage("warrior walk 2.png")

warrior.img["walk"][1] = love.graphics.newImage("warrior walk 1.png")
warrior.img["walk"][2] = love.graphics.newImage("warrior walk 2.png")
warrior.img["walk"][3] = love.graphics.newImage("warrior walk 3.png")
warrior.img["walk"][4] = love.graphics.newImage("warrior walk 2.png")

warrior.img["attack"][1] = love.graphics.newImage("warrior attack 1.png")
warrior.img["attack"][2] = love.graphics.newImage("warrior attack 2.png")
warrior.img["attack"][3] = love.graphics.newImage("warrior attack 3.png")
warrior.img["attack"][4] = love.graphics.newImage("warrior attack 4.png")

warrior.img["hurt"][1] = love.graphics.newImage("warrior hurt.png")

warrior.img["dead"][1] = love.graphics.newImage("warrior hurt.png")
warrior.img["dead"][2] = love.graphics.newImage("warrior dead.png")

warrior.img["wait"][1] = love.graphics.newImage("warrior walk 2.png")

warrior.active_img = 1

function warrior.mail(warrior, dt, game)
  for im, m in ipairs(warrior.messages) do
    if m[1] == "hit by " then
      if warrior.state ~= "hurt" and warrior.state ~= "dead"
      and m[2].type == "char" then
        game.entity.StateChange(warrior, "hurt")
        warrior.dir = game.entity.oppositeDirection(warrior, m[2])
        warrior.health = warrior.health - 1
      end
    end
  end
  warrior.messages = {}
end

function warrior.update(warrior, dt, game)
  if game.entity.Distance(warrior, game.char) > 10 
  and (warrior.state == "walk" or warrior.state == "rest") then
    warrior.direction = game.entity.oppositeDirection(warrior, game.char)
  end

  if game.entity.Distance(warrior, game.char) < 20 and warrior.state=="walk" then
    game.entity.StateChange(warrior, "attack")
  end

  if warrior.state=="attack" then
    if warrior.t < 0.35 then
      warrior.active_img = 1
      warrior.v = 0
    elseif warrior.t < 0.50 then
      warrior.active_img = 2
      warrior.v = 100
    elseif warrior.t < 0.65 then
      warrior.active_img = 3
      warrior.v = 50
    elseif warrior.t < 0.80 then
      warrior.active_img = 4
      warrior.v = 0
    else
      game.entity.StateChange(warrior, "rest")
    end

    if warrior.t > 0.15 then
      for ie, e in ipairs(game.entity) do
        if e ~= warrior then
          if game.entity.Distance(e, warrior) < 12 then
            e.messages[#e.messages+1] = {"hit by ", warrior}
          end
        end
      end
    end

  elseif warrior.state=="rest" then

    warrior.v = 0
    warrior.active_img = 1
    if warrior.t < 0.8 then 
    else game.entity.StateChange(warrior, "walk") end
  
  elseif warrior.state == "walk" then
    
    warrior.v = 50
    if warrior.t < 0.2 then
      warrior.active_img = 1
    elseif warrior.t < 0.4 then
      warrior.active_img = 2
    elseif warrior.t < 0.6 then
      warrior.active_img = 3
    elseif warrior.t < 0.8 then
      warrior.active_img = 4
    else
      warrior.t = warrior.t - 0.8
    end

  elseif warrior.state == "hurt" then

    warrior.active_img = 1
    if warrior.t < 0.1 then
      warrior.v = -90
    elseif warrior.t < 0.5 then
      warrior.v = 0
    else game.entity.StateChange(warrior, "walk") end

    if warrior.health <= 0 then game.entity.StateChange(warrior, "dead") end

  elseif warrior.state == "dead" then

    warrior.z = 1
    warrior.v = 0
    if warrior.t < 0.5 then
      warrior.active_img = 1
    else
      warrior.active_img = 2
    end

  elseif warrior.state == "wait" then
    warrior.v = 0
    warrior.active_img = 1
  end
end

return warrior