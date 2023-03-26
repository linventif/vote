if file.Exists("linventif/linventif_stuff/linvvote_settings.json", "DATA") then
    local data = util.JSONToTable(file.Read("linventif/linventif_stuff/linvvote_settings.json", "DATA"))
    if data.version < "0.2.0" then
        file.Delete("linventif/linventif_stuff/linvvote_settings.json")
    end
end


// Net Init
util.AddNetworkString("LinvVote")

// Net ID
/*
    Net Send
    ID 1 = Show Vote Panel
    ID 2 = Remove Vote Panel
    ID 3 = Send alert message to all players
    ID 4 = Open Vote Menu
    ID 5 = Send chat message to player

    Net Receive
    ID 1 = Add Player to Check Table
*/

// SQL
sql.Query("CREATE TABLE IF NOT EXISTS linvvote_cooldown (steamid TEXT PRIMARY KEY, date TEXT DEFAULT CURRENT_TIMESTAMP)")

// ConCommands

concommand.Add("linvvote_cooldown_clear", function(ply, cmd, args)
    if ply:IsValid() then return end
    sql.Query("DELETE FROM linvvote_cooldown")
    print("[LinvVote] Cooldown table cleared")
end)

concommand.Add("linvvote_cooldown_list", function(ply, cmd, args)
    if ply:IsValid() then return end
    local plys_in_cool = sql.Query("SELECT * FROM linvvote_cooldown")
    if !plys_in_cool || table.IsEmpty(plys_in_cool) then print("[LinvVote] No player in cooldown") return end
    for _, ply in pairs(plys_in_cool) do
        print("[LinvVote] " .. ply.steamid .. " - " .. ply.date)
    end
end)

// Vars
local ply_to_check = {}

// Functions
local function SendChatMessage(ply, id_msg, args)
    net.Start("LinvVote")
        net.WriteUInt(5, 8) // ID 5 = Send chat message to player
        net.WriteUInt(id_msg, 8)
        if args then
            net.WriteString(util.TableToJSON(args))
        end
    net.Send(ply)
end

// Net Receive
net.Receive("LinvVote", function(len, ply)
    local id = net.ReadUInt(8)
    if id == 1 then
        local date_last_vote = sql.QueryValue("SELECT date FROM linvvote_cooldown WHERE steamid = '" .. ply:SteamID64() .. "'")
        if ply_to_check[ply] then
            SendChatMessage(ply, 1)
            return
        elseif date_last_vote then
            SendChatMessage(ply, 2)
            SendChatMessage(ply, 3, {(tonumber(string.sub(date_last_vote, 12, 13))+2)%23, string.sub(date_last_vote, 15, 16)})
            return
        end
        ply_to_check[ply] = true
        SendChatMessage(ply, 4, {math.Round(LinvVote.Config.RefreshTime / 60)})
    end
end)

// Timer
timer.Create("LinvVote:RefreshVoteList", LinvVote.Config.RefreshTime, 0, function()
    if !ply_to_check || table.IsEmpty(ply_to_check) then return end
    for ply, _ in pairs(ply_to_check) do
        if !IsValid(ply) then ply_to_check[ply] = nil continue end
        http.Fetch("https://api.top-serveurs.net/v1/votes/check?server_token=" .. LinvVote.Config.Token .. "&playername=" .. ply:Nick(), function(body)
            local data = util.JSONToTable(body)
            if data.code == 200 then
                sql.Query("INSERT INTO linvvote_cooldown (steamid) VALUES ('" .. ply:SteamID64() .. "') ON CONFLICT(steamid) DO UPDATE SET date = CURRENT_TIMESTAMP")
                ply:addMoney(LinvVote.Config.Money)
                if LinvVote.Config.ShowVotes then
                    net.Start("LinvVote")
                        net.WriteUInt(3, 8) // ID 3 = Send alert message to all players
                        net.WriteString(ply:Nick())
                    net.Broadcast()
                end
            end
        end)
        ply_to_check[ply] = nil
    end
end)

timer.Create("LinvVote:ClearSQLPlayer", 30, 0, function()
    local plys_not_in_cool = sql.Query("SELECT * FROM linvvote_cooldown WHERE date < datetime('now', '-" .. LinvVote.Config.Cooldown .. " minutes')")
    if !plys_not_in_cool || table.IsEmpty(plys_not_in_cool) then return end
    for _, ply in pairs(plys_not_in_cool) do
        sql.Query("DELETE FROM linvvote_cooldown WHERE steamid = '" .. ply.steamid .. "'")
    end
end)

// Hooks
hook.Add("PlayerEnteredVehicle", "LinvVote:PlayerEnteredVehicle", function(ply, vehicle)
    if !LinvVote.Config.RemoveInVehicle then return end
    net.Start("LinvVote")
        net.WriteUInt(2, 8) // ID 2 = Remove Vote Panel
    net.Send(ply)
end)

hook.Add("PlayerLeaveVehicle", "LinvVote:PlayerLeaveVehicle", function(ply, vehicle)
    if !LinvVote.Config.RemoveInVehicle then return end
    net.Start("LinvVote")
        net.WriteUInt(1, 8) // ID 1 = Show Vote Panel
    net.Send(ply)
end)

// Initialize
hook.Add("Initialize", "LinvVote:LoadSettings", function()
    LinvVote.Config = LinvLib:LoadSettings("linvvote_settings", LinvVote.Config, LinvVote.Info.version, "LinvVote")
end)

hook.Add("LinvLib:AddSettings", "LinvVote:AddSettings", function()
    LinvLib:MonitorAddSettings("LinvVote:Token", function()
        LinvVote.Config.Token = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:Url", function()
        LinvVote.Config.Url = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:RewardMoney", function()
        LinvVote.Config.RewardMoney = net.ReadInt(32)
    end)
    LinvLib:MonitorAddSettings("LinvVote:NpcName", function()
        LinvVote.Config.NPC_Name = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:NpcModel", function()
        LinvVote.Config.NPC_Model = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:NpcHeight", function()
        LinvVote.Config.NPC_Height = net.ReadInt(32)
    end)
    LinvLib:MonitorAddSettings("LinvVote:RefreshTime", function()
        LinvVote.Config.RefreshTime = net.ReadInt(32)
    end)
    LinvLib:MonitorAddSettings("LinvVote:Cooldown", function()
        LinvVote.Config.Cooldown = net.ReadInt(32)
    end)
    LinvLib:MonitorAddSettings("LinvVote:ShowVotesPanel", function()
        LinvVote.Config.ShowVotesPanel = net.ReadBool()
    end)
    LinvLib:MonitorAddSettings("LinvVote:RemoveInVehicle", function()
        LinvVote.Config.RemoveInVehicle = net.ReadBool()
    end)
    LinvLib:MonitorAddSettings("LinvVote:ShowOnJoin", function()
        LinvVote.Config.ShowOnJoin = net.ReadBool()
    end)
    LinvLib:MonitorAddSettings("LinvVote:ShowVotes", function()
        LinvVote.Config.ShowVotes = net.ReadBool()
    end)
    LinvLib:MonitorAddSettings("LinvVote:SaveSettings", function()
        LinvLib:SaveSettings("linvvote_settings", LinvVote.Config, LinvVote.Info.version, "LinvVote")
    end)
end)