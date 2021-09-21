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
require 'Enemy'
require 'Coins'
require 'Jump'

function love.load()
  love.window.setTitle("Theo's Adventure")
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(virtual_width, virtual_height, window_width, window_height)

  small_pixel = love.graphics.newFont('menu/pixel.otf', 25)
  normal_pixel = love.graphics.newFont('menu/pixel.otf', 40)
  big_pixel = love.graphics.newFont('menu/pixel.otf', 70)

  crown = love.graphics.newImage('maps/crown.png')
  bg_music = love.audio.newSource('bg_music.mp3', 'stream')
  love.audio.play(bg_music)
  love.audio.setVolume(0.06)
  music_state = true

  state = 'menu'

  world = wf.newWorld(0, 1000, false)
  world:addCollisionClass('Player')

  cam = Camera()
  map = Map(world)
  jump = Jump()
  player = Player(world)

  coins = {}
  for _, c in ipairs(map.game_map.layers['Coins'].objects) do
    local coin = Coins(world, c.x, c.y)
    table.insert(coins, coin)
  end

  spikes = {}
  for _, s in ipairs(map.game_map.layers['Spikes'].objects) do
    local spike = {x = s.x, y = s.y}
    table.insert(spikes, spike)
  end

  enemies = {}
  for _, e in ipairs(map.game_map.layers['Enemies'].objects) do
    local enemy = Enemy(world, e.x, e.y)
    table.insert(enemies, enemy)
  end

  lim_enemy = {}
  for _, le in ipairs(map.game_map.layers['Limit Enemies'].objects) do
    local lenemy = {x = le.x, y = le.y}
    table.insert(lim_enemy, lenemy)
  end
end

function love.update(dt)
  if not bg_music:isPlaying() and music_state then
    love.audio.play(bg_music)
    love.audio.setVolume(0.06)
    music_state = true
  end

  if state == 'play' then
    world:update(dt)
    map:update(dt)
    jump:update(dt)
    player:update(dt)
    for _, e in ipairs(enemies) do
      e:update(dt)
    end

    local cont = 1
    for _, c in ipairs(coins) do
      if collides(c, player, 15) then
        table.remove(coins, cont)
        player.score = player.score + 1
      end
      cont = cont + 1
    end

    for _, s in ipairs(spikes) do
      if collides(s, player, 10) and player.isDead == false then
        player.life = 0
      end
    end
  end
end

function love.draw()
  love.graphics.clear(71/255, 45/255, 60/255)
  love.graphics.setColor(1, 1, 1)

  if state == 'menu' then
    love.graphics.setFont(big_pixel)
    love.graphics.setColor(207/255, 198/255, 184/255)
    love.graphics.printf("Theo's Adventure", 0, window_height/3+50, window_width, 'center')
    love.graphics.setFont(normal_pixel)
    love.graphics.printf("Press SPACE to Play", 0, window_height/2+110, window_width, 'center')
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(crown, window_width/2, window_height/2-150, 0, 10, 10, 8, 8)
    love.graphics.setColor(207/255, 198/255, 184/255)
    love.graphics.setFont(small_pixel)
    love.graphics.printf('Joathan Mareto', window_width-190, window_height-45, 190, 'center')
    love.graphics.printf('Music: The White Lady (Hollow Knight)', 20, window_height-90, 600, 'left')
    love.graphics.printf('[M] to Mute or Unmute Music', 20, window_height-45, 500, 'left')
  elseif state == 'play' then
    push:start()
    cam:attach()

    map:draw()
    for _, c in ipairs(coins) do
      c:draw()
    end
    jump:draw()
    player:draw()
    for _, e in ipairs(enemies) do
      e:draw()
    end

    cam:lookAt(player.x+450, player.y+200)

    cam:detach()
    push:finish()

    if player.isDead then
      love.graphics.setFont(big_pixel)
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf("GAME OVER\nPress ENTER to Continue", 23, window_height/2-97, window_width-17, 'center')
      love.graphics.setColor(207/255, 198/255, 184/255)
      love.graphics.printf("GAME OVER\nPress ENTER to Continue", 20, window_height/2-100, window_width-20, 'center')
    end
  elseif state == 'won' then

  end
end

function love.keypressed(key)
  if key == 'w' then
    player:jump(1)
  elseif key == 'return' and state == 'play' and player.isDead then
    state = 'menu'
    player.isDead = false
    player.life = 3
    player.score = 0
    player.body:setX(100)
    player.body:setY(290)
    player.grounded = false
    player.direction = 1
    player.cur_animation = player.animations.idle
  elseif key == 'space' then
    state = 'play'
  elseif key == 'm' then
    if music_state then
      love.audio.pause(bg_music)
      music_state = false
    else
      love.audio.play(bg_music)
      music_state = true
    end
  end
end

-- Para as colisões com as moedas
function collides(a, b, c)
  if math.sqrt((a.y - b.y)^2 + (a.x - b.x)^2) <= c then
    return true
  end
  return false
end
