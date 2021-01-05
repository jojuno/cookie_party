require('./internal/util')

-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  DebugPrint("[BAREBONES] NPC Spawned")
  DebugPrintTable(keys)
  --print("[GameMode:OnNPCSpawned] keys: ")
  --PrintTable(keys)
  local npc = EntIndexToHScript(keys.entindex)

  --add items if this is first spawn after cookie god
  
  

  --if player is a cookie god
  --replaceherowith original hero via .heroname
  if GameMode.cookieGods[npc:GetUnitName()] ~= nil then
    local npc_playerID = npc:GetPlayerID()
    if GameMode.teams[PlayerResource:GetTeam(npc_playerID)]["players"][npc_playerID].cookieGodActive then

      --print("[GameMode:OnNPCSpawned] npc_playerID: " .. npc_playerID)
      --items are initially not present in first spawn of new hero
      local newHero = PlayerResource:ReplaceHeroWith(npc_playerID, GameMode.teams[PlayerResource:GetTeam(npc_playerID)]["players"][npc_playerID].heroName, PlayerResource:GetGold(npc_playerID), 0)
      newHero:ForceKill(false)
      --delay by a moment
      Timers:CreateTimer({
        endTime = 0.06, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
        callback = function()
          newHero:RespawnHero(false, false)
        end
      })
      
      
      GameMode.teams[PlayerResource:GetTeam(npc_playerID)]["players"][npc_playerID].cookieGodActive = false

      --update GameMode table
      --add all items to 
      --add all items
      GameMode.teams[PlayerResource:GetTeam(npc_playerID)]["players"][npc_playerID].hero = newHero
    end
    --cookie god spawn
    --cookieGodSpawn = true
    --cookie god dies
    --respawn time
    --warlock spawns
    --warlock plays
    --warlock dies
    --respawn time
    --warlock spawns again
  end

  --if he's in frogger then
  if npc.froggerActive then
    --add "attack immune" modifier
    npc:AddNewModifier(nil, nil, "modifier_attack_immune", {})
  end


  --npc:AddNewModifier(nil, nil, "modifier_specially_deniable", {})
  --npc:AddNewModifier(nil, nil, "modifier_magic_immune", {duration = 2})
  --npc:AddNewModifier(nil, nil, "modifier_attack_immune", {duration = 2})

