function SumoOutOfBounds(trigger)
    local ent = trigger.activator
    if not ent then return end
    --triggered flag
    --loop through all players
    --if there's only one player left whose flag hasn't been triggered yet then
    --end game

    --stun
    ent:AddNewModifier(nil, nil, "modifier_stunned", {})
    --table of players
    --GameMode.teams[teamNum][playerID].sumoOutOfBounds
    GameMode.teams[ent:GetTeamNumber()][ent:GetPlayerID()].sumoOutOfBounds = true
    local numAlive = 0
    local winner = {}
    for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
            for playerID  = 0, GameMode.maxNumPlayers - 1 do
                if GameMode.teams[teamNumber][playerID] ~= nil then
                    if not GameMode.teams[teamNumber][playerID].sumoOutOfBounds then
                        numAlive = numAlive + 1
                        winner[1] = GameMode.teams[teamNumber][playerID].hero
                    end
                end
            end
        end
    end
    if numAlive == 1 then
        GameMode:EndGame(winner, "sumo")
        --reset
        for teamNumber = 6, 13 do
            if GameMode.teams[teamNumber] ~= nil then
                for playerID  = 0, GameMode.maxNumPlayers - 1 do
                    if GameMode.teams[teamNumber][playerID] ~= nil then
                        GameMode.teams[teamNumber][playerID].sumoOutOfBounds = false
                    end
                end
            end
        end
    end
end

function DashEnd(trigger)
    local ent = trigger.activator
    if not ent then return end
    local winner = {}
    winner[1] = ent
    GameMode:EndGame(winner, "dash")
end

function DashOutOfBounds(trigger)
    local ent = trigger.activator
    if not ent then return end
    ent:AddNewModifier(nil, nil, "modifier_stunned", { duration = 2})
end

function FroggerEnd(trigger)
    local ent = trigger.activator
    if not ent then return end

    --flag for game thinker
    GameMode.games["frogger"].finished = true

    --set winner
    local winner = ent

    --announce
    Notifications:BottomToAll({text = "Winner! ", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
    Notifications:BottomToAll({text = GameMode.teamNames[winner:GetTeam()], duration= 5.0, style={["font-size"] = "45px", color = GameMode.teamColors[winner:GetTeam()]}, continue=true})
    
    --assign score
    GameMode.teams[winner:GetTeam()].score = GameMode.teams[winner:GetTeam()].score + 1

    --end game
    GameMode:EndGame()
end

function FeederAndEaterLevel6End(trigger)
    print("activated")
    local ent = trigger.activator
    if not ent then return end
    GameMode.games["feederAndEater"].level6Finished = GameMode.games["feederAndEater"].level6Finished + 1
    if GameMode.games["feederAndEater"].level6Finished == 2 then
        Notifications:BottomToAll({text = "Feeder And Eater finished", duration= 5.0, style={["font-size"] = "45px", color = "white"}}) 
        local winners = {}
        for teamNumber = 6, 13 do
            if GameMode.teams[teamNumber] ~= nil then
              for playerID  = 0, GameMode.maxNumPlayers - 1 do
                if GameMode.teams[teamNumber][playerID] ~= nil then
                  local heroEntity = GameMode.teams[teamNumber][playerID].hero
                  winners[playerID+1] = heroEntity
                end
              end
            end
          end
        GameMode:EndGame(winners, "feederAndEater")
        --GameMode:FeederAndEaterLevel7()
        --shooter and eater
        --shooter has no vision
    end
end