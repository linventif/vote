// Functions
local function AddChatMsg(msg)
    chat.AddText(Color(45, 160, 180),  LinvVote:GetTrad("linv_vote"), LinvLib:GetColorTheme("text"), msg)
end

local function voteMenu()
    LinvLib:WebPage(LinvVote.Config.Url .. "?pseudo=" .. LocalPlayer():Nick(), {["on_close"] = function()
        net.Start("LinvVote")
            net.WriteUInt(1, 8)
        net.SendToServer()
    end})
end

local function GetPosPanel(id)
    local pos = {
        ["w"] = {
            ["value"] = LinvVote.Config.PanelPosW,
            ["left"] = 30,
            ["center"] = 1920 / 2 - 200 / 2,
            ["right"] = 1920 - 30 - 200
        },
        ["h"] = {
            ["value"] = LinvVote.Config.PanelPosH,
            ["top"] = 30,
            ["center"] = 1080 / 2 - 180 / 2,
            ["bottom"] = 1080 - 30 - 180
        }
    }
    return pos[id][pos[id]["value"]]
end

local function votePanel()
    if !LinvVote.Config.ShowVotesPanel then return end
    hook.Call("LinvVote:RemoveVotePanel")
    panelState = true

    local frame = LinvLib:Frame(200, 180, {["no_popup"] = true})
    frame:DockMargin(0, 0, 0, 0)
    frame:DockPadding(LinvLib:RespW(30), LinvLib:RespH(20), LinvLib:RespW(30), LinvLib:RespH(30))
    frame:SetPos(LinvLib:RespW(GetPosPanel("w")), LinvLib:RespH(GetPosPanel("h")))

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

hook.Add("LinvLib:LoadSetting", "LinvVote:LoadSetting", function(addon, setting)
    if addon == "LinvVote" then
        LinvVote.Config = setting
        hook.Call("LinvVote:RemoveVotePanel")
        if !LocalPlayer():InVehicle() then votePanel() end
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
                    local data = {
                        ["data"] = {
                            "right",
                            "center",
                            "left",
                        },
                        ["callback"] = function(value)
                            LinvVote.Config.PanelPosW = value
                            net.Start("LinvLib:SaveSetting")
                                net.WriteString("LinvVote:PanelPosW")
                                net.WriteString(LinvVote.Config.PanelPosW)
                            net.SendToServer()
                        end,
                        ["title"] = LinvVote:GetTrad("panel_pos_w")
                    }
                    LinvLib.SelectMenu(data)
                end,
                ["name"] = LinvVote:GetTrad("panel_pos_w")
            },
            [8] = {
                ["icon"] = LinvLib.Materials["edit"],
                ["function"] = function()
                    local data = {
                        ["data"] = {
                            "top",
                            "center",
                            "bottom",
                        },
                        ["callback"] = function(value)
                            LinvVote.Config.PanelPosH = value
                            net.Start("LinvLib:SaveSetting")
                                net.WriteString("LinvVote:PanelPosH")
                                net.WriteString(LinvVote.Config.PanelPosH)
                            net.SendToServer()
                        end,
                        ["title"] = LinvVote:GetTrad("panel_pos_h")
                    }
                    LinvLib.SelectMenu(data)
                end,
                ["name"] = LinvVote:GetTrad("panel_pos_h")
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