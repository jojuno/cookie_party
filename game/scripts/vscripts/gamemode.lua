-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end


-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')
-- This library contains the function that checks if a player's talent has been activated
require('libraries/player')


-- Rune system override
require('components/runes') 
require('filters')
require('libraries/keyvalues')



-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
require('internal/util')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')
-- core_mechanics.lua is where you can specify how the game works
require('core_mechanics')
-- modifier_ai_morty.lua is where you can specify how morty will behave
require('libraries/modifiers/modifier_ai_morty')
-- modifier_ai_morty.lua is where you can specify how much health morty will have
require('libraries/modifiers/modifier_extra_health_morty')
-- modifiers mana pool and regen
require('libraries/modifiers/modifier_extra_mana')
-- modifier_stunned.lua stuns the entity on creation
require('libraries/modifiers/modifier_stunned')
-- modifier_invulnerable.lua adds the invulnerability modifier
require('libraries/modifiers/modifier_invulnerable')
-- modifier_invulnerable.lua adds the magic immunity modifier
require('libraries/modifiers/modifier_magic_immune')
-- modifier_silenced.lua adds the silenced modifier
require('libraries/modifiers/modifier_silenced')
-- modifier_attack_immune.lua adds the attack immunity modifier
require('libraries/modifiers/modifier_attack_immune')
-- modifier_attack_immune.lua adds the attack immunity modifier
require('libraries/modifiers/modifier_specially_deniable')
-- modifier_invisible.lua adds the invisibility modifier
require('libraries/modifiers/modifier_invisible')
-- modifier_attack_immune.lua adds the bloodlust modifier that speeds up the hero when it kills another hero
require('modifier_fiery_soul_on_kill_lua')
-- modifier that applies a red color to units that have been aggroed
require('libraries/modifiers/modifier_aggro')
-- removes the max move speed
require('libraries/modifiers/modifier_set_max_move_speed')
-- removes the min move speed
require('libraries/modifiers/modifier_set_min_move_speed')

-----------
-- Skins --
-----------
-- teleport
require('libraries/modifiers/modifier_teleport_effect')

-- npc_events is a feature in the normal phase of the game
require('npc_events')

----------------
-- Mini Games --
----------------
require('minigames/frogger')
require('minigames/shotgun')
require('minigames/button_mash')
require('minigames/morty')
require('minigames/mines')
require('minigames/twenty_one')
require('libraries/modifiers/modifier_cookie_eaten')
require('minigames/cookie_party')
require("minigames/escape")

-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "what_the_kuck" then
  require("what_the_kuck")
  GameMode.mapName = "what_the_kuck"
end

---------------------------------------------------------------
--helper functions
---------------------------------------------------------------

---------------------------------------------------------------
--coordiantes of square boundaries
---------------------------------------------------------------
--top left 
--[[
local boundaryTopLeftEnt = Entities:FindByName(nil, "shotgun_boundary_top_left")
local boundaryTopLeftEntVector = boundaryTopLeftEnt:GetAbsOrigin()
print("shotgun top left location: ")
print(boundaryTopLeftEntVector)
--[-2631.641357 -6653.456543 256.000000]

--top right
local boundaryTopRightEnt = Entities:FindByName(nil, "shotgun_boundary_top_right")
local boundaryTopRightEntVector = boundaryTopRightEnt:GetAbsOrigin()
print("shotgun top right location: ")
print(boundaryTopRightEntVector)
--[-3938.178711 -6721.492188 256.000000]

--bottom left
local boundaryBottomLeftEnt = Entities:FindByName(nil, "shotgun_boundary_bottom_left")
local boundaryBottomLeftEntVector = boundaryBottomLeftEnt:GetAbsOrigin()
print("shotgun bottom left location: ")
print(boundaryBottomLeftEntVector)
--[-3931.667725 -8008.909180 256.000000]

--bottom right
local boundaryBottomRightEnt = Entities:FindByName(nil, "shotgun_boundary_bottom_right")
local boundaryBottomRightEntVector = boundaryBottomRightEnt:GetAbsOrigin()
print("shotgun bottom right location: ")
print(boundaryBottomRightEntVector)
--[-2630.993164 -7924.344238 256.000000]
]]

---------------------------------------------------------------
--get a hammer entity's location as a vector
---------------------------------------------------------------
--local xxxEnt = Entities:FindByName(nil, "ent_name_in_hammer")
--local xxxEntVector = xxxEnt:GetAbsOrigin()

---------------------------------------------------------------
--get hero entity with player ID
---------------------------------------------------------------
--local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)

---------------------------------------------------------------
--finding info_target in hammer
---------------------------------------------------------------
--local xxxxEnt = Entities:FindByName(nil, "entity_name_in_hammer")
-- GetAbsOrigin() is a function that can be called on any entity to get its location
--local xxxxEntVector = xxxxEnt:GetAbsOrigin()

