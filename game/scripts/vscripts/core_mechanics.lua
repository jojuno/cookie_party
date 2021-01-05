-- This function runs to save the location and particle spawn upon hero killed
function GameMode:HeroKilled(hero, attacker, ability)
    if GameMode.pregameActive then
        --RandomFloat(low, high) doesn't work with negative numbers
        local respawnLocationX = math.random(-8835, -7062)
        local respawnLocationY = math.random(-7729, -6140)
        local respawnLocationZ = math.random(128, 256)
        hero:SetRespawnPosition(Vector(respawnLocationX, respawnLocationY, respawnLocationZ))
        if GameMode.pregameBuffer == false then
            Timers:CreateTimer({
                endTime = 1, -- respawn in 1 second
                callback = function()
                    GameMode:SetCamera(hero)
                    GameMode:Restore(hero)
                end
            })
        end
    else
        --[[Timers:CreateTimer({
            endTime = 1, -- respawn in 1 second
            callback = function()
                if GameMode.games["frogger"].active then
                    --respawn position must be set every life; otherwise, player will spawn at the first location
                    hero:SetRespawnPosition(hero.respawnPosition)
                    GameMode:Restore(hero)
                elseif GameMode.games["feederAndEater"].active then
                    --skip; taken care of in game thinker
                elseif GameMode.games["shotgun"].active then
                    --skip; taken care of in game thinker
                elseif GameMode.games["cookieDuo"].active then
                    --skip; taken care of in game thinker
                elseif hero:GetUnitName() == "npc_dota_hero_meepo" then
                    --skip; part of cookieDuo
                elseif GameMode.games["feederAndEater2"].active then
                    --skip; taken care of in game thinker
                else
                    local respawnLocationX = math.random(-8835, -7062)
                    local respawnLocationY = math.random(-7729, -6140)
                    local respawnLocationZ = math.random(128, 256)
                    hero:SetRespawnPosition(Vector(respawnLocationX, respawnLocationY, respawnLocationZ))
                    GameMode:Restore(hero)
                end
            end
        })]]
    end
end

--meepo killed
--endgame
    --replace hero
    --kill it
    --respawn