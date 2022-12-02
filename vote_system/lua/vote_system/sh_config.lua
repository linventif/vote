VoteSys.Config = VoteSys.Config or {}

VoteSys.Config.Commands = {
    ["/vote"] = true,
    ["!vote"] = true,
    ["!v"] = true,
    ["/v"] = true
}

if SERVER then
    VoteSys.Config.Token = "5MLBLK5K1Q" // KFMOWQLRGQ
end

VoteSys.Config.Money = 10000
VoteSys.Config.RefreshTime = 30
VoteSys.Config.ShowVotes = true
VoteSys.Config.Language = "english" // english - french