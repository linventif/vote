// Functions
local function AddChatMsg(msg)
    chat.AddText(Color(45, 160, 180),  LinvVote:GetTrad("linv_vote"), LinvLib:GetColorTheme("text"), msg)
end

local function thanksMenu()
    local frame = LinvLib:Frame(600, 240)
    frame:DockMargin(0, 0, 0, 0)
    frame:DockPadding(LinvLib:RespW(30), LinvLib:RespH(20), LinvLib:RespW(30), LinvLib:RespH(30))

    local title = LinvLib:LabelPanel(frame, LinvVote:GetTrad("thanks"), "LinvFontRobo25", 500, 40)
    title:Dock(TOP)
    title:DockMargin(0, 0, 0, LinvLib:RespH(20))

    LinvLib:CloseButton(frame, 36, 36, LinvLib:RespW(600 - 60), LinvLib:RespH(20), function()
        frame:Close()
    end)

    local panel = LinvLib:Panel(frame, 500, 200)
    panel:Dock(FILL)
    panel:DockMargin(0, 0, 0, LinvLib:RespH(15))

    local info1 = LinvLib:LabelPanel(panel, LinvVote:GetTrad("thanks_info1"), "LinvFontRobo20", 500, 30)
    info1:Dock(TOP)
    info1:DockMargin(0, 0, 0, LinvLib:RespH(15))

    local info2 = LinvLib:LabelPanel(panel, LinvVote:GetTrad("thanks_info2", {LinvLib:MoneyFormat(LinvVote.Config.Money)}), "LinvFontRobo20", 500, 30)
    info2:Dock(TOP)
    info2:DockMargin(0, 0, 0, LinvLib:RespH(15))

    local info3 = LinvLib:LabelPanel(panel, LinvVote:GetTrad("thanks_info3"), "LinvFontRobo20", 500, 30)
    info3:Dock(TOP)
    info3:DockMargin(0, 0, 0, LinvLib:RespH(15))
end

local function voteMenu()
    LinvLib:WebPage(LinvVote.Config.Url .. "?pseudo=" .. LocalPlayer():Nick(), {["on_close"] = function()
        net.Start("LinvVote")
            net.WriteUInt(1, 8)
        net.SendToServer()
        thanksMenu()
    end})
end

local function votePanel()
    if !LinvVote.Config.ShowVotesPanel then return end
    hook.Call("LinvVote:RemoveVotePanel")
    panelState = true

    local frame = LinvLib:Frame(200, 180, {["no_popup"] = true})
    frame:DockMargin(0, 0, 0, 0)
    frame:DockPadding(LinvLib:RespW(30), LinvLib:RespH(20), LinvLib:RespW(30), LinvLib:RespH(30))
    frame:SetPos(LinvLib:RespW(1920 - 200 - 30), LinvLib:RespH(1080 / 2 - 300 / 2))

    local title = LinvLib:LabelPanel(frame, LinvVote:GetTrad("claim"), "LinvFontRobo25", 200, 20)
    title:Dock(TOP)

    local amount = LinvLib:LabelPanel(frame, LinvLib:MoneyFormat(LinvVote.Config.Money), "LinvFontRobo30", 200, 20)
    amount:Dock(FILL)

    local vote = LinvLib:Button(frame, LinvVote:GetTrad("vote"), 200, 40, LinvLib:GetColorTheme("element"), true, function()
        voteMenu()
    end)
    vote:Dock(BOTTOM)

    hook.Add("LinvVote:RemoveVotePanel", "LinvLib:VotePanel", function()
        frame:Remove()
    end)
end

// Net Messages
local netMessage = {
    [1] = function()
        AddChatMsg(LinvVote:GetTrad("already_in_list"))
    end,
    [2] = function()
        AddChatMsg(LinvVote:GetTrad("already_vote"))
    end,
    [3] = function(args)
        AddChatMsg(LinvVote:GetTrad("can_revote_in", args))
    end,
    [4] = function(args)
        AddChatMsg(LinvVote:GetTrad("added_to_list", args))
    end,
}

// Nets
net.Receive("LinvVote", function()
    local id = net.ReadUInt(8)
    if id == 1 then
        votePanel()
    elseif id == 2 then
        hook.Call("LinvVote:RemoveVotePanel")
    elseif id == 3 then
        local ply_name = net.ReadString()
        AddChatMsg(LinvVote:GetTrad("ply_vote", {ply_name, LinvLib:MoneyFormat(LinvVote.Config.Money)}))
    elseif id == 4 then
        voteMenu()
    elseif id == 5 then
        netMessage[net.ReadUInt(8)](util.JSONToTable(net.ReadString() || "[]"))
    end
end)

// Hooks
hook.Add("OnPlayerChat", "Vote", function(ply, text, team)
    if ply != LocalPlayer() then return end
    if LinvVote.Config.Commands[string.lower(text)] then
        voteMenu()
    end
end)

hook.Add("InitPostEntity", "LinvLib:VotePanel", function()
    if LinvVote.Config.ShowOnJoin then votePanel() end
end)

hook.Add("LinvLib:LoadSetting", "LinvVote:LoadSetting", function(addon, setting)
    if addon == "LinvVote" then
        LinvVote.Config = setting
    end
end)

