local game = {}
game.entity = {}
game.state = "dialogue"
game.t = 0
game.inCombat = false
game.stage = "beginning"
game.dialogue_t = 0
game.previous_state = "dialogue"
function game.entity.Distance(e1, e2)
  return math.sqrt((e1.x - e2.x)^2 + (e1.y - e2.y)^2)
end
function game.entity.StateChange(e, newState)
  e.state = newState
  e.active_img = 1
  e.t = 0
end
function game.entity.oppositeDirection(e1, e2)
  local dx = e1.x - e2.x
  local dy = e1.y - e2.y
  local dir = ""
  if dy > 0 and dx + dy > 0  then
    dir = dir .. "n"
  elseif dy < 0 and dx + dy < 0 then
    dir = dir .. "s"
  end
  if dx > 0 and dx > dy then
    dir = dir .. "w"
  elseif dx < 0 and dx < dy then
    dir = dir .. "e"
  end
  return dir
end
function game.entity.properDistance(entity, e1, i1)
  for i2, e2 in ipairs(entity) do
    if e1 ~= e2 then
      if e1.type == e2.type and e2.state ~= "dead" then
        if game.entity.Distance(e1, e2) < 5 then
          if i1 > i2 then return false end
        end
      end
    end
  end
  return true
end
function game.entity.newArrow(entity, from, to)
  entity[#entity+1] = love.filesystem.load("arrow.lua")()
  entity[#entity].x = from.x
  entity[#entity].y = from.y
  entity[#entity].direction = entity.oppositeDirection(from, to)
  entity[#entity].angle = math.atan2(to.y-from.y, to.x-from.x)
end
game.tree = require "tree"
game.vegetation = require "vegetation"
game.polygon = {
  -61.5	,	148.5	,
  -186	,	57	,
  -180	,	-130.5	,
  -40.5	,	-195	,
  202.5	,	-144	,
  402	,	-183	,
  664.5	,	-124.5	,
  729	,	72	,
  802	,	162	,
  831	,	53	,
  893	,	13	,
  1033.5	,	37.5	,
  1260	,	244.5	,
  1282.5	,	328.5	,
  1386	,	493.5	,
  1393.5	,	645	,
  1525.5	,	871.5	,
  1507.5	,	1072.5	,
  1120.5	,	1141.5	,
  861	,	990	,
  865.5	,	849	,
  882	,	795	,
  976.5	,	774	,
  1065	,	831	,
  1140	,	814.5	,
  1144.5	,	723	,
  1074	,	583.5	,
  988.5	,	411	,
  958.5	,	238.5	,
  934.5	,	150	,
  931.5	,	84	,
  894	,	76.5	,
  865.5	,	250.5	,
  759	,	252	,
  576	,	111	,
  405	,	162	,
  168	,	114	,
  31.5	,	124.5	,  
}
for i = 2, #game.polygon, 2 do
  game.polygon[i] = -game.polygon[i]
end
game.vegetation:polygon(game.polygon)
local sw, sh = love.graphics.getDimensions()
local zoom = 3
local direction_table = {
  ["n"]=math.rad(180),
  ["s"]=math.rad(0),
  ["w"]=math.rad(90),
  ["e"]=math.rad(270),
  ["nw"]=math.rad(135),
  ["ne"]=math.rad(225),
  ["sw"]=math.rad(45),
  ["se"]=math.rad(315),
}

game.dialogue = {portrait={}}
game.dialogue.portrait["char"] = love.graphics.newImage("char portrait.png")
game.dialogue.portrait["deer"] = love.graphics.newImage("deer portrait.png")
game.dialogue.portrait["wolf"] = love.graphics.newImage("wolf portrait.png")
game.dialogue.portrait["warrior"] = love.graphics.newImage("warrior portrait.png")
game.dialogue.portrait["snow"] = love.graphics.newImage("snow portrait.png")
game.dialogue.portrait["boss"] = love.graphics.newImage("boss portrait.png")

game.quest = {state="not", text=""}
game.quest.img = love.graphics.newImage("quest.png")

function game.load(game, menu)  
  love.graphics.setBackgroundColor(bg_green)
  for i = #game.entity, 1, -1 do
    table.remove(game.entity, i)
  end
  game.state = "play"
  game.previous_state = "play"
  game.inCombat = false
  game.t = 0
  game.stage = "beginning"

  game.char = love.filesystem.load("char.lua")()
  game.entity[1] = game.char

  game.deer = {
    type="dead deer", 
    health=10, 
    x=350, y=8, z=1,
    state="rest", t=0,
    img={ ["rest"]={love.graphics.newImage("dead deer.png")} },
    active_img = 1,
    direction="s",
    v=0,
    scale=1.5,
    messages={},
  }
  game.entity[2] = game.deer

  --game.inCombat = true
  --game.entity[3] = love.filesystem.load("boss.lua")()
  --game.entity[3].state = "rest"
  --game.entity[3].x = 30
  --game.entity[3].y = 30
  --game.entity[3] = love.filesystem.load("archer.lua")()
  --game.entity[3] = love.filesystem.load("warrior.lua")()
  --game.entity[3] = love.filesystem.load("wolf.lua")()
  --game.entity[4] = love.filesystem.load("wolf.lua")()
  --game.entity[4].x = 50
end

function game.ScaleToScreen(game, cx, cy)
  return cx * zoom, cy * zoom
end

function game.ScaleToCoord(game, sx, sy)
  return sx / zoom, sy / zoom
end

function game.ScreenToCoord(game, sx, sy)
  local cx = sx/zoom + game.char.x
  local cy = sy/zoom + game.char.y
  return cx, cy
end

function game.CoordToScreen(game, cx, cy)
  local wx = (cx - game.char.x)*zoom + sw/2
  local wy = (cy - game.char.y)*zoom + sh/2
  return wx, wy
end

function game.OnScreen(game, sx, sy)
  local treshold = 100
  return -treshold <= sx and sx <= sw+treshold and -treshold <= sy and sy <= sh + treshold
end

function game.save(game, main)
  main.saved = deepcopy(game)
end

function game.update(game, dt, main, input)
  game.t = game.t + dt

  if game.stage == "beginning" then
    if game.char.x > 230 then
      game.stage = "dialogue1"
      game.state = "dialogue"
      game.dialogue[1] = {actor="char", message="My god! A dead reindeer"}
      game.dialogue[2] = {actor="char", message="Let's take a closer look", event="closer"}
    end
  end

  if game.stage == "closer" then
    if game.entity.Distance(game.char, game.deer) < 30 then
      game.stage = "dialogue2"
      game.state = "dialogue"
      game.dialogue[1] = {actor="deer", message="Oh kind sir! \nI'm actually a dying doe"}
      game.dialogue[2] = {actor="char", message="What is a doe?"}
      game.dialogue[3] = {actor="deer", message="A female deer, that is"}
      game.dialogue[4] = {actor="char", message="Ah! Looks like I learned \na new word"}
      game.dialogue[5] = {actor="char", message="What is your condition?"}
      game.dialogue[6] = {actor="deer", message="I'm severely injured \nand in need of medication"}
      game.dialogue[7] = {actor="deer", message="If you want to make a good deed \nbring me some healing herbs"}
      game.dialogue[8] = {actor="deer", message="I will do the rest."}
      game.dialogue[9] = {actor="char", message="Do not worry, noble beast"}
      game.dialogue[10] = {actor="char", message="I'll soon be back", event="to wolves"}
    end
  end

  if game.stage == "to wolves" then
    if game.char.x > 1000 and game.char.y < -250 then
      game:save(main)
      game.stage = "dialogue3"
      game.state = "dialogue"
      game.dialogue[1] = {actor="wolf", message="Wooof! \nWe're wolves"}
      game.dialogue[2] = {actor="char", message="I can see that.", event="wolves"}
    end
  end

  if game.stage == "wolves" then
    if game.wolf1.state=="dead"
    and game.wolf2.state=="dead" then
      game.stage = "dialogue3"
      game.inCombat = false
      game.state = "dialogue"
      game.dialogue[1] = {actor="char", message="Well, this is taken care of"}
      game.dialogue[2] = {actor="char", message="And I'm getting closer to the \nherbs, I can feel it"}
      game.dialogue[3] = {actor="char", message="Even though I'm technically not \nsupposed to know where they are", event="to herbs"}

      game.herb = love.filesystem.load("herb.lua")()
      game.entity[#game.entity+1] = game.herb
    end
  end

  if game.stage == "to herbs" then
    if game.herb.state == "not" then
      game.quest.state = "yes"
      game.quest.text = "Return to your deer"
      game.quest.x, game.quest.y = game.entity[2].x, game.entity[2].y

      game.stage = "to defender wolves"

      game.warrior1 = love.filesystem.load("warrior.lua")()
      game.warrior1.x = 1100
      game.warrior1.y = -330
      game.entity[#game.entity+1] = game.warrior1

      game.warrior2 = love.filesystem.load("warrior.lua")()
      game.warrior2.x = 1120
      game.warrior2.y = -320
      game.entity[#game.entity+1] = game.warrior2
    end
  end

  if game.stage == "to defender wolves" then
    if game.char.y > -400 then
      game:save(main)
      game.stage = "dialogue4"
      game.state = "dialogue"
      game.dialogue[1] = {actor="warrior", message="Greetings, adventurer!"}
      game.dialogue[2] = {actor="char", message="Greetings."}
      game.dialogue[3] = {actor="warrior", message="Interesting, we look \nstrikingly similar"}
      game.dialogue[4] = {actor="char", message="Don't draw attention to that."}
      game.dialogue[5] = {actor="warrior", message="Anyways, we found these poor \ndying wolves"}
      game.dialogue[6] = {actor="warrior", message="And being good men, \nwe were moved to compassion"}
      game.dialogue[7] = {actor="warrior", message="We seek healing herbs \nand I see you've got some."}
      game.dialogue[8] = {actor="warrior", message="Would you please \ngive them to us?"}
      game.dialogue[9] = {actor="char", message="No way."}
      game.dialogue[10] = {actor="char", message="I have a doe to keep alive and \nnothing will stand in my way"}
      game.dialogue[10] = {actor="warrior", message="Then you shall suffer! \nATTACK!", event="defender wolves"}
    end
  end

  if game.stage == "defender wolves" then
    if game.warrior1.state == "dead"
    and game.warrior2.state == "dead" then
      game.stage = "dialogue5"
      game.inCombat = false
      game.state = "dialogue"
      game.dialogue[1] = {actor="char", message="Trying to kill me just to \nsave wolves"}
      game.dialogue[2] = {actor="char", message="People are getting crazy \nthese days", event="return deer"}
    end
  end

  if game.stage == "return deer" then
    if game.entity.Distance(game.char, game.deer) < 30 then
      game.stage = "dialogue6"
      game.state = "dialogue"
      game.dialogue[1] = {actor="deer", message="Oh kind sir! \n"}
      game.dialogue[2] = {actor="deer", message="I'm afraid my situation \nis getting worse"}
      game.dialogue[3] = {actor="deer", message="I don't know if I'll \nsurvive for long"}
      game.dialogue[4] = {actor="char", message="No, no, no...\nThis can't be"}
      game.dialogue[5] = {actor="char", message="You HAVE to survive!"}
      game.dialogue[6] = {actor="char", message="There must be something \nI can do... something..."}
      game.dialogue[7] = {actor="deer", message="There's still a chance"}
      game.dialogue[8] = {actor="deer", message="Deliver me a deer heart \nand I might live"}
      game.dialogue[9] = {actor="char", message="It shall be done"}
      game.dialogue[10] = {actor="char", message="Resist my deer. \nI'll return soon", event="to defender defender"}
    end
  end

  if game.stage == "to defender defender" then
    if game.char.x > 1000 and game.char.y < -260 then
      game:save(main)
      game.stage = "dialogue7"
      game.state = "dialogue"
      game.dialogue[1] = {actor="warrior", message="Hello there."}
      game.dialogue[2] = {actor="char", message="Hi."}
      game.dialogue[3] = {actor="warrior", message="You seem to be a very \nhealthy individual"}
      game.dialogue[4] = {actor="char", message="Hmm."}
      game.dialogue[5] = {actor="warrior", message="and you see, these good men \nare dying"}
      game.dialogue[6] = {actor="warrior", message= "and need lungs, kidneys, livers..."}
      game.dialogue[7] = {actor="warrior", message="not to mention these beautiful, \npoor wolves"}
      game.dialogue[8] = {actor="char", message="You want my organs?\nTake them if you can, bastards!"}
      game.dialogue[9] = {actor="warrior", message="It seems like diplomacy \ndidn't work. ATTACK!"}
      game.dialogue[10] = {actor="wolf", message="Wooof!", event="defender defender"}
    end
  end

  if game.stage == "defender defender wolves" then
    if game.warriorb1.state == "dead"
    and game.warriorb2.state == "dead"
    and game.wolfb1.state == "dead" 
    and game.wolfb2.state == "dead" then
      game.stage = "to maybe deer"
      game.inCombat = false

      game.snow = love.filesystem.load("snow.lua")()
      game.entity[#game.entity+1] = game.snow
      game.quest.state = "yes"
      game.quest.text = "Extract a heart from a deer"
      game.quest.x, game.quest.y = game.snow.x, game.snow.y
    end
  end

  if game.stage == "to maybe deer" then
    if game.entity.Distance(game.char, game.snow) < 90 then
      game.stage = "dialogue8"
      game.state = "dialogue"
      game.dialogue[1] = {actor="char", message="My senses were mistaken"}
      game.dialogue[2] = {actor="char", message="There is no deer here"}
      game.dialogue[3] = {actor="char", message="But maybe she'll do. \nLet's go talk to her", event="to snow"}
    end
  end

  if game.stage == "to snow" then
    if game.entity.Distance(game.char, game.snow) < 30 then
      game.stage = "dialogue9"
      game.state = "dialogue"
      game.dialogue[1] = {actor="char", message="Good day, beautiful girl. \nWhat is your name?"}
      game.dialogue[2] = {actor="snow", message="I am Snow-white, gentle boy"}
      game.dialogue[3] = {actor="char", message="Yes, she's close enough \nto a deer, probably"}
      game.dialogue[4] = {actor="snow", message="What did you say?", event="snow"}
    end
  end

  if game.stage == "snow" then
    if game.snow.state == "dead" then
      game.stage = "to defender defender defender"
      game.quest.state = "yes"
      game.quest.text = "Return to your deer"
      game.quest.x, game.quest.y = game.entity[2].x, game.entity[2].y
      
      game.warriorc1 = love.filesystem.load("warrior.lua")()
      game.warriorc1.x = 1130
      game.warriorc1.y = -320
      game.entity[#game.entity+1] = game.warriorc1
      
      game.warriorc2 = love.filesystem.load("warrior.lua")()
      game.warriorc2.x = 1100
      game.warriorc2.y = -330
      game.entity[#game.entity+1] = game.warriorc2
      
      game.warriorc3 = love.filesystem.load("warrior.lua")()
      game.warriorc3.x = 1090
      game.warriorc3.y = -310
      game.entity[#game.entity+1] = game.warriorc3
      
      game.wolfc1 = love.filesystem.load("wolf.lua")()
      game.wolfc1.x = 1150
      game.wolfc1.y = -330
      game.entity[#game.entity+1] = game.wolfc1
      
      game.wolfc2 = love.filesystem.load("wolf.lua")()
      game.wolfc2.x = 1160
      game.wolfc2.y = -300
      game.entity[#game.entity+1] = game.wolfc2

      game.wolfc3 = love.filesystem.load("wolf.lua")()
      game.wolfc3.x = 1180
      game.wolfc3.y = -310
      game.entity[#game.entity+1] = game.wolfc3

      game.archerc1 = love.filesystem.load("archer.lua")()
      game.archerc1.x = 1120
      game.archerc1.y = -340
      game.entity[#game.entity+1] = game.archerc1
      
      game.archerc2 = love.filesystem.load("archer.lua")()
      game.archerc2.x = 1100
      game.archerc2.y = -350
      game.entity[#game.entity+1] = game.archerc2
    end
  end

  if game.stage == "to defender defender defender" then
    if game.char.y > -400 then
      game:save(main)
      game.stage = "dialogue10"
      game.state = "dialogue"
      game.dialogue[1] = {actor="warrior", message="Greetings, ..."}
      game.dialogue[2] = {actor="char", message="Oh, just shut up and \nattack me already", event="defender defender defender"}
    end
  end

  if game.stage == "defender defender defender" then
    if game.warriorc1.state == "dead"
    and game.warriorc2.state == "dead"
    and game.warriorc3.state == "dead"
    and game.wolfc1.state == "dead" 
    and game.wolfc2.state == "dead"
    and game.wolfc3.state == "dead" 
    and game.archerc1.state == "dead"
    and game.archerc2.state == "dead" then
      game.stage = "to final deer"
      game.inCombat = false

      game.boss = love.filesystem.load("boss.lua")()
      game.entity[#game.entity+1] = game.boss
      game.quest.state = "yes"
      game.quest.text = "Return to your deer"
      game.quest.x, game.quest.y = game.deer.x, game.deer.y
    end
  end

  if game.stage == "to final deer" then
    if game.entity.Distance(game.boss, game.char) < 50 then
      game:save(main)
      game.stage = "dialogue11"
      game.state = "dialogue"
      game.dialogue[1] = {actor="char", message="Hey you! What do you \nthink you're doing?"}
      game.dialogue[2] = {actor="boss", message="I'm helping out \nthis poor doe"}
      game.dialogue[3] = {actor="char", message="Away with you! \nThat's MY doe!"}
      game.dialogue[4] = {actor="boss", message="What!? I found her first!"}
      game.dialogue[5] = {actor="char", message="That's a lie!"}
      game.dialogue[6] = {actor="char", message="Now step aside or I'll make \na hole in your skull"}
      game.dialogue[7] = {actor="boss", message="We shall see that.", event="boss"}
    end
  end

  if game.stage == "boss" then
    if game.boss.state == "dead" then
      game.stage = "dialogue12"
      game.state = "dialogue"
      game.dialogue[1] = {actor="boss", message="I surrender! Please stop!"}
      game.dialogue[2] = {actor="char", message="I'm a man of noble manners, \nso I will spare you", event = "black"}
      game.dialogue[3] = {actor="boss", message="Thank you."}
      game.dialogue[4] = {actor="boss", message="..."}
      game.dialogue[5] = {actor="char", message="..."}
      game.dialogue[6] = {actor="boss", message="Why do you care so much \nabout this deer anyways"}
      game.dialogue[7] = {actor="char", message="...I dunno, it looked \nkinda cute"}
      game.dialogue[8] = {actor="boss", message="That's what you say? \nAfter killing so many?"}
      game.dialogue[9] = {actor="boss", message="What about the pile of corpses \nyou left behind?"}
      game.dialogue[10] = {actor="char", message="They're not very cute"}
      game.dialogue[11] = {actor="boss", message="I see. You've got a point."}
      game.dialogue[12] = {actor="char", message="..."}
      game.dialogue[13] = {actor="boss", message="..."}
      game.dialogue[14] = {actor="char", message="I'm starting to get \na bit hungry."}
      game.dialogue[15] = {actor="boss", message="Me too. Do you have anything \nto eat?"}
      game.dialogue[16] = {actor="char", message="No, not really. \nWhat about you?"}
      game.dialogue[17] = {actor="boss", message="Me neither."}
      game.dialogue[18] = {actor="char", message="..."}
      game.dialogue[19] = {actor="boss", message="..."}
      game.dialogue[20] = {actor="boss", message="Well, we do have a deer..."}
      game.dialogue[21] = {actor="char", message="Hmm... After all I've \nbeen through..."}
      game.dialogue[22] = {actor="char", message="You can't think that \njust like that..."}
      game.dialogue[23] = {actor="char", message="Okay you convinced me"}
      game.dialogue[24] = {actor="deer", message="...", event = "win"}
    end
  end

  if game.state == "play" then

    for ie, e in ipairs(game.entity) do
      e.t = e.t + dt
      if e.mail then e:mail(dt, game) end
    end

    for ie, e in ipairs(game.entity) do
      if e.update then e:update(dt, game, input) end
    end


    for ie, e in ipairs(game.entity) do
      if e.type == "arrow" and e.state == "rest" then
        e.x = e.x + e.v * math.cos(e.angle) * dt
        e.y = e.y + e.v * math.sin(e.angle) * dt
      else
        local newX = e.x - e.v * math.sin(direction_table[e.direction]) * dt
        local newY = e.y + e.v * math.cos(direction_table[e.direction]) * dt
        if not game.tree:inTree(newX, newY) and pointInPolygon(game.polygon, newX, newY)
        and game.entity:properDistance(e, ie) then
          e.x = newX
          e.y = newY
        end
      end
    end

  elseif game.state == "dialogue" then
    if game.previous_state ~= "dialogue" then
      game.dialogue_t = 0
    end
    game.dialogue_t = game.dialogue_t + dt


    if input.keyboard.z == 1 and game.dialogue_t > 0.5 then

      input.keyboard.z = -1
      if game.dialogue[1].event == "closer" then

        game.stage = "closer"

      elseif game.dialogue[1].event == "to wolves" then

        game.stage = "to wolves"

        game.wolf1 = love.filesystem.load("wolf.lua")()
        game.wolf1.x = 1140
        game.wolf1.y = -330
        game.entity[#game.entity+1] = game.wolf1

        game.wolf2 = love.filesystem.load("wolf.lua")()
        game.wolf2.x = 1160
        game.wolf2.y = -320
        game.entity[#game.entity+1] = game.wolf2

        game.quest.text = "Cut down some healing herbs"
        game.quest.state = "yes"
        game.quest.x, game.quest.y = 952, -848

      elseif game.dialogue[1].event == "wolves" then

        game.stage = "wolves"
        game.entity.StateChange(game.wolf1, "rest")
        game.entity.StateChange(game.wolf2, "rest")
        game.inCombat = true
        game.quest.state = "no marker"
        game.quest.text = "Defeat the wolves"
      
      elseif game.dialogue[1].event == "to herbs" then
        game.stage = "to herbs"
        game.quest.state = "yes"
        game.quest.text = "Cut down some healing herbs"
      
      elseif game.dialogue[1].event == "defender wolves" then
        game.stage = "defender wolves"
        game.quest.state = "no marker"
        game.quest.text = "Defeat the aiders of wolves"
        game.inCombat = true
        game.warrior1.state = "rest"
        game.warrior2.state = "rest"
      
      elseif game.dialogue[1].event == "return deer" then
        game.stage = "return deer"
        
        game.quest.state = "yes"
        game.quest.text = "Return to your deer"
        game.quest.x, game.quest.y = game.entity[2].x, game.entity[2].y
      
      elseif game.dialogue[1].event == "to defender defender" then
        game.stage = "to defender defender"

        game.warriorb1 = love.filesystem.load("warrior.lua")()
        game.warriorb1.x = 1130
        game.warriorb1.y = -320
        game.entity[#game.entity+1] = game.warriorb1
        
        game.warriorb2 = love.filesystem.load("warrior.lua")()
        game.warriorb2.x = 1100
        game.warriorb2.y = -330
        game.entity[#game.entity+1] = game.warriorb2
        
        game.wolfb1 = love.filesystem.load("wolf.lua")()
        game.wolfb1.x = 1150
        game.wolfb1.y = -330
        game.entity[#game.entity+1] = game.wolfb1
        
        game.wolfb2 = love.filesystem.load("wolf.lua")()
        game.wolfb2.x = 1160
        game.wolfb2.y = -300
        game.entity[#game.entity+1] = game.wolfb2

        game.quest.state = "yes"
        game.quest.text = "Extract a heart from a deer"
        game.quest.x, game.quest.y = 1400, -900


      elseif game.dialogue[1].event == "defender defender" then
        game.stage = "defender defender wolves"
        game.quest.state = "no marker"
        game.quest.text = "Defeat the aiders of the aiders of wolves"
        game.inCombat = true
        game.warriorb1.state = "rest"
        game.warriorb2.state = "rest"
        game.wolfb1.state = "rest"
        game.wolfb2.state = "rest"
      
      elseif game.dialogue[1].event == "to snow" then
        game.stage = "to snow"
        game.quest.text = "Go talk to the lady"

      elseif game.dialogue[1].event == "snow" then
        game.stage = "snow"
        game.quest.text = "Extract a heart from Snow-white"

      elseif game.dialogue[1].event == "defender defender defender" then
        game.stage = "defender defender defender"
        game.quest.state = "no marker"
        game.quest.text = "Defeat the aiders of the aiders of the aiders of wolves"
        game.inCombat = true
        game.warriorc1.state = "rest"
        game.warriorc2.state = "rest"
        game.warriorc3.state = "rest"
        game.wolfc1.state = "rest"
        game.wolfc2.state = "rest"
        game.wolfc3.state = "rest"
        game.archerc1.state = "rest"
        game.archerc2.state = "rest"
      
      elseif game.dialogue[1].event == "boss" then
        game.stage = "boss"
        game.quest.state = "Defeat the usurper of the deer"
        game.inCombat = true
        game.boss.state = "rest"
      
      elseif game.dialogue[1].event == "black" then
        game.state = "black"
        game.black_t = 0
        game.entity.StateChange(game.boss, "rest")
        game.boss.direction = "nw"
        game.entity.StateChange(game.char, "rest")
        game.char.direction = "sw"
        game.boss.x, game.boss.y = 360, 18
        game.char.x, game.char.y = 360, -8
      elseif game.dialogue[1].event == "win" then
        game.state = "win"
        goto win
      end

      table.remove(game.dialogue, 1)
      if game.dialogue[1] then
      else
        game.state = "play"
      end
    end
    ::win::
  elseif game.state == "dead" then
    main.state = "dead"
  elseif game.state == "win" then
    main.state = "win"
  elseif game.state == "black" then
    game.black_t = game.black_t + dt
    if game.black_t > 0.5 then
      game.state = "dialogue"
    end
  end
  game.previous_state = game.state
end


function game.draw(game)
  love.graphics.setColor(1, 1, 1)

  for i, t in ipairs(game.vegetation.flower) do
    local sx, sy = game:CoordToScreen(t.x, t.y)
    if game:OnScreen(sx, sy) then
      local image = game.vegetation.img["flower"][t.img]
      love.graphics.draw(image, sx, sy, 0, zoom*t.scale, zoom*t.scale, image:getWidth()/2, image:getHeight()/2)
    end
  end

  local sortTable = {}
  for ie, e in ipairs(game.entity) do
    sortTable[#sortTable+1] = {i=ie, z=e.z}
  end
  table.sort(sortTable, function(a, b) return a.z < b.z end)
  for i = 1, #sortTable do
    local ie = sortTable[i].i
    local e = game.entity[ie]
    local sx, sy = game:CoordToScreen(e.x, e.y)
    if game:OnScreen(sx, sy) then
      local angle = direction_table[e.direction]
      if e.type=="arrow" then angle = e.angle + math.pi/2 end

      local image = e.img[e.state][e.active_img]
      
      love.graphics.draw(image, sx, sy, angle, zoom*e.scale, zoom*e.scale, image:getWidth()/2, image:getHeight()/2)
    end
  end

  for it, t in ipairs(game.tree) do
    local sx, sy = game:CoordToScreen(t.x, t.y)
    if game:OnScreen(sx, sy) then
      local image = game.tree.img[t.img]
      love.graphics.draw(image, sx, sy, 0, zoom*game.tree.scale, zoom*game.tree.scale, image:getWidth()/2, image:getHeight()/2)
    end
  end

  for it, t in ipairs(game.vegetation.tree) do
    local sx, sy = game:CoordToScreen(t.x, t.y)
    if game:OnScreen(sx, sy) then
      local image = game.vegetation.img["tree"][t.img]
      love.graphics.draw(image, sx, sy, 0, zoom*t.scale, zoom*t.scale, image:getWidth()/2, image:getHeight()/2)
    end
  end

  love.graphics.setColor(dark_blue)
  love.graphics.rectangle("fill", 20-4, 20-4, game.char.maxHealth*10+8, 20+8)

  love.graphics.setColor(228/255, 59/255, 68/255)
  love.graphics.rectangle("fill", 20, 20, clamp(game.char.health*10, 0, game.char.maxHealth*10), 20)

  love.graphics.setColor(dark_blue)
  love.graphics.rectangle("fill", 20-4, 50-4, game.char.maxHealth*10+8, 20+8)

  love.graphics.setColor(99/255, 199/255, 77/255)
  love.graphics.rectangle("fill", 20, 50, clamp(game.char.stamina*10, 0, game.char.maxStamina*10), 20)

  if game.quest.state == "yes" then
    love.graphics.setFont(tinyFont)
    love.graphics.setColor(light_yellow)
    love.graphics.print(game.quest.text, 70, 80)
  end
  if game.quest.state == "no marker" then
    love.graphics.setFont(tinyFont)
    love.graphics.setColor(light_yellow)
    love.graphics.print(game.quest.text, 20, 80)
  end
  --love.graphics.setColor(1, 0, 0, 0.1)
  --local spolygon = {}
  --for i = 1, #game.polygon, 2 do
  --  local sx, sy = game:CoordToScreen(game.polygon[i], game.polygon[i+1])
  --  spolygon[#spolygon+1]= sx
  --  spolygon[#spolygon+1]= sy
  --end
  --love.graphics.polygon("line", spolygon)

  if game.quest.state == "yes" then
    love.graphics.setColor(1, 1, 1)
    local img = game.quest.img

    local qx, qy = game:CoordToScreen(game.quest.x, game.quest.y)
    if 10 <= qx and qx <= sw-10 and 10 <= qy and qy <= sh-10 then
      love.graphics.draw(img, qx, qy-40, 0, 2, 2, img:getWidth()/2, img:getHeight()/2)
    end
    
    local sx, sy, angle = 0, 0, 0
    local cx, cy = game:CoordToScreen(game.char.x, game.char.y)
    local dx = qx - cx
    local dy = qy - cy
    angle = math.atan2(dy, dx) - math.pi/2
    sx, sy = 40, 100

    love.graphics.setColor(dark_blue)
    love.graphics.circle("fill", 40, 100, 20)
    

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(img, sx, sy, angle, 2, 2, img:getWidth()/2, img:getHeight()/2)
  end

  if game.state == "dialogue" then
    love.graphics.setColor(dark_blue)
    love.graphics.rectangle("fill", 20, 420, 760, 160)
    love.graphics.setColor(light_yellow)
    love.graphics.setFont(smallFont)
    love.graphics.print(game.dialogue[1].message, 60, 440)

    love.graphics.setColor(dark_blue)
    love.graphics.rectangle("fill", 20, 200, 180, 180)
    love.graphics.setColor(1, 1, 1)
    local img = game.dialogue.portrait[game.dialogue[1].actor]
    love.graphics.draw(img, 30, 210, 0, 10, 10)
  end

  if game.state == "black" then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, sw, sh)
  end
end

return game