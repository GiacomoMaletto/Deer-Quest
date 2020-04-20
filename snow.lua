local snow = {
  type = "snow",
  health=4,
  x=1400, y=-900, z=2,
  state="rest", t=0,
  direction="s",
  v=0,
  scale=1,
  messages={}
}

snow.img = {["rest"]={}, ["dead"]={}}
snow.img["rest"][1] = love.graphics.newImage("snow.png")
snow.img["dead"][1] = love.graphics.newImage("snow dead.png")

snow.active_img = 1

function snow.mail(snow, dt, game)
  for im, m in ipairs(snow.messages) do
    if m[1] == "hit by " then
      if m[2].type == "char" then
        game.entity.StateChange(snow, "dead")
      end
    end
  end
  snow.messages = {}
end

function snow.update(snow, dt, game)
  if snow.state=="rest" then
    snow.direction = game.entity.oppositeDirection(snow, game.char)
  elseif snow.state=="not" then
    snow.z = 1
  end
end

return snow