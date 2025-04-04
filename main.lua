-- main.lua
local menu = require("menu")
local gameActive = false
local gameOver = false
local gameOverMessage = ""

-- Variáveis do jogo
local tableWidth, tableHeight = 600, 300
local tableX, tableY = (love.graphics.getWidth() - tableWidth) / 2, (love.graphics.getHeight() - tableHeight) / 2
local balls = {}

-- Variáveis do taco
local cue = {x = 0, y = 0, angle = 0, power = 0, maxPower = 500}
local isAiming = false
local score = 0
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
    if gameOver then
        drawGameOverScreen()
    elseif gameActive then
        drawTable()
        drawBalls()
        if isAiming then
            drawCue()
        end

        -- Exibir pontuação
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Pontuação: " .. score, 10, 10)
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
                if ball.type == "cue" then
                    -- Penalidade: bola branca encaçapada
                    foulOccurred = true
                    ball.x, ball.y = tableX + 100, tableY + tableHeight / 2
                    ball.vx, ball.vy = 0, 0
                elseif ball.type == "8" then
                    -- Regras para a bola 8
                    if areAllBallsPocketed() then
                        -- Jogador vence
                        print("Você venceu!")
                        gameOver = true
                        gameOverMessage = "Você venceu!"
                    else
                        -- Derrota por encaçapar a bola 8 antes
                        print("Você perdeu!")
                        gameOver = true
                        gameOverMessage = "Você perdeu!"
                    end
                else
                    -- Atualizar pontuação
                    score = score + 1
                    table.remove(balls, i)
                end
                break
            end
        end
    end
end

function drawGameOverScreen()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(gameOverMessage, 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")

    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2, 200, 50)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Jogar", 0, love.graphics.getHeight() / 2 + 15, love.graphics.getWidth(), "center")
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameOver then
        local buttonX = love.graphics.getWidth() / 2 - 100
        local buttonY = love.graphics.getHeight() / 2
        local buttonWidth = 200
        local buttonHeight = 50

        if x > buttonX and x < buttonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
            -- Reiniciar o jogo
            gameOver = false
            gameActive = false
            score = 0
            foulOccurred = false
            balls = {}
            menu.load()
        end
    elseif gameActive then
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

    -- Bola branca
    table.insert(balls, {
        x = tableX + 100,
        y = tableY + tableHeight / 2,
        radius = 10,
        color = {1, 1, 1},
        vx = 0,
        vy = 0,
        type = "cue" -- Bola branca
    })

    -- Configuração do triângulo
    local startX = tableX + tableWidth - 200 -- Posição inicial do triângulo
    local startY = tableY + tableHeight / 2
    local offset = 22 -- Espaço entre as bolas

    -- Tabela de bolas (tipo e cor)
    local ballSetup = {
        {"solid", {1, 0, 0}}, -- Lisa vermelha
        {"striped", {0, 0, 1}}, -- Listrada azul
        {"solid", {1, 0.5, 0}}, -- Lisa laranja
        {"striped", {0.5, 0, 0.5}}, -- Listrada roxa
        {"8", {0, 0, 0}}, -- Bola 8
        {"striped", {1, 1, 0}}, -- Listrada amarela
        {"solid", {0, 1, 0}}, -- Lisa verde
        {"striped", {0, 1, 1}}, -- Listrada ciano
        {"solid", {1, 0.5, 0.5}}, -- Lisa rosa
        {"striped", {0.5, 0.5, 1}}, -- Listrada lavanda
        {"solid", {1, 1, 0}}, -- Lisa amarela
        {"striped", {0.5, 1, 0.5}}, -- Listrada verde-claro
        {"solid", {1, 0.5, 1}}, -- Lisa magenta
        {"striped", {0.5, 0.5, 0}}, -- Listrada marrom
        {"solid", {1, 0, 0}}, -- Lisa branca
    }

    -- Gerar bolas em forma de triângulo
    local index = 1
    for row = 0, 4 do
        for col = 0, row do
            if index <= #ballSetup then
                local type, color = ballSetup[index][1], ballSetup[index][2]
                table.insert(balls, {
                    x = startX + row * offset,
                    y = startY + (col - row / 2) * offset,
                    radius = 10,
                    color = color,
                    vx = 0,
                    vy = 0,
                    type = type
                })
                index = index + 1
            end
        end
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

        ball.vx = ball.vx * 0.99
        ball.vy = ball.vy * 0.99
    end

    checkPockets()
    checkBallCollisions()
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

function areAllBallsPocketed()
    for _, ball in ipairs(balls) do
        if ball.type ~= "cue" and ball.type ~= "8" then
            return false
        end
    end
    return true
end
