-- main.lua

-- default scaling filter for images
love.graphics.setDefaultFilter('nearest', 'nearest')

local snake = {}
local apple = {}
local gridSize = 20
local gameWidth = 400
local gameHeight = 400
local direction = 'right'
local nextDirection = direction
local snakeSpeed = 0.1
local timer = 0
local score = 0

function love.load()
    love.window.setTitle('Snake Game')
    love.window.setMode(gameWidth, gameHeight)
    resetGame()
end

function love.update(dt)
    timer = timer + dt
    if timer >= snakeSpeed then
        timer = 0
        updateSnake()
        checkCollision()
    end
    if direction ~= nextDirection then
        direction = nextDirection
    end
end

function love.draw()
    drawSnake()
    drawApple()
    love.graphics.print("Score: " .. score, 10, 10)
end

function love.keypressed(key)
    if key == 'up' and direction ~= 'down' then
        nextDirection = 'up'
    elseif key == 'down' and direction ~= 'up' then
        nextDirection = 'down'
    elseif key == 'left' and direction ~= 'right' then
        nextDirection = 'left'
    elseif key == 'right' and direction ~= 'left' then
        nextDirection = 'right'
    end
end

function updateSnake()
    local headX, headY = snake[1].x, snake[1].y
    if direction == 'up' then
        headY = headY - 1
    elseif direction == 'down' then
        headY = headY + 1
    elseif direction == 'left' then
        headX = headX - 1
    elseif direction == 'right' then
        headX = headX + 1
    end

    table.insert(snake, 1, {x = headX, y = headY})

    if headX == apple.x and headY == apple.y then
        score = score + 1
        spawnApple()
    else
        table.remove(snake)
    end
end

function checkCollision()
    local head = snake[1]

    -- wall collision
    if head.x < 0 or head.x >= gameWidth / gridSize or head.y < 0 or head.y >= gameHeight / gridSize then
        resetGame()
    end

    -- self collision
    for i = 2, #snake do
        if snake[i].x == head.x and snake[i].y == head.y then
            resetGame()
        end
    end
end

function drawSnake()
    -- ignore first value returned by ipairs, second value -> segment
    for _, segment in ipairs(snake) do
        love.graphics.rectangle('fill', segment.x * gridSize, segment.y * gridSize, gridSize, gridSize)
    end
end

function drawApple()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', apple.x * gridSize, apple.y * gridSize, gridSize, gridSize)
    love.graphics.setColor(1, 1, 1)
end

function spawnApple()
    apple.x = math.random(0, (gameWidth / gridSize) - 1)
    apple.y = math.random(0, (gameHeight / gridSize) - 1)

    -- Ensure apple doesn't spawn inside the snake
    for _, segment in ipairs(snake) do
        if segment.x == apple.x and segment.y == apple.y then
            spawnApple()
            break
        end
    end
end

function resetGame()
    snake = {
        {x = 5, y = 5},
        {x = 4, y = 5},
        {x = 3, y = 5}
    }
    direction = 'right'
    nextDirection = direction
    score = 0
    spawnApple()
end
