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
    ["linv_vote"] = "Linventif Vote | ",
    ["ply_vote"] = "{1} à soutenu le serveur en votant est a reçu {2} !", // {1} : player name - {2} : reward amount
    ["reward_received"] = "Merci de soutenir le serveur, vous avez recu {1}.", // {1} : reward amount
    ["already_vote"] = "Vous avez déjà voté récemment !",
    ["can_revote_in"] = "Vous pourrez re-voter dans {1}h{2} !", // {1} : hours - {2} : minutes
    ["already_in_list"] = "Vous êtes déja dans la liste d'attente.",
    ["added_to_list"] = "Vous avez étais ajouté a la liste d'attente, vous recevrez votre récompense dans maximum {1} minutes.", // {1} : minutes
    ["linvvote"] = "Linventif Vote",
    ["reward_money"] = "Récompense en argent",
    ["url"] = "URL de vote",
    ["url_desc"] = "L'url vers votre server, sur vote-serveur.",
    ["token"] = "Token de vote",
    ["token_desc"] = "top-serveurs.net -> Your Servers -> Web API",
    ["refresh_time"] = "Temps de rafraichissement",
    ["cooldown"] = "Cooldown entre chaque vote",
    ["cooldown_desc"] = "temps en minutes",
    ["commands"] = "Commandes de vote",
    ["reward_money_desc"] = "Montant de la récompense",
    ["refresh_time_desc"] = "Temps de rafrechisement en seconde",
    ["npc_model"] = "Modèle du NPC",
    ["npc_name"] = "Nom du NPC",
    ["height"] = "Hauteur du NPC",
    ["show_votes_panel"] = "Afficher le panneau de vote",
    ["remove_in_vehicle"] = "Enlever le panneau en véhicule",
    ["show_on_join"] = "Afficher le panneau au join",
    ["show_votes"] = "Afficher les votes dans le chat",
    ["npc_height"] = "Hauteur du NPC",
    ["panel_pos_w"] = "Position X du panel",
    ["panel_pos_h"] = "Position Y du panel",
}

// -- // -- // -- // -- // -- // -- // -- //
// Do not edit below this line
// -- // -- // -- // -- // -- // -- // -- //

function LinvVote:GetTrad(id, args)
    return LinvLib:GetTranslation(LinvVote.Config.ForceLanguage, LinvVote.Info.folder, id, lang[id] || id, args)
end