end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local unitEntity = nil
  if keys.UnitEntitIndex then
    unitEntity = v(keys.UnitEntitIndex)
  elseif keys.HeroEntityIndex then
    unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
  end

  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  DebugPrint( '[BAREBONES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  --level 2 - 4 = basic upgrade
  --level 5 = ult upgrade
  --level 6 - 8 = basic upgrade
  --level 9 = ult upgrade
  --level 10 - 12 = basic upgrade
  --level 13 = ult upgrade
  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
  local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())

  if level > 13 or GameMode.gameActive or hero.numUpgrades > 10 then
    --nothing
  else
    --add upgrade
    local abilityName
    if level >= 2 and level <= 4 then
      --pick a random number between 1 and 9
      local abilityUpgradeIndex = math.random(1,9)
      abilityName = GameMode.abilityUpgrades.basic[abilityUpgradeIndex]
      --if hero already has that upgrade, pick another one
      while hero:HasAbility(abilityName) do
        local abilityUpgradeIndex = math.random(1,9)
        abilityName = GameMode.abilityUpgrades.basic[abilityUpgradeIndex]
      end
    elseif level == 5 then
      --pick a random number between 10 and 12
      local abilityUpgradeIndex = math.random(1, 3)
      abilityName = GameMode.abilityUpgrades.ult[abilityUpgradeIndex]
      --if hero already has that upgrade, pick another one
      while hero:HasAbility(abilityName) do
        local abilityUpgradeIndex = math.random(1, 3)
        abilityName = GameMode.abilityUpgrades.ult[abilityUpgradeIndex]
      end
    elseif level >= 6 and level <= 8 then
      --pick a random number between 1 and 9
      local abilityUpgradeIndex = math.random(1,9)
      abilityName = GameMode.abilityUpgrades.basic[abilityUpgradeIndex]
      --if hero already has that upgrade, pick another one
      while hero:HasAbility(abilityName) do
        local abilityUpgradeIndex = math.random(1,9)
        abilityName = GameMode.abilityUpgrades.basic[abilityUpgradeIndex]
      end
    elseif level == 9 then
      --pick a random number between 10 and 12
      local abilityUpgradeIndex = math.random(1, 3)
      abilityName = GameMode.abilityUpgrades.ult[abilityUpgradeIndex]
      --if hero already has that upgrade, pick another one
      while hero:HasAbility(abilityName) do
        local abilityUpgradeIndex = math.random(1, 3)
        abilityName = GameMode.abilityUpgrades.ult[abilityUpgradeIndex]
      end
    elseif level >= 10 and level <= 12 then
      --pick a random number between 10 and 12
      local abilityUpgradeIndex = math.random(1, 9)
      abilityName = GameMode.abilityUpgrades.basic[abilityUpgradeIndex]
      --if hero already has that upgrade, pick another one
      while hero:HasAbility(abilityName) do
        local abilityUpgradeIndex = math.random(1, 9)
        abilityName = GameMode.abilityUpgrades.basic[abilityUpgradeIndex]
      end
    elseif level == 13 then
      --pick a random number between 10 and 12
      local abilityUpgradeIndex = math.random(1, 3)
      abilityName = GameMode.abilityUpgrades.ult[abilityUpgradeIndex]
      --if hero already has that upgrade, pick another one
      while hero:HasAbility(abilityName) do
        local abilityUpgradeIndex = math.random(1, 3)
        abilityName = GameMode.abilityUpgrades.ult[abilityUpgradeIndex]
      end
    end
    --hero has all abilities
    --on level up,
    --active and hidden=false
    print("adding ability: " .. abilityName)
    local upgrade = hero:AddAbility(abilityName)
    upgrade:SetLevel(1)
    --for testing
    --ult is at index 6
    upgrade:SetAbilityIndex(6 + hero.numUpgrades)
    hero.numUpgrades = hero.numUpgrades + 1
    
    if abilityName == "cookie_oven" then
      hero.score = 0
    end
    
    --print(abilityName)
    --if ability is machine gun or double barreled then
    if abilityName == "lil_shredder_machine_gun" then 
      hero:SwapAbilities("lil_shredder_base", "lil_shredder_machine_gun", false, true)
    elseif abilityName == "scatterblast_double_barreled" then
      hero:SwapAbilities("scatterblast_base", "scatterblast_double_barreled", false, true)
    end
    --announce which ability was gained
    Notifications:Bottom(hero:GetPlayerID(), {text=string.format("upgrade gained: %s", abilityName), duration=5, style={color="white"}})
  end
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
  --playerID is based on the order the player joined the game
  local playerID = player:GetPlayerID()
  --player id for the first player = 0
  --once game starts (0:00), this doesn't run anymore
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died (an entity killed an entity)
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )

  -- The Killing entity
  local killerEntity = nil

  -- Indexes:
  local killed_entity_index = keys.entindex_killed
  local attacker_entity_index = keys.entindex_attacker
  local inflictor_index = keys.entindex_inflictor -- it can be nil if not killed by an item or ability

  -- Find the entity that was killed
  local killed_unit
  if killed_entity_index then
    killed_unit = EntIndexToHScript(killed_entity_index)
  end

  -- Find the entity (killer) that killed the entity mentioned above
  local killer_unit
  if attacker_entity_index then
    killer_unit = EntIndexToHScript(attacker_entity_index)
  end

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- Find the ability/item used to kill, or nil if not killed by an item/ability
  local killing_ability
  if inflictor_index then
    killing_ability = EntIndexToHScript(inflictor_index)
  end

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  --if cookie heap kills a unit or a hero
  if killer_unit:GetTeamNumber() == 0 then
    --continue
  elseif killer_unit:GetUnitName() == "freshly_baked_cookie_heap" then
    --increase its size, its hp, and heal it
    --killer_unit:AddNewModifier(nil, nil, "modifier_absorb", {})
    killer_unit:FindAbilityByName("absorb"):OnSpellStart()
    --increase its size
    --cast absorb again
    --set its immolation radius larget
    --killer_unit:SetModelScale(killer_unit:GetModelScale() + 0.1)
    --killer_unit:AddNewModifier(nil, nil, "modifier_extra_health_morty", {extraHealth = 50})
    --add modifier on creating creep
    --on killing an enemy, update its stack
    --on refresh, increase health by stack size and heal it
    --killer_unit:Heal()
  end


  -- Put code here to handle when an entity gets killed
  --if it's a hero
  if killed_unit:IsRealHero() then 
    DebugPrint("[BAREBONES] Hero killed, calling HeroKilled function.")
    --if horde is active then
    if GameMode.games["horde"].active then
      --if only one hero is alive
      local numHeroesAlive = 0
      local heroAlive
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID  = 0, GameMode.maxNumPlayers - 1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              if GameMode.teams[teamNumber][playerID].hero:IsAlive() then
                numHeroesAlive = numHeroesAlive + 1
                heroAlive = GameMode.teams[teamNumber][playerID].hero
              end
            end
          end
        end
      end
      if numHeroesAlive == 1 then
        local mostKillsHero = 0
        local mostKills = 0
        for teamNumber = 6, 13 do
          if GameMode.teams[teamNumber] ~= nil then
            for playerID  = 0, GameMode.maxNumPlayers - 1 do
              if GameMode.teams[teamNumber][playerID] ~= nil then
                if GameMode.teams[teamNumber][playerID].hordeCreepKills > mostKills then
                  mostKillsHero = GameMode.teams[teamNumber][playerID].hero
                  mostKills = GameMode.teams[teamNumber][playerID].hordeCreepKills
                end
              end
            end
          end
        end
        --kill remaining creeps
        for i = 1, 100 do
          if GameMode.games["horde"].creeps[i]:IsAlive() then
            GameMode.games["horde"].creeps[i]:ForceKill(false)
          end
        end
        --declare him as the winner
        GameMode:EndGame(mostKillsHero, "horde")
      end
    --[[elseif GameMode.games["morty"].active then
      print("[GameMode:OnEntityKilled( keys )] killed entity is a hero, and morty game is active")
      --if one person alive,
        --end game
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          if GameMode.teams[teamNumber][killed_unit:GetPlayerOwnerID()] ~= nil then
            if GameMode.teams[teamNumber][killed_unit:GetPlayerOwnerID()].minigameActive == false then
              --nothing
            else
              GameMode.teams[teamNumber][killed_unit:GetPlayerOwnerID()].minigameActive = false
              killed_unit:SetTeam(killed_unit.originalTeam)
              GameMode.games["morty"].numAlive = GameMode.games["morty"].numAlive - 1
            end
          end
        end
      end
      print("[GameMode:OnEntityKilled( keys )] num alive: " .. GameMode.games["morty"].numAlive)
      --for one person remaining to win
      --[[if GameMode.games["morty"].numAlive == 1 then
        print("[GameMode:OnEntityKilled( keys )] one player left")
        --declare winner
        --find alive player
        local winner = {}
        for teamNumber = 6, 13 do
          if GameMode.teams[teamNumber] ~= nil then
            for playerID  = 0, GameMode.maxNumPlayers - 1 do
              if GameMode.teams[teamNumber][playerID] ~= nil then
                if GameMode.teams[teamNumber][playerID].hero:IsAlive() and GameMode.teams[teamNumber][playerID].minigameActive then
                  winner[playerID + 1] = GameMode.teams[teamNumber][playerID].hero
                end
              end
            end
          end
        end
        print("[GameMode:OnEntityKilled( keys )] winner:")
        PrintTable(winner)
        GameMode.games["morty"].morty:ForceKill(false)
        --Timers:CreateTimer({
          --endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
          --callback = function()
            print("[GameMode:OnEntityKilled( keys )] ending game because one person's left")
            GameMode:EndGame(winner, "morty")
            GameMode.games["morty"].numAlive = 0
          --end
        --})]]
      --for team game
      --[[if GameMode.games["morty"].numAlive == 0 then
        print("[GameMode:OnEntityKilled( keys )] everyone dead")
        GameMode:EndGame({}, "morty")
        GameMode.games["morty"].morty:ForceKill(false)
      else
        --spawn back in arena
        --set respawn position
        
        local start_center_ent = Entities:FindByName(nil, "start_center")
        local start_center_ent_vector = start_center_ent:GetAbsOrigin()
        GameMode.teams[killed_unit:GetTeam()][killed_unit:GetPlayerOwnerID()].hero:SetRespawnPosition(start_center_ent_vector)
        --set minigame active to false
        GameMode.teams[killed_unit:GetTeam()][killed_unit:GetPlayerOwnerID()].minigameActive = false
        --call heroKilled
        GameMode:HeroKilled(killed_unit, killer_unit, killing_ability)
      end]]
    elseif GameMode.games["feederAndEater2"].active then
      --print("name of killer unit: " .. killer_unit:GetUnitName())
      --give killer score
      --Notifications:BottomToTeam(killer_unit:GetTeam(), {text="Scored TWO points", duration=3, class="NotificationMessage"})
      --prevent self-kill as counting score
      --hammer entity's team = 0
      if killer_unit:GetTeam() ~= 0 then
        print("killer's team: " .. killer_unit:GetTeam())
        print("Scored TWO points")
        GameMode.games["feederAndEater2"].newTeams[killer_unit:GetTeam()].score = GameMode.games["feederAndEater2"].newTeams[killer_unit:GetTeam()].score + 2
      end
    else
      --print("[GameMode:OnEntityKilled( keys )] hero dead")
      GameMode:HeroKilled(killed_unit, killer_unit, killing_ability)
    end
  --else (e.g. creep)
  else
    --if killed entity is an event creep
    if killed_unit:GetUnitName() == "bristleback_cookie"  or killed_unit:GetUnitName() == "immortal_morty" then
      --so that "object of type none" doesn't happen
      GameMode.games["normal"].npcs[killed_unit.index] = nil
    --if fae creep is dead
    elseif killed_unit:GetUnitName() == "fae_creep" then
      GameMode.games["feederAndEater"].creeps[killed_unit.index] = nil
      --killed_unit:RemoveSelf()
    --if maze target is dead
    elseif killed_unit == GameMode.maze.mazeTarget then
      --declare winner
      local winner = {}
      winner[1] = killer_unit
      GameMode:EndGame(winner, "maze")
    --[[elseif killed_unit:GetUnitName() == "npc_dota_neutral_kobold" then
      print("[GameMode:OnEntityKilled( keys )] kobold killed")
      print("[GameMode:OnEntityKilled( keys )] killer unit: ")
      PrintTable(killer_unit)
      print(killer_unit:GetUnitName())
      --increase count for player
      --GameMode.teams[killer_unit:GetTeam()][killer_unit:GetPlayerID()].hordeCreepKills = GameMode.teams[killer_unit:GetTeam()][killer_unit:GetPlayerID()].hordeCreepKills + 1
      --increase count for kills
      --GameMode.games["horde"].creepsKilled = GameMode.games["horde"].creepsKilled + 1
      --if kill reached threshold
      if GameMode.games["horde"].creepsKilled == 100 then
        --check who had the most kills
        local mostKillsHero = 0
        local mostKills = 0
        for teamNumber = 6, 13 do
          if GameMode.teams[teamNumber] ~= nil then
            for playerID  = 0, GameMode.maxNumPlayers - 1 do
              if GameMode.teams[teamNumber][playerID] ~= nil then
                if GameMode.teams[teamNumber][playerID].hordeCreepKills > mostKills then
                  mostKillsHero = GameMode.teams[teamNumber][playerID].hero
                  mostKills = GameMode.teams[teamNumber][playerID].hordeCreepKills
                end
              end
            end
          end
        end
        local winner = {}
        winner[1] = mostKillsHero
        --declare him as the winner
        GameMode:EndGame(winner, "horde")
      end]]
    --for feeder and eater 2
    elseif killed_unit:GetUnitName() == "npc_dota_neutral_kobold"  and GameMode.games["feederAndEater2"].active then
      GameMode.games["feederAndEater2"].creeps[killed_unit.index] = nil
      --give killer score
      --Notifications:BottomToTeam(killer_unit:GetTeam(), {text="Scored a point", duration=3, class="NotificationMessage"})
      print("Scored a point")
      --kobolds can also be killed at the end of the game
      if killer_unit:GetUnitName() == "npc_dota_hero_snapfire" then
        GameMode.games["feederAndEater2"].newTeams[killer_unit:GetTeam()].score = GameMode.games["feederAndEater2"].newTeams[killer_unit:GetTeam()].score + 1
      end
    --[[elseif killed_unit:GetUnitName() == "mortimer" then
      print("[GameMode:OnEntityKilled( keys )] killed entity morty")
      --turn everyone back to their original teams
      for teamNumber = 6, 13 do
          if GameMode.teams[teamNumber] ~= nil then
              for playerID  = 0, GameMode.maxNumPlayers - 1 do
                  if GameMode.teams[teamNumber][playerID] ~= nil then
                      GameMode.teams[teamNumber][playerID].hero:SetTeam(GameMode.teams[teamNumber][playerID].originalTeam)
                  end
              end
          end
      end
      --end game with remaining people as winners
      local winners = {}
      for teamNumber = 6, 13 do
          if GameMode.teams[teamNumber] ~= nil then
              for playerID  = 0, GameMode.maxNumPlayers - 1 do
                  if GameMode.teams[teamNumber][playerID] ~= nil then
                      if GameMode.teams[teamNumber][playerID].minigameActive then
                          print("[GameMode:OnEntityKilled( keys )] setting a winner")
                          winners[playerID+1] = GameMode.teams[teamNumber][playerID].hero
                      end
                  end
              end
          end
      end
      print("[GameMode:OnEntityKilled( keys )] ending game because morty died")
      PrintTable(winners)
      GameMode:EndGame(winners, "morty")
      GameMode.games["morty"].numAlive = 0]]
    end
  end
end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
-- doesn't get called for bots
function GameMode:OnConnectFull(keys)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(keys)
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
  local teamNum = PlayerResource:GetTeam(playerID)

  --[[if GameMode.teams[teamNum] == nil then
    print("[GameMode:OnHeroInGame] making a new entry in the 'teams' table")
    GameMode.teams[teamNum] = {}
    GameMode.teams[teamNum]["players"] = {}
    GameMode.teams[teamNum].score = 0
    GameMode.teams[teamNum].remaining = true
    GameMode.teams[teamNum].totalDamageDealt = 0
    GameMode.teams[teamNum].sentry = nil
    --deprecate
    GameMode.teams[teamNum].wanted = false
  end
  GameMode.teams[teamNum]["players"][playerID] = {}
  GameMode.teams[teamNum]["players"][playerID].hero = PlayerResource:GetSelectedHeroEntity(playerID)
  GameMode.teams[teamNum]["players"][playerID].totalDamageDealt = 0
  GameMode.teams[teamNum]["players"][playerID].totalKills = 0

  GameMode.numPlayers = GameMode.numPlayers + 1]]
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  DebugPrint('[BAREBONES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  --local playerID = self.vUserIds[userID]:GetPlayerID()
  local text = keys.text
end


-- This function turns the "name" table into vector table
function GameMode:InitializeVectors()
  for i,list in pairs(MultPatrol) do
    MultVector[i] = {}
    for j,entloc in pairs(list) do
      local pos = Entities:FindByName(nil, entloc):GetAbsOrigin()
      MultVector[i][j] = pos
    end
  end
  --[[for i,list in pairs(Bounds) do
    BoundsVector[i] = {}
    for j,entloc in pairs(list) do
      local pos = Entities:FindByName(nil, entloc):GetAbsOrigin()
      BoundsVector[i][j] = pos
    end
  end]]
end


