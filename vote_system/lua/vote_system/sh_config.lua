VoteSys.Config = VoteSys.Config or {}

if SERVER then
    VoteSys.Config.Token = "DMDBGYWSRF" // Your API token from the website
end

VoteSys.Config.Language = "french" // english - french
VoteSys.Config.Money = 25000 // How much money the player gets when he votes
VoteSys.Config.RefreshTime = 5 // Refresh time in minutes

VoteSys.Config.ShowOnJoin = true // Show the vote menu when a player joins
VoteSys.Config.ShowVotes = true // Show the votes in the middle top of the screen
VoteSys.Config.VoteSound = "UI/buttonclick.wav" // Sound played when a player votes (leave empty to disable)

VoteSys.Config.VotePanel = true // Enable the vote panel (to encourage players to vote)
VoteSys.Config.VotePanelPos = "right" // Position of the vote panel (left or right)

VoteSys.Config.Url = "https://top-serveurs.net/discord/vote/linventif" // The url of the vote page

VoteSys.Config.Commands = { // Commands that players can use to vote
    ["/vote"] = true,
    ["!vote"] = true,
    ["!v"] = true,
    ["/v"] = true
}

VoteSys.Config.UI = { // Change the UI of the vote menu
    ["Background"] = Color(51, 51, 51, 255), // Color of the background
    ["Border"] = Color(113, 113, 113), // Color of the border
    ["ButtonHover"] = Color(77, 77, 77), // Color of the button when the player hovers over it
    ["TextColor"] = Color(255, 255, 255), // Color of the text
    ["ChatName"] = Color(204, 40, 103) // Color of the addon name in the chat
}