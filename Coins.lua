Coins = Class{}

function Coins:init(world, x, y)
  self.sprite = love.graphics.newImage('maps/coin.png')
  self.w = 16
  self.h = 16
  self.x = x
  self.y = y
end

function Coins:draw()
  love.graphics.draw(self.sprite, self.x, self.y)
end
