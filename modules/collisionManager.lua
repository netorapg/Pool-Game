local collisionManager = {}

function collisionManager.checkBallCollisions(balls)
    for i = 1, #balls - 1 do
        for j = i + 1, #balls do
            local ball1 = balls[i]
            local ball2 = balls[j]
            local dx, dy = ball2.x - ball1.x, ball2.y - ball1.y
            local distance = math.sqrt(dx * dx + dy * dy)
            local minDistance = ball1.radius + ball2.radius

            if distance < minDistance then
                handleBallCollision(ball1, ball2, dx, dy, distance, minDistance)
            end
        end
    end
end

function handleBallCollision(ball1, ball2, dx, dy, distance, minDistance)
    local nx, ny = dx / distance, dy / distance
    local overlap = minDistance - distance

    ball1.x = ball1.x - nx * overlap / 2
    ball1.y = ball1.y - ny * overlap / 2
    ball2.x = ball2.x + nx * overlap / 2
    ball2.y = ball2.y + ny * overlap / 2

    local p = 2 * (ball1.vx * nx + ball1.vy * ny - ball2.vx * nx - ball2.vy * ny) / 2

    ball1.vx = ball1.vx - p * nx
    ball1.vy = ball1.vy - p * ny
    ball2.vx = ball2.vx + p * nx
    ball2.vy = ball2.vy + p * ny
end


function collisionManager.areAllBallsPocketed(balls)
    for _, ball in ipairs(balls) do
        if ball.type ~= "cue" and ball.type ~= "8" then
            return false
        end
    end
    return true
end

return collisionManager
