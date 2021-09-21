Player = Class{}
anim8 = require 'lib/anim8'

function Player:init(world)
  self.spritesheet = love.graphics.newImage('player/Adventurer Sprite Sheet.png')
  self.w = self.spritesheet:getWidth()/13
  self.h = self.spritesheet:getHeight()/16
  self.cw = self.w - 15
  self.x = 100
  self.y = 290
  self.speed = 100
  self.grounded = false
  self.direction = 1
  self.score = 0
  self.isDead = false
  g = anim8.newGrid(self.w, self.h, self.spritesheet:getWidth(), self.spritesheet:getHeight())
  self.animations = {}
  self.animations.idle = anim8.newAnimation(g('1-13', 1), 0.1)
  self.animations.run = anim8.newAnimation(g('1-8', 2), 0.1)
  self.animations.jump = anim8.newAnimation(g('3-5', 6), 0.2)
  self.animations.hit = anim8.newAnimation(g('1-4', 7), 0.2)
  self.animations.dead = anim8.newAnimation(g('1-7', 8), 0.1)
  self.cur_animation = self.animations.idle
  self.body = world:newBSGRectangleCollider(self.x, self.y, self.cw, self.h-10, 1)
  self.body:setFixedRotation(true)
end

function Player:update(dt)
  if not self.isDead then
    self.x, self.y = self.body:getPosition()

    if love.keyboard.isDown('a') then
      self.x = self.x - self.speed * dt
      self.cur_animation = self.animations.run
      self.direction = -1
    elseif love.keyboard.isDown('d') then
      self.x = self.x + self.speed * dt
      self.cur_animation = self.animations.run
      self.direction = 1
    else
      self.cur_animation = self.animations.idle
    end

    if self.grounded == false then
      self.cur_animation = self.animations.jump
    end

    self.body:setX(self.x)

    colliders = world:queryRectangleArea(self.x-self.cw/2+2, self.y+self.h/2-5, self.cw-5, 1, {'Solids'})

    if #colliders > 0 then
      self.grounded = true
    else
      self.grounded = false
    end

    self.cur_animation:update(dt)
  end
end

function Player:draw()
  if not self.isDead then
    self.cur_animation:draw(self.spritesheet, self.body:getX(), self.body:getY()-5, 0, self.direction, 1, self.w/2, self.h/2-1)
  end
end

function Player:jump(force)
  if self.grounded and not self.isDead then
    self.body:applyLinearImpulse(0, -250*force)
  end
end
