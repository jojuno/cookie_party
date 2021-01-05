modifier_immolation = class({})

function modifier_immolation:IsHidden()
	return false
end

function modifier_immolation:OnCreated( kv )
    -- references
    self.immolation_damage = kv.immolation_damage
	self.immolation_range = kv.immolation_range
    self.immolation_interval = kv.immolation_interval
    self.outgoing_damage_percent = kv.outgoing_damage_percent
    
    -- Start interval
	self:StartIntervalThink( self.immolation_interval )
	self:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_immolation:OnIntervalThink()
    
    --burn enemies within range

    -- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.immolation_damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.immolation_range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_immolation:GetEffectName()
	return "particles/ogre_magi_arcana_ignite_burn_immolation.vpcf"
end

function modifier_immolation:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

