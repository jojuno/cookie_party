modifier_cookie_eaten = class({})

function modifier_cookie_eaten:IsHidden()
	return false
end

function modifier_cookie_eaten:IsDebuff()
	return false
end

function modifier_cookie_eaten:IsStunDebuff()
	return false
end

function modifier_cookie_eaten:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_cookie_eaten:OnCreated( kv )
    if not IsServer() then return end
    self:SetStackCount( 0 )
end