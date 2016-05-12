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
local Audio = require('lib.audio')
local graphics = require('lib.graphics')
local Tweener = require('lib.tween')

-- MODULE DECLARATION ----------------------------------------------------------

local game = {
  world = require('game.world'),
}

-- MODULE FUNCTIONS ------------------------------------------------------------

function game:initialize(environment)
  self.environment = environment

  self.tweener = Tweener.new()
  self.tweener:initialize()

  self.audio = Audio.new()
  self.audio:initialize({
      ['bgm'] = { file = 'assets/sounds/everyday.ogg', overlayed = false, looping = true, mode = 'stream' }
    })

  self.world:initialize()
end

function game:enter()
  self.world:reset()

  self.tweener:reset()
  
  -- Start the background music and create a tweener to fade in both the
  -- graphics and the audio.
  self.audio:play('bgm', 0)
  self.tweener:linear(5,
      function(ratio)
        love.audio.setVolume(ratio)
      end)

  --
  self.sequence = {
    { 'fade-in', 3, 255, function(ratio)
          self.alpha = math.floor((1 - ratio) * 255)
        end },
    { 'intro', 5, 255, nil },
    { 'intro-out', 5, 191, function(ratio)
          self.alpha = math.floor((1 - ratio) * 191)
        end },
    { 'running', 0, 255, nil }
  }
  self.sequence_index = 0
  self.sequence_move_to_next = true
end

function game:leave()
  self.audio:halt()
end

function game:input(keys, dt)
  self.world:input(keys, dt)
end

function game:update(dt)
  self.tweener:update(dt)

  self.audio:update(dt)

  self.world:update(dt)
  
  --
  if self.sequence_move_to_next and self.sequence_index < #self.sequence then
    self.sequence_index = self.sequence_index + 1
    local state, timeout, alpha, on_update = unpack(self.sequence[self.sequence_index])
    self.state = state
    self.alpha = alpha
    self.sequence_move_to_next = false
    self.tweener:linear(timeout,
        function(ratio)
          if on_update then
            on_update(ratio)
          end
        end,
        function()
          self.sequence_move_to_next = true
        end)
  end

  --
  if self.world.state == 'finishing' then
    self.world.state = 'finished'
    
    self.state = 'fade-out'
    self.alpha = 0
    self.tweener:linear(10,
        function(ratio)
          self.alpha = math.floor(ratio * 255)
          love.audio.setVolume(1 - ratio)
        end,
        function()
          self.state = 'done'
        end)
  end
  
  return nil
end

function game:draw()
  self.world:draw()

  if self.state == 'fade-in' or self.state == 'intro' then
    graphics.fill('black', 191)
    graphics.text('THE TRIP',
      constants.SCREEN_RECT, 'retro-computer', 'white', 'center', 'middle', 2, 191)
  elseif self.state == 'intro-out' then
    graphics.fill('black', self.alpha)
    graphics.text('THE TRIP',
      constants.SCREEN_RECT, 'retro-computer', 'white', 'center', 'middle', 2, self.alpha)
  elseif self.state == 'done' then
    graphics.fill('black')
    graphics.text('THE END',
      constants.SCREEN_RECT, 'retro-computer', 'white', 'center', 'middle', 2)
  end

  -- Fade the display if needed, by overlapping a translucent black rectangle.
  if self.state == 'fade-in' then
    graphics.fill('black', self.alpha)
  elseif self.state == 'intro' then
  elseif self.state == 'intro-out' then
  elseif self.state == 'running' then
  elseif self.state == 'fade-out' then
    graphics.fill('black', self.alpha)
  elseif self.state == 'done' then
  end

  love.graphics.setColor(255, 255, 255)
end

-- END OF MODULE ---------------------------------------------------------------

return game

-- END OF FILE -----------------------------------------------------------------
