util.AddNetworkString("VoteSys")

local plys_info = {
    ["incooldown"] = {},
    ["inwait"] = {},
    ["inwaitnb"] = 0
}

local function NetToPly(id, ply, data)
    net.Start("VoteSys")
    net.WriteString(id)
    net.WriteString(data)
    if ply == "all" then
        net.Broadcast()
    else
        net.Send(ply)
    end
end

net.Receive("VoteSys", function(len, ply)
    plys_info.inwait[ply] = true
    plys_info.inwaitnb = plys_info.inwaitnb + 1
end)

timer.Create("RefreshVoteList", VoteSys.Config.RefreshTime, 0, function()
    for ply, _ in pairs(plys_info.inwait) do
        http.Fetch("https://api.top-serveurs.net/v1/votes/check?server_token=" .. VoteSys.Config.Token .. "&playername=" .. ply:Nick(), function(body)
            local data = util.JSONToTable(body)
            if data.code == 200 && !plys_info.incooldown[ply] then
                ply:addMoney(VoteSys.Config.Money)
                plys_info.inwait[ply] = nil
                plys_info.incooldown[ply] = true
                if VoteSys.Config.ShowVotes then
                    NetToPly("notif-vote", "all", ply:Nick())
                end
                NetToPly("notif", ply, 4)
            elseif plys_info.incooldown[ply] then
                NetToPly("notif", ply, 3)
            else
                NetToPly("notif", ply, 6)
            end
        end)
        plys_info.inwait[ply] = nil
        plys_info.inwaitnb = plys_info.inwaitnb - 1
    end
end)