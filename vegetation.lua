local veg = {tree={}, flower={}}

veg.img = {["tree"]={}, ["flower"]={}}
veg.img["tree"][1] = love.graphics.newImage("tree 1.png")
veg.img["tree"][2] = love.graphics.newImage("tree 2.png")
veg.img["tree"][3] = love.graphics.newImage("tree 3.png")
veg.img["tree"][4] = love.graphics.newImage("tree 4.png")
veg.img["tree"][5] = love.graphics.newImage("tree 5.png")
veg.img["tree"][6] = love.graphics.newImage("tree 6.png")
veg.img["tree"][7] = love.graphics.newImage("tree 7.png")
veg.img["tree"][8] = love.graphics.newImage("tree 8.png")
veg.img["tree"][9] = love.graphics.newImage("tree 9.png")
veg.img["tree"][10] = love.graphics.newImage("tree 10.png")
veg.img["flower"][1] = love.graphics.newImage("flower 1.png") 

--local scale_table = {["tree"]=3, ["flower"]=1}
function veg.placeTree(veg, x, y, scale)
  veg.tree[#veg.tree+1] = {x=x, y=y, scale=scale, img=love.math.random(#veg.img["tree"])}
end
function veg.placeFlower(veg, x, y, scale)
  veg.flower[#veg.flower+1] = {x=x, y=y, scale=scale, img=love.math.random(#veg.img["flower"])}
end

function veg.treeLine(veg, x0, y0, x1, y1)
  local distance = math.sqrt((x1-x0)^2 + (y1-y0)^2)
  local N = math.ceil(distance/42)
  local dx = (x1 - x0)/N
  local dy = (y1 - y0)/N
  local x, y = x0, y0
  for i = 1, N do
    local px = x + love.math.random()*4-2
    local py = y + love.math.random()*4-2
    local scale = 2.5 + love.math.random()
    veg:placeTree(px, py, scale)
    x = x + dx
    y = y + dy
  end
end

--placeVeg(-30, -30, "tree")
--placeVeg(-30, -60, "tree")
--placeVeg(30, 0, "tree")

local abs = math.abs

function veg.polygon(veg, polygon)
  local xMin = -300
  local xMax = 1600
  local yMin = -1200
  local yMax = 250

  local flowerDist = 40
  for y = yMin, yMax, flowerDist do
    for x = xMin, xMax, flowerDist do
      local rx = x + love.math.random()*40-20
      local ry = y + love.math.random()*40-20
      veg:placeFlower(rx, ry, 1)
    end
  end 

  for i = 1, #polygon-2 , 2 do
    local x0, y0 = polygon[i], polygon[i+1]
    local x1, y1 = polygon[i+2], polygon[i+3]
    veg:treeLine(x0, y0, x1, y1)
  end
  local x0, y0 = polygon[#polygon-1], polygon[#polygon]
  local x1, y1 = polygon[1], polygon[2]
  veg:treeLine(x0, y0, x1, y1)

  
  local treeDist = 50
  for y = yMin, yMax, treeDist do
    for x = xMin, xMax, treeDist do
      local rx = x + love.math.random()*20-10
      local ry = y + love.math.random()*20-10
      if not pointInPolygon(polygon, rx, ry) then
        local scale = 1.5 + 2*love.math.random()
        veg:placeTree(rx, ry, scale)
      end
    end
  end 
end

return veg