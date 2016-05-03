--[[

Copyright (c) 2016 by Marco Lizza (marco.lizza@gmail.com)

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

]]--

-- MODULE INCLUSIONS -----------------------------------------------------------

local constants = require('game.constants')
local graphics = require('lib.graphics')

-- MODULE DECLARATION ----------------------------------------------------------

local Hud = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Hud.__index = Hud

function Hud.new()
  local self = setmetatable({}, Hud)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

local PHRASES = require('assets.data.phrases')

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- 'idle', 'fade-in', 'display', 'fade-out'

local offset(rectangle, ox, oy)
  local left, top, right, bottom = unpack(rectangle)
  left = left + ox
  top = top + oy
  right = right - ox
  bottom = bottom - oy
  return { left, top, right, bottom }
end

-- MODULE FUNCTIONS ------------------------------------------------------------

function Hud:initialize()
  self.message = nil
  self.state = nil
  self.position = nil
  self.canvas = love.graphics.newCanvas(math.floor(constants.SCREEN_WIDTH * 0.33), math.floor(constants.SCREEN_HEIGHT * 0.5))
end

function Hud:update(dt)
--  self.x = nil
--  self.y = nil
--  self.width = math.max(constants.SCREEN_WIDTH / 2, text_width)
--  self.height = math.max(constants.SCREEN_HEIGHT / 4, text_height)
--  width, height = graphics.measure(message)
end

function Hud:draw()
  if not self.message then
    return
  end

  love.graphics.setCanvas(self.canvas)
  graphics.frame(0, 0, width, height, {}, 255, 2, 4)
  graphics.text(message, offset(self.position, 4, 4),
      'retro-computer', 'yellow', 'left', 'top')
  love.graphics.setCanvas()
  
  love.graphics.setScissor(x, y, width, height)
  love.graphics.setColor(255, 255, 255, alpha)
  love.graphics.draw(self.canvas, x, y)
  love.graphics.setScissor()
end

function Hud:control(direction)
  self.direction = direction
end

-- END OF MODULE ---------------------------------------------------------------

return Hud

-- END OF FILE -----------------------------------------------------------------
