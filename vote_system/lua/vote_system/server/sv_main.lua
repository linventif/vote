util.AddNetworkString("VoteSys")

local plys_info = {
    ["incooldown"] = {},
    ["inwait"] = {},
    ["inwaitnb"] = 0
}

local function notif(id, ply)
    net.Start("VoteSys")
    net.WriteInt(id, 8)
    net.Send(ply)
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
                notif(4, ply)
            elseif plys_info.incooldown[ply] then
                notif(3, ply)
            else
                notif(6, ply)
            end
        end)
        plys_info.inwait[ply] = nil
        plys_info.inwaitnb = plys_info.inwaitnb - 1
    end
end)