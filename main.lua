-- main.lua
local menu = require("menu")
local gameActive = false

-- Variáveis do jogo
local tableWidth, tableHeight = 600, 300
local tableX, tableY = (love.graphics.getWidth() - tableWidth) / 2, (love.graphics.getHeight() - tableHeight) / 2
local balls = {}

-- Variáveis do taco
local cue = {x = 0, y = 0, angle = 0, power = 0, maxPower = 500}
local isAiming = false
local currentPlayer = 1
local scores = {0, 0}
local foulOccurred = false

function love.load()
    menu.load()
end

function love.update(dt)
    if gameActive then
        updateBalls(dt)
        if isAiming then
            updateCue()
        end
    else
        menu.update(dt)
    end
end

function love.draw()
    if gameActive then
        drawTable()
        drawBalls()
        if isAiming then
            drawCue()
        end

        -- Exibir pontuação
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Jogador 1: " .. scores[1], 10, 10)
        love.graphics.print("Jogador 2: " .. scores[2], 10, 30)
        love.graphics.print("Turno do Jogador " .. currentPlayer, 10, 50)
    else
        menu.draw()
    end
end

-- Função para verificar se a bola foi encaçapada
function checkPockets()
    local holes = {
        {x = tableX, y = tableY},
        {x = tableX + tableWidth / 2, y = tableY},
        {x = tableX + tableWidth, y = tableY},
        {x = tableX, y = tableY + tableHeight},
        {x = tableX + tableWidth / 2, y = tableY + tableHeight},
        {x = tableX + tableWidth, y = tableY + tableHeight}
    }

    for i = #balls, 1, -1 do
        local ball = balls[i]
        for _, hole in ipairs(holes) do
            local dx, dy = ball.x - hole.x, ball.y - hole.y
            local distance = math.sqrt(dx * dx + dy * dy)
            if distance < 15 then
                if i == 1 then -- Se a bola encaçapada for a branca
                    foulOccurred = true
                    -- Reposicionar a bola branca no centro da mesa
                    ball.x = tableX + 100
                    ball.y = tableY + tableHeight / 2
                    ball.vx, ball.vy = 0, 0
                else
                    scores[currentPlayer] = scores[currentPlayer] + 1
                    table.remove(balls, i)
                end
                break
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameActive then
        if button == 1 then
            startAiming(x, y)
        end
    else
        menu.mousepressed(x, y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if gameActive then
        if button == 1 and isAiming then
            shootCueBall()
        end
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
    local ballsMoving = false

    for i, ball in ipairs(balls) do
        ball.x = ball.x + ball.vx * dt
        ball.y = ball.y + ball.vy * dt

        if ball.vx ~= 0 or ball.vy ~= 0 then
            ballsMoving = true
        end

        if ball.x - ball.radius < tableX or ball.x + ball.radius > tableX + tableWidth then
            ball.vx = -ball.vx
        end
        if ball.y - ball.radius < tableY or ball.y + ball.radius > tableY + tableHeight then
            ball.vy = -ball.vy
        end

        ball.vx = ball.vx * 0.99
        ball.vy = ball.vy * 0.99
    end

    checkPockets()

    -- Só troca de turno quando ocorre uma falta
    if foulOccurred == true then
        foulOccurred = false -- Limpa a falta para o próximo turno
        switchTurn()
        
       
    end

    checkBallCollisions()
end

-- Função para alternar o turno
function switchTurn()
    currentPlayer = 3 - currentPlayer
end

function updateCue()
    local cueBall = balls[1]
    local mx, my = love.mouse.getPosition()
    cue.angle = math.atan2(my - cueBall.y, mx - cueBall.x)
    cue.power = math.min(cue.maxPower, math.sqrt((mx - cueBall.x)^2 + (my - cueBall.y)^2))
end

function drawCue()
    local cueBall = balls[1]
    love.graphics.setColor(0.8, 0.5, 0.3)
    love.graphics.push()
    love.graphics.translate(cueBall.x, cueBall.y)
    love.graphics.rotate(cue.angle)
    love.graphics.rectangle("fill", -cue.power, -2, cue.power, 4)
    love.graphics.pop()
end

function startAiming(x, y)
    local cueBall = balls[1]
    local dx, dy = x - cueBall.x, y - cueBall.y
    if math.sqrt(dx * dx + dy * dy) < cueBall.radius * 2 then
        isAiming = true
    end
end

function shootCueBall()
    local cueBall = balls[1]
    cueBall.vx = cue.power * math.cos(cue.angle)
    cueBall.vy = cue.power * math.sin(cue.angle)
    isAiming = false
    cue.power = 0
end

function checkBallCollisions()
    for i = 1, #balls - 1 do
        for j = i + 1, #balls do
            local ball1 = balls[i]
            local ball2 = balls[j]
            local dx, dy = ball2.x - ball1.x, ball2.y - ball1.y
            local distance = math.sqrt(dx * dx + dy * dy)
            local minDistance = ball1.radius + ball2.radius

            -- Verifica se as bolas estão colidindo
            if distance < minDistance then
                -- Normaliza a direção da colisão
                local nx, ny = dx / distance, dy / distance
                local overlap = minDistance - distance

                -- Move as bolas para fora uma da outra proporcionalmente
                ball1.x = ball1.x - nx * overlap / 2
                ball1.y = ball1.y - ny * overlap / 2
                ball2.x = ball2.x + nx * overlap / 2
                ball2.y = ball2.y + ny * overlap / 2

                -- Calcula a troca de velocidade usando a direção normal
                local p = 2 * (ball1.vx * nx + ball1.vy * ny - ball2.vx * nx - ball2.vy * ny) / 2

                ball1.vx = ball1.vx - p * nx
                ball1.vy = ball1.vy - p * ny
                ball2.vx = ball2.vx + p * nx
                ball2.vy = ball2.vy + p * ny
            end
        end
    end
end
