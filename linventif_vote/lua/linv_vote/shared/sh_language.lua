// -- // -- // -- // -- // -- // -- // -- //
// This file is only for debug / force language
// If you want to add a language, please use resource localization
// More info on the documentation : https://linv.dev/docs/#language
// -- // -- // -- // -- // -- // -- // -- //

local lang = {
    ["thanks"] = "Merci d'avoir voté !",
    ["thanks_info1"] = "Nous vous remercions de votre soutien.",
    ["thanks_info2"] = "Vous allez bientôt recevoir {1} directement dans votre portefeuille.",
    ["thanks_info3"] = "Vous pouvez voter toutes les 2 heures.",
    ["claim"] = "Récupérer",
    ["vote"] = "VOTEZ",
    ["linv_vote"] = " Linventif Vote | ",
    ["ply_vote"] = "{1} à soutenu le serveur en votant est a reçu {2} !", // {1} : player name - {2} : reward amount
    ["reward_received"] = "Vous avez reçu {1} pour avoir voté !", // {1} : reward amount
}

// -- // -- // -- // -- // -- // -- // -- //
// Do not edit below this line
// -- // -- // -- // -- // -- // -- // -- //

function LinvVote:GetTrad(id, args)
    return LinvLib:GetTranslation(LinvVote.Config.ForceLanguage, LinvVote.Info.folder, id, lang[id] || id, args)
end