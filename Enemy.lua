Enemy = Class{}

function Enemy:init(world, x, y)
  self.spritesheet = love.graphics.newImage('maps/enemy.png')
  self.w = 16
  self.h = 16
  self.x = x
  self.y = y
  self.speed = 25
  self.direction = -1
  g = anim8.newGrid(self.w, self.h, self.spritesheet:getWidth(), self.spritesheet:getHeight())
  self.animations = {}
  self.animations.walk = anim8.newAnimation(g('1-4', 2), 0.2)
  self.body = world:newCircleCollider(self.x, self.y, 8)
  self.body:setFixedRotation(true)
end

function Enemy:update(dt)
  for _, le in ipairs(lim_enemy) do
    if collides(self, le, 10) then
      self.direction = self.direction * -1
    end
  end

  self.x = self.x + self.speed * dt * self.direction
  self.body:setX(self.x)

  self.animations.walk:update(dt)

  if self.body:enter('Player') then
    player.life = player.life - 1
    player.cur_animation = player.animations.hit
    player.body:applyLinearImpulse(-130*player.direction, -130)
  end
end

function Enemy:draw()
  self.animations.walk:draw(self.spritesheet, self.body:getX(), self.body:getY(), 0, self.direction, 1, self.w/2, self.h/2)
end
