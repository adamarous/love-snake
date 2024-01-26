Object = require 'classic'

Player = Object:extend()

function Player:new(x, y, speed, size)
    self.x = x or love.graphics.getWidth() / 2
    self.y = y or love.graphics.getHeight() / 2
    self.speed = speed or 100
    self.size = size or 50
end

Consumable = Object:extend()

function Consumable:new(type, x, y, size, speedIncrease)
    self.type = type
    self.x = x or 0
    self.y = y or 0
    self.size = size or 50
    self.speedIncrease = speedIncrease or 50
end