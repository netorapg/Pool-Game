-- modules/cueManager.lua

local cueManager = {
    isAiming   = false,
    gameState  = nil,
    ballManager = nil,

    -- Parâmetros de mira
    aimStart = { x = 0, y = 0 },
    aimEnd   = { x = 0, y = 0 },
    maxPower = 500    -- distância máxima para power
}

function cueManager.initialize(gs, bm)
    cueManager.gameState   = gs
    cueManager.ballManager = bm
end

function cueManager.update(dt)
    -- Aqui poderia animar algo, se quiser
end

-- Esta é a função chamada pelo main.lua
function cueManager.draw()
    if not cueManager.isAiming then return end

    local ball = cueManager.ballManager.getCueBall()
    love.graphics.setLineWidth(2)
    love.graphics.setColor(1, 1, 1)

    -- Calcula posição atual do mouse
    local mx, my = love.mouse.getPosition()
    love.graphics.line(ball.x, ball.y, mx, my)
end

function cueManager.handleMousePress(x, y, button)
    if button ~= 1 then return end
    if not cueManager.gameState.isGameActive() then return end

    local ball = cueManager.ballManager.getCueBall()
    local dx, dy = x - ball.x, y - ball.y
    local dist = math.sqrt(dx*dx + dy*dy)

    -- Só ativa mira se clicou próximo à bola branca
    if dist <= ball.radius then
        cueManager.isAiming = true
    end
end

function cueManager.handleMouseRelease(x, y, button)
    if button ~= 1 or not cueManager.isAiming then return end

    local ball = cueManager.ballManager.getCueBall()
    local dx, dy = ball.x - x, ball.y - y
    local dist = math.sqrt(dx*dx + dy*dy)

    -- Calcula power proporcional, limitando em maxPower
    local power = math.min(dist, cueManager.maxPower)
    local angle = math.atan2(dy, dx)

    -- Aplica velocidade à bola (v = power * constante)
    local strength = power / cueManager.maxPower * 800  -- 800 é um fator de escala
    ball.vx = math.cos(angle) * strength
    ball.vy = math.sin(angle) * strength

    cueManager.isAiming = false
end

return cueManager
