// Functions
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

// Nets
net.Receive("LinvVote", function()
    local id = net.ReadUInt(8)
    if id == 1 then
        votePanel()
    elseif id == 2 then
        hook.Call("LinvVote:RemoveVotePanel")
    elseif id == 3 then
        local ply_name = net.ReadString()
        if ply_name == LocalPlayer():Nick() then return end
        chat.AddText(Color(45, 160, 180), LinvVote:GetTrad("linv_vote"), LinvLib:GetColorTheme("text"), LinvVote:GetTrad("ply_vote", {ply_name, LinvLib:MoneyFormat(LinvVote.Config.Money)}))
    elseif id == 4 then
        voteMenu()
    elseif id == 5 then
        chat.AddText(Color(45, 160, 180), LinvVote:GetTrad("linv_vote"), LinvLib:GetColorTheme("text"), LinvVote:GetTrad("reward_received", {LinvLib:MoneyFormat(LinvVote.Config.Money)}))
    end
end)

// Hooks
hook.Add("OnPlayerChat", "Vote", function(ply, text, team)
    if ply != LocalPlayer() then return end
    if LinvVote.Config.Commands[string.lower(text)] then
        voteMenu()
    end
    return true
end)

hook.Add("InitPostEntity", "LinvLib:VotePanel", function()
    if LinvVote.Config.ShowOnJoin then votePanel() end
end)