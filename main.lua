-- main.lua
local menu = require("menu")
local gameActive = false

-- Variáveis do jogo
local tableWidth, tableHeight = 600, 300
local tableX, tableY = (love.graphics.getWidth() - tableWidth) / 2, (love.graphics.getHeight() - tableHeight) / 2
local balls = {}

function love.load()
    menu.load()
end

function love.update(dt)
    if gameActive then
        updateBalls(dt)  -- Atualizar a física das bolas
    else
        menu.update(dt)
    end
end

function love.draw()
    if gameActive then
        drawTable()
        drawBalls()
    else
        menu.draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameActive then
        hitCueBall(x, y)
    else
        menu.mousepressed(x, y)
    end
end

function startGame()
    gameActive = true
    setupBalls()
end

function setupBalls()
    balls = {}
    table.insert(balls, {x = tableX + 100, y = tableY + tableHeight / 2, radius = 10, color = {1, 1, 1}, vx = 0, vy = 0})

    for i = 1, 7 do
        table.insert(balls, {
            x = tableX + 300 + (i * 20),
            y = tableY + tableHeight / 2,
            radius = 10,
            color = {1, 0, 0},
            vx = 0,
            vy = 0
        })
    end
end

function drawTable()
    local borderWidth = 20
    local holeRadius = 15

    love.graphics.setColor(0, 0.5, 0)
    love.graphics.rectangle("fill", tableX, tableY, tableWidth, tableHeight)

    love.graphics.setColor(0.5, 0.25, 0)
    love.graphics.rectangle("fill", tableX - borderWidth, tableY, borderWidth, tableHeight)
    love.graphics.rectangle("fill", tableX + tableWidth, tableY, borderWidth, tableHeight)
    love.graphics.rectangle("fill", tableX - borderWidth, tableY - borderWidth, tableWidth + borderWidth * 2, borderWidth)
    love.graphics.rectangle("fill", tableX - borderWidth, tableY + tableHeight, tableWidth + borderWidth * 2, borderWidth)

    love.graphics.setColor(0, 0, 0)
    local holes = {
        {x = tableX, y = tableY},
        {x = tableX + tableWidth / 2, y = tableY},
        {x = tableX + tableWidth, y = tableY},
        {x = tableX, y = tableY + tableHeight},
        {x = tableX + tableWidth / 2, y = tableY + tableHeight},
        {x = tableX + tableWidth, y = tableY + tableHeight}
    }
    for _, hole in ipairs(holes) do
        love.graphics.circle("fill", hole.x, hole.y, holeRadius)
    end
end

function drawBalls()
    for _, ball in ipairs(balls) do
        love.graphics.setColor(ball.color)
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    end
end

function updateBalls(dt)
    for i, ball in ipairs(balls) do
        ball.x = ball.x + ball.vx * dt
        ball.y = ball.y + ball.vy * dt

        if ball.x - ball.radius < tableX or ball.x + ball.radius > tableX + tableWidth then
            ball.vx = -ball.vx
        end
        if ball.y - ball.radius < tableY or ball.y + ball.radius > tableY + tableHeight then
            ball.vy = -ball.vy
        end

        ball.vx = ball.vx * 0.98
        ball.vy = ball.vy * 0.98
    end

    checkBallCollisions()
end

function hitCueBall(x, y)
    local cueBall = balls[1]
    local dx, dy = x - cueBall.x, y - cueBall.y
    local distance = math.sqrt(dx * dx + dy * dy)

    local force = 200
    cueBall.vx = (dx / distance) * force
    cueBall.vy = (dy / distance) * force
end

-- Função para verificar colisões entre bolas
function checkBallCollisions()
    for i = 1, #balls - 1 do
        for j = i + 1, #balls do
            local ball1 = balls[i]
            local ball2 = balls[j]
            local dx, dy = ball2.x - ball1.x, ball2.y - ball1.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance < ball1.radius + ball2.radius then
                -- Calcula as velocidades após a colisão
                local nx, ny = dx / distance, dy / distance
                local p = 2 * (ball1.vx * nx + ball1.vy * ny - ball2.vx * nx - ball2.vy * ny) / 2

                ball1.vx = ball1.vx - p * nx
                ball1.vy = ball1.vy - p * ny
                ball2.vx = ball2.vx + p * nx
                ball2.vy = ball2.vy + p * ny
            end
        end
    end
end
