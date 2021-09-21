window_width = 1280
window_height = 720
virtual_width = 426
virtual_height = 240

Class = require 'lib/class'
Camera = require 'lib/camera'
push = require 'lib/push'
sti = require 'lib/sti'
wf = require 'lib/windfield'

require 'Map'
require 'Player'
-- require 'Enemy'
require 'Coins'

function love.load()
  love.window.setTitle("Theo's Adventures")
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(virtual_width, virtual_height, window_width, window_height)

  world = wf.newWorld(0, 1000, false)
  -- world:setQueryDebugDrawing(true)

  cam = Camera()

  map = Map(world)
  player = Player(world)

  coins = {}
  for _, c in ipairs(map.game_map.layers['Coins'].objects) do
    local coin = Coins(world, c.x, c.y)
    table.insert(coins, coin)
  end
end

function love.update(dt)
  world:update(dt)
  map:update(dt)
  player:update(dt)

  local cont = 1
  for _, c in ipairs(coins) do
    c:update(dt)
    if collides(c, player, 20) then
      table.remove(coins, cont)
      player.score = player.score + 1
    end
    cont = cont + 1
  end
end

function love.draw()
  love.graphics.clear(71/255, 45/255, 60/255)

  push:start()
  cam:attach()

  map:draw()
  for _, c in ipairs(coins) do
    c:draw()
  end
  player:draw()

  -- world:draw()

  cam:lookAt(player.x+450, player.y+200)

  cam:detach()
  push:finish()

  love.graphics.printf('Score: ' .. player.score, 10, 10, 500, 'left')
end

function love.keypressed(key)
  if key == 'w' then
    player:jump()
  end
end

-- Para as colisões com as moedas
function collides(a, b, c)
  if math.sqrt((a.y - b.y)^2 + (a.x - b.x)^2) <= c then
    return true
  end
  return false
end