---------------------------------------------------------------
--ordering elements in a table
---------------------------------------------------------------
function GameMode:spairs(t, order)
  -- collect the keys
  local keys = {}
  for k in pairs(t) do keys[#keys+1] = k end

  -- if order function given, sort by it by passing the table and keys a and b
  -- otherwise just sort the keys 
  if order then
      table.sort(keys, function(a,b) return order(t, a, b) end)
  else
      table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
      i = i + 1
      if keys[i] then
          return keys[i], t[keys[i]]
      end
  end
end

---------------------------------------------------------------
--rounding numbers
---------------------------------------------------------------
function GameMode:Round (num)
  return math.floor(num + 0.5)
end

---------------------------------------------------------------
--pass in a function (x)
--block that loops through every player in the game
--search keyboards: for all players
---------------------------------------------------------------
function GameMode:ApplyToAllPlayers(do_this)
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.maxNumPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          --disconnect check
          if PlayerResource:IsValidPlayerID(playerID) then
            local heroEntity = GameMode.teams[teamNumber][playerID]
            do_this(heroEntity)
          end
        end
      end
    end
  end
end

---------------------------------------------------------------
-- get num players
---------------------------------------------------------------
function GameMode:GetNumberOfPlayers()
  local numPlayers = 0
  for playerID = 0, GameMode.maxNumPlayers - 1 do
      if PlayerResource:IsValidPlayerID(playerID) then
        numPlayers = numPlayers + 1
      end
  end
  return numPlayers
end


---------------------------------------------------------------
--freeze all players
---------------------------------------------------------------
function GameMode:FreezeAllPlayers()
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
          heroEntity:AddNewModifier(nil, nil, "modifier_stunned", {})
          heroEntity:AddNewModifier(nil, nil, "modifier_invulnerable", {})
        end
      end
    end
  end
end

---------------------------------------------------------------
--count down 4 seconds
---------------------------------------------------------------
function GameMode:CountDown()
  --do the announcement
  Timers:CreateTimer({
    callback = function()
      Notifications:BottomToAll({text="4... " , duration= 8.0, style={["font-size"] = "45px"}})
    end
  })
  Timers:CreateTimer({
    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      Notifications:BottomToAll({text="3... " , duration= 1.0, style={["font-size"] = "45px"}, continue=true})
    end
  })
  Timers:CreateTimer({
    endTime = 2, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      Notifications:BottomToAll({text="2... " , duration= 1.0, style={["font-size"] = "45px"}, continue=true})
    end
  })
  Timers:CreateTimer({
    endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      Notifications:BottomToAll({text="1... " , duration= 1.0, style={["font-size"] = "45px"}, continue=true})
    end
  })
  Timers:CreateTimer({
    endTime = 4, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      Notifications:BottomToAll({text="GO!" , duration= 1.0, style={["font-size"] = "45px", color = "red"}, continue=true})
    end
  })
end

---------------------------------------------------------------
-- Remove all abilities
---------------------------------------------------------------
function GameMode:RemoveAllAbilities(hero)
  for abilityIndex = 0, 10 do
    abil = hero:GetAbilityByIndex(abilityIndex)
    if abil ~= nil then
      hero:RemoveAbilityByHandle(abil)
    end
  end
end

---------------------------------------------------------------
-- Remove all items
---------------------------------------------------------------
function GameMode:RemoveAllItems(hero)
  for itemIndex = 0, 10 do
    if hero:GetItemInSlot(itemIndex) ~= nil then
      hero:RemoveItem(hero:GetItemInSlot(itemIndex))
    end
  end
end

---------------------------------------------------------------
-- Add all original abilities
---------------------------------------------------------------
function GameMode:AddAllOriginalAbilities(hero)
  --check by hero name
  if hero:GetUnitName() == "npc_dota_hero_snapfire" then
    --add all her abilities
    hero:AddAbility("snapfire_scatterblast")
    hero:AddAbility("snapfire_firesnap_cookie")
    hero:AddAbility("snapfire_lil_shredder")
    hero:AddAbility("snapfire_gobble_up")
    --"gobble up" is hidden by default
    --hero:GetAbilityByIndex(3):SetHidden(false)
    hero:AddAbility("snapfire_spit_creep")
    hero:AddAbility("snapfire_mortimer_kisses")
    --level them up
        local abil = hero:GetAbilityByIndex(0)
        abil:SetLevel(4)
        abil = hero:GetAbilityByIndex(1)
        abil:SetLevel(4)
        abil = hero:GetAbilityByIndex(2)
        abil:SetLevel(4)
        abil = hero:GetAbilityByIndex(5)
        abil:SetLevel(3)
        --abil = hero:GetAbilityByIndex(4)
        --abil:SetLevel(1)
        --abil = hero:GetAbilityByIndex(5)
        --abil:SetLevel(3)
  end
end

---------------------------------------------------------------
-- Level up all abilities to Max Level
---------------------------------------------------------------
function GameMode:MaxAllAbilities(hero)
  for index = 0, 9 do
    if hero:GetAbilityByIndex(index) ~= nil then
      --it's okay if argument is above the max level
      hero:GetAbilityByIndex(index):SetLevel(10)
    end
  end
  if hero:GetUnitName() == "npc_dota_hero_invoker" then
    --deafening blast talent
    for i = 0, 29 do
      hero:HeroLevelUp(false)
    end
  end
end

---------------------------------------------------------------
-- Add all original items
---------------------------------------------------------------
function GameMode:AddAllOriginalItems(hero)
  local item = CreateItem("item_greater_crit", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_greater_crit", hero, hero)
  hero:AddItem(item)
  --local item = CreateItem("item_black_king_bar", hero, hero)
  --hero:AddItem(item)
  local item = CreateItem("item_greater_crit", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_monkey_king_bar", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_ultimate_scepter", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_octarine_core", hero, hero)
  hero:AddItem(item)
end

-------------------------------------------------------------------
-- Spawn player at the location of the entity with the given name
-------------------------------------------------------------------
function GameMode:SpawnPlayer(heroEntity, hammerEntityName)
  print("spawning player")
  --special spawn for feeder and eater 2
  local spawnEnt
  local spawnEntVector
  if GameMode.games["feederAndEater2"].active then
    if heroEntity.role == "eater" then
      spawnEnt = Entities:FindByName(nil, hammerEntityName)
      spawnEntVector = spawnEnt:GetAbsOrigin()
      spawnEntVector = Vector(spawnEntVector.x + math.random(-500, 500), 
                              spawnEntVector.y + math.random(-500, 500), 
                              spawnEntVector.z)
    else
      spawnEnt = Entities:FindByName(nil, hammerEntityName)
      spawnEntVector = spawnEnt:GetAbsOrigin()
      spawnEntVector = Vector(spawnEntVector.x, 
                              spawnEntVector.y + math.random(-500, 500), 
                              spawnEntVector.z)
    end
  else
    spawnEnt = Entities:FindByName(nil, hammerEntityName)
    spawnEntVector = spawnEnt:GetAbsOrigin()
  end
  heroEntity:SetRespawnPosition(spawnEntVector)
  GameMode:Restore(heroEntity)
end

function GameMode:SpawnPlayerRandomlyAroundCenter(heroEntity, hammerEntityName)
  local spawnEnt
  local spawnEntVector
  spawnEnt = Entities:FindByName(nil, hammerEntityName)
  spawnEntVector = spawnEnt:GetAbsOrigin()
  local rangeReduction = 0
  if hammerEntityName == "escape_start" 
  or hammerEntityName == "escape_checkpoint_1_center"
  or hammerEntityName == "escape_checkpoint_2_center" 
  or hammerEntityName == "escape_checkpoint_3_center" 
  or hammerEntityName == "escape_checkpoint_4_center" 
  or hammerEntityName == "escape_checkpoint_5_center"then
    rangeReduction = 500
  end
  spawnEntVector = Vector(spawnEntVector.x + math.random(-600 + rangeReduction, 600 - rangeReduction), 
                          spawnEntVector.y + math.random(-600 + rangeReduction, 600 - rangeReduction), 
                          spawnEntVector.z)
  heroEntity:SetRespawnPosition(spawnEntVector)
  GameMode:Restore(heroEntity)
end

function GameMode:GetHammerEntityLocation(hammerEntityName)
  local spawnEnt = Entities:FindByName(nil, hammerEntityName)
  local spawnEntVector = spawnEnt:GetAbsOrigin()
  return spawnEntVector
end

---------------------------------------------------------------
-- Pick a random mini game
---------------------------------------------------------------
function GameMode:PickGame(gameIndex)
  --get number of players
  GameMode.numPlayers = GameMode:GetNumberOfPlayers()
  --loop through IDs with number of players; ID goes up to max number of players

  --kill everybody
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.maxNumPlayers-1 do
        if PlayerResource:IsValidPlayerID(playerID) then
          if GameMode.teams[teamNumber][playerID] ~= nil then
            GameMode.teams[teamNumber][playerID]:ForceKill(false)
            --save items "takes" items which clears them from players
            --teleport
            if PlayerResource:GetSelectedHeroEntity(playerID).teleportCast == true then
              print("teleport cast")
            end
          end
        end
      end
    end
  end
  --delay to wait for projectiles to disappear
  Timers:CreateTimer({
    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      if gameIndex == 1 then
        --singles
        GameMode:Shotgun()
      elseif gameIndex == 2 then
        --singles
        GameMode:Frogger()
      --version 2
      elseif gameIndex == 3 then
        --singles
        GameMode:ButtonMash()
      elseif gameIndex == 4 then
        --team
        GameMode:Morty()
      elseif gameIndex == 5 then
        --singles
        GameMode:Mines()
        --doubles
        --GameMode:FeederAndEater2()
      elseif gameIndex == 6 then
        GameMode:TwentyOne()
        --teams
        --GameMode:BattleShip()
      elseif gameIndex == 7 then
        cookie_party:Start()
        --doubles
        --GameMode:CookieDuo()
      elseif gameIndex == 8 then
        --everyone
        escape:Start()
      elseif gameIndex == 9 then
        GameMode:Race()
        --GameMode:CookieParty()
      elseif gameIndex == 10 then
        GameMode:Frogger2()
      elseif gameIndex == 11 then
        GameMode:BishiBashi()
        --rules
        --kiss
        --shotgun
        --feeder and eater
        
        --singles
        --GameMode:FeederAndEater()
        
        --epicenter
        --cookie gyro
        --cookie jump (slow turnrate)
        --ult
        --feed morty to attack opponents
      end
    end
  })

end



--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]




function GameMode:OnAllPlayersLoaded()

  GameMode.numPlayers = PlayerResource:NumPlayers()
  
  GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierFilter"), self)

  --countdown how many seconds until starting the main game
  GameMode.COUNT_DOWN_FROM = 30
  GameMode.endTime = GameMode:Round(GameRules:GetGameTime() + GameMode.COUNT_DOWN_FROM)

  --testing
  --spawn monsters
  --[[local rX = math.random(-8835, -7062)
  local rY = math.random(-7729, -6140)
  local rZ = math.random(128, 256)
  local monster = CreateUnitByName("winter_wyvern", Vector(rX, rY, rZ), true, PlayerResource:GetSelectedHeroEntity(0), PlayerResource:GetSelectedHeroEntity(0), 6)
  monster:SetControllableByPlayer(0, false)]]
  
  --CustomNetTables:SetTableValue("special_ability_upgrades", "key_10", { value = "hello" } )


  --pregame
  GameRules:GetGameModeEntity():SetThink(function ()

    local delta = GameMode:Round(GameMode.endTime - GameRules:GetGameTime())

    --won't run if delta == 20
    if delta == 29 then
      --picks a random game to play in 30 seconds
      GameMode:GameThinker()
      EmitGlobalSound('gbuTheme')
      Notifications:BottomToAll({text="Warm Up Phase" , duration= 20, style={["font-size"] = "45px", color = "red"}})
      return 1

    elseif delta > 4 then
      --sets the amount of seconds until SetThink is called again
      return 1

    elseif delta == 4 then
      --set pregame buffer so people don't resurrect when they die
      GameMode.pregameBuffer = true
      --kill everybody
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID = 0, GameMode.maxNumPlayers-1 do
            if PlayerResource:IsValidPlayerID(playerID) then
              if GameMode.teams[teamNumber][playerID] ~= nil then
                GameMode.teams[teamNumber][playerID]:ForceKill(false)
              end
            end
          end
        end
      end
      
      Notifications:ClearTopFromAll()
      Notifications:ClearBottomFromAll()
      --oh no, i'm finished..
      --and i'm taking my friends with me!
      Notifications:BottomToAll({text="I'm... DEAD?!" , duration= 2.0, style={["font-size"] = "45px", color = "red"}})
      Timers:CreateTimer({
        endTime = 2, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
        callback = function()
          Notifications:BottomToAll({text="I'M TAKING EVERYONE WITH ME!" , duration= 2.0, style={["font-size"] = "45px", color = "red"}})
        end
      })
      return 4

    elseif delta == 0 then
      GameMode.pregameActive = false
      GameMode.pregameBuffer = false
    end
  end)
end

function GameMode:GameThinker()
  --so that games are picked in a different sequence in every game
  math.randomseed(Time())
  Timers:CreateTimer("gameTimer", {
    useGameTime = true,
    callback = function()
      if GameMode.gameActive then
        --skip
        return 1
      else
        --if max games to play is reached then
        if GameMode.numGamesPlayed == GameMode.numGamesToPlay then
          local mostPoints = 0
          local teamNumWithMostPoints = nil
          --add score for kills
          for teamNumber = 6, 13 do
            if GameMode.teams[teamNumber] ~= nil then
              --based on GameMode.pointsPerKill
              --print("in game thinker, team number " .. teamNumber .. "'s score is " .. GameMode.teams[teamNumber].score)
              GameMode.teams[teamNumber].score = GameMode.teams[teamNumber].score + PlayerResource:GetTeamKills(teamNumber) * GameMode.pointsPerKill
            end
          end
          
          --find team with the most points
          --show scoreboard
          for teamNumber = 6, 13 do
            if GameMode.teams[teamNumber] ~= nil then
              --declare points for team
              Notifications:BottomToAll({text=string.format("%s: %s points", GameMode.teamNames[teamNumber], GameMode.teams[teamNumber].score), duration= 5.0, style={["font-size"] = "35px", color = GameMode.teamColors[teamNumber]}}) 
              --if team's score is higher than mostPoints
              if GameMode.teams[teamNumber].score > mostPoints then
                teamNumWithMostPoints = teamNumber
                mostPoints = GameMode.teams[teamNumber].score
              end
            end
          end

          --end game
          Timers:CreateTimer({
            endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            callback = function()
              GameRules:SetCustomVictoryMessage(string.format("%s WINS!", GameMode.teamNames[teamNumWithMostPoints]))
              GameRules:SetGameWinner(teamNumWithMostPoints)
              GameRules:SetSafeToLeave(true)
            end
          })

        --else
        else
          --pick a random game
          Notifications:BottomToAll({text="Playing a random game in 30 seconds", duration= 10.0, style={["font-size"] = "45px", color = "white"}}) 
          --during EndGame(), players will be spawned on the board
          --a new game will launch after 30 seconds
          
          --run only once, after 30 seconds
          Timers:CreateTimer({
            --one second before outer timer thinking again so GameMode.gameActive block runs in the next thought
            endTime = 29, -- how many seconds players can play on the board
            callback = function()
              --save player state
              for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                  for playerID = 0, GameMode.maxNumPlayers - 1 do
                    if GameMode.teams[teamNumber][playerID] ~= nil then
                      if PlayerResource:IsValidPlayerID(playerID) then
                        local heroEntity = GameMode.teams[teamNumber][playerID]
                        GameMode:SaveItems(heroEntity)
                        GameMode:SaveAbilities(heroEntity)
                        --set custom xp to 0 so they don't level up
                        heroEntity:SetDeathXP(0)
                      end
                    end
                  end
                end
              end

              --remove special item
              --if GameMode.mortyLoot ~= nil then
                --after removing, the model will linger
                --GameMode.mortyLoot:RemoveSelf()
                --UTIL_Remove(GameMode.mortyLoot)
              --end

              --pick a random game
              --local game_index = math.random(8)
              --testing
              --local game_index = 8
              --GameMode.game_index = 0
              GameMode.game_index = GameMode.game_index + 1
              if GameMode.game_index == 9 then
                GameMode.game_index = 1
              end
              
              GameMode:PickGame(GameMode.game_index)
              --testing
              --GameMode:PickGame(GameMode.game_index)

              --it will take a second before the game starts
              --[[for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                  for playerID = 0, GameMode.numPlayers - 1 do
                    if GameMode.teams[teamNumber][playerID] ~= nil then
                      local heroEntity = GameMode.teams[teamNumber][playerID]
                      GameMode:SaveItems(heroEntity)
                    end
                  end
                end
              end]]
              
              GameMode.numGamesPlayed = GameMode.numGamesPlayed + 1
              GameMode.gameActive = true
              GameRules:SetHeroRespawnEnabled(false)
            end
          })
          return 30 -- how many seconds players can play on the board
        end
      end
    end
  })
end

--kill all players
--give score to winner
  --different for every game
--respawn them back on the board
--restore their abilities and items
--set camera
function GameMode:EndGame()
  --flag for GameThinker()
  GameMode.gameActive = false

  --kill all players
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.maxNumPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            local heroEntity = GameMode.teams[teamNumber][playerID]
            heroEntity:ForceKill(false)
          end
        end
      end
    end
  end

  --respawn back on the board
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.maxNumPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            local heroEntity = GameMode.teams[teamNumber][playerID]
            GameMode:SpawnPlayerOnBoard(heroEntity)
            GameMode:SetCamera(heroEntity)
          end
        end
      end
    end
  end

  --move: ground
  --attack: ranged
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.maxNumPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            local heroEntity = GameMode.teams[teamNumber][playerID]

            --attributes
            heroEntity:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
            heroEntity:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
            heroEntity:SetModelScale(0.7)
            heroEntity:SetDayTimeVisionRange(2000)
            heroEntity:SetNightTimeVisionRange(2000)

            --items
            --remove items that were added in the mini game
            GameMode:RemoveAllItems(heroEntity)
            GameMode:ReturnItems(heroEntity)

            --abilities
            --remove everything held in the minigame
            GameMode:RemoveAllAbilities(heroEntity)
            --restore abilities held on the board
            GameMode:ReturnAbilities(heroEntity)

            --level
            heroEntity:SetDeathXP(70)

          end
        end
      end
    end
  end

  --game settings
  GameRules:SetHeroRespawnEnabled(true)
  GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)


  --js
  for playerID = 0, 7 do
    local player = PlayerResource:GetPlayer(playerID)
    if player ~= nil then
      CustomGameEventManager:Send_ServerToPlayer(player, "on_board", {})
    end
  end

end

function GameMode:SpawnPlayerOnBoard(hero)
  local respawnLocationX = math.random(-8835, -7062)
  local respawnLocationY = math.random(-7729, -6140)
  local respawnLocationZ = math.random(128, 256)
  --order matters
  hero:SetRespawnPosition(Vector(respawnLocationX, respawnLocationY, respawnLocationZ))
  hero:RespawnHero(false, false)
end

function GameMode:SaveItems(hero)
  --slot index is 0 based
  for itemSlot = 0, 9 do
    if hero:GetItemInSlot(itemSlot) ~= nil then
      local item = hero:GetItemInSlot(itemSlot)
      --"take item" preserves the item as a handle that can be retrieved later
      --returns the taken item
      GameMode.teams[hero:GetTeam()].items[itemSlot] = hero:TakeItem(item)
    end
  end
end

function GameMode:ReturnItems(hero)
  --10 is for special items like morty loot
  for itemSlot = 0, 10 do
    if GameMode.teams[hero:GetTeam()].items[itemSlot] ~= nil then
      local item = GameMode.teams[hero:GetTeam()].items[itemSlot]
      hero:AddItem(item)
    end
  end
end

function GameMode:SaveAbilities(hero)
  --save names
  --remove ability

  --talents that are on slots 10 - 13 get placed on 6 - 9 if there is space
  for abilitySlot = 0, 25 do
    if hero:GetAbilityByIndex(abilitySlot) ~= nil then
      if hero:GetAbilityByIndex(abilitySlot):GetAbilityName() ~= nil then
        local abilityName = hero:GetAbilityByIndex(abilitySlot):GetAbilityName()
        GameMode.teams[hero:GetTeam()].abilities[abilitySlot] = {}
        GameMode.teams[hero:GetTeam()].abilities[abilitySlot].name = abilityName
        GameMode.teams[hero:GetTeam()].abilities[abilitySlot].index = abilitySlot

        --save its level
        GameMode.teams[hero:GetTeam()].abilities[abilitySlot].level = hero:GetAbilityByIndex(abilitySlot):GetLevel()
        hero:RemoveAbility(abilityName)
      end
    end
  end

end

function GameMode:ReturnAbilities(hero)
  --add ability by name
  for abilitySlot = 0, 25 do
    if GameMode.teams[hero:GetTeam()].abilities[abilitySlot] ~= nil then
      local abilityName = GameMode.teams[hero:GetTeam()].abilities[abilitySlot].name
      local addedAbility = hero:AddAbility(abilityName)
      addedAbility:SetLevel(GameMode.teams[hero:GetTeam()].abilities[abilitySlot].level)
      addedAbility:SetAbilityIndex(GameMode.teams[hero:GetTeam()].abilities[abilitySlot].index)
    end
  end
end

----------------
-- Mini Games --
----------------

--cookie sumo
--cookie or scatterblast to push them out
--invis, bkb
--dodgeable
--phase boots (fast enough to avoid click)

--add all custom cookie abilities
function GameMode:Sumo() 
  Notifications:BottomToAll({text = "Cookie Sumo", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Cookie your opponents to throw them off stage", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  --spawn everyone on the sumo platform
  --remove their items
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            for itemIndex = 0, 10 do
              if heroEntity:GetItemInSlot(itemIndex) ~= nil then
                heroEntity:RemoveItem(heroEntity:GetItemInSlot(itemIndex))
              end
            end
            local item = CreateItem("item_phase_boots", heroEntity, heroEntity)
            heroEntity:AddItem(item)
            item = CreateItem("item_black_king_bar", heroEntity, heroEntity)
            heroEntity:AddItem(item)
            GameMode:RemoveAllAbilities(heroEntity)
            local sumo_center_ent = Entities:FindByName(nil, "sumo_center")
            local sumo_center_ent_vector = sumo_center_ent:GetAbsOrigin()
            heroEntity:SetRespawnPosition(sumo_center_ent_vector)
            GameMode:Restore(heroEntity)
            PlayerResource:SetCameraTarget(playerID, heroEntity)
            --must delay the undoing of the SetCameraTarget by a second; if they're back to back, the camera will not move
            --set entity to 'nil' to undo setting the camera
            heroEntity:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
            heroEntity:AddNewModifier(nil, nil, "modifier_attack_immune", {})
            heroEntity:AddAbility("dummy_spell")
            local abil = heroEntity:GetAbilityByIndex(0)
            abil:SetLevel(1)
            heroEntity:AddAbility("cookie_sumo")
            abil = heroEntity:GetAbilityByIndex(1)
            abil:SetLevel(1)
            --shotgun
            --force staff
            --bkb
            Timers:CreateTimer({
              endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
              callback = function()            
                PlayerResource:SetCameraTarget(playerID, nil)
              end
            })
          end
        end
      end
    end
  end
  --if player steps off the stage
    --trigger stun
    --add FOW vision on a hill
    --if there's one player remaining
      --end game with remaining player
  --hills
end




--dash
--high speed
--little curves
--force staff to run / push others
--"hoops" (make it VERY easy)
--movespeed fast
--few obstacles
--cookie, scatterblast, kisses that last longer and slows more
function GameMode:Dash()
  Notifications:BottomToAll({text = "Dash", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Move Move Move!", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  --spawn everyone on the maze
  --remove their items
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            GameMode:RemoveAllItems(heroEntity)
            GameMode:RemoveAllAbilities(heroEntity)
            local dash_start_ent = Entities:FindByName(nil, "dash_start")
            local dash_start_ent_vector = dash_start_ent:GetAbsOrigin()
            heroEntity:SetRespawnPosition(dash_start_ent_vector)
            GameMode:Restore(heroEntity)
            --items
            local item = CreateItem("item_force_staff", heroEntity, heroEntity)
            heroEntity:AddItem(item)
            --abilities
            heroEntity:AddAbility("snapfire_scatterblast")
            abil = heroEntity:GetAbilityByIndex(0)
            abil:SetLevel(4)
            heroEntity:AddAbility("cookie_selfcast")
            abil = heroEntity:GetAbilityByIndex(1)
            abil:SetLevel(1)
            --kisses
            --unique to this game
            heroEntity:SetBaseMoveSpeed(600)
            PlayerResource:SetCameraTarget(playerID, heroEntity)
            --must delay the undoing of the SetCameraTarget by a second; if they're back to back, the camera will not move
            --set entity to 'nil' to undo setting the camera
            heroEntity:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
            heroEntity:AddNewModifier(nil, nil, "modifier_set_max_move_speed", {})
            Timers:CreateTimer({
              endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
              callback = function()            
                PlayerResource:SetCameraTarget(playerID, nil)
              end
            })
          end
        end
      end
    end
  end
end


--skirmish
--kill each other
--easy
--maze
function GameMode:Maze() 
  Notifications:BottomToAll({text = "Maze", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Find the golem and kill it", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  --spawn everyone on the maze
  --remove their items
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            for itemIndex = 0, 10 do
              if heroEntity:GetItemInSlot(itemIndex) ~= nil then
                heroEntity:RemoveItem(heroEntity:GetItemInSlot(itemIndex))
              end
            end
            GameMode:RemoveAllAbilities(heroEntity)
            local maze_center_ent = Entities:FindByName(nil, "maze_center")
            local maze_center_ent_vector = maze_center_ent:GetAbsOrigin()
            heroEntity:SetRespawnPosition(maze_center_ent_vector)
            GameMode:Restore(heroEntity)
            PlayerResource:SetCameraTarget(playerID, heroEntity)
            --must delay the undoing of the SetCameraTarget by a second; if they're back to back, the camera will not move
            --set entity to 'nil' to undo setting the camera
            heroEntity:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
            Timers:CreateTimer({
              endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
              callback = function()            
                PlayerResource:SetCameraTarget(playerID, nil)
              end
            })
          end
        end
      end
    end
  end
  spawn_index = math.random(10)
  GameMode.maze.mazeTarget = GameMode:SpawnNeutral(string.format("maze_target_spawn_%s", spawn_index), "npc_dota_warlock_golem_1") 

  --scatterblast slows them
  --set thinker
  --if golem is dead
  --announce winner
  --meet back at the starting zone
  --can kill again
  --give it 20 seconds
  --start next game
end




--divide players into two teams
--if opposing team dies
  --endgame
  --return players to their original teams

--gamethinker
--run every second
--if all players in one team died,
  --endgame
  --return players to their original teams
  --respawn at normal


  --kiss providing no vision on battleship

function GameMode:BattleShip()
  GameMode.games["battleship"].active = true
  --spawn players on the field
  Notifications:BottomToAll({text = "BattleShip", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Blink or Ult", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  local team = 1
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            --spawn player based on team
            heroEntity:SetTeam(team)
            if team == 1 then
              local snapCenterEnt = Entities:FindByName(nil, "battleship_snap_center")
              local snapCenterEntVector = snapCenterEnt:GetAbsOrigin()
              heroEntity:SetRespawnPosition(snapCenterEntVector)
              --add vision of every teammate
              --location: teammate's location
              --kiss cannot see beyond 
              --check if regular kiss can see through hills
              Timers:CreateTimer(function()
                AddFOWViewer(teamNumber, snapCenterEntVector, 10000, 1, true)
                if GameMode.games["battleship"].active then
                  return 1
                else
                  return nil
                end
              end)
            else
              local fireCenterEnt = Entities:FindByName(nil, "battleship_fire_center")
              local fireCenterEntVector = fireCenterEnt:GetAbsOrigin()
              heroEntity:SetRespawnPosition(fireCenterEntVector)
              Timers:CreateTimer(function()
                AddFOWViewer(teamNumber, fireCenterEntVector, 10000, 1, true)
                if GameMode.games["battleship"].active then
                  return 1
                else
                  return nil
                end
              end)
            end
            GameMode:Restore(heroEntity)
            ----alternate team
            if team == 1 then
              team = 2
            else
              team = 1
            end
            --set camera
            PlayerResource:SetCameraTarget(playerID, heroEntity)
            Timers:CreateTimer({
              endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
              callback = function()            
                PlayerResource:SetCameraTarget(playerID, nil)
              end
            })
            --custom abilities
            GameMode:RemoveAllAbilities(heroEntity)
            local blink = heroEntity:AddAbility("antimage_blink_custom")
            blink:SetLevel(1)
            --for the vision
            local kiss = heroEntity:AddAbility("mortimer_kisses_battleship")
            kiss:SetLevel(1)
            local illusion = heroEntity:AddAbility("mirror_image")
            illusion:SetLevel(1)
            --modifiers
            heroEntity:AddNewModifier(nil, nil, "modifier_extra_mana", { extraMana = -995, regen = 1 })
            heroEntity:SetBaseMoveSpeed(200)
            --vision
            --heroEntity:GiveMana(5)
            --stats
            --heroEntity:SetDayTimeVisionRange(500)
            --heroEntity:SetNightTimeVisionRange(500)
            --mortimer kiss with one projectile
          end
        end
      end
    end
  end
  --run mini game thinker
  GameMode:BattleShipThinker()
end

function GameMode:BattleShipThinker()
  print("[GameMode:BattleShipThinker()] called")
  --local battleShipRunning = true
  Timers:CreateTimer(function()
    --check if the game is over
    --when everyone in one of the teams is dead
    --team 1, team 2
    local winner = {}
    for team = 1, 2 do
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID = 0, GameMode.numPlayers-1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              if PlayerResource:IsValidPlayerID(playerID) then
                local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
                if heroEntity:GetTeam() == team then
                  if not heroEntity:IsAlive() then
                    print("[GameMode:BattleShipThinker()] ending")
                    GameMode.games["battleship"].active = false
                  end
                end
              end
            end
          end
        end
      end
    end

    if not GameMode.games["battleship"].active then
      --find alive hero
      for team = 1, 2 do
        for teamNumber = 6, 13 do
          if GameMode.teams[teamNumber] ~= nil then
            for playerID = 0, GameMode.numPlayers-1 do
              if GameMode.teams[teamNumber][playerID] ~= nil then
                if PlayerResource:IsValidPlayerID(playerID) then
                  local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
                  if heroEntity:GetTeam() == team then
                    if heroEntity:IsAlive() then
                      print("[GameMode:BattleShipThinker()] found winner")
                      winner[playerID+1] = heroEntity
                    end
                  end
                end
              end
            end
          end
        end
      end
      --change their teams back to their original
      for team = 1, 2 do
        for teamNumber = 1,2 do
          if GameMode.teams[teamNumber] ~= nil then
            for playerID = 0, GameMode.numPlayers-1 do
              if GameMode.teams[teamNumber][playerID] ~= nil then
                if PlayerResource:IsValidPlayerID(playerID) then
                  local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
                  heroEntity:SetTeam(heroEntity.originalTeam)
                end
              end
            end
          end
        end
      end
      --end game
      GameMode:EndGame(winner, "battleship")
    end
    if GameMode.games["battleship"].active then
      print("[GameMode:BattleShipThinker()] still running")
      return 1.0
    else
      return nil
    end
  end)
end



--cookie duo
--cookie that goes backwards
--channel for distance

--divide into teams of 2
--turn into meepo
--if one dies, team dies
--thinker
  --if one team alive,
    --end

--abilities

function GameMode:CookieDuo()
  Notifications:BottomToAll({text = "Cookie Duo", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  --[[local newTeams = {}
  newTeams[6] = 0
  newTeams[7] = 0
  newTeams[8] = 0
  newTeams[9] = 0
  newTeams[10] = 0
  newTeams[11] = 0
  newTeams[12] = 0
  newTeams[13] = 0]]

  --make teams
  --number of teams = playernum / 2
  --turns into float division
  --someone will be in a team alone
  local numTeams = GameMode:Round(PlayerResource:NumPlayers() / 2)
  
  print("number of teams: " .. numTeams)
  math.randomseed(Time())
  for teamIndex = 1, numTeams do
    local randomTeam = math.random(6, 13)
    --make sure there's no overlap
    while GameMode.games["cookieDuo"].newTeams[randomTeam] ~= nil do
      randomTeam = math.random(6, 13)
    end
    GameMode.games["cookieDuo"].newTeams[randomTeam] = {}
  end

  --spawn players
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
          --assign new team
          for team, players in pairs(GameMode.games["cookieDuo"].newTeams) do
            print("assigning new team for team " .. team)
            local numPlayers = 0
            for _, _ in pairs(players) do
              numPlayers = numPlayers + 1
            end
            print('num players: ' .. numPlayers)
            if numPlayers < 2 then
              --switch hero to meepo
              --when a new hero is selected, team is reset
              local oldHero = heroEntity
              PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_meepo", PlayerResource:GetGold(playerID), 0)
              heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
              --returns "meepo"
              print("after switching to meepo, unit name: " .. heroEntity:GetUnitName())
              --also returns "meepo"
              print("name of original hero entity: " .. oldHero:GetUnitName())
              GameMode.teams[teamNumber][playerID].hero = heroEntity
              heroEntity.originalTeam = teamNumber
              heroEntity:SetTeam(team)
              GameMode.games["cookieDuo"].newTeams[team][playerID] = heroEntity

              --to make someone respawn at a custom location,
              --kill
              --set respawn location
              --respawn
              heroEntity:ForceKill(false)

              --local spawnEnt = Entities:FindByName(nil, ("shotgun_player_1"))
              --local spawnEntVector = spawnEnt:GetAbsOrigin()
              --selectedHero:SetRespawnPosition(spawnEntVector)

              --spawn on one of the 8 spots based on team; team goes from 6 to 13 and hammer entity goes from 1 to 8
              
              GameMode:SpawnPlayer(heroEntity, string.format("shotgun_player_%s", team-5))
              break
            else
              --continue
            end
          end

          --set camera
          GameMode:SetCamera(heroEntity)

          --customize abilities
          local abilitiesToAdd = {}
          --animations built in to ability slots
          --hits multiple targets
          --on hit, jump to target
          abilitiesToAdd[1] = "arrow_cookie"
          --shoots out from caster
          --on hit, shoot cookie to target nearby
          --abilitiesToAdd[2] = "bomb_cookie"
          --on hit, shoot cookie to nearest target
          --after hit target lands, shoot cookie to nearest target
          --abilitiesToAdd[3] = "chain_cookie"
          --to jump
          --abilitiesToAdd[4] = "channeled_cookie"
          --abilitiesToAdd[5] = "direction"
          --add effects to cookies, like fizzing on bomb cookie
          GameMode:CustomizeAbilities(heroEntity, abilitiesToAdd)
          --attack
          heroEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        end
      end
    end
  end

  --if there is a team with one player
    --assign him to one of the existing teams

  --remove team with one player
  --[[local alonePlayerID = nil
  for team, players in pairs(GameMode.games["cookieDuo"].newTeams) do
    local numPlayers = 0
    for _, _ in pairs(players) do
      numPlayers = numPlayers + 1
    end
    if numPlayers == 1 then
      --put player in a team with 2 players
      --set his previous team to nil
      for playerID, player in pairs(players) do
        alonePlayerId = playerID
      end
      team[alonePlayerID] = nil
    end
  end]]

  --add player to new team
  --[[if alonePlayerID ~= nil then
    --original 
    local alonePlayerHeroEntity = PlayerResource:GetSelectedHeroEntity(alonePlayerID)
    for team, players in pairs(GameMode.games["cookieDuo"].newTeams) do
      GameMode.games["cookieDuo"].newTeams[team][alonePlayerID] = alonePlayerHeroEntity
      --only need one iteration
      break
    end
  end]]

  GameMode:CookieDuoThinker()
end

function GameMode:CookieDuoThinker()
  --if player dead
  --kill his whole team
  Timers:CreateTimer({
    endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      --start with number of teams that started
      --when a team that's dead is found, subtract 1
      --if teamAlive = 1, endGame

      --find number of teams
      local numTeamAlive = 0
      for _, _ in pairs(GameMode.games["cookieDuo"].newTeams) do
        numTeamAlive = numTeamAlive + 1
      end

      --kill teams with players that is/are dead
      --[[for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID = 0, GameMode.numPlayers-1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
              if not heroEntity:IsAlive() then
                numTeamAlive = numTeamAlive - 1
                
                print("numTeamAlive = " .. numTeamAlive)
                for team, players in pairs(GameMode.games["cookieDuo"].newTeams) do
                  if team == heroEntity:GetTeam() then
                    for _, player in pairs(players) do
                      player:ForceKill(false)
                    end
                  end
                end
              end
            end
          end
        end
      end]]

      for team, players in pairs(GameMode.games["cookieDuo"].newTeams) do
        for _, player in pairs(players) do
          if not player:IsAlive() then
            for _, player2 in pairs(players) do
              player2:ForceKill(false)
            end
            numTeamAlive = numTeamAlive - 1
            break
          end
        end
      end

      --if only 1 team is alive then
        --set it as the winner
      local winners = {}
      if numTeamAlive == 1 then
        for team, players in pairs(GameMode.games["cookieDuo"].newTeams) do
          for playerID, player in pairs(players) do
            if player:IsAlive() then
              --print("name of hero kept in GameMode table: " .. GameMode.teams[player.originalTeam][playerID].hero:GetUnitName())
              winners[playerID+1] = GameMode.teams[player.originalTeam][playerID].hero
            end
          end
        end
        --return players to their original teams
        --for team, players in pairs(GameMode.games["cookieDuo"].newTeams) do
          --for playerID, player in pairs(players) do
            --[[if not player:IsAlive() then
              player:RespawnHero(false, false)
            end]]
            --GameMode:TurnPlayerToOriginalTeam(player)
            --PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_snapfire", PlayerResource:GetGold(playerID), 0)
          --end
        --end
        GameMode:EndGame(winners, "cookieDuo")
        return nil
      end
      return 0.1
    end
  })
end

--*storyboard*
--three spaces
--zone1, zone2 where eater and creeps spawn
--zone3 where feeders spawn
--creeps spawn randomly in zone 1 and 2
--feeder shoots a channeled cookie to eater
--channeled cookie can hit team or enemy
--eater eats cookie and hopefully jumps to a creep to kill it
--this is a point
--if eater kills another eater, this is 2 points
  --two hits to kill an eater
--first team to 5 points wins
--feeder = snap without the mount
--eater = morty
--feeders = magic immune, can still take damage from cookie

--*implementation*
--switch players into teams
--assign players into appropriate heroes
--assign players roles
--for each role, spawn accordingly
--make announcement explaining the role

function GameMode:FeederAndEater2()
  Notifications:BottomToAll({text = "Feeder and Eater 2", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 

  --flag
  GameMode.games["feederAndEater2"].active = true
  
  --make teams
  --someone will be in a team alone
  local numTeams = GameMode:Round(PlayerResource:NumPlayers() / 2)
  math.randomseed(Time())
  for teamIndex = 1, numTeams do
    local randomTeam = math.random(6, 13)
    --make sure there's no overlap
    while GameMode.games["feederAndEater2"].newTeams[randomTeam] ~= nil do
      randomTeam = math.random(6, 13)
    end
    GameMode.games["feederAndEater2"].newTeams[randomTeam] = {}
    GameMode.games["feederAndEater2"].newTeams[randomTeam].score = 0
  end

  --set teams
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
          --assign new team
          for team, _ in pairs(GameMode.games["feederAndEater2"].newTeams) do
            --count number of players in the team
            local numPlayers = 0
            for playerID2 = 0, GameMode.numPlayers-1 do
              if GameMode.games["feederAndEater2"].newTeams[team][playerID2] ~= nil then
                numPlayers = numPlayers + 1
              end
            end
            print("numPlayers: " .. numPlayers)
            --if there are less than 2 players (2 is the maximum)
            if numPlayers < 2 then
              --when a new hero is selected, team is reset
              
              print("assigning player with ID " .. playerID .. " to team " .. team)
              GameMode.games["feederAndEater2"].newTeams[team][playerID] = heroEntity
              heroEntity.originalTeam = teamNumber
              heroEntity:SetTeam(team)
              --heroEntity.FAE2Score = 0

              --to make someone respawn at a custom location,
              --kill
              --set respawn location
              --respawn
              heroEntity:ForceKill(false)
              break
            else
              --continue
            end
          end
        end
      end
    end
  end

  --assign roles to players
  --loop through players
  local role = "feeder"
  for team, _ in pairs(GameMode.games["feederAndEater2"].newTeams) do
    print("team: " .. team)
    --[[if type(playerID) == "table" then
      print("playerID is a table. Its value is: ")
      --PrintTable(playerID)
    else
      --print("playerID is NOT a table. Its value is: " .. playerID)
    end]]
    for playerID2 = 0, GameMode.numPlayers-1 do
      if GameMode.games["feederAndEater2"].newTeams[team][playerID2] ~= nil then
        local player = GameMode.games["feederAndEater2"].newTeams[team][playerID2]
        GameMode:RemoveAllAbilities(player)
        if role == "feeder" then
          --PlayerResource:ReplaceHeroWith(playerID, "snap_solo", PlayerResource:GetGold(playerID), 0)
          local arrow_cookie_fae_2 = player:AddAbility("arrow_cookie_fae_2")
          arrow_cookie_fae_2:SetLevel(1)
          local arrow_cookie_fae_2_release = player:AddAbility("arrow_cookie_fae_2_release")
          arrow_cookie_fae_2_release:SetLevel(1)
          GameMode:SpawnPlayer(player, "feeder_center")
          --player:AddNewModifier(nil, nil, "modifier_magic_immune", {})
          player.role = role
          role = "eater"
        else
          --PlayerResource:ReplaceHeroWith(playerID, "morty_solo", PlayerResource:GetGold(playerID), 0)
          math.randomseed(Time())
          local zone = math.random(2)
          GameMode:SpawnPlayer(player, string.format("eater_zone_%s_center", zone))
          player.role = role
          role = "feeder"
        end
        --set camera
        GameMode:SetCamera(player)
        --attack
        player:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
      end
    end

  end
  --in each team,
  --player 1 gets feeder
    --arrow channeled cookie ability
    --spawns on feeder_center
  --player 2 gets eater
    --no abilities
    --spawns on eater_zone_1 or 2_center
  GameMode:FeederAndEater2Thinker()
end

--kill creep = 1 point
--kill hero = 2 points
--reach 10 points = end game

--among us with creep
--cookie doesn't shoot so no one can see who cookied it

--creepThinker
--if killed, award a point to killer
--respawn

--creep spawn
--respawn player on death
--wall around arena
--feeders immune to cookie
function GameMode:FeederAndEaterTargetThinker()
end

function GameMode:FeederAndEater2Thinker()
  local finished = false

  --spawn creeps
  --randomly spawn them in each zone, 10 maximum at any point
  Timers:CreateTimer("creeps", {
    useGameTime = false,
    endTime = 1,
    callback = function()
      --when it's set immediately, same numbers can be drawn
      math.randomseed(Time())
      if finished then
        --kill all the creeps
        for creepIndex = 1, 10 do
          if GameMode.games["feederAndEater2"].creeps[creepIndex] ~= nil then
            GameMode.games["feederAndEater2"].creeps[creepIndex]:ForceKill(false)
          end
        end
        return nil
      else
        --spawn creeps
        for creepIndex = 1, 10 do
          if GameMode.games["feederAndEater2"].creeps[creepIndex] == nil then
            --pick a random spot within a zone
            local zone = math.random(2)
            local spawnEnt = Entities:FindByName(nil, string.format("eater_zone_%s_center", zone))
            local spawnEntVector = spawnEnt:GetAbsOrigin()
            spawnEntVector = Vector(spawnEntVector.x + math.random(-500, 500), 
                                    spawnEntVector.y + math.random(-500, 500), 
                                    spawnEntVector.z)
            GameMode.games["feederAndEater2"].creeps[creepIndex] = CreateUnitByName("npc_dota_neutral_kobold", spawnEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
            --death is handled in events.lua
            GameMode.games["feederAndEater2"].creeps[creepIndex].index = creepIndex
          end
        end
        return 1
      end
    end
  })

  --score is given to heroEntity in events.lua
  local winners = {}
  Timers:CreateTimer("finished", {
    useGameTime = false,
    endTime = 1,
    callback = function()
      for team, players in pairs(GameMode.games["feederAndEater2"].newTeams) do
        if GameMode.games["feederAndEater2"].newTeams[team].score >= 10 then
          for playerID = 0, GameMode.numPlayers-1 do
            if GameMode.games["feederAndEater2"].newTeams[team][playerID] ~= nil then
              local player = GameMode.games["feederAndEater2"].newTeams[team][playerID]
              winners[playerID+1] = GameMode.teams[player.originalTeam][playerID].hero
            end
          end
          --set the flag
          finished = true
          --kill all the entities specific to this game
          for team, _ in pairs(GameMode.games["feederAndEater2"].newTeams) do
            for playerID = 0, GameMode.numPlayers-1 do
              if GameMode.games["feederAndEater2"].newTeams[team][playerID] ~= nil then
                local player = GameMode.games["feederAndEater2"].newTeams[team][playerID]
                player:ForceKill(false)
              end
            end
          end
          GameMode:EndGame(winners, "feederAndEater2")
          return nil
        end
      end
      return 0.1
    end
  })

  --respawn players
  Timers:CreateTimer("spawnPlayers", {
    useGameTime = false,
    endTime = 0,
    callback = function()
      if not finished then
        math.randomseed(Time())
        for team, _ in pairs(GameMode.games["feederAndEater2"].newTeams) do
          for playerID = 0, GameMode.numPlayers-1 do
            if GameMode.games["feederAndEater2"].newTeams[team][playerID] ~= nil then
              local player = GameMode.games["feederAndEater2"].newTeams[team][playerID]
              if not player:IsAlive() then
                if player.role == "eater" then
                  local zone = math.random(2)
                  GameMode:SpawnPlayer(player, string.format("eater_zone_%s_center", zone))
                  player:SetTeam(team)
                else
                  GameMode:SpawnPlayer(player, "feeder_center")
                  player:SetTeam(team)
                end
              end
            end
          end
        end
        return 3
      else
        return nil
      end
    end
  })
end


--storyboard
  --tutorial
  --feeder and eater games
function GameMode:FeederAndEater()
  Notifications:BottomToAll({text = "Feeder and Eater", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Feed a cookie. Eat a cookie.", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Tutorial", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
  GameMode.games["feederAndEater"].active = true
  --for all players
  local role = "feeder"
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
          --spawn
          GameMode:SpawnPlayer(heroEntity, "faeStart")
          --set camera
          GameMode:SetCamera(heroEntity)
          --customize abilities
          --feeder = cookie abilities
          --eater = none
          --tutorial
            --feeder = creeps in place
            --eater = bot shooting cookies, face the right way
          --initially, everyone has all abilities
          local abilitiesToAdd = {}
          abilitiesToAdd[1] = "arrow_cookie_fae"
          GameMode:CustomizeAbilities(heroEntity, abilitiesToAdd)
          --vision
          --[[if role == "feeder" then
            heroEntity:SetDayTimeVisionRange(100)
            heroEntity:SetNightTimeVisionRange(100)
          end]]
          --assign role
          heroEntity.role = role
          if role == "feeder" then
            --announce "shoot the eater a cookie"
            role = "eater"
          else
            --announce "face the right direction"
            role = "feeder"
          end
          --attack
          heroEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        end
      end
    end
  end
  --tutorial
  --set up creeps
  --attack immune
  for creepIndex = 1, 3 do
    local creepEnt = Entities:FindByName(nil, string.format("faeCreepT_%s", creepIndex))
    local creepEntVector = creepEnt:GetAbsOrigin()
    GameMode.games["feederAndEater"].creeps[creepIndex] = CreateUnitByName("fae_creep", creepEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
    GameMode.games["feederAndEater"].creeps[creepIndex].index = creepIndex
    GameMode.games["feederAndEater"].creeps[creepIndex]:AddNewModifier(nil, nil, "modifier_attack_immune", {})
  end
  --run thinker
  GameMode:FeederAndEaterTutorialThinker()
end

function GameMode:FeederAndEaterTutorialThinker()
  Timers:CreateTimer(function()
    local finished = true
    for _, creep in pairs(GameMode.games["feederAndEater"].creeps) do
      if creep:IsAlive() then
        finished = false
      else
        creep:RemoveSelf()
      end
    end
    if finished then
      Notifications:BottomToAll({text = "Tutorial finished", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
      --run next level
      --GameMode:FeederAndEaterLevel1()
      --for testing
      GameMode:FeederAndEaterLevel6()
      return nil
    else
      return 1
    end
  end)
end

function GameMode:FeederAndEaterLevel1()
  Notifications:BottomToAll({text = "Level 1", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
  local creepIndex = 1
  --set up creeps
  GameMode:SpawnFAECreep(1, creepIndex, true)
  GameMode:FeederAndEaterLevel1Thinker()
end

function GameMode:FeederAndEaterPatrolCreepThinker(faeCreep)
  --unit first spawns on the left
  local leftEnt = Entities:FindByName(nil, string.format("faeCreep%s_%s_left", faeCreep.level, faeCreep.index))
  local leftEntVector = leftEnt:GetAbsOrigin()
  local rightEnt = Entities:FindByName(nil, string.format("faeCreep%s_%s_right", faeCreep.level, faeCreep.index))
  local rightEntVector = rightEnt:GetAbsOrigin()
  faeCreep.destination = rightEntVector
  faeCreep:MoveToPosition(faeCreep.destination)
  --moving
  Timers:CreateTimer(function()
    if faeCreep:IsAlive() then
      if GridNav:FindPathLength(faeCreep.destination, faeCreep:GetAbsOrigin()) < 100 then
        if faeCreep.destination == rightEntVector then
          faeCreep.destination = leftEntVector
        else
          faeCreep.destination = rightEntVector
        end
      end
      faeCreep:MoveToPosition(faeCreep.destination)
      return 1.0
    else
      return nil
    end
  end)
  
  --aggro
  --limit cookie range
  --prevent creep from jumping if it's dead
  local enemyFound = false
  faeCreep.cookie = faeCreep:FindAbilityByName("fae_cookie")
  Timers:CreateTimer(function()
    if GameMode.games["feederAndEater"].creeps[faeCreep.index] ~= nil then
      local units = FindUnitsInRadius(faeCreep:GetTeam(), faeCreep:GetAbsOrigin(), nil,
      faeCreep.aggroRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
      FIND_ANY_ORDER, false)
      -- If one or more units were found, start attacking the first one
      if #units > 0 then
        faeCreep.aggroTarget = units[1]
        faeCreep:AddNewModifier(nil, nil, "modifier_aggro", { duration = 3 })
        Timers:CreateTimer({
          endTime = 2, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
          callback = function()
            faeCreep:SetCursorPosition(faeCreep.aggroTarget:GetAbsOrigin())
            faeCreep.cookie:OnSpellStart()
          end
        })
        return 3
      else
        return 0.06
      end
    else
      return nil
    end
  end)
end

function GameMode:FeederAndEaterLevel1Thinker()
  Timers:CreateTimer(function()
    local finished = true
    --if hero dies, revive it
    for teamNumber = 6, 13 do
      if GameMode.teams[teamNumber] ~= nil then
        for playerID  = 0, GameMode.numPlayers - 1 do
          if GameMode.teams[teamNumber][playerID] ~= nil then
            local heroEntity = GameMode.teams[teamNumber][playerID].hero
            if not heroEntity:IsAlive() then
              GameMode:SpawnPlayer(heroEntity, "faeStart")
              heroEntity:AddNewModifier(nil, nil, "modifier_attack_immune", {})
            end
          end
        end
      end
    end
    for _, creep in pairs(GameMode.games["feederAndEater"].creeps) do
      if creep:IsAlive() then
        finished = false
      else
        creep:RemoveSelf()
      end
    end
    if finished then
      Notifications:BottomToAll({text = "Level 1 finished", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
      --run next level
      --skip level 2
      GameMode:FeederAndEaterLevel3()
      return nil
    else
      return 1
    end
  end)
end

--can't have a function that returns nothing
function GameMode:FeederAndEaterLevel2()
  Notifications:BottomToAll({text = "Level 2", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
  --set up creeps
  for creepIndex = 1, 3 do
    GameMode:SpawnFAECreep(2, creepIndex, true)
  end
  GameMode:FeederAndEaterLevel2Thinker()
end

function GameMode:FeederAndEaterLevel2Thinker()
  Timers:CreateTimer(function()
    local finished = true
    --if hero dies, revive it
    for teamNumber = 6, 13 do
      if GameMode.teams[teamNumber] ~= nil then
        for playerID  = 0, GameMode.numPlayers - 1 do
          if GameMode.teams[teamNumber][playerID] ~= nil then
            local heroEntity = GameMode.teams[teamNumber][playerID].hero
            if not heroEntity:IsAlive() then
              GameMode:SpawnPlayer(heroEntity, "faeStart")
              heroEntity:AddNewModifier(nil, nil, "modifier_attack_immune", {})
            end
          end
        end
      end
    end
    for _, creep in pairs(GameMode.games["feederAndEater"].creeps) do
      if creep:IsAlive() then
        finished = false
      else
        creep:RemoveSelf()
      end
    end
    if finished then
      Notifications:BottomToAll({text = "Level 2 finished", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
      --run next level
      GameMode:FeederAndEaterLevel3()
      return nil
    else
      return 1
    end
  end)
end

--if in range for cookie
  --order kill in 2 seconds
  --turn red to indicate aggro

function GameMode:FeederAndEaterLevel3()
  Notifications:BottomToAll({text = "Level 3", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
  --set up creeps
  for creepIndex = 1, 5 do
    GameMode:SpawnFAECreep(3, creepIndex, true)
  end
  GameMode:FeederAndEaterLevel3Thinker()
  --set up players
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID  = 0, GameMode.numPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          local heroEntity = GameMode.teams[teamNumber][playerID].hero
          heroEntity:ForceKill(false)
          GameMode:SpawnPlayer(heroEntity, "faeStart2")
          GameMode:SetCamera(heroEntity)
        end
      end
    end
  end
end

function GameMode:SpawnFAECreep(level, creepIndex, moving)
  local creepEnt
  local creepEntVector
  if moving then
    creepEnt = Entities:FindByName(nil, string.format("faeCreep%s_%s_left", level, creepIndex))
    creepEntVector = creepEnt:GetAbsOrigin()
  else
    creepEnt = Entities:FindByName(nil, string.format("faeCreep%s_%s", level, creepIndex))
    creepEntVector = creepEnt:GetAbsOrigin()
  end
  --if level == 5 then
    --GameMode.games["feederAndEater"].creeps[creepIndex] = CreateUnitByName("fae_creep2", creepEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  --else
    GameMode.games["feederAndEater"].creeps[creepIndex] = CreateUnitByName("fae_creep", creepEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  --end
  GameMode.games["feederAndEater"].creeps[creepIndex].index = creepIndex
  GameMode.games["feederAndEater"].creeps[creepIndex].level = level
  GameMode.games["feederAndEater"].creeps[creepIndex].aggroRange = 200
  GameMode.games["feederAndEater"].creeps[creepIndex]:AddNewModifier(nil, nil, "modifier_attack_immune", {})
  GameMode.games["feederAndEater"].creeps[creepIndex]:SetBaseMoveSpeed(400)
  if moving then
    GameMode.games["feederAndEater"].creeps[creepIndex]:SetThink("FeederAndEaterPatrolCreepThinker", self)
  else
    --skip
  end
end


function GameMode:FeederAndEaterLevel3Thinker()
  local finished = false
  --time limit = 30 seconds
  --run only once
  --local levelRunning = true
  --when first creep is killed, set off a timer that will run in 20 seconds
  --local countdownRunning = false
  --if hero's dead, revive it
  Timers:CreateTimer("reviver", {
    useGameTime = true,
    endTime = 0,
    callback = function()
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID  = 0, GameMode.numPlayers - 1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              local heroEntity = GameMode.teams[teamNumber][playerID].hero
              if not heroEntity:IsAlive() then
                GameMode:SpawnPlayer(heroEntity, "faeStart2")
              end
            end
          end
        end
      end
      if finished then
        return nil
      else
        return 1.0
      end
    end
  })
  
  --check finished
  Timers:CreateTimer("checkFinished", {
    useGameTime = true,
    endTime = 0.5,
    callback = function()
      --count number of creeps
      --if creeps are 0, then end game
      local creepCount = 0
      for _, creep in pairs(GameMode.games["feederAndEater"].creeps) do
        creepCount = creepCount + 1
      end
      if creepCount == 0 then
        finished = true
        Notifications:BottomToAll({text = "Level 3 finished", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
        --run next level
        GameMode:FeederAndEaterLevel4()
        return nil
      else
        return 1
      end
    end
  })
end

function GameMode:FeederAndEaterLevel4()
  --announce start
  Notifications:BottomToAll({text = "Level 4", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
  --set up creeps
  for creepIndex = 1, 2 do
    GameMode:SpawnFAECreep(4, creepIndex, false)
  end
  GameMode:FeederAndEaterLevel4Thinker()
  --set up players
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID  = 0, GameMode.numPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          local heroEntity = GameMode.teams[teamNumber][playerID].hero
          heroEntity:ForceKill(false)
          GameMode:SpawnPlayer(heroEntity, "faeStart3")
          GameMode:SetCamera(heroEntity)
        end
      end
    end
  end
end

function GameMode:FeederAndEaterLevel4Thinker()
  local finished = false
  Timers:CreateTimer("reviver", {
    useGameTime = true,
    endTime = 0,
    callback = function()
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID  = 0, GameMode.numPlayers - 1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              local heroEntity = GameMode.teams[teamNumber][playerID].hero
              if not heroEntity:IsAlive() then
                GameMode:SpawnPlayer(heroEntity, "faeStart3")
              end
            end
          end
        end
      end
      if finished then
        return nil
      else
        return 1.0
      end
    end
  })

  --thinker
  local reviving1 = false
  local reviving2 = false
  Timers:CreateTimer("checkFinished", {
    useGameTime = false,
    endTime = 0,
    callback = function()
      --if both cookies are dead,
      if GameMode.games["feederAndEater"].creeps[1] == nil and GameMode.games["feederAndEater"].creeps[2] == nil then
        --end game
        Notifications:BottomToAll({text = "Level 4 finished", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
        finished = true
        --run next level
        --GameMode:FeederAndEaterLevel5()
        GameMode:FeederAndEaterLevel6()
        return nil
      --else
      else
        --if cookie one is dead,
        if GameMode.games["feederAndEater"].creeps[1] == nil then
          if reviving1 then
            --nothing
          else
            --revive it after 3 seconds
            Timers:CreateTimer({
              endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
              callback = function()
                if finished then
                  --skip
                else
                  GameMode:SpawnFAECreep(4, 1, false)
                  reviving1 = false
                end
              end
            })
            reviving1 = true
          end
        --if cookie two is dead,
        elseif GameMode.games["feederAndEater"].creeps[2] == nil then
          if reviving2 then
            --nothing
          else
            --revive it after 3 seconds
            Timers:CreateTimer({
              endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
              callback = function()
                if finished then
                  --skip
                else
                  GameMode:SpawnFAECreep(4, 2, false)
                  reviving2 = false
                end
              end
            })
            reviving2 = true
          end
        end
        return 1
      end
    end
  })
end

--when level finished,
  --stop spawning creeps
function GameMode:FeederAndEaterLevel5()
  Notifications:BottomToAll({text = "Level 5", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "10 points to clear. Creep will spawn in 5 seconds", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  --whack a mole
  --thinker
    --spawn cookies every 5 seconds
      --at first, one cookie
      --then, two cookies
      --then, three cookies
    --at the end of 5 seconds
      --if all cookies dead,
        --one point
      --else,
        --negative point

  --spawn players
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID  = 0, GameMode.numPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          local heroEntity = GameMode.teams[teamNumber][playerID].hero
          heroEntity:ForceKill(false)
          GameMode:SpawnPlayer(heroEntity, "faeStart4")
          GameMode:SetCamera(heroEntity)
        end
      end
    end
  end

  --thinker
  GameMode:FeederAndEaterLevel5Thinker()

  --initialize fields
  GameMode.games["feederAndEater"].points = 0
  --threshold = 10 for now
end

function GameMode:FeederAndEaterLevel5Thinker()
  local finished = false
  --reviver
  Timers:CreateTimer("reviver", {
    useGameTime = true,
    endTime = 5,
    callback = function()
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID  = 0, GameMode.numPlayers - 1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              local heroEntity = GameMode.teams[teamNumber][playerID].hero
              if not heroEntity:IsAlive() then
                GameMode:SpawnPlayer(heroEntity, "faeStart4")
              end
            end
          end
        end
      end
      if finished then
        return nil
      else
        return 1.0
      end
    end
  })

  --set up creeps
  Timers:CreateTimer("creeps", {
    useGameTime = true,
    endTime = 5,
    callback = function()
      if finished then
        return nil
      else
        --kill creeps
        for creepIndex = 1, 6 do
          if GameMode.games["feederAndEater"].creeps[creepIndex] ~= nil then
            GameMode.games["feederAndEater"].creeps[creepIndex]:ForceKill(false)
            --GameMode.games["feederAndEater"].creeps[creepIndex]:RemoveSelf()
            --GameMode.games["feederAndEater"].creeps[creepIndex] = nil
          end
        end
        --respawn creeps
        --Timers:CreateTimer({
          --endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
          --callback = function()
            creepIndex1 = math.random(6)
            GameMode:SpawnFAECreep(5, creepIndex1, false)
            creepIndex2 = math.random(6)
            GameMode:SpawnFAECreep(5, creepIndex2, false)
          --end
        --})
        return 10
      end
    end
  })

  local bothDead = true
  --if both cookies are dead
  Timers:CreateTimer("checkFinished", {
    useGameTime = false,
    endTime = 5,
    callback = function()
      print("thinking")
      --find whether there are more than one cookie left
      local creepCount = 0
      for _, creep in pairs(GameMode.games["feederAndEater"].creeps) do
        creepCount = creepCount + 1
      end
      print("creep count: " .. creepCount)
      if creepCount > 0 then
        bothDead = false
      end
      --if they ARE both dead
      if bothDead then
        --announce point earned
        Notifications:BottomToAll({text = "1 point", duration= 1.0, style={["font-size"] = "45px", color = "white"}}) 
        --point earned
        GameMode.games["feederAndEater"].points = GameMode.games["feederAndEater"].points + 1
      end
      --if points reach threshold
      if GameMode.games["feederAndEater"].points == 10 then
        finished = true
        --announce level finished
        Notifications:BottomToAll({text = "Level 5 finished", duration= 3.0, style={["font-size"] = "45px", color = "white"}}) 
        --next level
        GameMode:FeederAndEaterLevel6()
        --end thinker
        return nil
      else
        --set the flag to true so that it can be checked again in the next thought
        bothDead = true
        --run the next thought
        return 1
      end
    end
  })
end

function GameMode:SpawnFAEObstacle(level, obstacleIndex)
  local obstacleEnt = Entities:FindByName(nil, string.format("faeCreep%s_obstacle_%s", level, obstacleIndex))
  local obstacleEntVector = obstacleEnt:GetAbsOrigin()
  GameMode.games["feederAndEater"].obstacles[obstacleIndex] = CreateUnitByName("fae_obstacle", obstacleEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  GameMode.games["feederAndEater"].obstacles[obstacleIndex].index = obstacleIndex
end

function GameMode:SpawnFAERunner(level, runnerIndex, side)
  local runnerEnt = Entities:FindByName(nil, string.format("faeCreep%s_runner_%s", level, side))
  local runnerEntVector = runnerEnt:GetAbsOrigin()
  GameMode.games["feederAndEater"].runners[runnerIndex] = CreateUnitByName("fae_runner", runnerEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  GameMode.games["feederAndEater"].runners[runnerIndex].index = runnerIndex
  GameMode.games["feederAndEater"].runners[runnerIndex].level = level
  GameMode.games["feederAndEater"].runners[runnerIndex].side = side
  GameMode.games["feederAndEater"].runners[runnerIndex].spawnLoc = runnerEntVector
  GameMode.games["feederAndEater"].runners[runnerIndex]:SetThink("FeederAndEaterRunnerThinker", self)
end

--on every turn, there's a destination. when destination is reached, go to the next one
--when the last destination is reached, kill it
function GameMode:FeederAndEaterRunnerThinker(runner)
  --memory in the back of the mind
  local destination1Ent = Entities:FindByName(nil, string.format("faeCreep%s_runner_%s_destination_1", runner.level, runner.side))
  local destination1 = destination1Ent:GetAbsOrigin()
  local destination2Ent = Entities:FindByName(nil, string.format("faeCreep%s_runner_%s_destination_2", runner.level, runner.side))
  local destination2 = destination2Ent:GetAbsOrigin()
  local destination3Ent = Entities:FindByName(nil, string.format("faeCreep%s_runner_%s_destination_3", runner.level, runner.side))
  local destination3 = destination3Ent:GetAbsOrigin()
  --thinking
  --timer string has to be unique for all running timers
  --use runner index so that it's unique for all runners on the tracks
  Timers:CreateTimer(string.format("thinker%s", runner.index), {
    useGameTime = false,
    endTime = 0,
    callback = function()
      print("thinking")
      --if runner is within 50 units of spawn loc
      if GridNav:FindPathLength(runner.spawnLoc, runner:GetAbsOrigin()) < 50 then
        print("moving to destination 1")
        --set destination to destination 1
        runner.destination = destination1
      --elseif runner is within 50 units of destination 1
      elseif GridNav:FindPathLength(destination1, runner:GetAbsOrigin()) < 50 then
        print("moving to destination 2")
        --move to destination 2
        runner.destination = destination2
      --elseif runner is within 50 units of destination 2
      elseif GridNav:FindPathLength(destination2, runner:GetAbsOrigin()) < 50 then
        print("moving to destination 3")
        --move to destination 3
        runner.destination = destination3
      --elseif runner is within 50 units of destination 3
      elseif GridNav:FindPathLength(destination3, runner:GetAbsOrigin()) < 50 then
        print("reached destination")
        --kill
        runner:ForceKill(false)
        --end thinker
        return nil
      end
      runner:MoveToPosition(runner.destination)
      return 0.2
    end
  })
end

function GameMode:FeederAndEaterLevel6()
  --spawn obstacles
  --left
  --separated indexes for adding to table
  for obstacleIndex = 1, 10 do
    GameMode:SpawnFAEObstacle(6, obstacleIndex)
  end
  --announcement
  Notifications:BottomToAll({text = "Level 6", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  --thinker
  GameMode:FeederAndEaterLevel6Thinker()
  --spawn players
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID  = 0, GameMode.numPlayers - 1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          local heroEntity = GameMode.teams[teamNumber][playerID].hero
          heroEntity:ForceKill(false)
          GameMode:SpawnPlayer(heroEntity, "faeStart5")
          GameMode:SetCamera(heroEntity)
        end
      end
    end
  end
end

function GameMode:FeederAndEaterLevel6Thinker()

  --thinker 1: spawn runner
  --there can be multiple pairs of runners on the tracks
  local runnerIndex = 1
  Timers:CreateTimer("runnerSpawn", {
    useGameTime = false,
    endTime = 3,
    callback = function()
      if GameMode.games["feederAndEater"].level6Finished == 2 then
        return nil
      else
        for side = 1, 2 do
          GameMode:SpawnFAERunner(6, runnerIndex, side)
          runnerIndex = runnerIndex + 1
        end
        return 10
      end
    end
  })

  --thinker 2: spawn players
  Timers:CreateTimer("reviver", {
    useGameTime = true,
    endTime = 0,
    callback = function()
      for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
          for playerID  = 0, GameMode.numPlayers - 1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              local heroEntity = GameMode.teams[teamNumber][playerID].hero
              if not heroEntity:IsAlive() then
                GameMode:SpawnPlayer(heroEntity, "faeStart5")
              end
            end
          end
        end
      end
      if GameMode.games["feederAndEater"].level6Finished == 2 then
        return nil
      else
        return 1.0
      end
    end
  })

  --thinker 3: kill obstacles
  Timers:CreateTimer("obstacles", {
    useGameTime = true,
    endTime = 0,
    callback = function()
      if GameMode.games["feederAndEater"].level6Finished == 2 then
        for obstacleIndex = 1, 10 do
          GameMode.games["feederAndEater"].obstacles[obstacleIndex]:ForceKill(false)
        end
        return nil
      else
        return 1.0
      end
    end
  })
end

--shooter can't see
--shooter has channeled cookie
--shooter has jump-in-place cookie
--eater has nothing
--faces the endzone and tells shooter how strong of a cookie to shoot
--eater has runner that spawns periodically
--kill runner with jump-in-place cookie
--kill endzone creeps for points

--eater has jump-in-place cookie ?

--[[function GameMode:FeederAndEaterLevel7()
    --announcement
    Notifications:BottomToAll({text = "Level 7", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
    --spawn players
    local role
    if math.random(2) == 1 then
      role = "feeder"
    else
      role = "eater"
    end
    for teamNumber = 6, 13 do
      if GameMode.teams[teamNumber] ~= nil then
        for playerID  = 0, GameMode.numPlayers - 1 do
          if GameMode.teams[teamNumber][playerID] ~= nil then
            local heroEntity = GameMode.teams[teamNumber][playerID].hero
            heroEntity:ForceKill(false)
            heroEntity.role = role
            if role == "feeder" then
              role = "eater"
            else
              role = "feeder"
            end
            GameMode:SpawnPlayer(heroEntity, string.format("faeStart6_%s", role)
            GameMode:SetCamera(heroEntity)
          end
        end
      end
    end
      --feeder
      --eater
    --thinker
      --target creeps
        --two bad
        --one good
      --runners
end]]

--instead of time limits, use leaves
--or a creep that runs behind you

--running together


--hit them with the edge of the impact radius
  
--cookie each other
--kill the creeps at the same time
--respawns within a reasonable amount of time

--when first fae creep dies, start a timer
--set a time limit for every level
--if all creeps are not dead when the timer expires, start over

--eater can only turn

--throw cookie at each other to kill opponents


--testing 
--add ability to me 
--onspellstart, end minigame and return to arena

--shoot the cookie first
--target is moving so turn the right way

--channeled cookie

--shooter roles
  --shooting the cookie in the right direction
--eater roles
  --facing the right direction

--implement level 2 with time limit



function GameMode:CookieParty()
end





function GameMode:CustomizeAbilities(heroEntity, abilitiesToAdd)
  --remove current abilities
  GameMode:RemoveAllAbilities(heroEntity)
  --add new ones
  for _, abilityName in ipairs(abilitiesToAdd) do
    local ability = heroEntity:AddAbility(abilityName)
    ability:SetLevel(1)
    if abilityName == "barebones_empty1" then
      ability:SetHidden(true)
    end
  end
end


function GameMode:SetCamera(heroEntity)
  local playerID = heroEntity:GetPlayerID()
  PlayerResource:SetCameraTarget(playerID, heroEntity)
  Timers:CreateTimer({
    endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()            
      PlayerResource:SetCameraTarget(playerID, nil)
    end
  })
end





function GameMode:Kiss()
  Notifications:BottomToAll({text = "Kiss", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Blink or Ult or Fake", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers-1 do
        if GameMode.teams[teamNumber][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            --spawn player
            local heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            local heroSpawnEnt = Entities:FindByName(nil, "kiss_center")
            local heroSpawnEntVector = heroSpawnEnt:GetAbsOrigin()
            heroEntity:SetRespawnPosition(heroSpawnEntVector)
            GameMode:Restore(heroEntity)
            --custom abilities
            GameMode:RemoveAllAbilities(heroEntity)
            local blink = heroEntity:AddAbility("antimage_blink_custom")
            blink:SetLevel(1)
              --mortimer kiss with one projectile
            local kiss = heroEntity:AddAbility("kiss_custom")
            kiss:SetLevel(1)
            --modifiers
            heroEntity:AddNewModifier(nil, nil, "modifier_extra_mana", { extraMana = -995, regen = 1 })
            heroEntity:AddNewModifier(nil, nil, "modifier_attack_immune", {})
            heroEntity:SetBaseMoveSpeed(200)
            --heroEntity:GiveMana(5)
            --stats
            Timers:CreateTimer({
              --initially, show where the players are
              endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
              callback = function()
                heroEntity:SetDayTimeVisionRange(300)
                heroEntity:SetNightTimeVisionRange(300)
              end
            })
          end
        end
      end
    end
  end
end

  --divide players into two teams
  --keep track of which team players were on before
  --spawn players on appropriate side
  --abilities: cookie (long distance), mortimer kisses
  --items: none
  --hp: 5
  --mana: 1
  --mana regen: 0.2
  --when all players on a team are eliminated,
    --end game
  


function GameMode:Horde()
  GameMode.games["horde"].active = true
  Notifications:BottomToAll({text = "Kill the Horde", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  Notifications:BottomToAll({text = "Most kills win", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
  --spawn mobs in the center
  local hordeCenterEnt = Entities:FindByName(nil, "horde_center")
  local hordeCenterEntVector = hordeCenterEnt:GetAbsOrigin()
  for i = 1, 100 do
    print("[GameMode:Horde()] kobold spawned")
    GameMode.games["horde"].creeps[i] = CreateUnitByName("npc_dota_neutral_kobold", hordeCenterEntVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  end
  --spawn players at their respective locations
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
        for playerID  = 0, GameMode.numPlayers - 1 do
            if GameMode.teams[teamNumber][playerID] ~= nil then
              --set their kill count to 0
              GameMode.teams[teamNumber][playerID].hordeCreepKills = 0
              heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
              local heroSpawnEnt = Entities:FindByName(nil, string.format("horde_hero_spawn_%s", teamNumber-5))
              local heroSpawnEntVector = heroSpawnEnt:GetAbsOrigin()
              heroEntity:SetRespawnPosition(heroSpawnEntVector)
              GameMode:Restore(heroEntity)
            end
        end
    end
  end
  --level up abilities
    --custom abilities where every level up grants an action upgrade
  --spawn multiple times
  --when last spawn dies,


    --in "OnEntityKilled" in events.lua
      --record the num killed for each team
      --whoever killed the most wins
  --stats on the side

  --earthshaker
  --zombies
  --linas
end






--click on player portrait?

--hack and slash
--god
--projectile avoiding
--different based on character
--for example, when jugg omnis, must turn invis / scepter
--sound to know what to prepare for
--jugg, cm, bb, axe
--cm ice blasts randomly around her
--invoker is the supreme god
--if everyone is dead at the same time, lose
--shotgun game
--three guns -- birdshot, buckshot, slug
--bkb
--2hp
--can choose to have players on separate teams
--choose your horse
--give them everything
--attacking with lil shredder -- counter with blade mail; when you have blademail on, you take no damage



--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  --this is called every time a new hero is introduced in the game
  --for example, when you enter the game, this is called. then, when you change to a new hero, it's called again
  local playerID = hero:GetPlayerID()
  local teamNum = PlayerResource:GetTeam(playerID)
  local heroName = hero:GetUnitName()
  --testing, skin
  --hero:AddNewModifier(nil, nil, "modifier_fire_remnant_effect", { duration = 20 })

  if heroName == "npc_dota_hero_snapfire" then
    --if hero is spawning for the first time, team hasn't been set yet
    if GameMode.teams[teamNum] == nil then
      GameMode.teams[teamNum] = {}
      GameMode.teams[teamNum].score = 0
      --to save items
      --save onto the team because hero entities may change through mini games
      --to put key inside brackets, the variable has to have a value
      --item index that starts from 10 is special items, like the loot you get from Morty()
      GameMode.teams[teamNum].items = {}
      GameMode.teams[teamNum].abilities = {}
    end
  end

  GameMode.teams[teamNum][playerID] = hero
  --for ability upgrade
  hero.numUpgrades = 0
  

  --hero:AddNewModifier(nil, nil, "modifier_extra_health_morty", {extraHealth = 10000})

  --for testing
  GameMode:MaxAllAbilities(hero)
  --[[Timers:CreateTimer({
    endTime = 6, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      hero:SwapAbilities("lil_shredder_base", "machine_gun", false, true)
    end
  })]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  --use "print" and "PrintTable" to print messages in the debugger
  DebugPrint("[BAREBONES] The game has officially begun")
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  --make file in modifiers folder
  --link it to the class (this is the modifier for neutral creeps' AI)
  LinkLuaModifier("modifier_ai_morty", "libraries/modifiers/modifier_ai_morty.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_extra_health_morty", "libraries/modifiers/modifier_extra_health_morty.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_extra_mana", "libraries/modifiers/modifier_extra_mana.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_stunned", "libraries/modifiers/modifier_stunned.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_invulnerable", "libraries/modifiers/modifier_invulnerable.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_silenced", "libraries/modifiers/modifier_silenced.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_attack_immune", "libraries/modifiers/modifier_attack_immune.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_magic_immune", "libraries/modifiers/modifier_magic_immune.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_specially_deniable", "libraries/modifiers/modifier_specially_deniable.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_invisible", "libraries/modifiers/modifier_invisible.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_set_max_move_speed", "libraries/modifiers/modifier_set_max_move_speed.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_set_min_move_speed", "libraries/modifiers/modifier_set_min_move_speed.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_aggro", "libraries/modifiers/modifier_aggro", LUA_MODIFIER_MOTION_NONE)
  -----------
  -- Skins --
  -----------
  LinkLuaModifier("modifier_teleport_effect", "libraries/modifiers/modifier_teleport_effect", LUA_MODIFIER_MOTION_NONE)
  --change game title in addon_english.txt
  --remove items in shops.txt to remove them from the shop
  --remove items completely by disabling them in npc_abilities_custom.txt
  
  --disable the in game announcer
  --GameMode:SetAnnouncerDisabled(true)
  --GameMode:SetBuybackEnabled(false)

  
  CustomGameEventManager:RegisterListener("js_player_select_type", OnJSPlayerSelectType)
  CustomGameEventManager:RegisterListener("js_player_select_points", OnJSPlayerSelectPoints)
  CustomGameEventManager:RegisterListener("js_player_select_hero", OnJSPlayerSelectHero)
  CustomGameEventManager:RegisterListener("js_player_select_cookie_god", OnJSPlayerSelectCookieGod)
  
  

  --call this which is located in the internal/gamemode file to initialize the basic settings provided by barebones 
  GameMode:_InitGameMode()


  -- SEEDING RNG IS VERY IMPORTANT
  math.randomseed(Time())
  


  -----------
  --pregame--
  -----------
  GameMode.pregameActive = true
  GameMode.pregameBuffer = false

  ------------
  --settings--
  ------------
  GameMode.numGamesToPlay = 8
  GameMode.maxNumPlayers = 8
  GameMode.pointsPerKill = 0.1
  GameMode.teamNames = {}
  GameMode.teamNames[6] = "Aqua Team"
  GameMode.teamNames[7] = "Red Team"
  GameMode.teamNames[8] = "Pink Team"
  GameMode.teamNames[9] = "Green Team"
  GameMode.teamNames[10] = "Brown Team"
  GameMode.teamNames[11] = "Orange Team"
  GameMode.teamNames[12] = "Beige Team"
  GameMode.teamNames[13] = "Purple Team"
  GameMode.teamColors = {}
  GameMode.teamColors[6] = "aqua"
  GameMode.teamColors[7] = "red"
  GameMode.teamColors[8] = "pink"
  GameMode.teamColors[9] = "green"
  GameMode.teamColors[10] = "brown"
  GameMode.teamColors[11] = "orange"
  GameMode.teamColors[12] = "beige"
  GameMode.teamColors[13] = "purple"

  ----------
  --status--
  ----------
  GameMode.numGamesPlayed = 0
  GameMode.numPlayers = 0
  GameMode.gameActive = false
  --GameMode.game_index = nil
  --testing
  GameMode.game_index = 0
  --GameMode.mortyLoot = nil

  ---------
  --teams--
  ---------
  GameMode.teams = {}

  --------------------
  --ability upgrades--
  --------------------
  GameMode.abilityUpgrades = {}
  GameMode.abilityUpgrades.basic = {}
  GameMode.abilityUpgrades.basic[1] = "scatterblast_double_barreled"
  GameMode.abilityUpgrades.basic[2] = "scatterblast_stopping_power"
  GameMode.abilityUpgrades.basic[3] = "scatterblast_sawed_off"
  GameMode.abilityUpgrades.basic[4] = "cookie_bakers_dozen"
  GameMode.abilityUpgrades.basic[5] = "cookie_raisin_firesnap"
  GameMode.abilityUpgrades.basic[6] = "cookie_oven"
  GameMode.abilityUpgrades.basic[7] = "lil_shredder_machine_gun"
  GameMode.abilityUpgrades.basic[8] = "lil_shredder_fragments"
  GameMode.abilityUpgrades.basic[9] = "lil_shredder_steam"
  GameMode.abilityUpgrades.ult = {}
  GameMode.abilityUpgrades.ult[1] = "mortimer_kisses_added_effect"
  GameMode.abilityUpgrades.ult[2] = "mortimer_kisses_make_it_rain"
  GameMode.abilityUpgrades.ult[3] = "mortimer_kisses_teleport"

  ----------------
  --cookie names--
  ----------------
  GameMode.cookieNames = {}
  GameMode.cookieNames[1] = "freshly_baked_cookie_cm"
  GameMode.cookieNames[2] = "freshly_baked_cookie_axe"
  GameMode.cookieNames[3] = "freshly_baked_cookie_ogre"
  GameMode.cookieNames[4] = "freshly_baked_cookie_lina"
  GameMode.cookieNames[5] = "freshly_baked_cookie_jugg"
  GameMode.cookieNames[6] = "freshly_baked_cookie_bristleback"
  GameMode.cookieNames[7] = "freshly_baked_cookie_invoker"
  GameMode.cookieNames[8] = "freshly_baked_cookie_morty"
  GameMode.cookieNames[9] = "freshly_baked_cookie_oreo"
  GameMode.cookieNames[10] = "freshly_baked_cookie_stack"
  GameMode.cookieNames[11] = "freshly_baked_cookie_heap"
  GameMode.cookieNames[12] = "freshly_baked_cookie_ginger_bread_man"

  -----------------
  --game specific--
  -----------------
  GameMode.games = {}

  --frogger
  GameMode.games["frogger"] = {}
  GameMode.games["frogger"].zombies = {}
  GameMode.games["frogger"].leaves = {}
  GameMode.games["frogger"].logs = {}

  --shotgun
  GameMode.games["shotgun"] = {}

  --button mash
  GameMode.games["mash"] = {}

  --morty
  GameMode.games["morty"] = {}
  --GameMode.games["morty"].numAlive = 0
  --can't leave it unassigned
  GameMode.games["morty"].morty = nil
  --GameMode.games["morty"].hunters = {}

  --mines
  GameMode.games["mines"] = {}
  GameMode.games["mines"].miner = nil

  --twenty one
  GameMode.games["twentyOne"] = {}
  GameMode.games["twentyOne"].morty = nil
  GameMode.games["twentyOne"].turn = nil
  GameMode.games["twentyOne"].cookiesToBust = nil

  --cookie party
  GameMode.games["cookieParty"] = {}

  --escape
  GameMode.games["escape"] = {}
  GameMode.games["escape"].checkpointActivated = 0
  GameMode.games["escape"].checkpointHammerEntity = nil
  GameMode.games["escape"].timbersawsSpawned = 0
  GameMode.games["escape"].timbersaws = {}
  GameMode.games["escape"].checkpointSixOneActivated = false
  GameMode.games["escape"].checkpointSixTwoActivated = false
  GameMode.games["escape"].numLives = 50

  GameMode.maze = {}
  GameMode.maze.mazeTarget = nil
  GameMode.numTeams = 0

  --GameMode.numPlayers = 8
  GameMode.pointsToWin = 5
  GameMode.pointsChosen = "short"
  GameMode.pointsVote = {}
  GameMode.pointsVote["short"] = 0
  GameMode.pointsVote["medium"] = 0
  GameMode.pointsVote["long"] = 0
  GameMode.pointsNumVoted = 0
  --GameMode.numPlayers = 0

  --for testing
  GameMode.typeNumVoted = 0
  --GameMode.typeNumVoted = 3
  GameMode.wantedEnabled = true
  GameMode.firstBlood = true
  GameMode.specialGame = 0
  GameMode.specialGameCooldown = false
  GameMode.cookieGodNumPicked = 0

  -----------------------------------------------------------
  --heroes that can be in the game
  GameMode.regularHeroes = {}
  GameMode.regularHeroes["npc_dota_hero_chen"] = true
  GameMode.regularHeroes["npc_dota_hero_disruptor"] = true
  GameMode.regularHeroes["npc_dota_hero_abaddon"] = true
  GameMode.regularHeroes["npc_dota_hero_snapfire"] = true
  GameMode.regularHeroes["npc_dota_hero_mirana"] = true
  GameMode.regularHeroes["npc_dota_hero_luna"] = true
  GameMode.regularHeroes["npc_dota_hero_gyrocopter"] = true
  GameMode.regularHeroes["npc_dota_hero_batrider"] = true

  -----------------------------------------------------------
  --cookie gods
  GameMode.cookieGods = {}
  GameMode.cookieGods["npc_dota_hero_bristleback"] = true
  GameMode.cookieGods["npc_dota_hero_lina"] = true
  GameMode.cookieGods["npc_dota_hero_ogre"] = true
  GameMode.cookieGods["npc_dota_hero_invoker"] = true
  GameMode.cookieGods["npc_dota_hero_axe"] = true
  GameMode.cookieGods["npc_dota_hero_crystal_maiden"] = true
  GameMode.cookieGods["npc_dota_hero_juggernaut"] = true
  GameMode.cookieGods["npc_dota_hero_mortimer"] = true

  -----------------------------------------------------------
  --games
  --GameMode.games = {}
  GameMode.games["maze"] = {}
  GameMode.games["maze"].active = false

  GameMode.games["sumo"] = {}
  GameMode.games["sumo"].active = false
  GameMode.games["dash"] = {}
  GameMode.games["dash"].active = false
  GameMode.games["horde"] = {}
  GameMode.games["horde"].active = false
  GameMode.games["horde"].creepsKilled = 0
  GameMode.games["horde"].creeps = {}






  --battle ship
  GameMode.games["battleship"] = {}
  GameMode.games["battleship"].active = false
  


  --feeder and eater
  GameMode.games["feederAndEater"] = {}
  GameMode.games["feederAndEater"].active = false
  GameMode.games["feederAndEater"].creeps = {}
  GameMode.games["feederAndEater"].level6Finished = 0
  GameMode.games["feederAndEater"].obstacles = {}
  GameMode.games["feederAndEater"].runners = {}
  GameMode.games["feederAndEater"].endzoneActivator = nil

  --cookie duo
  GameMode.games["cookieDuo"] = {}
  GameMode.games["cookieDuo"].active = false
  GameMode.games["cookieDuo"].newTeams = {}

   --feeder and eater 2
   GameMode.games["feederAndEater2"] = {}
   GameMode.games["feederAndEater2"].active = false
   GameMode.games["feederAndEater2"].newTeams = {}
   GameMode.games["feederAndEater2"].creeps = {}

  -----------------------------------------------------------
  --in between game
  GameMode.games["normal"] = {}
  GameMode.games["normal"].npcs = {}


  --event
  GameMode.event = false


  
  
  


  --[[DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')]]
end



function OnJSPlayerSelectType(event, keys)
  print("[OnJSPlayerSelectType] someone voted")
  
	local player_id = keys["PlayerID"]
  local type = keys["type"]
  print("[OnJSPlayerSelectType] type: " .. type)

  local player = PlayerResource:GetPlayer(player_id)
  if player ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "type_selection_end", {})
  end

  --decide type of gamemode after everyone votes
  
  if GameMode.typeVote[type] == nil then
    GameMode.typeVote[type] = 1
  else
    GameMode.typeVote[type] = GameMode.typeVote[type] + 1
  end
  print("[OnJSPlayerSelectType] GameMode.typeVote[type]: " .. GameMode.typeVote[type])

  --check if everyone has voted
  GameMode.typeNumVoted = GameMode.typeNumVoted + 1
  print("[OnJSPlayerSelectType] GameMode.typeNumVoted: " .. GameMode.typeNumVoted)
  if GameMode.typeNumVoted == PlayerResource:NumPlayers() then
    print("[OnJSPlayerSelectType] everyone voted for the game mode")
    local typeVoteRanking = {}

  
  
    local rank = 1
    for k,v in GameMode:spairs(GameMode.typeVote, function(t,a,b) return t[b] < t[a] end) do
        typeVoteRanking[rank] = k 
        rank = rank + 1
    end
    local topTypeVote = GameMode.typeVote[typeVoteRanking[1]]

    --ipairs?
    for type, votes in pairs(GameMode.typeVote) do
      if GameMode.typeVote[type] == topTypeVote then
          --GameMode.type = "battleRoyale"
          GameMode.type = type
          if type == "battleRoyale" then
            Notifications:TopToAll({text="Mode: Battle Royale", duration= 35.0, style={["font-size"] = "35px", color = "white"}})
          else
            Notifications:TopToAll({text="Mode: Death Match", duration= 35.0, style={["font-size"] = "35px", color = "white"}})
          end
          --subsequent lines get displayed below
          --Notifications:TopToAll({text=string.format("Game Mode: %s", "Battle Royale"), duration= 35.0, style={["font-size"] = "35px", color = "white"}})
          
        --[[else
        print("[OnJSPlayerSelectType] everyone voted for the game mode deathMatch block")
        GameMode.type = "deathMatch"
        Notifications:TopToAll({text=string.format("Game Mode: %s", "Death Match"), duration= 35.0, style={["font-size"] = "35px", color = "white"}})]]
      end
    end
  end
end

function OnJSPlayerSelectPoints(event, keys)
  local pointsTable = {}
  pointsTable["deathMatch"] = {}
  pointsTable["battleRoyale"] = {}
  pointsTable["deathMatch"]["short"] = 15
  pointsTable["deathMatch"]["medium"] = 30
  pointsTable["deathMatch"]["long"] = 45
  pointsTable["battleRoyale"]["short"] = 3
  pointsTable["battleRoyale"]["medium"] = 5
  pointsTable["battleRoyale"]["long"] = 7
	local player_id = keys["PlayerID"]
  local points = keys["points"]

  local player = PlayerResource:GetPlayer(player_id)
  if player ~= nil then
    CustomGameEventManager:Send_ServerToPlayer(player, "points_selection_end", {})
  end

  --decide points to win after everyone votes
  
  if GameMode.pointsVote[points] == nil then
    GameMode.pointsVote[points] = 1
  else
    GameMode.pointsVote[points] = GameMode.pointsVote[points] + 1
  end

  --check if everyone has voted
  GameMode.pointsNumVoted = GameMode.pointsNumVoted + 1
  if GameMode.pointsNumVoted == PlayerResource:NumPlayers() then
    local pointsVoteRanking = {}
  
  
    local rank = 1
    for k,v in GameMode:spairs(GameMode.pointsVote, function(t,a,b) return t[b] < t[a] end) do
        pointsVoteRanking[rank] = k 
        rank = rank + 1
    end
    local topPointsVote = GameMode.pointsVote[pointsVoteRanking[1]]
    for key, points in pairs({"short", "medium", "long"}) do
      if GameMode.pointsVote[points] == topPointsVote then
        GameMode.pointsToWin = pointsTable[GameMode.type][points]
        Notifications:TopToAll({text=string.format("Number of Points to Win: %s", GameMode.pointsToWin), duration= 35.0, style={["font-size"] = "35px", color = "white"}})
        break
      end
    end
  end
end

function OnJSPlayerSelectHero(event, keys)
	local player_id = keys["PlayerID"]
	local hero_name = keys["hero_name"]
	
	local current_hero_name = PlayerResource:GetSelectedHeroName(player_id)
	if current_hero_name == nil then
		return
	end

	if current_hero_name == "npc_dota_hero_wisp" then
    local selectedHero = PlayerResource:ReplaceHeroWith(player_id, hero_name, PlayerResource:GetGold(player_id), 0)
    --selectedHero:AddAbility("dummy_unit")
    --local abil = selectedHero:GetAbilityByIndex(4)
    --abil:SetLevel(1)
		if selectedHero == nil then
			return
		end
	end

	local player = PlayerResource:GetPlayer(player_id)
	if player ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "hero_selection_end", {})
	end
end





-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end

function GameMode:Restore(hero)
  if not hero:IsAlive() then
    hero:RespawnHero(false, false)
  end
  --Purge stuns and debuffs from pregame
  --set "bFrameOnly" to maintain the purged state
  --hero:Purge(true, true, false, true, true)
  --heal health and mana to full
  --hero:Heal(8000, nil)
  --hero:GiveMana(8000)

end


--play the starting sound
--calculate the damage dealt for every hero against each other
--rank them in descending order
--highest rank gets placed first; lowest rank gets placed last at the starting line
function GameMode:RoundStart(teams)
  EmitGlobalSound('snapfireOlympics.introAndBackground3')      
  GameMode.currentRound = GameMode.currentRound + 1
  
  Notifications:BottomToAll({text=string.format("ROUND %s", GameMode.currentRound), duration= 5.0, style={["font-size"] = "45px", color = "white"}})  
  for teamNumber = 6, 13 do
    if teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers do
        if teams[teamNumber]["players"][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            print("[GameMode:RoundStart] playerID: " .. playerID)
            for itemIndex = 0, 10 do
              if heroEntity:GetItemInSlot(itemIndex) ~= nil then
                heroEntity:GetItemInSlot(itemIndex):EndCooldown()
              end
            end
            for abilityIndex = 0, 5 do
              abil = heroEntity:GetAbilityByIndex(abilityIndex)
              abil:EndCooldown()
            end

            --[[Timers:CreateTimer(function()
              for i = 0, 10 do
                print("[GameMode:RoundStart] hero of playerID " .. playerID .. "has a modifier: " .. heroEntity:GetModifierNameByIndex(i))
              end
              return 1.0
            end)]]
            heroEntity:Stop()
            heroEntity:ForceKill(false)
            GameMode:Restore(heroEntity)
            --heroEntity:AddNewModifier(nil, nil, "modifier_specially_deniable", {})
            --heroEntity:AddNewModifier(nil, nil, "modifier_truesight", {})
            --set camera to hero because when the hero is relocated, the camera stays still
            --use global variable 'PlayerResource' to call the function
            PlayerResource:SetCameraTarget(playerID, heroEntity)
            --must delay the undoing of the SetCameraTarget by a second; if they're back to back, the camera will not move
            --set entity to 'nil' to undo setting the camera
            heroEntity:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
          end
        end
      end
    end
  end

  GameMode:SetUpRunes()
  
  GameMode.roundActive = true
  -- 1 second delayed, run once using gametime (respect pauses)
  Timers:CreateTimer({
    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()            
      for playerID = 0, GameMode.numPlayers do
        if PlayerResource:IsValidPlayerID(playerID) then
          PlayerResource:SetCameraTarget(playerID, nil)
        end
      end
    end
  })
  
end

function GameMode:DeathMatchStart()
  --intro sound
  EmitGlobalSound('snapfireOlympics.introAndBackground3')
  GameRules:SetHeroRespawnEnabled( true )
  --do the announcement
  Timers:CreateTimer({
    callback = function()
      Notifications:BottomToAll({text="3..." , duration= 1.0, style={["font-size"] = "45px"}})
    end
  })
  Timers:CreateTimer({
    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      Notifications:BottomToAll({text="2..." , duration= 1.0, style={["font-size"] = "45px"}})
    end
  })
  Timers:CreateTimer({
    endTime = 2, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      Notifications:BottomToAll({text="1..." , duration= 1.0, style={["font-size"] = "45px"}})
    end
  })
  Timers:CreateTimer({
    endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      Notifications:BottomToAll({text="GO!" , duration= 5.0, style={["font-size"] = "45px"}})
    end
  })
  --set up runes
  --runes every 1 minute
  --[[Timers:CreateTimer(0, function()
      GameMode:RemoveRunes()
      return 60.0
    end
  )]]
  Timers:CreateTimer(0, function()
      GameMode:SetUpRunes()
      return 60.0
    end
  )
  Timers:CreateTimer(59.5, function()
    GameMode:RemoveRunes()
    return 60.0
  end
)


  --reset cooldowns
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers do
        if GameMode.teams[teamNumber]["players"][playerID] ~= nil then
          if PlayerResource:IsValidPlayerID(playerID) then
            heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
            print("[GameMode:RoundStart] playerID: " .. playerID)
            for itemIndex = 0, 5 do
              if heroEntity:GetItemInSlot(itemIndex) ~= nil then
                heroEntity:GetItemInSlot(itemIndex):EndCooldown()
              end
            end
            for abilityIndex = 0, 5 do
              abil = heroEntity:GetAbilityByIndex(abilityIndex)
              abil:EndCooldown()
            end

            --[[Timers:CreateTimer(function()
              for i = 0, 10 do
                print("[GameMode:RoundStart] hero of playerID " .. playerID .. "has a modifier: " .. heroEntity:GetModifierNameByIndex(i))
              end
              return 1.0
            end)]]
            heroEntity:Stop()
            heroEntity:ForceKill(false)
            GameMode:Restore(heroEntity)
            --heroEntity:AddNewModifier(nil, nil, "modifier_specially_deniable", {})
            --set camera to hero because when the hero is relocated, the camera stays still
            --use global variable 'PlayerResource' to call the function
            PlayerResource:SetCameraTarget(playerID, heroEntity)
            --must delay the undoing of the SetCameraTarget by a second; if they're back to back, the camera will not move
            --set entity to 'nil' to undo setting the camera
            heroEntity:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
          end
        end
      end
    end
  end
  Timers:CreateTimer({
    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()            
      for playerID = 0, GameMode.numPlayers do
        if PlayerResource:IsValidPlayerID(playerID) then
          PlayerResource:SetCameraTarget(playerID, nil)
        end
      end
    end
  })
  
  --run an event every 30 seconds
    --arrow cookie
    --bomb cookie
    --mortimer
end


function GameMode:CheckTeamsRemaining()
  print("[GameMode:CheckTeamsRemaining] inside the function")
  local teamsRemaining = 0
  local winningTeamNumber = 0
  for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
      for playerID = 0, GameMode.numPlayers do
        if GameMode.teams[teamNumber]["players"][playerID] ~= nil then
          heroEntity = GameMode.teams[teamNumber]["players"][playerID].hero
          if heroEntity:IsAlive() then
            teamsRemaining = teamsRemaining + 1
            winningTeamNumber = teamNumber
            break
          end
        end
      end
    end
  end
  print("[GameMode:CheckTeamsRemaining] teamsRemaining: " .. teamsRemaining)
  print("[GameMode:CheckTeamsRemaining] winningTeamNumber: " .. winningTeamNumber)
  if teamsRemaining == 1 then
    return winningTeamNumber
  else
    return 0
  end
end

function GameMode:SpawnItem(item_name, item_x, item_y)
  --for i = 0, 3 do
    --randomly generate a number between x1 and x2
    --randomly generate a number between y1 and y2
    --place a potion there
  --create the item
  --it returns a handle; store it in a variable
  --pass this variable to the function
  local item_a = CreateItem(item_name, nil, nil)
  --item_a:SetCastOnPickup(true)

  
  --print("[GameMode:SpawnItem] item_y: " .. item_y)
  --what happens when an item is spawned on the hill?
  --island bottom layer's z = 128
  local item_z = 128
  --print("[GameMode:SpawnItem] item_vector: " .. tostring(Vector(item_x, item_y, item_z)))
  item_handle = CreateItemOnPositionSync(Vector(item_x, item_y, item_z), item_a)
  --print("[GameMode:SpawnItem] item_handle: ")
  --PrintTable(item_a)
  return item_handle
  --spawn 4 items
  --put them in a table
  --add a field "item_used"
  --when item is used,
    --set "item_used" to true
  --at the start of rounds
  --if item_used == true then
    --spawn new item
  --else
    --do nothing
  --
end

function GameMode:SpawnRune(rune_number, item_x, item_y)
  --local item_a = CreateItem("item_imba_rune_doubledamage", nil, nil)

  local item_z = 128
  --print("[GameMode:SpawnItem] rune_vector: " .. tostring(Vector(item_x, item_y, item_z)))

  local rune_handle = CreateRune(Vector(item_x, item_y, item_z), rune_number)
  --rune_handle = CreateItemOnPositionSync(Vector(item_x, item_y, item_z), item_a)
  --print("[GameMode:SpawnItem] rune_handle: ")
  --PrintTable(item_a)
  return rune_handle
  --spawn 4 items
  --put them in a table
  --add a field "item_used"
  --when item is used,
    --set "item_used" to true
  --at the start of rounds
  --if item_used == true then
    --spawn new item
  --else
    --do nothing
  --
end

--CustomGameEventManager:Send_ServertoAllPlayers("scores_create_scoreboard", {name = "This is lua!", desc="This is also LUA!", max= 5, id= 5})
