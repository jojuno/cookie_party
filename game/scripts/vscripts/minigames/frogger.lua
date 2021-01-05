--spawn npcs
--zombies, leaves, logs
--all npcs immune to stuns
--kill them all when the game ends
--they have to be already walking when the players spawn
--walking at various speeds

--zombies
--spawns on the left or the right side
--each row has a side and distinct speed
--on spawn, walk to the opposite side
--spawn a random bunch of 1, 2, or 3 zombies at a time
--spawn a bunch every few seconds
--when they reach the opposite side, they die
--if players touch a zombie, they die
function GameMode:Frogger()
    --notification
    Notifications:BottomToAll({text = "Frogger", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
    Notifications:BottomToAll({text = "Reach the end first", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  
    --always set the seed when doing random
    math.randomseed(Time())
  
    ---------
    --flags--
    ---------
    GameMode.games["frogger"].finished = false
  
    ---------------------------
    -----------creeps----------
    ---------------------------
    --zombies
    for row = 1, 6 do
      GameMode.games["frogger"].zombies[row] = {}
      GameMode.games["frogger"].zombies[row].speed = math.random(300, 450)
      GameMode.games["frogger"].zombies[row].zombieLeftEnt = Entities:FindByName(nil, string.format("zombie_%s_left", row))
      GameMode.games["frogger"].zombies[row].zombieLeftEntVector = GameMode.games["frogger"].zombies[row].zombieLeftEnt:GetAbsOrigin()
      GameMode.games["frogger"].zombies[row].zombieRightEnt = Entities:FindByName(nil, string.format("zombie_%s_right", row))
      GameMode.games["frogger"].zombies[row].zombieRightEntVector = GameMode.games["frogger"].zombies[row].zombieRightEnt:GetAbsOrigin()
      GameMode.games["frogger"].zombies[row].side = math.random(2)
      --bunch
      Timers:CreateTimer(0, function()
        if not GameMode.games["frogger"].finished then
          GameMode.games["frogger"].zombies[row].bunch = math.random(3)
          GameMode.games["frogger"].zombies[row].bunchCount = 0
          --RandomFloat is a global function provided by Valve
          GameMode.games["frogger"].zombies[row].space = RandomFloat(1.5, 3)
          --individual
          Timers:CreateTimer(0, function()
            GameMode.games["frogger"].zombies[row].bunchCount = GameMode.games["frogger"].zombies[row].bunchCount + 1
            if GameMode.games["frogger"].zombies[row].bunchCount == (GameMode.games["frogger"].zombies[row].bunch + 1) then
              GameMode.games["frogger"].zombies[row].bunchCount = 0
              return nil
            else
              --spawns on the left or the right side
              --left
              if GameMode.games["frogger"].zombies[row].side == 1 then
                GameMode.games["frogger"].zombies[row][GameMode.games["frogger"].zombies[row].bunchCount] = CreateUnitByName("zombie", GameMode.games["frogger"].zombies[row].zombieLeftEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                GameMode.games["frogger"].zombies[row][GameMode.games["frogger"].zombies[row].bunchCount].destination = GameMode.games["frogger"].zombies[row].zombieRightEntVector
              else
                GameMode.games["frogger"].zombies[row][GameMode.games["frogger"].zombies[row].bunchCount] = CreateUnitByName("zombie", GameMode.games["frogger"].zombies[row].zombieRightEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                GameMode.games["frogger"].zombies[row][GameMode.games["frogger"].zombies[row].bunchCount].destination = GameMode.games["frogger"].zombies[row].zombieLeftEntVector
              end
              GameMode.games["frogger"].zombies[row][GameMode.games["frogger"].zombies[row].bunchCount]:SetBaseMoveSpeed(GameMode.games["frogger"].zombies[row].speed)
              GameMode.games["frogger"].zombies[row][GameMode.games["frogger"].zombies[row].bunchCount]:SetThink("ZombieThinker", self)
              return 1.0
            end
          end)
          return GameMode.games["frogger"].zombies[row].bunch + GameMode.games["frogger"].zombies[row].space
        else
          return nil
        end
      end)
    end
  
    --leaves
    --set up
    for leafRow = 1, 8 do
      GameMode.games["frogger"].leaves[leafRow] = {}
      for leafNum = 1, 8 do
        GameMode.games["frogger"].leaves[leafRow][leafNum] = {}
        GameMode.games["frogger"].leaves[leafRow][leafNum].skip = false
      end
    end
  
    local first = true
    Timers:CreateTimer(0, function()
      if not GameMode.games["frogger"].finished then
        for leafRow = 1, 8 do
          local leafPos1 = math.random(9)
          local leafPos2 = math.random(9)
          while leafPos1 == leafPos2 do
            leafPos2 = math.random(9)
          end
          --spawn leaves in all spots
          for leafNum = 1, 8 do
            if first then
              --spawn
              --good leaf
              if leafNum == leafPos1 or leafNum == leafPos2 then
                local spawnEnt = Entities:FindByName(nil, string.format("leaf_%s_%s", leafRow, leafNum))
                local spawnEntVector = spawnEnt:GetAbsOrigin()
                GameMode.games["frogger"].leaves[leafRow][leafNum] = CreateUnitByName("leaf", spawnEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                GameMode.games["frogger"].leaves[leafRow][leafNum].skip = false
                GameMode.games["frogger"].leaves[leafRow][leafNum].spawnEntVector = spawnEntVector
              else
                --bad leaf
                local spawnEnt = Entities:FindByName(nil, string.format("leaf_%s_%s", leafRow, leafNum))
                local spawnEntVector = spawnEnt:GetAbsOrigin()
                GameMode.games["frogger"].leaves[leafRow][leafNum] = CreateUnitByName("badLeaf", spawnEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                GameMode.games["frogger"].leaves[leafRow][leafNum].skip = false
                GameMode.games["frogger"].leaves[leafRow][leafNum].spawnEntVector = spawnEntVector
              end
            else 
              --if skip then
              if GameMode.games["frogger"].leaves[leafRow][leafNum].skip then
                --skip
                --reset skip so it doesn't skip next time
                GameMode.games["frogger"].leaves[leafRow][leafNum].skip = false
              else
                if leafNum == leafPos1 or leafNum == leafPos2 then
                  local spawnEnt = Entities:FindByName(nil, string.format("leaf_%s_%s", leafRow, leafNum))
                  local spawnEntVector = spawnEnt:GetAbsOrigin()
                  GameMode.games["frogger"].leaves[leafRow][leafNum] = CreateUnitByName("leaf", spawnEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                  GameMode.games["frogger"].leaves[leafRow][leafNum].skip = false
                  GameMode.games["frogger"].leaves[leafRow][leafNum].spawnEntVector = spawnEntVector
                else
                  --bad leaf
                  local spawnEnt = Entities:FindByName(nil, string.format("leaf_%s_%s", leafRow, leafNum))
                  local spawnEntVector = spawnEnt:GetAbsOrigin()
                  GameMode.games["frogger"].leaves[leafRow][leafNum] = CreateUnitByName("badLeaf", spawnEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                  GameMode.games["frogger"].leaves[leafRow][leafNum].skip = false
                  GameMode.games["frogger"].leaves[leafRow][leafNum].spawnEntVector = spawnEntVector
                end
              end
            end
          end
        end
        first = false
        Timers:CreateTimer({
          endTime = 3.9, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
          callback = function()
            for leafRow = 1, 8 do
              for leafNum = 1, 8 do
                --if there's someone standing on it,
                --100 is the heal radius
                local units = FindUnitsInRadius(GameMode.games["frogger"].leaves[leafRow][leafNum]:GetTeam(), 
                  GameMode.games["frogger"].leaves[leafRow][leafNum]:GetAbsOrigin(), nil,
                  150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
                  FIND_ANY_ORDER, false)
                local unitCount = 0
                for _, unit in pairs(units) do
                  print("[GameMode:Frogger()] unit found")
                  unitCount = unitCount + 1
                end
                if unitCount > 0 then
                  --don't kill
                  GameMode.games["frogger"].leaves[leafRow][leafNum].skip = true
                --else
                else
                  --kill
                  GameMode.games["frogger"].leaves[leafRow][leafNum]:ForceKill(false)
                  GameMode.games["frogger"].leaves[leafRow][leafNum]:RemoveSelf()
                end
              end
            end
          end})
        return 4
      else
        return nil
      end
    end)
  
    --logs
    --same as zombies except very scarce space in between
    --must jump into the space to cross
    --consistent spaces in between
    --consistent directions alternate between every row
    for row = 1, 9 do
      local numToSkip = math.random(10)
      GameMode.games["frogger"].logs[row] = {}
      GameMode.games["frogger"].logs[row].speed = math.random(150, 200)
      GameMode.games["frogger"].logs[row].logLeftEnt = Entities:FindByName(nil, string.format("log_%s_left", row))
      GameMode.games["frogger"].logs[row].logLeftEntVector = GameMode.games["frogger"].logs[row].logLeftEnt:GetAbsOrigin()
      GameMode.games["frogger"].logs[row].logRightEnt = Entities:FindByName(nil, string.format("log_%s_right", row))
      GameMode.games["frogger"].logs[row].logRightEntVector = GameMode.games["frogger"].logs[row].logRightEnt:GetAbsOrigin()
      GameMode.games["frogger"].logs[row].side = math.random(2)
      --bunch
      Timers:CreateTimer(numToSkip, function()
        if not GameMode.games["frogger"].finished then
          GameMode.games["frogger"].logs[row].bunch = math.random(7, 12)
          GameMode.games["frogger"].logs[row].bunchCount = 0
          --RandomFloat is a global function provided by Valve
          GameMode.games["frogger"].logs[row].space = math.random(3, 5)
          --individual
          Timers:CreateTimer(0, function()
            GameMode.games["frogger"].logs[row].bunchCount = GameMode.games["frogger"].logs[row].bunchCount + 1
            if GameMode.games["frogger"].logs[row].bunchCount == (GameMode.games["frogger"].logs[row].bunch + 1) then
              GameMode.games["frogger"].logs[row].bunchCount = 0
              return nil
            else
              --spawns on the left or the right side
              --left
              if GameMode.games["frogger"].logs[row].side == 1 then
                GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount] = CreateUnitByName("water", GameMode.games["frogger"].logs[row].logLeftEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount].destination = GameMode.games["frogger"].logs[row].logRightEntVector
              else
                GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount] = CreateUnitByName("water", GameMode.games["frogger"].logs[row].logRightEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
                GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount].destination = GameMode.games["frogger"].logs[row].logLeftEntVector
              end
              GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount]:SetBaseMoveSpeed(GameMode.games["frogger"].logs[row].speed)
              GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount]:SetThink("ZombieThinker", self)
              return 1.0
            end
            GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount]:AddNewModifier(nil, nil, "modifier_set_min_move_speed", {})
            GameMode.games["frogger"].logs[row][GameMode.games["frogger"].logs[row].bunchCount]:SetBaseMoveSpeed(1)
          end)
          return GameMode.games["frogger"].logs[row].bunch + GameMode.games["frogger"].logs[row].space
        else
          return nil
        end
      end)
    end
  
    --set up players
  
    --minigame flag
    --GameMode.games["frogger"].active = true
  
    --spawn
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
              local froggerStartEnt = Entities:FindByName(nil, string.format("frogger_start_%s", playerID + 1))
              local froggerStartEntVector = froggerStartEnt:GetAbsOrigin()
              --to remember where to spawn when the player is dead
              heroEntity.respawnPosition = froggerStartEntVector
              GameMode.teams[teamNumber][playerID]:SetRespawnPosition(froggerStartEntVector)
              heroEntity:RespawnHero(false, false)
              
              --items
              GameMode:RemoveAllItems(heroEntity)
  
              --abilities
              --remove all abilities
              GameMode:RemoveAllAbilities(heroEntity)
              --add specific abilities
              local cookie_frogger = heroEntity:AddAbility("cookie_frogger_channeled")
              cookie_frogger:SetLevel(1)
              local arrow_cookie = heroEntity:AddAbility("arrow_cookie")
              arrow_cookie:SetLevel(1)
              local cookie_frogger_release = heroEntity:AddAbility("cookie_frogger_channeled_release")
              cookie_frogger_release:SetLevel(1)

              --set camera
              GameMode:SetCamera(heroEntity)
  
              --modifiers
              heroEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
            end
          end
        end
      end
    end
  
    --game thinker
    GameMode:FroggerThinker()
end
  
--respawn players
function GameMode:FroggerThinker()
  --respawn players if they're dead
  Timers:CreateTimer("respawnIfDead", {
    useGameTime = false,
    endTime = 0,
    callback = function()
      if GameMode.games["frogger"].finished then
        return nil
      else
        for teamNumber = 6, 13 do
          if GameMode.teams[teamNumber] ~= nil then
            for playerID = 0, GameMode.maxNumPlayers - 1 do
              if GameMode.teams[teamNumber][playerID] ~= nil then
                local heroEntity = GameMode.teams[teamNumber][playerID]
                if not heroEntity:IsAlive() then
                  heroEntity:SetRespawnPosition(heroEntity.respawnPosition)
                  heroEntity:RespawnHero(false, false)
                end
              end
            end
          end
        end
        return 1
      end
    end
  })
  --end triggered by trigger
end
  
function GameMode:ZombieThinker(unit)
  --if it's within 50 units of the destination,
  if GridNav:FindPathLength(unit.destination, unit:GetAbsOrigin()) < 100 then
    --kill it
    unit:ForceKill(false)
    unit:RemoveSelf()
    --return nil
    return nil
  --else, 
  else
    --MoveToPosition(destination)
    unit:MoveToPosition(unit.destination)
    --return 0.5
    return 0.5
  end
end

--functions with same names canNOT exit
--will pick one of them
function GameMode:SpawnNeutral(spawn_loc_name, spawn_name)
  --Start an iteration finding each entity with this name
  --If you've named everything with a unique name, this will return your entity on the first go
  --dynamically assign spawn to entity location via argument passed into the function

  local spawnVectorEnt = Entities:FindByName(nil, spawn_loc_name)

  -- GetAbsOrigin() is a function that can be called on any entity to get its location
  local spawnVector = spawnVectorEnt:GetAbsOrigin()

  -- Spawn the unit at the location on the dire team
  -- if set to neutral team, when hero dies, their death timer gets added 26 seconds to the fixed resurrection time
  local spawnedUnit = CreateUnitByName(spawn_name, spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  

  spawnedUnit.spawn_loc_name = spawn_loc_name
  spawnedUnit.spawn_name = spawn_name
  return spawnedUnit
end