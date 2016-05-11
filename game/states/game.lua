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
  local bgm = self.audio:play('bgm', 0)
  self.tweener:linear(5,
      function(ratio)
        bgm:setVolume(ratio)
      end)

  self.state = 'fade-in'
  self.alpha = 255
  self.tweener:linear(3,
      function(ratio)
        self.alpha = math.floor((1 - ratio) * 255)
      end,
      function()
        self.state = 'intro'
        self.tweener:linear(5,
            function(ratio)
            end,
            function()
              self.state = 'intro-out'
              self.alpha = 191
              self.tweener:linear(5,
                  function(ratio)
                    self.alpha = math.floor((1 - ratio) * 191)
                  end,
                  function()
                    self.state = 'running'
                  end)
            end)
      end)
end

function game:leave()
  self.audio:halt('bgm')
end

function game:input(keys, dt)
  self.world:input(keys, dt)
end

function game:update(dt)
  self.tweener:update(dt)

  self.audio:update(dt)

  self.world:update(dt)
  
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
