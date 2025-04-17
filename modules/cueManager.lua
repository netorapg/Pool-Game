local cueManager = {
    cue = {x = 0, y = 0, angle = 0, power = 0, maxPower = 500},
    isAiming = false
}

function cueManager.initialize()

end

function cueManager.updateCue(dt)
    if cueManager.isAiming then
    
    end
end

function cueManager.drawCue()
    if cueManager.isAiming then
        
    end
end

function cueManager.handleMousePress(x, y, button)
    if button == 1 then

    end
end

function cueManager.handleMouseRelease(x, y, button)
    if button == 1 and cueManager.isAiming then
    end
end

return cueManager