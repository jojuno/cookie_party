modifier_set_min_move_speed = class({})

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_set_min_move_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}
	return funcs
end

function modifier_set_min_move_speed:GetModifierMoveSpeed_AbsoluteMin()
	return 0
end
