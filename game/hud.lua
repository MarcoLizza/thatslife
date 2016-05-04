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
local utils = require('lib.utils')

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
    local w, h = graphics.measure(line, face)
    width = math.max(width, w)
    height = math.max(height, h)
  end
  return width, height
end

-- MODULE FUNCTIONS ------------------------------------------------------------

function Hud:initialize()
  self:reset()
end

function Hud:reset()
  self.message = nil
  self.time = 0
  self.delay = 10
  self.index = 0
end

function Hud:update(dt)
  -- A message is currently displayed, so just advance it's relative ticker.
  if self.message then
    self.message.time = self.message.time + dt
    return
  end

  -- Update the message ticker, bailing out while the needed amount of delay
  -- is not reached. Otherwise, continue by clearing the counter.
  self.time = self.time + dt
  if self.time <= self.delay then
    return
  end
  self.time = 0

  -- Pick the next message from the clump.
  self.index = utils.forward(self.index, TEXTS)
  local text = TEXTS[self.index]

  -- Compute the message size and pick a random screen position for it.
  local width, height = measure(text, 'silkscreen')
  local x, y = love.math.random(constants.SCREEN_WIDTH - width), love.math.random(constants.SCREEN_HEIGHT - height)

  -- Create the message "object".
  self.message = {
    text = text,
    face = 'silkscreen',
    color = 'white',
    position = { x, y },
    size = { width, height },
    state = 'fade-in',
    fading_time = 3,
    idle_time = 10,
    time = 0
  }
end

function Hud:draw()
  local message = self.message  
  if not message then
    return
  end
  
  local alpha = nil
  if message.state == 'fade-in' then
    alpha = message.time / message.fading_time
    
    if message.time >= message.fading_time then
      message.time = 0
      message.state = 'idle'
    end
  elseif message.state == 'idle' then
    alpha = 1.0
  
    if message.time >= message.idle_time then
      message.time = 0
      message.state = 'fade-out'
    end
  elseif message.state == 'fade-out' then
    alpha = message.time / message.fading_time
    alpha = 1 - alpha
  
    if message.time >= message.fading_time then
      message.time = 0
      message.state = 'done'
    end
  elseif message.state == 'done' then
    self.message = nil
  end

  if alpha then
    local x, y = unpack(message.position)
    for _, line in ipairs(message.text) do
      local width, height = graphics.measure(line, 'silkscreen')
      graphics.text(line, { x, y, x + width, y + height },
          'silkscreen', 'white', 'left', 'top', 1, math.floor(alpha * 255))
      y = y + height
    end
  end
end

function Hud:control(direction)
  self.direction = direction
end

-- END OF MODULE ---------------------------------------------------------------

return Hud

-- END OF FILE -----------------------------------------------------------------
