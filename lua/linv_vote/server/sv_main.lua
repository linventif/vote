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

// Functions Table
local netFunc = {
    [1] = function(ply)
        // Check if player is in cooldown
        local date_last_vote = sql.QueryValue("SELECT date FROM linvvote_cooldown WHERE steamid = '" .. ply:SteamID64() .. "'")
        if date_last_vote then
            local time_left = LinvVote.Config.Cooldown * 60 - LinvLib.timeDifference(date_last_vote, os.date("%Y-%m-%d %H:%M:%S"))
            SendChatMessage(ply, 2)
            SendChatMessage(ply, 3, {os.date("%H", time_left), os.date("%M", time_left)})
            return
        end
        // Check if player has vote
        http.Fetch("https://api.top-serveurs.net/v1/votes/check?server_token=" .. LinvVote.Config.Token .. "&playername=" .. ply:Nick(), function(body, length, headers, code)
            if code != 200 then return end
            local data = util.JSONToTable(body)
            sql.Query("INSERT INTO linvvote_cooldown (steamid) VALUES ('" .. ply:SteamID64() .. "') ON CONFLICT(steamid) DO UPDATE SET date = CURRENT_TIMESTAMP")
            ply:addMoney(LinvVote.Config.Money)
            // Send alert message to all players
            if LinvVote.Config.ShowVotes then
                net.Start("LinvVote")
                    net.WriteUInt(3, 8)
                    net.WriteString(ply:Nick())
                net.Broadcast()
            end
        end)
    end
}

// Net Receive
net.Receive("LinvVote", function(len, ply)
    local id = net.ReadUInt(8)
    if !netFunc[id] then return end
    netFunc[id](ply)
end)

// Timer
timer.Create("LinvVote:ClearSQLPlayer", 60, 0, function()
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

hook.Add("Initialize", "LinvVote:LoadSettings", function()
    if !LinvVote.Config.UseInGameConfig then return end
    LinvVote.Config = LinvLib:LoadSettings("linvvote_settings", LinvVote.Config, LinvVote.Info.version, "LinvVote")
end)

// Linventif Stuff Monitor

hook.Add("LinvLib:AddSettings", "LinvVote:AddSettings", function()
    LinvLib:MonitorAddSettings("LinvVote:Token", function()
        LinvVote.Config.Token = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:Url", function()
        LinvVote.Config.Url = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:RewardMoney", function()
        LinvVote.Config.Money = net.ReadInt(32)
    end)
    LinvLib:MonitorAddSettings("LinvVote:NpcName", function()
        LinvVote.Config.NPC_Name = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:PanelPosW", function()
        LinvVote.Config.PanelPosW = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:PanelPosH", function()
        LinvVote.Config.PanelPosH = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:NpcModel", function()
        LinvVote.Config.NPC_Model = net.ReadString()
    end)
    LinvLib:MonitorAddSettings("LinvVote:NpcHeight", function()
        LinvVote.Config.NPC_Height = net.ReadInt(32)
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

hook.Add("LinvVote:SendSettings", "LinvVote:SendSettings", function()
    LinvLib.SendAddonSettings("LinvVote", LinvVote.Config)
end)