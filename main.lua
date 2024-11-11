-- main.lua
local menu = require("menu")
local gameActive = false

-- Variáveis do jogo
local tableWidth, tableHeight = 600, 300
local tableX, tableY = (love.graphics.getWidth() - tableWidth) / 2, (love.graphics.getHeight() - tableHeight) / 2
local balls = {}  -- Tabela para armazenar as bolas

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
        drawTable()  -- Desenhar a mesa de sinuca
        drawBalls()  -- Desenhar as bolas na mesa
    else
        menu.draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameActive then
        hitCueBall(x, y)  -- Acertar a bola branca
    else
        menu.mousepressed(x, y)
    end
end

function startGame()
    gameActive = true
    setupBalls()  -- Configurar as bolas para o início do jogo
end

-- Função para configurar as bolas
function setupBalls()
    balls = {}

    -- Bola branca
    table.insert(balls, {x = tableX + 100, y = tableY + tableHeight / 2, radius = 10, color = {1, 1, 1}, vx = 0, vy = 0})

    -- Bolas coloridas (simplesmente colocadas em uma linha para simplificar)
    for i = 1, 7 do
        table.insert(balls, {
            x = tableX + 300 + (i * 20),
            y = tableY + tableHeight / 2,
            radius = 10,
            color = {1, 0, 0},  -- Cor vermelha para as bolas
            vx = 0,
            vy = 0
        })
    end
end

-- Função para desenhar a mesa de sinuca
function drawTable()
    local borderWidth = 20
    local holeRadius = 15

    -- Fundo da mesa
    love.graphics.setColor(0, 0.5, 0)
    love.graphics.rectangle("fill", tableX, tableY, tableWidth, tableHeight)

    -- Bordas da mesa
    love.graphics.setColor(0.5, 0.25, 0)
    love.graphics.rectangle("fill", tableX - borderWidth, tableY, borderWidth, tableHeight)  -- Esquerda
    love.graphics.rectangle("fill", tableX + tableWidth, tableY, borderWidth, tableHeight)   -- Direita
    love.graphics.rectangle("fill", tableX - borderWidth, tableY - borderWidth, tableWidth + borderWidth * 2, borderWidth) -- Topo
    love.graphics.rectangle("fill", tableX - borderWidth, tableY + tableHeight, tableWidth + borderWidth * 2, borderWidth) -- Base

    -- Buracos da mesa
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

-- Função para desenhar as bolas
function drawBalls()
    for _, ball in ipairs(balls) do
        love.graphics.setColor(ball.color)
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    end
end

-- Função para atualizar a física das bolas
function updateBalls(dt)
    for _, ball in ipairs(balls) do
        -- Atualizar posição
        ball.x = ball.x + ball.vx * dt
        ball.y = ball.y + ball.vy * dt

        -- Colisão com as bordas
        if ball.x - ball.radius < tableX or ball.x + ball.radius > tableX + tableWidth then
            ball.vx = -ball.vx
        end
        if ball.y - ball.radius < tableY or ball.y + ball.radius > tableY + tableHeight then
            ball.vy = -ball.vy
        end

        -- Atrito para desacelerar a bola
        ball.vx = ball.vx * 0.98
        ball.vy = ball.vy * 0.98
    end
end

-- Função para acertar a bola branca
function hitCueBall(x, y)
    local cueBall = balls[1]  -- Assumimos que a primeira bola é a bola branca
    local dx, dy = x - cueBall.x, y - cueBall.y
    local distance = math.sqrt(dx * dx + dy * dy)

    -- Aplique uma força para mover a bola branca
    local force = 200
    cueBall.vx = (dx / distance) * force
    cueBall.vy = (dy / distance) * force
end
