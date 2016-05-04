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

local TEXTS = require('assets.data.texts')

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- 'idle', 'fade-in', 'display', 'fade-out'

local function offset(rectangle, ox, oy)
  local left, top, right, bottom = unpack(rectangle)
  left = left + ox
  top = top + oy
  right = right - ox
  bottom = bottom - oy
  return { left, top, right, bottom }
end

local function rectangle(position, size)
  local x, y = unpack(position)
  local width, height = unpack(size)
  return { x, y, x + width, y + height }
end

-- Scan the message content, line by line, and compute the minimum containing
-- rectangle.
local function measure(lines, face)
  local width, height = 0, 0
  for _, line in ipairs(lines) do
    local w, h = graphics.measure(face, line)
    width = math.max(width, w)
    height = math.max(width, h)
  end
  return width, height
end

-- MODULE FUNCTIONS ------------------------------------------------------------

function Hud:initialize()
  self.message = nil
  self.state = nil
end

function Hud:update(dt)
  -- Pick the next message from the clump.
  self.index = utils.forward(self.index, TEXTS)
  local text = TEXTS[self.index]

  -- Compute the message size and pick a random screen position for it.
  local width, height = measure(text, 'retro-computer')
  local x, y = love.math.random(constants.SCREEN_WIDTH - width), love.math.random(constants.SCREEN_HEIGHT - height)

  --
  self.message = {
    text = text,
    face = 'retro-computer',
    position = { x, y },
    size = { width, height },
  }
end

function Hud:draw()
  if not self.message then
    return
  end

  graphics.text(self.message.text, rectangle(self.message.position, self.message.size),
      'retro-computer', 'white', 'left', 'top')
end

function Hud:control(direction)
  self.direction = direction
end

-- END OF MODULE ---------------------------------------------------------------

return Hud

-- END OF FILE -----------------------------------------------------------------
