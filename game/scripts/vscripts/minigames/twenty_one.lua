LinkLuaModifier( "modifier_cookie_eaten", "libraries/modifiers/modifier_cookie_eaten", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cextra_mana", "libraries/modifiers/modifier_extra_mana", LUA_MODIFIER_MOTION_NONE )

function GameMode:TwentyOne()
    --circle around morty
    --feed morty 3, 2, or 1 cookies
    --if you get the exact amount, you win!
    --if you go over, you lose
    --continue until one person left or someone wins

    Notifications:BottomToAll({text = "Twenty One", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 

    GameMode:CreateMorty()

    --spawn players around morty
    for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
            for playerID = 0, GameMode.maxNumPlayers-1 do
                if GameMode.teams[teamNumber][playerID] ~= nil then
                    if PlayerResource:IsValidPlayerID(playerID) then
                        local heroEntity = GameMode.teams[teamNumber][playerID]
                        --flag for player
                        --GameMode.teams[teamNumber][playerID].minigameActive = true
                        --GameMode.teams[teamNumber][playerID].hero.froggerActive = true
                        --when a player dies, respawn back at the start
                        local mashEnt = Entities:FindByName(nil, string.format("twenty_one_spawn_%s", playerID + 1))
                        local mashEntVector = mashEnt:GetAbsOrigin()
                        --to remember where to spawn when the player is dead
                        heroEntity.respawnPosition = mashEntVector
                        GameMode.teams[teamNumber][playerID]:SetRespawnPosition(mashEntVector)
                        heroEntity:RespawnHero(false, false)

                        --add specific abilities
                        local feed_one_cookie = heroEntity:AddAbility("feed_one_cookie")
                        feed_one_cookie:SetLevel(1)
                        local feed_two_cookies = heroEntity:AddAbility("feed_two_cookies")
                        feed_two_cookies:SetLevel(1)
                        local feed_three_cookies = heroEntity:AddAbility("feed_three_cookies")
                        feed_three_cookies:SetLevel(1)
                    
                        --set camera
                        GameMode:SetCamera(heroEntity)

                        --modifiers
                        heroEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
                        heroEntity:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
                        heroEntity:AddNewModifier(nil, nil, "modifier_extra_mana", { extraMana = -900, regen = 0 })
                        --reduce mana so only the one with the turn can cast
                        heroEntity:ReduceMana(100)

                        --flag to check whether to end turn or not
                        heroEntity.cast = false
                        heroEntity.playing = true

                    end
                end
            end
        end
    end

    --set random player to start
    --what if player with an ID between 0 and maxNumPlayers left before the game started?
    GameMode.games["twentyOne"].turn = math.random(0, GameMode.maxNumPlayers-1)
    while not PlayerResource:IsValidPlayerID(GameMode.games["twentyOne"].turn) 
    or not PlayerResource:GetSelectedHeroEntity(GameMode.games["twentyOne"].turn).playing do
        GameMode.games["twentyOne"].turn = GameMode.games["twentyOne"].turn + 1
        if GameMode.games["twentyOne"].turn == GameMode.maxNumPlayers then
            GameMode.games["twentyOne"].turn = 0
        end
    end
    local hero = PlayerResource:GetSelectedHeroEntity(GameMode.games["twentyOne"].turn)
    Notifications:BottomToAll({text = string.format("%s's turn", GameMode.teamNames[hero:GetTeamNumber()]), duration= 5.0, style={["font-size"] = "45px", color = GameMode.teamColors[hero:GetTeamNumber()]}})
    --give mana
    hero:GiveMana(100)

    --thinker; keeps the rules
    GameMode:TwentyOneThinker()

end

function GameMode:TwentyOneThinker()

    local finished = false
    GameMode.games["twentyOne"].countdown = 0

    Timers:CreateTimer("take_turns", {
        useGameTime = true,
        endTime = 1,
        callback = function()
            
            local hero = PlayerResource:GetSelectedHeroEntity(GameMode.games["twentyOne"].turn)

            if finished then

                --kill morty
                GameMode.games["twentyOne"].morty:ForceKill(false)
                GameMode.games["twentyOne"].morty:EmitSound("ogre_death_1")
                GameMode.games["twentyOne"].morty = nil

                --end thinker
                return nil
            elseif hero.cast == false then
                GameMode.games["twentyOne"].countdown = GameMode.games["twentyOne"].countdown + 0.06
                if GameMode.games["twentyOne"].countdown > 7 then
                    --kill hero
                    Notifications:BottomToAll({text = "Out of time!", duration= 5.0, style={["font-size"] = "45px", color = "red"}})
                    hero:ForceKill(false)
                    hero.playing = false
                    --next turn
                    GameMode:SwitchTurn()
                else
                    --continue
                end

                return 0.06
            else

                --cookie has been fed
                --check stack on morty
                --if morty had more than enough,
                
                local cookieEatenModifier = GameMode.games["twentyOne"].morty:FindModifierByName("modifier_cookie_eaten")
                print("current number of cookies eaten: " .. cookieEatenModifier:GetStackCount())
                if cookieEatenModifier:GetStackCount() > GameMode.games["twentyOne"].cookiesToBust then

                    print("busted!")
                    Notifications:BottomToAll({text = "Busted!", duration= 5.0, style={["font-size"] = "45px", color = "red"}})
                                        
                    --morty explodes
                    local particle_cast = "particles/alchemist_smooth_criminal_unstable_concoction_explosion_custom.vpcf"
                    --PATTACH_ABSORIGIN_FOLLOW to create effect at unit's location
                    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, GameMode.games["twentyOne"].morty )
                    ParticleManager:ReleaseParticleIndex( effect_cast )

                    --kill morty
                    GameMode.games["twentyOne"].morty:ForceKill(false)
                    GameMode.games["twentyOne"].morty:EmitSound("explosion")
                    GameMode.games["twentyOne"].morty:EmitSound("ogre_death_1")

                    --kill player that fed him last
                    hero:ForceKill(false)
                    hero.playing = false

                    --reset all hero.cast
                    --stun until next round
                    for teamNumber = 6, 13 do
                        if GameMode.teams[teamNumber] ~= nil then
                            for playerID  = 0, GameMode.numPlayers - 1 do
                                if GameMode.teams[teamNumber][playerID] ~= nil then
                                    local heroEntity = GameMode.teams[teamNumber][playerID]
                                    if heroEntity.playing then
                                        heroEntity.cast = false
                                        heroEntity:AddNewModifier(nil, nil, "modifier_stunned", {duration = 2.1})
                                    end
                                end
                            end
                        end
                    end

                    Timers:CreateTimer("next_turn", {
                        useGameTime = true,
                        endTime = 1.5,
                        callback = function()
                            --switch turn
                            GameMode:SwitchTurn()
                            --create morty
                            GameMode:CreateMorty()
                            return nil
                        end
                    })

                    return 2
                      
                elseif cookieEatenModifier:GetStackCount() == GameMode.games["twentyOne"].cookiesToBust then
                    print("jackpot!")
                    --make sound
                    hero:EmitSound("jackpot")
                    
                    --kill morty
                    GameMode.games["twentyOne"].morty:ForceKill(false)
                    GameMode.games["twentyOne"].morty:EmitSound("ogre_death_1")
                    GameMode.games["twentyOne"].morty = nil

                    --winner
                    Notifications:ClearBottomFromAll()
                    Notifications:BottomToAll({text = "Jackpot! ", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
                    Notifications:BottomToAll({text = GameMode.teamNames[hero:GetTeamNumber()], duration= 5.0, style={["font-size"] = "45px", color = GameMode.teamColors[hero:GetTeamNumber()]}, continue=true})
                    GameMode.teams[hero:GetTeamNumber()].score = GameMode.teams[hero:GetTeamNumber()].score + 1
                    GameMode:EndGame()
                    finished = true
                    return nil
                else
                    
                    --switch turns
                    GameMode:SwitchTurn()

                    return 0.06
                end
            end
            
        end
    })

    --another thinker that checks whether there's only one player alive
    --if true,
        --set player as winner
        --set "finished" flag
    --else,
        --continue

    Timers:CreateTimer("checkDead", {
        useGameTime = true,
        endTime = 1,
        callback = function()
            if finished then
                return nil
            else
                local numAlive = 0
                local winner = {}
                --count how many dead
                for teamNumber = 6, 13 do
                    if GameMode.teams[teamNumber] ~= nil then
                        for playerID = 0, GameMode.numPlayers-1 do
                            if GameMode.teams[teamNumber][playerID] ~= nil then
                                if PlayerResource:IsValidPlayerID(playerID) then
                                    local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
                                    if heroEntity:IsAlive() then
                                        numAlive = numAlive + 1
                                        --winner[playerID + 1] = heroEntity
                                    end
                                end
                            end
                        end
                    end
                end
                --if one player remaining, he's the winner
                if numAlive == 1 then
                    print("twenty one ended")
                    --assign score
                    for teamNumber = 6, 13 do
                        if GameMode.teams[teamNumber] ~= nil then
                            for playerID = 0, GameMode.numPlayers - 1 do
                                if GameMode.teams[teamNumber][playerID] ~= nil then
                                    local heroEntity = GameMode.teams[teamNumber][playerID]
                                    if heroEntity:IsAlive() then
                                        --declare winner
                                        Notifications:BottomToAll({text = "Winner! ", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
                                        Notifications:BottomToAll({text = GameMode.teamNames[teamNumber], duration= 5.0, style={["font-size"] = "45px", color = GameMode.teamColors[teamNumber]}, continue=true})
                                        GameMode.teams[teamNumber].score = GameMode.teams[teamNumber].score + 1
                                    end
                                end
                            end
                        end
                    end
                    finished = true
                    GameMode:EndGame()
                    return nil
                end
                return 0.06
            end
        end
    })
    
    --players take turns feeding him
    --if player takes too long, kill him

    --morty can't move
    --morty has modifier that stacks
        --counts how many cookies have been fed to him
        --when it goes over the limit, morty dies, as well as the one that fed him last
        --when it's at the


    --start with 100 mana
    --spell cast -> reduced to 0
    --switch turns
    --heal 100 mana for new player
    --0 mana regen
end

function GameMode:CreateMorty()
    --spawn morty on mash center
    local spawnEnt = Entities:FindByName(nil, ("mash_center"))
    local spawnEntVector = spawnEnt:GetAbsOrigin()
    GameMode.games["twentyOne"].morty = CreateUnitByName("fatty", spawnEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
    GameMode.games["twentyOne"].morty:SetForwardVector(Vector(0, -1, 0))
    GameMode.games["twentyOne"].morty:AddNewModifier(nil, nil, "modifier_cookie_eaten", {})
    GameMode.games["twentyOne"].morty.scale = 2
    GameMode.games["twentyOne"].morty:SetModelScale(GameMode.games["twentyOne"].morty.scale)
    GameMode.games["twentyOne"].morty:SetDeathXP(0)
    GameMode.games["twentyOne"].cookiesToBust = math.random(10, 21)
    --testing
    --GameMode.games["twentyOne"].cookiesToBust = 3
end

function GameMode:SwitchTurn()
    print("switching turns")
    GameMode.games["twentyOne"].turn = GameMode.games["twentyOne"].turn + 1
    if GameMode.games["twentyOne"].turn == GameMode.maxNumPlayers then
        GameMode.games["twentyOne"].turn = 0
    end
    while not PlayerResource:IsValidPlayerID(GameMode.games["twentyOne"].turn) 
    or not PlayerResource:GetSelectedHeroEntity(GameMode.games["twentyOne"].turn).playing do
        GameMode.games["twentyOne"].turn = GameMode.games["twentyOne"].turn + 1
        if GameMode.games["twentyOne"].turn == GameMode.maxNumPlayers then
            GameMode.games["twentyOne"].turn = 0
        end
    end
    --PlayerResource:GetSelectedHeroEntity and PlayerResource:GetPlayer return two different values
    local hero = PlayerResource:GetSelectedHeroEntity(GameMode.games["twentyOne"].turn)
    Notifications:BottomToAll({text = string.format("%s's turn", GameMode.teamNames[hero:GetTeamNumber()]), duration= 5.0, style={["font-size"] = "45px", color = GameMode.teamColors[hero:GetTeamNumber()]}})
    hero.cast = false
    hero:GiveMana(100)
    --reset countdown
    GameMode.games["twentyOne"].countdown = 0
end