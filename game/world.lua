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
local Scene = require('game.scene.scene')

-- MODULE DECLARATION ----------------------------------------------------------

local world = {
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local PARAMS = {
  {
    depth = 0,
    offset = 0,
    speed = 10,
    file = 'assets/1gam.png',
    alpha = 0.5
  },
  {
    depth = 1,
    offset = 0,
    speed = 5,
    file = 'assets/1gam.png',
    alpha = 0.5
  },
  {
    depth = 2,
    offset = 0,
    speed = 0,
    file = 'assets/love2d.png',
    alpha = 1
  },
}

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function world:initialize()
  self.width = constants.SCREEN_WIDTH
  self.height = constants.SCREEN_HEIGHT

  self.scene = Scene.new()
  self.scene:initialize()
end

function world:reset()
  self.scene:reset()
  for _, params in ipairs(PARAMS) do
    self.scene:push(params)
  end
end

function world:input(keys, dt)
  local delta = 0
  if keys.pressed['left'] then
    delta = delta - 1
  end
  if keys.pressed['right'] then
    delta = delta + 1
  end

  local direction = 'none'
  if delta > 0 then
    direction = 'right'
  elseif delta < 0 then
    direction = 'left'
  end

  self.scene:scroll(direction, dt)
end

function world:update(dt)
  self.scene:update(dt)
end

function world:draw()
  self.scene:draw()
end

-- END OF MODULE -------------------------------------------------------------

return world

-- END OF FILE ---------------------------------------------------------------
