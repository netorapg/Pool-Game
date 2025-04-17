local ballManager = {
    balls = {},
    ballTypes = {
        {"solid", {1, 0, 0}},    -- Lisa vermelha
        {"striped", {0, 0, 1}},   -- Listrada azul
        {"solid", {1, 0.5, 0}},   -- Lisa laranja
        {"striped", {0.5, 0, 0.5}},-- Listrada roxa
        {"8", {0, 0, 0}},         -- Bola 8
        {"striped", {1, 1, 0}},   -- Listrada amarela
        {"solid", {0, 1, 0}},     -- Lisa verde
        {"striped", {0, 1, 1}},   -- Listrada ciano
        {"solid", {1, 0.5, 0.5}}, -- Lisa rosa
        {"striped", {0.5, 0.5, 1}},-- Listrada lavanda
        {"solid", {1, 1, 0}},     -- Lisa amarela
        {"striped", {0.5, 1, 0.5}},-- Listrada verde-claro
        {"solid", {1, 0.5, 1}},   -- Lisa magenta
        {"striped", {0.5, 0.5, 0}},-- Listrada marrom
        {"solid", {1, 0, 0}}      -- Lisa branca
    }
}

function ballManager.load()
    ballManager.balls = {}
end

function ballManager.setupBalls(tableX, tableY, tableWidth, tableHeight)
    ballManager.balls = {}

    -- Bola branca (cue)
    table.insert(ballManager.balls, {
        x = tableX + 100,
        y = tableY + tableHeight / 2,
        radius = 10,
        color = {1, 1, 1},
        vx = 0,
        vy = 0,
        type = "cue"
    })

    -- Configuração do triângulo de bolas
    local startX = tableX + tableWidth - 200
    local startY = tableY + tableHeight / 2
    local offset = 22

    -- Gerar bolas em forma de triângulo
    local index = 1
    for row = 0, 4 do
        for col = 0, row do
            if index <= #ballManager.ballTypes then
                local type, color = ballManager.ballTypes[index][1], ballManager.ballTypes[index][2]
                table.insert(ballManager.balls, {
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

function ballManager.update(dt)
    for _, ball in ipairs(ballManager.balls) do
        -- Atualiza posição
        ball.x = ball.x + ball.vx * dt
        ball.y = ball.y + ball.vy * dt

        -- Verifica colisões com as bordas da mesa
        if ball.x - ball.radius < tableX or ball.x + ball.radius > tableX + tableWidth then
            ball.vx = -ball.vx * 0.9  -- Adiciona um pouco de atrito
        end
        if ball.y - ball.radius < tableY or ball.y + ball.radius > tableY + tableHeight then
            ball.vy = -ball.vy * 0.9  -- Adiciona um pouco de atrito
        end

        -- Aplica atrito
        ball.vx = ball.vx * 0.99
        ball.vy = ball.vy * 0.99
    end

    ballManager.checkPockets()
    require("modules.collisionManager").checkBallCollisions(ballManager.balls)
end

function ballManager.draw()
    for _, ball in ipairs(ballManager.balls) do
        love.graphics.setColor(ball.color)
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    end
end

function ballManager.checkPockets()
    local holes = {
        {x = tableX, y = tableY},
        {x = tableX + tableWidth / 2, y = tableY},
        {x = tableX + tableWidth, y = tableY},
        {x = tableX, y = tableY + tableHeight},
        {x = tableX + tableWidth / 2, y = tableY + tableHeight},
        {x = tableX + tableWidth, y = tableY + tableHeight}
    }

    for i = #ballManager.balls, 1, -1 do
        local ball = ballManager.balls[i]
        for _, hole in ipairs(holes) do
            local dx, dy = ball.x - hole.x, ball.y - hole.y
            local distance = math.sqrt(dx * dx + dy * dy)
            
            if distance < 15 then  -- Bola entrou no buraco
                handlePocketedBall(i, ball)
                break
            end
        end
    end
end

function handlePocketedBall(index, ball)
    if ball.type == "cue" then
        -- Penalidade: bola branca encaçapada
        gameState.setFoul(true)
        resetCueBall(ball)
    elseif ball.type == "8" then
        handleEightBallPocketed()
    else
        -- Pontuação normal
        gameState.addScore(1)
        table.remove(ballManager.balls, index)
    end
end

function resetCueBall(ball)
    ball.x, ball.y = tableX + 100, tableY + tableHeight / 2
    ball.vx, ball.vy = 0, 0
end

function handleEightBallPocketed()
    if require("modules.collisionManager").areAllBallsPocketed(ballManager.balls) then
        gameState.endGame("Você venceu!")
    else
        gameState.endGame("Você perdeu!")
    end
end

function ballManager.getCueBall()
    return ballManager.balls[1]  -- A primeira bola é sempre a bola branca
end

function ballManager.getBalls()
    return ballManager.balls
end

return ballManager