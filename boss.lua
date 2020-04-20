local boss = {
  type = "boss",
  health=8,
  x=370, y=8, z=2,
  state="wait", t=0, arrow=false,
  direction="e",
  v=50,
  scale=1.2,
  messages={}
}

boss.img = {["rest"]={}, ["walk"]={}, ["attack"]={}, ["hurt"]={}, ["dead"]={}, ["wait"]={}, ["bow"]={}, ["roll"]={}}
boss.img["rest"][1] = love.graphics.newImage("boss walk 2.png")

boss.img["walk"][1] = love.graphics.newImage("boss walk 1.png")
boss.img["walk"][2] = love.graphics.newImage("boss walk 2.png")
boss.img["walk"][3] = love.graphics.newImage("boss walk 3.png")
boss.img["walk"][4] = love.graphics.newImage("boss walk 2.png")

boss.img["attack"][1] = love.graphics.newImage("boss attack 1.png")
boss.img["attack"][2] = love.graphics.newImage("boss attack 2.png")
boss.img["attack"][3] = love.graphics.newImage("boss attack 3.png")
boss.img["attack"][4] = love.graphics.newImage("boss attack 4.png")

boss.img["hurt"][1] = love.graphics.newImage("boss hurt.png")

boss.img["dead"][1] = love.graphics.newImage("boss hurt.png")
boss.img["dead"][2] = love.graphics.newImage("boss dead.png")

boss.img["wait"][1] = love.graphics.newImage("boss walk 2.png")

boss.img["bow"][1] = love.graphics.newImage("boss bow attack 1.png")
boss.img["bow"][2] = love.graphics.newImage("boss bow attack 2.png")
boss.img["bow"][3] = love.graphics.newImage("boss bow attack 3.png")
boss.img["bow"][4] = love.graphics.newImage("boss bow attack 4.png")

boss.img["roll"][1] = love.graphics.newImage("boss walk 2.png")
boss.img["roll"][2] = love.graphics.newImage("boss roll 1.png")
boss.img["roll"][3] = love.graphics.newImage("boss roll 2.png")
boss.img["roll"][4] = love.graphics.newImage("boss roll 3.png")

boss.active_img = 1

function boss.mail(boss, dt, game)
  for im, m in ipairs(boss.messages) do
    if m[1] == "hit by " then
      if boss.state ~= "hurt" and boss.state ~= "dead"
      and m[2].type == "char" then
        game.entity.StateChange(boss, "hurt")
        boss.dir = game.entity.oppositeDirection(boss, m[2])
        boss.health = boss.health - 1
      end
    end
  end
  boss.messages = {}
end

function boss.update(boss, dt, game)
  if game.entity.Distance(boss, game.char) > 10 
  and (boss.state == "walk" or boss.state == "rest" or boss.state == "bow") then
    boss.direction = game.entity.oppositeDirection(boss, game.char)
  end

  if game.entity.Distance(boss, game.char) < 20 and boss.state=="walk" then
    if love.math.random() < 0.5 then
      if boss.y < -50 then
        boss.direction = "s"
      elseif boss.y > 50 then
        boss.direction = "n"
      end
      game.entity.StateChange(boss, "roll")
    else
      game.entity.StateChange(boss, "attack")
    end
  elseif 40 < game.entity.Distance(boss, game.char)
  and game.entity.Distance(boss, game.char) < 80 and boss.state=="walk" then
    game.entity.StateChange(boss, "bow")
  end

  if boss.state=="attack" then
    if boss.t < 0.2 then
      boss.active_img = 1
      boss.v = 0
    elseif boss.t < 0.4 then
      boss.active_img = 2
      boss.v = 100
    elseif boss.t < 0.55 then
      boss.active_img = 3
      boss.v = 50
    elseif boss.t < 0.70 then
      boss.active_img = 4
      boss.v = 0
    else
      game.entity.StateChange(boss, "rest")
    end

    if boss.t > 0.1 then
      for ie, e in ipairs(game.entity) do
        if e ~= boss then
          if game.entity.Distance(e, boss) < 12 then
            e.messages[#e.messages+1] = {"hit by ", boss}
          end
        end
      end
    end

  elseif boss.state == "roll" then

    boss.v = 100

    if boss.t < 0.15 then
      boss.active_img = 1
    elseif boss.t < 0.30 then
      boss.active_img = 2
    elseif boss.t < 0.45 then
      boss.active_img = 3
    elseif boss.t < 0.60 then
      boss.active_img = 4
    else
      boss.direction = game.entity.oppositeDirection(boss, game.char)
      game.entity.StateChange(boss, "bow")
    end

  elseif boss.state=="bow" then
    boss.v = 0
    if boss.t < 0.1 then
      boss.arrow = false
      boss.active_img = 1

    elseif boss.t < 0.2 then
      boss.active_img = 2

    elseif boss.t < 0.3 then
      boss.active_img = 3
      if not boss.arrow then
        game.entity:newArrow(boss, game.char)
        boss.arrow = true
      end

    elseif boss.t < 0.4 then
      boss.arrow = false
      boss.active_img = 1

    elseif boss.t < 0.5 then
      boss.active_img = 2

    elseif boss.t < 0.6 then
      boss.active_img = 3
      if not boss.arrow then
        game.entity:newArrow(boss, game.char)
        boss.arrow = true
      end
    elseif boss.t < 0.7 then
      boss.arrow = false
      boss.active_img = 1

    elseif boss.t < 0.8 then
      boss.active_img = 2

    elseif boss.t < 0.9 then
      boss.active_img = 3
      if not boss.arrow then
        game.entity:newArrow(boss, game.char)
        boss.arrow = true
      end
    elseif boss.t < 1.1 then
      boss.active_img = 4
    else
      game.entity.StateChange(boss, "rest")
    end

  elseif boss.state=="rest" then

    boss.v = 0
    boss.active_img = 1
    if boss.t < 0.5 then 
    else game.entity.StateChange(boss, "walk") end
  
  elseif boss.state == "walk" then
    
    boss.v = 60
    if boss.t < 0.2 then
      boss.active_img = 1
    elseif boss.t < 0.4 then
      boss.active_img = 2
    elseif boss.t < 0.6 then
      boss.active_img = 3
    elseif boss.t < 0.8 then
      boss.active_img = 4
    else
      boss.t = boss.t - 0.8
    end

  elseif boss.state == "hurt" then

    boss.active_img = 1
    if boss.t < 0.1 then
      boss.v = -90
    elseif boss.t < 0.5 then
      boss.v = 0
    else game.entity.StateChange(boss, "walk") end

    if boss.health <= 0 then game.entity.StateChange(boss, "dead") end

  elseif boss.state == "dead" then

    boss.z = 1
    boss.v = 0
    if boss.t < 0.5 then
      boss.active_img = 1
    else
      boss.active_img = 2
    end

  elseif boss.state == "wait" then
    boss.z = 1
    boss.v = 0
    boss.active_img = 1
  end
end

return boss