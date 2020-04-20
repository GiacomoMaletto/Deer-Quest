function deepcopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
			if copies[orig] then
					copy = copies[orig]
			else
					copy = {}
					copies[orig] = copy
					for orig_key, orig_value in next, orig, nil do
							copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
					end
					setmetatable(copy, deepcopy(getmetatable(orig), copies))
			end
	else -- number, string, boolean, etc
			copy = orig
	end
	return copy
end
function getQuad(axis_x,axis_y,vert_x,vert_y)
	if vert_x < axis_x then
		if vert_y < axis_y then
			return 1
		else
			return 4
		end
	else
		if vert_y < axis_y then
			return 2
		else
			return 3
		end	
	end
end
function pointInPolygon(pgon, tx, ty)
	if (#pgon < 6) then
		return false
	end
 
	local x1 = pgon[#pgon - 1]
	local y1 = pgon[#pgon]
	local cur_quad = getQuad(tx,ty,x1,y1)
	local next_quad
	local total = 0
	local i
 
	for i = 1,#pgon,2 do
		local x2 = pgon[i]
		local y2 = pgon[i+1]
		next_quad = getQuad(tx,ty,x2,y2)
		local diff = next_quad - cur_quad
 
		if (diff == 2) or (diff == -2) then
			if (x2 - (((y2 - ty) * (x1 - x2)) / (y1 - y2))) < tx then
				diff = -diff
			end
		elseif diff == 3 then
			diff = -1
		elseif diff == -3 then
			diff = 1
		end
 
		total = total + diff
		cur_quad = next_quad
		x1 = x2
		y1 = y2
	end
 
	return (math.abs(total)==4)
end
function clamp(x, minVal, maxVal)
	if x < minVal then return minVal end
	if x > maxVal then return maxVal end
	return x
end
 
love.graphics.setDefaultFilter("nearest", "nearest")

tinyFont = love.graphics.newFont("VT323-Regular.ttf", 25)
tinyFont:setFilter("nearest", "nearest")
smallFont = love.graphics.newFont("VT323-Regular.ttf", 50)
smallFont:setFilter("nearest", "nearest")
bigFont = love.graphics.newFont("VT323-Regular.ttf", 70)
bigFont:setFilter("nearest", "nearest")
bigFont2 = love.graphics.newFont("VT323-Regular.ttf", 60)
bigFont2:setFilter("nearest", "nearest")
bg_green = {62/255, 137/255, 72/255}
light_yellow = {254/255, 231/255, 97/255}
dark_yellow = {254/255, 174/255, 52/255}
dark_blue = {58/255, 68/255, 102/255}
dark_red = {162/255, 38/255, 51/255}
light_red = {228/255, 59/255, 68/255}

love.math.setRandomSeed(love.timer.getTime())

love.graphics.setFont(smallFont)

local main = {}
local game = require "game"
local menu = require "menu"
local input = require "input"
local dead = require "dead"
local win = require "win"
main.state = "menu"
main.saved = {}

function main.resetGame(main)
  game:load(menu)
end

function main.resetToSave(main)
  game = main.saved
end

sw, sh = love.graphics.getDimensions()

function love.load()
  menu:load()
  input:load()
end

local t = 0
local Dt = 0
function love.update(dt)
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

  input:update(dt)

  Dt = dt
  t = t + dt

  if main.state == "menu" then
    menu:update(Dt, main, input)
  elseif main.state == "game" then
    game:update(Dt, main, input)
  elseif main.state == "dead" then
    dead:update(Dt, main, input)
	elseif main.state == "win" then
		win:update(Dt, main, input)
	end
end

function love.draw()
  if main.state == "menu" then
    menu:draw()
  elseif main.state == "game" then
    game:draw()
  elseif main.state == "dead" then
    dead:draw()
	elseif main.state == "win" then
		win:draw()
	end
end