local herb = {
  type = "herb",
  health=4,
  x=952, y=-848, z=1,
  state="rest", t=0,
  direction="s",
  v=0,
  scale=1,
  messages={}
}

herb.img = {["rest"]={}, ["not"]={}}
herb.img["rest"][1] = love.graphics.newImage("herb.png")
herb.img["not"][1] = love.graphics.newImage("herb not.png")

herb.active_img = 1

function herb.mail(herb, dt, game)
  for im, m in ipairs(herb.messages) do
    if m[1] == "hit by " then
      if m[2].type == "char" then
        game.entity.StateChange(herb, "not")
      end
    end
  end
  herb.messages = {}
end

function herb.update(herb, dt, game)
  
  if herb.state=="rest" then

  elseif herb.state=="not" then

  end
end

return herb