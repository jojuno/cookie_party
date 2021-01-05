--players can mine
--spawn mines randomly
--last player standing wins
--cooldown

function GameMode:Mines()
    --GameMode.games["shotgun"].active = true
    --announcement
    Notifications:BottomToAll({text = "Mines", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  
    --check boundary coordinates
    --top left 
    --[-2631.641357 -6653.456543 256.000000]
  
    --top right
    --[-3938.178711 -6721.492188 256.000000]
  
    --bottom left
    --[-3931.667725 -8008.909180 256.000000]
  
    --bottom right
    --[-2630.993164 -7924.344238 256.000000]
  
    --random spawn around center
  
    --spawn players
    for teamNumber = 6, 13 do
      if GameMode.teams[teamNumber] ~= nil then
        for playerID = 0, GameMode.maxNumPlayers-1 do
          if GameMode.teams[teamNumber][playerID] ~= nil then
            local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            GameMode:SpawnPlayerRandomlyAroundCenter(heroEntity, "mines_center")
            --set camera
            GameMode:SetCamera(heroEntity)
            --customize abilities
            local abilitiesToAdd = {}
            --custom items
            local item = CreateItem("item_force_staff", heroEntity, heroEntity)
            heroEntity:AddItem(item)
            --animations built in to ability slots
            abilitiesToAdd[1] = "techies_land_mines"
            GameMode:CustomizeAbilities(heroEntity, abilitiesToAdd)
            --attack
            heroEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
            --modifiers
            --heroEntity:SetBaseMagicalResistanceValue(0)
            heroEntity:AddNewModifier(nil, nil, "modifier_attack_immune", {})
            heroEntity:SetDayTimeVisionRange(3000)
            heroEntity:SetNightTimeVisionRange(3000)
          end
        end
      end
    end

    --spawn miner
    local minerEnt = Entities:FindByName(nil, "mines_techies")
    local minerEntVector = minerEnt:GetAbsOrigin()
    --set an owner so it's visible when planted
    GameMode.games["mines"].miner = CreateUnitByName("techies", minerEntVector, true, PlayerResource:GetSelectedHeroEntity(3), PlayerResource:GetSelectedHeroEntity(3), DOTA_TEAM_BADGUYS)

    --run thinker
    GameMode:MinesThinker()
end
  
function GameMode:MinesThinker()

    local finished = false
    local countdown = 5
    Timers:CreateTimer("checkDead", {
        useGameTime = true,
        endTime = 1,
        callback = function()
        local numAlive = 0
        local winner = {}
        --count how many dead
        for teamNumber = 6, 13 do
            if GameMode.teams[teamNumber] ~= nil then
            for playerID = 0, GameMode.maxNumPlayers-1 do
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
            print("mines ended")
            --assign score
            for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                    for playerID = 0, GameMode.maxNumPlayers - 1 do
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
        elseif numAlive == 0 then
            
            print("mines ended, tie")
            finished = true
            Notifications:BottomToAll({text = "Tie", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
            GameMode:EndGame()
            return nil
        end
        return 0.06
        end
    })
    Timers:CreateTimer("miner", {
        useGameTime = true,
        endTime = 1,
        callback = function()
            print("cast mine thought called")
            --pick a cast location
            local centerEnt = Entities:FindByName(nil, "mines_center")
            local centerEntVector = centerEnt:GetAbsOrigin()

            --set cursor
            local castLoc = Vector(centerEntVector.x + math.random(-1000, 1000), centerEntVector.y + math.random(-1000, 1000), z)
            GameMode.games["mines"].miner:SetCursorPosition(castLoc)

            --cast ability
            local mineAbility = GameMode.games["mines"].miner:FindAbilityByName("techies_land_mines_custom")
            mineAbility:OnSpellStart()
            
            if finished then
                GameMode:ClearMines()
                return nil
            else
                if countdown > 1 then
                    countdown = countdown - 0.3
                else
                    --skip
                end
                return countdown
            end
        end
    })
    
end

function GameMode:ClearMines()
    --kill miner
    GameMode.games["mines"].miner:ForceKill(false)
    --spawn huge ogre
    --kill after a few seconds
    local centerEnt = Entities:FindByName(nil, "mines_center")
    local centerEntVector = centerEnt:GetAbsOrigin()
    local cleaner = CreateUnitByName("cleaner", centerEntVector, true, PlayerResource:GetSelectedHeroEntity(3), PlayerResource:GetSelectedHeroEntity(3), DOTA_TEAM_GOODGUYS)
    cleaner:SetHullRadius(3000)
    Timers:CreateTimer("killCleaner", {
        useGameTime = true,
        endTime = 5,
        callback = function()
          cleaner:ForceKill(false)
          return nil
        end
      })
    
end