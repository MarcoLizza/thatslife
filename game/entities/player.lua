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

local Entity = require('game.entities.entity')
--local Animator = require('lib.animator')
local graphics = require('lib.graphics')
local soop = require('lib.soop')

-- MODULE DECLARATION ----------------------------------------------------------

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

local Player = soop.class(Entity)

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Player:initialize(parameters)
  local base = self:base()
  base.initialize(self, parameters)
  
  self.type = 'player'
  self.priority = 2
  self.radius = 8
  self.life = 1
end

function Player:update(dt)
end

function Player:draw()
  -- Find the facing point on the circle by casting the current position
  -- according to the heading angle.
  local cx, cy = unpack(self.position)
  local x, y = self:cast(self.radius)

  graphics.circle(cx, cy, self.radius, 'blue')
--  graphics.line(cx, cy, x, y, 'blue')
  graphics.circle(x, y , 2, 'yellow')
end

-- END OF MODULE ---------------------------------------------------------------

return Player

-- END OF FILE -----------------------------------------------------------------