hook.Add("LinvLib:AddSettings", "LinvVote:AddSettings", function()
    LinvLib:MonitorAddSettings({
        ["name"] = LinvVote:GetTrad("linvvote"),
        ["settings"] = {
            [1] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:TextPanel(LinvVote:GetTrad("token"), LinvVote.Config.Token, function(value)
                        LinvVote.Config.Token = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:Token")
                            net.WriteString(LinvVote.Config.Token)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end, LinvVote:GetTrad("token_desc"))
                end,
                ["name"] = LinvVote:GetTrad("token")
            },
            [2] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:TextPanel(LinvVote:GetTrad("url"), LinvVote.Config.Url, function(value)
                        LinvVote.Config.Url = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:Url")
                            net.WriteString(LinvVote.Config.Url)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end, LinvVote:GetTrad("url_desc"))
                end,
                ["name"] = LinvVote:GetTrad("url")
            },
            [3] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:NumberPanel(LinvVote:GetTrad("reward_money"), LinvVote.Config.Money, 0, 10000000, function(value)
                        LinvVote.Config.Money = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:RewardMoney")
                            net.WriteInt(LinvVote.Config.Money, 32)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end, LinvVote:GetTrad("reward_money_desc"))
                end,
                ["name"] = LinvVote:GetTrad("reward_money")
            },
            [4] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:TextPanel(LinvVote:GetTrad("npc_name"), LinvVote.Config.NPC_Name, function(value)
                        LinvVote.Config.NPC_Name = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:NpcName")
                            net.WriteString(LinvVote.Config.NPC_Name)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end)
                end,
                ["name"] = LinvVote:GetTrad("npc_name")
            },
            [5] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:TextPanel(LinvVote:GetTrad("npc_model"), LinvVote.Config.NPC_Model, function(value)
                        LinvVote.Config.NPC_Model = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:NpcModel")
                            net.WriteString(LinvVote.Config.NPC_Model)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end)
                end,
                ["name"] = LinvVote:GetTrad("npc_model")
            },
            [6] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:NumberPanel(LinvVote:GetTrad("npc_height"), LinvVote.Config.NPC_Height, 0, 10000000, function(value)
                        LinvVote.Config.NPC_Height = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:NpcHeight")
                            net.WriteInt(LinvVote.Config.NPC_Height, 32)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end)
                end,
                ["name"] = LinvVote:GetTrad("npc_height")
            },
            [7] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:NumberPanel(LinvVote:GetTrad("refresh_time"), LinvVote.Config.RefreshTime, 0, 10000000, function(value)
                        LinvVote.Config.RefreshTime = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:RefreshTime")
                            net.WriteInt(LinvVote.Config.RefreshTime, 32)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end, LinvVote:GetTrad("refresh_time_desc"))
                end,
                ["name"] = LinvVote:GetTrad("refresh_time")
            },
            [8] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    LinvLib:NumberPanel(LinvVote:GetTrad("cooldown"), LinvVote.Config.Cooldown, 0, 10000000, function(value)
                        LinvVote.Config.Cooldown = value
                        net.Start("LinvLib:SaveSetting")
                            net.WriteString("LinvVote:Cooldown")
                            net.WriteInt(LinvVote.Config.Cooldown, 32)
                        net.SendToServer()
                    end, function()
                        RunConsoleCommand("linvlib_settings")
                    end, LinvVote:GetTrad("cooldown_desc"))
                end,
                ["name"] = LinvVote:GetTrad("cooldown")
            },
            [9] = {
                ["checkbox"] = true,
                ["state"] = LinvVote.Config.ShowVotesPanel,
                ["icon"] = LinvLib.Materials["valid"],
                ["save_setting"] = {
                    ["name"] = "LinvVote:ShowVotesPanel",
                    ["type"] = "boolean",
                    ["value"] = !LinvVote.Config.ShowVotesPanel
                },
                ["name"] = LinvVote:GetTrad("show_votes_panel")
            },
            [10] = {
                ["checkbox"] = true,
                ["state"] = LinvVote.Config.RemoveInVehicle,
                ["icon"] = LinvLib.Materials["valid"],
                ["save_setting"] = {
                    ["name"] = "LinvVote:RemoveInVehicle",
                    ["type"] = "boolean",
                    ["value"] = !LinvVote.Config.RemoveInVehicle
                },
                ["name"] = LinvVote:GetTrad("remove_in_vehicle")
            },
            [11] = {
                ["checkbox"] = true,
                ["state"] = LinvVote.Config.ShowOnJoin,
                ["icon"] = LinvLib.Materials["valid"],
                ["save_setting"] = {
                    ["name"] = "LinvVote:ShowOnJoin",
                    ["type"] = "boolean",
                    ["value"] = !LinvVote.Config.ShowOnJoin
                },
                ["name"] = LinvVote:GetTrad("show_on_join")
            },
            [12] = {
                ["checkbox"] = true,
                ["state"] = LinvVote.Config.ShowVotes,
                ["icon"] = LinvLib.Materials["valid"],
                ["save_setting"] = {
                    ["name"] = "LinvVote:ShowVotes",
                    ["type"] = "boolean",
                    ["value"] = !LinvVote.Config.ShowVotes
                },
                ["name"] = LinvVote:GetTrad("show_votes")
            },
        }
    })
end)