VoteSys.Config = VoteSys.Config or {}

if SERVER then
    VoteSys.Config.Token = "" // Your API token from the website
end

VoteSys.Config.Language = "french" // english - french
VoteSys.Config.Money = 25000 // How much money the player gets when he votes
VoteSys.Config.RefreshTime = 5 // Refresh time in minutes

VoteSys.Config.ShowOnJoin = true // Show the vote menu when a player joins
VoteSys.Config.ShowVotes = true // Show the votes in the middle top of the screen
VoteSys.Config.VoteSound = "UI/buttonclick.wav" // Sound played when a player votes (leave empty to disable)


VoteSys.Config.Url = "https://top-serveurs.net/garrys-mod/linventif" // The url of the vote page

VoteSys.Config.Commands = { // Commands that players can use to vote
    ["/vote"] = true,
    ["!vote"] = true,
    ["!v"] = true,
    ["/v"] = true
}