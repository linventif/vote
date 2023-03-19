// Net Init
util.AddNetworkString("LinvVote")

// SQL
sql.Query("CREATE TABLE IF NOT EXISTS linvvote_cooldown (steamid TEXT PRIMARY KEY, date TEXT DEFAULT CURRENT_TIMESTAMP)")

// Vars
local ply_to_check = {}

// Net Receive
net.Receive("LinvVote", function(len, ply)
    local id = net.ReadUInt(8)
    // ID 1 = Add Player to Check Table
    if id == 1 then
        local cooldown = sql.QueryValue("SELECT date FROM linvvote_cooldown WHERE steamid = '" .. ply:SteamID64() .. "'")
        if cooldown || ply_to_check[ply] then return end
        ply_to_check[ply] = true
    end
end)

// Timer
timer.Create("LinvVote:RefreshVoteList", LinvVote.Config.RefreshTime * 60, 0, function()
    for ply, _ in pairs(ply_to_check) do
        http.Fetch("https://api.top-serveurs.net/v1/votes/check?server_token=" .. LinvVote.Config.Token .. "&playername=" .. ply:Nick(), function(body)
            local data = util.JSONToTable(body)
            if data.code == 200 then
                ply:addMoney(LinvVote.Config.Money)
                sql.Query("INSERT INTO linvvote_cooldown (steamid) VALUES ('" .. ply:SteamID64() .. "') ON CONFLICT(steamid) DO UPDATE SET date = CURRENT_TIMESTAMP")
                net.Start("LinvVote")
                    // ID 2 = Send alert message to player
                    net.WriteUInt(5, 8)
                net.Send(ply)
                if LinvVote.Config.ShowVotes then
                    net.Start("LinvVote")
                        // ID 3 = Send alert message to all players
                        net.WriteUInt(3, 8)
                        net.WriteString(ply:Nick())
                    net.Broadcast()
                end
            end
        end)
        ply_to_check[ply] = nil
    end
end)

timer.Create("LinvVote:ClearSQLPlayer", 60, 0, function()
    local plys_not_in_cool = sql.Query("SELECT steamid FROM linvvote_cooldown WHERE date < CURRENT_TIMESTAMP - 7200")
    if plys_not_in_cool then
        for _, ply in pairs(plys_not_in_cool) do
            sql.Query("DELETE FROM linvvote_cooldown WHERE steamid = '" .. ply.steamid .. "'")
        end
    end
end)

// Hooks
hook.Add("PlayerEnteredVehicle", "LinvVote:PlayerEnteredVehicle", function(ply, vehicle)
    if !LinvVote.Config.RemoveInVehicle then return end
    net.Start("LinvVote")
        // ID 2 = Remove Vote Panel
        net.WriteUInt(2, 8)
    net.Send(ply)
end)

hook.Add("PlayerLeaveVehicle", "LinvVote:PlayerLeaveVehicle", function(ply, vehicle)
    if !LinvVote.Config.RemoveInVehicle then return end
    net.Start("LinvVote")
        // ID 1 = Show Vote Panel
        net.WriteUInt(1, 8)
    net.Send(ply)
end)