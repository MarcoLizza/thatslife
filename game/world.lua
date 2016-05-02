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
local Scene = require('game.scene.scene')
local tweener = require('lib.tweener')

-- MODULE DECLARATION ----------------------------------------------------------

local world = {
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local PARAMS = {
  {
    age = 0,
    callback = nil,
    layers = {
      {
        position = { 0, 0 },
        depth = 0,
        offset = 0,
        speed = 50,
        file = 'assets/S01L03.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 1,
        offset = 0,
        speed = 15,
        file = 'assets/S01L02.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 2,
        offset = 0,
        speed = 5,
        file = 'assets/S01L01.png',
        alpha = 1
      }
    }
  },
  {
    age = 5,
    callback = nil,
    layers =  {
      {
        position = { 0, 0 },
        depth = 0,
        offset = 0,
        speed = 50,
        file = 'assets/love2d.png',
        alpha = 1
      }
    }
  },
  {
    age = 10,
    callback = function() -- should pass an "alpha" argument, that is the relative scene age
        end,
    layers =  { }
  }
}

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function world:initialize()
  self.width = constants.SCREEN_WIDTH
  self.height = constants.SCREEN_HEIGHT

  self.entities = Entities.new()
  self.entities:initialize()
end

function world:reset()
  -- Reload all the scene
  self.scenes = {}
  for _, params in ipairs(PARAMS) do
    local scene = Scene.new()
    scene:initialize(params.age)
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

  -- Reset the entity manager and add the the player one at the center of the
  -- screen.
  self.entities:reset()
  local player = Player.new()
  player:initialize({
        position = { constants.SCREEN_WIDTH / 2, constants.SCREEN_HEIGHT / 2},
        angle = 0
      })
  self.entities:push(player)
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
  if delta < 0 then -- reverse the scroll direction to simulate movement
    direction = 'right'
  elseif delta > 0 then
    direction = 'left'
  end

  self.current:scroll(direction, dt)
  if self.next then
    self.next:scroll(direction, dt)
  end

  -- We don't update the current age while fading between scenes. This doesn't
  -- make sense and render the thinks difficult.
  if self.fader then
    return
  end

  -- Update the age according to the player input. It is more like a
  -- "distance".
  self.age = self.age + delta * dt

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
    self.next = next
    self.fader = tweener.linear(1, function(ratio)
          self.next.alpha = ratio
          self.current.alpha = 1 - ratio
          return nil
        end)
  end
end

function world:update(dt)
  if self.fader then
    local _, running = self.fader(dt)
    if not running then
      self.fader = nil
      self.current = self.next
      self.next = nil
    end
  end

  self.current:update(dt)
  if self.next then
    self.next:update(dt)
  end
  
  self.entities:update(dt)
end

function world:draw()
  self.current:draw()
  if self.next then
    self.next:draw()
  end

  self.entities:draw()
end

-- END OF MODULE -------------------------------------------------------------

return world

-- END OF FILE ---------------------------------------------------------------
