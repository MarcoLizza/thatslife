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

local Player = require('game.entities.player')
local Smoke = require('game.entities.smoke')
local Bubble = require('game.entities.bubble')
local constants = require('game.constants')
local Entities = require('game.entities')
local Hud = require('game.hud')
local Scene = require('game.scene.scene')
local tweener = require('lib.tweener')

-- MODULE DECLARATION ----------------------------------------------------------

local world = {
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local SCENE = require('assets.data.scene')

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function world:initialize()
  self.width = constants.SCREEN_WIDTH
  self.height = constants.SCREEN_HEIGHT

  self.entities = Entities.new()
  self.entities:initialize()

  self.hud = Hud.new()
  self.hud:initialize()
end

function world:reset()
  -- Reload all the scene
  self.scenes = {}
  for _, params in ipairs(SCENE) do
    local scene = Scene.new()
    scene:initialize(params.age, params.callback)
    for _, layer in ipairs(params.layers) do
      scene:push(layer)
    end
    self.scenes[#self.scenes + 1] = scene
  end
  
  -- Reset the world "age" to zero. Also, pick the first scene as the current
  -- one and clear the "next" scene reference (will be detected automatically
  -- depending on the age)
  self.age = 0
  self.current = self.scenes[1]
  self.next = nil
  self.delta = 0

  -- Reset the entity manager and add the the player one at the center of the
  -- screen.
  self.entities:reset()
  local player = Player.new()
  player:initialize({
        position = { constants.SCREEN_WIDTH / 2, constants.SCREEN_HEIGHT / 2},
        angle = 0
      })
  self.entities:push(player)
  
  -- Reset the HUD state, too.
  self.hud:reset()
end

function world:input(keys, dt)
  self.delta = 0
  if keys.pressed['space'] then
    self.delta = 1
  end
end

function world:update(dt)
  -- We compute a "scaled" delta-time, in order not to move/update if
  -- the user is not interacting. The nice thing is that by changing the
  -- scaling value we can also control the speed of the game.
  local sdt = self.delta * dt

  -- We don't update the current age while fading between scenes. This doesn't
  -- make sense and render the thinks difficult.
  local progress = true
  
  if self.fader then
    local running = self.fader(sdt)
    if running then
      progress = false
    else
      self.fader = nil
      self.current = self.next
      self.next = nil
    end
  end

  if progress then
    -- Compute the next age according to the player input. It is more like a
    -- "distance".
    self.age = self.age + sdt

    -- Find the scene to which the current age/distance belongs to.
    local next = nil
    for _, scene in ipairs(self.scenes) do
      if scene.age > self.age then
        break
      end
      next = scene
    end
    
    -- If the current scene is different from the one we are moving to, create
    -- a linear tweener to fade to the next one.
    if self.current ~= next then
      next.alpha = 0 -- HACK!!!

      self.next = next
      self.fader = tweener.linear(1, function(ratio)
            self.next.alpha = ratio
            return ratio < 1
          end)
    end
  end

  -- Reverse the scroll direction to simulate movement
  local direction = 'none'
  if self.delta > 0 then
    direction = 'left'
  end

  self.current:scroll(direction)
  if self.next then
    self.next:scroll(direction)
  end

  self.current:update(sdt)
  if self.next then
    self.next:update(sdt)
  end

  self.entities:update(sdt)
  self.hud:update(sdt)
end

function world:draw()
  self.current:draw()
  if self.next then
    self.next:draw()
  end

  self.entities:draw()
  self.hud:draw()
end

-- END OF MODULE -------------------------------------------------------------

return world

-- END OF FILE ---------------------------------------------------------------
