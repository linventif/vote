include("shared.lua")

function ENT:Draw()
	self:DrawModel()
    LinvLib:DrawNPCText(self, LinvVote.Config.NPC_Name, LinvVote.Config.NPC_Height)
end