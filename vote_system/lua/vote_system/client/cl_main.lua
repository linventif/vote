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
        [10] = "Après avoir voté, cliquez sur Réclamer pour récupérer votre récompense !"
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
        [10] = "After voting, click on Claim to receive your reward !"
    }
end

local function notif(msg)
    print("Vote System | " .. msg)
    chat.AddText(Color(204, 40, 103), "Vote System | ", Color(255, 255, 255), msg)
end

hook.Add("OnPlayerChat", "Vote", function(ply, text, team)
    if VoteSys.Config.Commands[string.lower(text)] then
        local frame = vgui.Create("DFrame")
        frame:SetSize(600, 280)
        frame:Center()
        frame:SetTitle("")
        frame:MakePopup()
        frame:ShowCloseButton(false)
        frame.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(113, 113, 113))
            draw.RoundedBox(6, 4, 4, w-8, h-8, Color(51, 51, 51, 255))
            draw.SimpleText(VoteSys.Language[1], "LinvFontRobo30", 600/2, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(VoteSys.Language[2], "LinvFontRobo20", 600/2, 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(VoteSys.Language[10], "LinvFontRobo20", 600/2, 140, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        local yes = vgui.Create("DButton", frame)
        yes:SetPos(600/2-200, 200)
        yes:SetSize(100, 40)
        yes:SetText(VoteSys.Language[7])
        yes:SetFont("LinvFontRobo20")
        yes:SetTextColor(Color(255, 255, 255))
        yes.DoClick = function()
            gui.OpenURL(VoteSys.Config.Url)
        end
        yes.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
            draw.RoundedBox(6, 4, 4, w-8, h-8, Color(51, 51, 51, 255))
        end
        yes.OnCursorEntered = function()
            yes.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
                draw.RoundedBox(6, 4, 4, w-8, h-8, Color(77, 77, 77))
            end
        end
        yes.OnCursorExited = function()
            yes.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
                draw.RoundedBox(6, 4, 4, w-8, h-8, Color(51, 51, 51, 255))
            end
        end
        local request = vgui.Create("DButton", frame)
        request:SetPos(600/2-50, 200)
        request:SetSize(100, 40)
        request:SetText(VoteSys.Language[8])
        request:SetFont("LinvFontRobo20")
        request:SetTextColor(Color(255, 255, 255))
        request.DoClick = function()
            net.Start("VoteSys")
            net.SendToServer()
            notif(VoteSys.Language[5])
        end
        request.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
            draw.RoundedBox(6, 4, 4, w-8, h-8, Color(51, 51, 51, 255))
        end
        request.OnCursorEntered = function()
            request.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
                draw.RoundedBox(6, 4, 4, w-8, h-8, Color(77, 77, 77))
            end
        end
        request.OnCursorExited = function()
            request.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
                draw.RoundedBox(6, 4, 4, w-8, h-8, Color(51, 51, 51, 255))
            end
        end
        local no = vgui.Create("DButton", frame)
        no:SetPos(600/2+100, 200)
        no:SetSize(100, 40)
        no:SetText(VoteSys.Language[9])
        no:SetFont("LinvFontRobo20")
        no:SetTextColor(Color(255, 255, 255))
        no.DoClick = function()
            frame:Close()
        end
        no.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
            draw.RoundedBox(6, 4, 4, w-8, h-8, Color(51, 51, 51, 255))
        end
        no.OnCursorEntered = function()
            no.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
                draw.RoundedBox(6, 4, 4, w-8, h-8, Color(77, 77, 77))
            end
        end
        no.OnCursorExited = function()
            no.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Color(113, 113, 113))
                draw.RoundedBox(6, 4, 4, w-8, h-8, Color(51, 51, 51, 255))
            end
        end
    end
end)

net.Receive("VoteSys", function()
    notif(VoteSys.Language[net.ReadInt(8)])
end)