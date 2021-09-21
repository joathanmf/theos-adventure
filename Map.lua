Map = Class{}

function Map:init(world)
  self.world = world
  self.solids = {}
  self.game_map = sti('maps/map.lua')
  self:create_solids()
end

function Map:update(dt)
  self.game_map:update(dt)
end

function Map:draw()
  self.game_map:drawLayer(self.game_map.layers['Tile Layer 1'])
end

function Map:create_solids()
  local solid
  for _, obj in ipairs(self.game_map.layers['Solids'].objects) do
    solid = self.world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height, {collision_class = 'Solids'})
    solid:setType('static')
    table.insert(self.solids, solid)
  end
end
