// -- // -- // -- // -- // -- // -- // -- //
// This addon can't work without Linventif Library : https://linv.dev/docs/#library
// Some configuration are only editable in Linventif Monitor : https://linv.dev/docs/#monitor
// If you have any problem with this addon please contact me on discord : https://linv.dev/discord
// -- // -- // -- // -- // -- // -- // -- //

// General Settings
LinvVote.Config.ForceLanguage = false // Force to use the sh_language.lua file
LinvVote.Config.Url = "https://top-serveurs.net/discord/vote/linventif" // The url of the vote page
LinvVote.Config.Token = "DMDBGYWSRF" // Your API token of your server (top-serveurs.net -> Your Servers -> Web API)

// Vote Settings
LinvVote.Config.Money = 25000 // How much money the player gets when he votes
LinvVote.Config.RefreshTime = 60 // Refresh time in seconds to check if the player has voted
LinvVote.Config.Cooldown = 120 // Cooldown in minutes between each vote

LinvVote.Config.ShowOnJoin = true // Show the vote menu when a player joins
LinvVote.Config.ShowVotes = true // Show the votes in the chat

LinvVote.Config.ShowVotesPanel = true // Show the left panel to insite the player to vote
LinvVote.Config.RemoveInVehicle = true // Remove the panel when the player is in a vehicle

LinvVote.Config.Commands = { // Commands that players can use to open the vote menu
    ["/vote"] = true,
    ["!vote"] = true,
    ["!v"] = true,
    ["/v"] = true
}

// NPC Settings
LinvVote.Config.NPC_Name = "Linventif Vote" // The name of the NPC
LinvVote.Config.NPC_Model = "models/Humans/Group01/Female_01.mdl" // The model of the NPC
LinvVote.Config.NPC_Height = 3000 // The position of the NPC name (Z Axis - Default: 3000)