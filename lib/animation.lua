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

-- MODULE DECLARATION ----------------------------------------------------------

local Animation = {
  _VERSION = '0.1.0'
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Animation.__index = Animation

function Animation.new()
  local self = setmetatable({}, Animation)
  return self
end

-- MODULE FUNCTIONS ------------------------------------------------------------

function Animation:initialize(image, frame_width, frame_height, offset, count)
  offset = offset or 0
  count = count or math.huge

  -- The frames are organized in the sheet in row-by-colums fashion,
  -- so we can get dynamically the amount of tiles with a couple of
  -- simple division.
  local columns = math.floor(image:getWidth() / frame_width)
  local rows = math.floor(image:getHeight() / frame_height)
  local quads = {}
  for i = 1, rows do
    for j = 1, columns do
      if offset <= 0 then
        quads[#quads + 1] = love.graphics.newQuad((j - 1) * frame_width, (i - 1) * frame_height,
          frame_width, frame_height, image:getWidth(), image:getHeight())
      end
      
      offset = offset - 1
    
      count = count - 1
      if count <= 0 then
        break
      end
    end
  end
  
  self.image = image
  self.quads = quads
  
  self.period = 1 / 50
  self.mode = 'cycle'
  
  self:reset()
end

function Animation:configure(frequency, mode)
  self.period = frequency and (1 / frequency) or self.period
  self.mode = mode or self.mode
end

function Animation:reset()
  self.index = 1 -- FIXME: could depend on the animation mode
  self.elapsed = 0
  self.running = true
end

function Animation:update(dt)
  if not self.running then
    return
  end
  
  self.elapsed = self.elapsed + dt
  while self.elapsed > self.period do
    self.index = (self.index % #self.quads) + 1 -- move to next, damned 1-indices!
    self.elapsed = self.elapsed - self.period
  end
end

function Animation:draw(...)
  local quad = self.quads[self.index]
  love.graphics.draw(self.image, quad, ...)
end

function Animation:suspend()
  self.running = false
end

function Animation:resume()
  self.running = true
end

function Animation:seek(index)
  if index >= 1 and index <= #self.quads then
    self.index = index
  end
end

-- END OF MODULE ---------------------------------------------------------------

return Animation

-- END OF FILE -----------------------------------------------------------------
