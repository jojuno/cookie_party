modifier_absorb = class({})

LinkLuaModifier("modifier_extra_health", "libraries/modifiers/modifier_extra_health", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Initializations
function modifier_absorb:IsHidden()
    return false
end

function modifier_absorb:OnCreated( kv )
    if not IsServer() then return end
    self:SetStackCount( 0 )
end

function modifier_absorb:OnRefresh( kv )

    self:SetStackCount( self:GetStackCount() + 1 )
    --apply extra health modifier based on stack count
    --must destroy modifier to reapply it
    self:GetParent():RemoveModifierByName("modifier_extra_health")
    --add ability for buff to show up on the buff bar
    --must use "GetModifierEXTRAHealthBonus" for creeps
    --heals automatically for a portion of the increase
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_extra_health", { extraHealth = self:GetStackCount() * 50 })
    --self:GetParent():Heal(50, nil)
    self:GetParent():SetModelScale(self:GetParent():GetModelScale() + 0.1)

    --add score to owner
    --only add score during cookie party
    if GameMode.gameActive then
        self:GetParent():GetOwnerEntity().score = self:GetParent():GetOwnerEntity().score + 1
    end
end