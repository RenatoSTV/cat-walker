function love.load()
  camera = require "libraries/camera"
  cam = camera()

  anim8 = require "libraries/anim8"
  love.graphics.setDefaultFilter("nearest", "nearest")

  sti = require "libraries/sti"
  gameMap = sti("maps/map.lua")

  player = {}
  player.x = 400
  player.y = 200
  player.speed = 4
  -- player.sprite = love.graphics.newImage("sprites/zero_sprite.png")
  player.spriteSheet = love.graphics.newImage("sprites/new_cat_spritesheet.png")
  player.grid = anim8.newGrid(64, 64, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

  player.animations = {}
  player.animations.up = anim8.newAnimation(player.grid("1-3", 1), 0.2)
  player.animations.down = anim8.newAnimation(player.grid("1-3", 3), 0.2)
  player.animations.left = anim8.newAnimation(player.grid("1-3", 4), 0.2)
  player.animations.right = anim8.newAnimation(player.grid("1-3", 2), 0.2)

  player.anim = player.animations.left

  background = love.graphics.newImage("sprites/background.png")
end

function love.update(dt)
  local isMoving = false

  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
    player.anim = player.animations.right
    isMoving = true
  end

  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed
    player.anim = player.animations.left
    isMoving = true
  end

  if love.keyboard.isDown("down") then
    player.y = player.y + player.speed
    player.anim = player.animations.down
    isMoving = true
  end

  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed
    player.anim = player.animations.up
    isMoving = true
  end

  if isMoving == false then
    player.anim:gotoFrame(1)
  end

  player.anim:update(dt)

  cam:lookAt(player.x, player.y)

  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  if cam.x < w/2 then
    cam.x = w/2
  end

  if cam.y < h/2 then
    cam.y = h/2
  end

  local mapW = gameMap.width * gameMap.tilewidth
  local mapH = gameMap.height * gameMap.tileheight

  if cam.x > (mapW - w/2) then
    cam.x = (mapW - w/2)
  end

  if cam.y > (mapH - h/2) then
    cam.y = (mapH - h/2)
  end
end

function love.draw()
  cam:attach()
  gameMap:drawLayer(gameMap.layers["Ground"])
  -- gameMap:drawLayer(gameMap.layers["Threes"])
  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 2, nil, 32, 32)
  cam:detach()
end
