--three abilities: birdshot, buckshot, slug, cookie
--gauge on/off
  --double damage on shotguns; double damage on cookie; double distance and radius on cookie
  --knockback on shotgun
  --charges on scatterblast
--magic immune for first few seconds

function GameMode:Shotgun()
    --GameMode.games["shotgun"].active = true
    --announcement
    Notifications:BottomToAll({text = "Shotgun", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  
    --check boundary coordinates
    --top left 
    --[-2631.641357 -6653.456543 256.000000]
  
    --top right
    --[-3938.178711 -6721.492188 256.000000]
  
    --bottom left
    --[-3931.667725 -8008.909180 256.000000]
  
    --bottom right
    --[-2630.993164 -7924.344238 256.000000]
  
    --seed randomness for spawn position
    math.randomseed(Time())
    --table of positions to choose from
    local positions = {}
    positions[1] = 1
    positions[2] = 2
    positions[3] = 3
    positions[4] = 4
    positions[5] = 5
    positions[6] = 6
    positions[7] = 7
    positions[8] = 8

    --set vision
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
  
    --spawn players
    for teamNumber = 6, 13 do
      if GameMode.teams[teamNumber] ~= nil then
        for playerID = 0, GameMode.maxNumPlayers-1 do
          if PlayerResource:IsValidPlayerID(playerID) then
            if GameMode.teams[teamNumber][playerID] ~= nil then
              local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
              --random among the 8 spawn spots
              local spawnNumber = math.random(8)
              --if it was chosen before, choose again
              while positions[spawnNumber] == nil do
                spawnNumber = math.random(8)
              end
              positions[spawnNumber] = nil
              print("spawnNumber: " .. spawnNumber)
              GameMode:SpawnPlayer(heroEntity, string.format("shotgun_player_%s", spawnNumber))
              --set camera
              GameMode:SetCamera(heroEntity)
              --customize abilities
              local abilitiesToAdd = {}
              --animations built in to ability slots
              abilitiesToAdd[1] = "birdshot"
              --abilitiesToAdd[2] = "buckshot"
              abilitiesToAdd[2] = "slug"
              --2x damage
              --knockback
              --2x cookie distance
              abilitiesToAdd[3] = "load"
              --fillers
              abilitiesToAdd[4] = "barebones_empty1"
              abilitiesToAdd[5] = "barebones_empty1"
              --jump to dodge
              abilitiesToAdd[6] = "cookie_shotgun"
              GameMode:CustomizeAbilities(heroEntity, abilitiesToAdd)
              --attack
              heroEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
              --modifiers
              --heroEntity:SetBaseMagicalResistanceValue(0)
              heroEntity:AddNewModifier(nil, nil, "modifier_attack_immune", {})
              heroEntity:SetDayTimeVisionRange(1500)
              heroEntity:SetNightTimeVisionRange(1500)
            end
          end
        end
      end
    end
    --for test
    --spawn mobs in the center
    --[[local hordeCenterEnt = Entities:FindByName(nil, "shotgun_center")
    local hordeCenterEntVector = hordeCenterEnt:GetAbsOrigin()
    for i = 1, 100 do
      print("[GameMode:Horde()] kobold spawned")
      GameMode.games["horde"].creeps[i] = CreateUnitByName("npc_dota_neutral_kobold", hordeCenterEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
    end]]
    --rules
      --abilities
    --thinker
    GameMode:ShotgunThinker()
  end
  
  function GameMode:ShotgunThinker()
  
    Timers:CreateTimer("checkDead", {
      useGameTime = false,
      endTime = 0,
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
          print("shotgun ended")
          --assign score
          for teamNumber = 6, 13 do
            if GameMode.teams[teamNumber] ~= nil then
              for playerID = 0, GameMode.maxNumPlayers - 1 do
                if PlayerResource:IsValidPlayerID(playerID) then
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
          end
          GameMode:EndGame()
          return nil
        end
        return 0.06
      end
    })
  end