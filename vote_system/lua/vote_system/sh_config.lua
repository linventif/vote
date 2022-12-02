VoteSys.Config = VoteSys.Config or {}

VoteSys.Config.Commands = {
    ["/vote"] = true,
    ["!vote"] = true,
    ["!v"] = true,
    ["/v"] = true
}

if SERVER then
    VoteSys.Config.Token = "" // Your token from the website
end

VoteSys.Config.Money = 10000
VoteSys.Config.RefreshTime = 30
VoteSys.Config.ShowVotes = true
VoteSys.Config.Language = "french" // english - french

VoteSys.Config.Url = "https://top-serveurs.net/discord/vote/linventif"