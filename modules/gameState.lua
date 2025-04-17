local gameState = {  active = false,
over = false,
message = "",
score = 0,
foul = false}


function gameState.load()
    gameState.active = false
    gameState.over = false
    gameState.message = ""
    gameState.score = 0
    gameState.foul = false
end

function gameState.startGame()
    gameState.active = true
    gameState.over = false
end

function gameState.endGame(message)
    gameState.over = true
    gameState.message = message or ""
end

function gameState.resetGame()
    gameState.load()
end

function gameState.addScore(points)
    gameState.score = gameState.score + (points or 1)
end

function gameState.isGameActive()
    return gameState.over
end

function gameState.isGameOver()
    return gameState.over
end

function gameState.getScore()
    return gameState.score
end

function gameStae.getGameOverMessage()
    return gameState.message
end

function gameState.hasFoul()
    return gameState.foul
end

return gameState