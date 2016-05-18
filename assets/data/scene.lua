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

return {
  {
    age = 0,
    callback = nil,
    layers = {
      {
        position = { 0, 0 },
        depth = 0,
        offset = 0,
        speed = 50,
        file = 'assets/S01L07.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 1,
        offset = 0,
        speed = 45,
        file = 'assets/S01L06.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 2,
        offset = 0,
        speed = 35,
        file = 'assets/S01L05.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 3,
        offset = 0,
        speed = 15,
        file = 'assets/S01L04.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 4,
        offset = 0,
        speed = 1,
        file = 'assets/S01L03.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 5,
        offset = 0,
        speed = 0.1,
        file = 'assets/S01L02.png',
        alpha = 1
      },
      {
        position = { 0, 0 },
        depth = 6,
        offset = 0,
        speed = 0,
        file = 'assets/S01L01.png',
        alpha = 1
      }
    }
  },
  {
    age = 30,
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
    age = 60,
    callback = function() -- should pass an "alpha" argument, that is the relative scene age
        end,
    layers =  { }
  }
}