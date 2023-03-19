if VoteSys.Config.Language == "french" then
    VoteSys.Language = {
        [1] = "Votez pour le serveur et recevez " .. LinvLib.MoneyToShow(" ", VoteSys.Config.Money) .. "€",
        [2] = "Votre pseudo doit être le meme qu'en jeu !",
        [3] = "Vous avez deja voté !",
        [4] = "Vous avez reçu " .. LinvLib.MoneyToShow(" ", VoteSys.Config.Money) .. "€ car vous avez votez pour le server",
        [5] = "Demande de récompense en cours...",
        [6] = "Vous n'avez rien reçus car vous n'avez pas voté !",
        [7] = "Votez",
        [8] = "Réclamer",
        [9] = "Fermer",
        [10] = "Après avoir voté, cliquez sur Réclamer pour récupérer votre récompense !",
        [11] = " à voté pour le serveur est a reçu " .. LinvLib.MoneyToShow(" ", VoteSys.Config.Money) .. "€  GG",
        [12] = "Votez",
        [13] = "Recevez",
        [14] = "€"
    }
else
    VoteSys.Language = {
        [1] = "Vote for the server and receive " .. LinvLib.MoneyToShow(",", VoteSys.Config.Money) .. "$",
        [2] = "Your nickname must be the same as in game !",
        [3] = "You have already voted !",
        [4] = "You received " .. LinvLib.MoneyToShow(",", VoteSys.Config.Money) .. "$ because you voted for the server",
        [5] = "Reward request in progress...",
        [6] = "You received nothing because you did not vote !",
        [7] = "Vote",
        [8] = "Claim",
        [9] = "Close",
        [10] = "After voting, click on Claim to receive your reward !",
        [11] = " has voted for the server and received " .. LinvLib.MoneyToShow(",", VoteSys.Config.Money) .. "$ GG",
    }
end

local function notif(msg)
    print("Vote System | " .. msg)
    chat.AddText(VoteSys.Config.UI["ChatName"], "Vote System | ", VoteSys.Config.UI["TextColor"], msg)
end

local function OpenMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 280)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, VoteSys.Config.UI["Border"])
        draw.RoundedBox(6, 4, 4, w-8, h-8, VoteSys.Config.UI["Background"])
        draw.SimpleText(VoteSys.Language[1], "LinvFontRobo30", 600/2, 40, VoteSys.Config.UI["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(VoteSys.Language[2], "LinvFontRobo20", 600/2, 100, VoteSys.Config.UI["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(VoteSys.Language[10], "LinvFontRobo20", 600/2, 140, VoteSys.Config.UI["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local yes = vgui.Create("DButton", frame)
    yes:SetPos(600/2-210, 200)
    yes:SetSize(100, 40)
    yes:SetText(VoteSys.Language[7])
    yes:SetFont("LinvFontRobo20")
    yes:SetTextColor(VoteSys.Config.UI["TextColor"])
    yes.DoClick = function()
        gui.OpenURL(VoteSys.Config.Url .. "?pseudo=" .. LocalPlayer():Nick())
    end
    yes.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, VoteSys.Config.UI["Border"])
        draw.RoundedBox(6, 4, 4, w-8, h-8, VoteSys.Config.UI["Background"])
    end
    LinvLib.Hover(yes, 6, 4, VoteSys.Config.UI["Background"], VoteSys.Config.UI["ButtonHover"], VoteSys.Config.UI["Border"], VoteSys.Config.UI["Border"])
    local request = vgui.Create("DButton", frame)
    request:SetPos(600/2-60, 200)
    request:SetSize(120, 40)
    request:SetText(VoteSys.Language[8])
    request:SetFont("LinvFontRobo20")
    request:SetTextColor(VoteSys.Config.UI["TextColor"])
    request.DoClick = function()
        net.Start("VoteSys")
        net.SendToServer()
        notif(VoteSys.Language[5])
    end
    request.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, VoteSys.Config.UI["Border"])
        draw.RoundedBox(6, 4, 4, w-8, h-8, VoteSys.Config.UI["Background"])
    end
    LinvLib.Hover(request, 6, 4, VoteSys.Config.UI["Background"], VoteSys.Config.UI["ButtonHover"], VoteSys.Config.UI["Border"], VoteSys.Config.UI["Border"])
    local no = vgui.Create("DButton", frame)
    no:SetPos(600/2+110, 200)
    no:SetSize(100, 40)
    no:SetText(VoteSys.Language[9])
    no:SetFont("LinvFontRobo20")
    no:SetTextColor(VoteSys.Config.UI["TextColor"])
    no.DoClick = function()
        frame:Close()
    end
    no.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, VoteSys.Config.UI["Border"])
        draw.RoundedBox(6, 4, 4, w-8, h-8, VoteSys.Config.UI["Background"])
    end
    LinvLib.Hover(no, 6, 4, VoteSys.Config.UI["Background"], VoteSys.Config.UI["ButtonHover"], VoteSys.Config.UI["Border"], VoteSys.Config.UI["Border"])
end

local function OpenNotif(name)
    local frame = vgui.Create("DPanel")
    frame:SetSize(600, 40)
    frame:SetPos(ScrW()/2-300, -100)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, VoteSys.Config.UI["Border"])
        draw.RoundedBox(6, 4, 4, w-8, h-8, VoteSys.Config.UI["Background"])
        draw.SimpleText(name .. VoteSys.Language[11], "LinvFontRobo20", 600/2, 20, VoteSys.Config.UI["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    frame:MoveTo(ScrW()/2-300, 10, 0.5, 0, 1)
    if VoteSys.Config.VoteSound != "" then
        surface.PlaySound("UI/buttonclick.wav")
    end
    timer.Simple(6, function()
        frame:MoveTo(ScrW()/2-300, -100, 0.5, 0, 1)
        timer.Simple(0.5, function()
            frame:Remove()
        end)
    end)
end

hook.Add("OnPlayerChat", "Vote", function(ply, text, team)
    if ply == LocalPlayer() then
        if VoteSys.Config.Commands[string.lower(text)] then
            OpenMenu()
        end
    end
end)

net.Receive("VoteSys", function()
    local id = net.ReadString()
    local data = net.ReadString()
    if id == "notif" then
        notif(VoteSys.Language[tonumber(data)])
        print(data)
    elseif id == "notif-vote" then
        OpenNotif(data)
    end
end)

if VoteSys.Config.ShowOnJoin then
    hook.Add("InitPostEntity", "VoteSys", function()
        timer.Simple(5, function()
            OpenMenu()
        end)
    end)
end

//  if VoteSys.Config.VotePanel then
//      hook.Add("HUDPaint", "VotePanel", function()
//          draw.RoundedBox(8, ScrW() - 200 - 40, ScrH() / 2 - 100, 200, 200, VoteSys.Config.UI["Border"])
//          draw.RoundedBox(6, ScrW() - 196 - 40, ScrH() / 2 - 96, 192, 192, VoteSys.Config.UI["Background"])
//          draw.SimpleText(VoteSys.Language[13], "LinvFontRobo30", ScrW() - 100 - 40, ScrH() / 2 - 25 - 30, VoteSys.Config.UI["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
//          draw.SimpleText(LinvLib.MoneyToShow(" ", VoteSys.Config.Money) .. VoteSys.Language[14], "LinvFontRobo30", ScrW() - 100 - 40, ScrH() / 2 - 25 + 20, VoteSys.Config.UI["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
//          draw.SimpleText(VoteSys.Language[12], "LinvFontRobo30", ScrW() - 100 - 40, ScrH() / 2 - 25 + 80, VoteSys.Config.UI["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
//      end)
//  end