Jump = Class{}
anim8 = require 'lib/anim8'

function Jump:init()
  self.spritesheet = love.graphics.newImage('maps/jump.png')
  self.w = 16
  self.h = 16
  self.x = 528
  self.y = 368
  self.jump = false
  g = anim8.newGrid(self.w, self.h, self.spritesheet:getWidth(), self.spritesheet:getHeight())
  self.animations = {}
  self.animations.idle = anim8.newAnimation(g('1-1', 1), 0.1)
  self.animations.jump = anim8.newAnimation(g('1-3', 1), 0.1)
  self.animations.pmuj = anim8.newAnimation(g('3-1', 1), 0.5)
  self.cur_animation = self.animations.idle
end

function Jump:update(dt)
  if collides(self, player, 10) and self.jump == false then
    player:jump(1)
    self.cur_animation = self.animations.jump
    self.jump = true
    self.cur_animation = self.animations.pmuj
    self.jump = false
  else
    self.cur_animation = self.animations.idle
  end

  self.cur_animation:update(dt)
end

function Jump:draw()
  self.cur_animation:draw(self.spritesheet, self.x, self.y)
end
