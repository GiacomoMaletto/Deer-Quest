local wolf = {
  type = "wolf",
  health=2,
  x=30, y=-30, z=2,
  state="wait", t=0, modifier=0,
  direction="se",
  v=50,
  scale=1.2,
  messages={}
}

wolf.img = {["walk"]={}, ["attack"]={}, ["rest"]={}, ["hurt"]={}, ["dead"]={}, ["wait"]={}}
wolf.img["walk"][1] = love.graphics.newImage("wolf 1.png")
wolf.img["walk"][2] = love.graphics.newImage("wolf 2.png")
wolf.img["walk"][3] = love.graphics.newImage("wolf 3.png")

wolf.img["attack"][1] = love.graphics.newImage("wolf 3.png")
wolf.img["attack"][2] = love.graphics.newImage("wolf 1.png")

wolf.img["rest"][1] = love.graphics.newImage("wolf 2.png")
wolf.img["wait"][1] = love.graphics.newImage("wolf 2.png")

wolf.img["hurt"][1] = love.graphics.newImage("wolf hurt.png")
wolf.img["dead"][1] = love.graphics.newImage("wolf dead.png")

wolf.active_img = 1

function wolf.mail(wolf, dt, game)
  for im, m in ipairs(wolf.messages) do
    if m[1] == "hit by " then
      if wolf.state ~= "hurt" and wolf.state ~= "dead"
      and m[2].type == "char" then
        game.entity.StateChange(wolf, "hurt")
        wolf.dir = game.entity.oppositeDirection(wolf, m[2])
        wolf.health = wolf.health - 1
      end
    end
  end
  wolf.messages = {}
end

function wolf.update(wolf, dt, game)

  if game.entity.Distance(wolf, game.char) > 5 
  and (wolf.state == "rest" or wolf.state == "walk") then
    wolf.direction = game.entity.oppositeDirection(wolf, game.char)
  end

  if game.entity.Distance(wolf, game.char) < 20 and wolf.state=="walk" then
    game.entity.StateChange(wolf, "attack")
  end

  if wolf.state=="attack" then

    for ie, e in ipairs(game.entity) do
      if e ~= wolf then
        if game.entity.Distance(e, wolf) < 10 then
          e.messages[#e.messages+1] = {"hit by ", wolf}
        end
      end
    end

    if wolf.t < 0.5 then 
      wolf.v = 0
      wolf.active_img = 1
    elseif wolf.t < 1 then 
      wolf.v = 100
      wolf.active_img = 2
    else game.entity.StateChange(wolf, "rest") end

  elseif wolf.state=="rest" then

    wolf.v = 0
    wolf.active_img = 1
    if wolf.t < 0.8 then 
    else game.entity.StateChange(wolf, "walk") end
  
  elseif wolf.state == "walk" then
    
    wolf.v = 45
    if game.entity.Distance(wolf, game.char) < 20 then
      game.entity.StateChange(wolf, "attack")
    end

    if wolf.t < 0.3 then
      wolf.active_img = 1
    elseif wolf.t < 0.6 then
      wolf.active_img = 2
    elseif wolf.t < 0.9 then
      wolf.active_img = 3
    else
      wolf.t = wolf.t - 0.9
    end

  elseif wolf.state == "hurt" then

    if wolf.health <= 0 then game.entity.StateChange(wolf, "dead") end

    wolf.active_img = 1
    if wolf.t < 0.1 then
      wolf.v = -90
    elseif wolf.t < 0.5 then
      wolf.v = 0
    else game.entity.StateChange(wolf, "walk") end

  elseif wolf.state == "dead" then

    wolf.z = 1
    wolf.active_img = 1
    wolf.v = 0
  elseif wolf.state == "wait" then
    wolf.v = 0
    wolf.active_img = 1
  end
end

return wolf