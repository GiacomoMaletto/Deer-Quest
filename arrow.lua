local arrow = {
  type = "arrow",
  health=4,
  x=952, y=-848, z=1,
  state="rest", t=0,
  direction="s",
  v=0,
  scale=1,
  messages={}
}

arrow.img = {["rest"]={}, ["dead"]={}}
arrow.img["rest"][1] = love.graphics.newImage("arrow.png")
arrow.img["dead"][1] = love.graphics.newImage("arrow dead.png")

arrow.active_img = 1

function arrow.mail(arrow, dt, game)
  arrow.messages = {}
end

function arrow.update(arrow, dt, game)
  
  if arrow.state=="rest" then
    arrow.v = 500
    if arrow.t < 0.2 then

      for ie, e in ipairs(game.entity) do
        if e ~= arrow then
          if game.entity.Distance(e, arrow) < 5 then
            e.messages[#e.messages+1] = {"hit by ", arrow}
          end
        end
      end
      
    else 
      arrow.state = "dead"
    end
  elseif arrow.state=="dead" then
    arrow.v = 0
  end
end

return arrow