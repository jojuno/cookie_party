morty_cookie_blast = class({})

--load modifiers
LinkLuaModifier("modifier_knockback_custom", "libraries/modifiers/modifier_knockback_custom", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_stunned", "libraries/modifiers/modifier_stunned.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("mortimer_kisses_thinker_modifier", "custom_abilities/mortimer_kisses_base", LUA_MODIFIER_MOTION_NONE)

--cookie a far distance
--blast cookies in a circle
--none-tracking projectiles
--no target
--targets enemy teams

function morty_cookie_blast:OnSpellStart()
    self:GetCaster():EmitSound("mortimerCookieBlast")

    --to randomize cookie directions
    math.randomseed(Time())

    local caster = self:GetCaster()
    self.caster = caster
    
    --local direction = caster:GetForwardVector()
    local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
    local numberOfCookies = self:GetSpecialValueFor( "number_of_cookies" )
    self.projectile_speed = projectile_speed
    print("[morty_cookie_blast:OnSpellStart()] called")
    --1
    --print(direction.x)
    --0
    --print(direction.y)
    --0
    --print(direction.z)

    --local counter = 0
    --[[Timers:CreateTimer("cookieBlastTimer", {
        useGameTime = false,
        endTime = 0,
        callback = function()]]
            --[[counter = counter + 1
            if counter == 4 then
                return nil
            else]]
                
                for cookieIndex = 1, numberOfCookies do
                    --create six projectiles in random directions
                    local anglerad = math.random(360)
                    --flip side for half of the projectiles
                    local direction
                    if cookieIndex % 2 == 0 then
                        --forward
                        direction = Vector(caster:GetForwardVector().x + math.cos(anglerad), caster:GetForwardVector().y + math.sin(anglerad), caster:GetForwardVector().z):Normalized()
                    else
                        --backward
                        direction = Vector(-(caster:GetForwardVector().x + math.cos(anglerad)), -(caster:GetForwardVector().y + math.sin(anglerad)), caster:GetForwardVector().z):Normalized()
                    end
            
                    info = 
                    { 
                        Ability = self,
                        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
                        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
                        vSpawnOrigin = caster:GetAbsOrigin(),
                        fDistance = 3000,
                        fStartRadius = 100,
                        fEndRadius = 100,
                        Source = caster,
                        bHasFrontalCone = true,
                
                        --bReplaceExisting = false,
                        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                        fExpireTime = GameRules:GetGameTime() + 10.0,
                        bDeleteOnHit = true,
                        --vVelocity = Vector(direction.x +  radius*math.cos(anglerad * i), direction.y + radius*math.sin(anglerad * i), direction.z) * self.projectile_speed, --apply 60 degrees space for each cookie
                        vVelocity = direction * projectile_speed,
                        bProvidesVision = false,
                        iVisionRadius = 0,
                        iVisionTeamNumber = caster:GetTeamNumber()
                    }
                    projectile = ProjectileManager:CreateLinearProjectile(info)
                end
                --return 1
            --end
        --end
      --})


    --[[------------------------------
    -- Projectile 1
    -- Straight
    ------------------------------

    local info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,

        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        --vVelocity = Vector(direction.x +  radius*math.cos(anglerad * i), direction.y + radius*math.sin(anglerad * i), direction.z) * self.projectile_speed, --apply 60 degrees space for each cookie
        vVelocity = Vector(direction.x, direction.y, direction.z) * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)

    ------------------------------
    -- Projectile 2
    -- Behind
    ------------------------------
    info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,

        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        --vVelocity = Vector(direction.x +  radius*math.cos(anglerad * i), direction.y + radius*math.sin(anglerad * i), direction.z) * self.projectile_speed, --apply 60 degrees space for each cookie
        vVelocity = Vector(-direction.x, -direction.y, direction.z) * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)

    ---------------------
    -- Projectile 3
    -- 60 degrees up
    ---------------------
    local anglerad = math.rad(60)
    print("[morty_cookie_blast:OnSpellStart()] x = " .. direction.x+math.cos(anglerad * 2))
    print("[morty_cookie_blast:OnSpellStart()] y = " .. direction.y+math.sin(anglerad * 2))

    --normalize the direction vector
    --direction = forward vector
    if (direction.x > 0 and direction.y > 0) then 
        direction2 = Vector(direction.x + math.cos(anglerad), direction.y + math.sin(anglerad), direction.z)
    elseif (direction.x < 0 and direction.y > 0) then
        --pi + -80 = 100
        direction2 = Vector(direction.x + math.cos(anglerad + math.pi), direction.y + math.sin(anglerad + math.pi), direction.z)
    elseif (direction.x < 0 and direction.y < 0) then
        direction2 = Vector(direction.x + math.cos(anglerad + math.pi), direction.y + math.sin(anglerad + math.pi), direction.z)
    else
        direction2 = Vector(direction.x + math.cos(anglerad + 2*math.pi), direction.y + math.sin(anglerad + 2*math.pi), direction.z)
    end
    direction2 = direction2:Normalized()
    info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,

        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        --vVelocity = Vector(direction.x +  radius*math.cos(anglerad * i), direction.y + radius*math.sin(anglerad * i), direction.z) * self.projectile_speed, --apply 60 degrees space for each cookie
        
        vVelocity = direction2 * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
    ---------------------
    -- Projectile 4
    -- 240 degrees up
    ---------------------
    if (direction.x > 0 and direction.y > 0) then 
        direction3 = Vector(-(direction.x + math.cos(anglerad)), -(direction.y + math.sin(anglerad)), direction.z)
    elseif (direction.x < 0 and direction.y > 0) then
        --pi + -80 = 100
        direction3 = Vector(-(direction.x + math.cos(anglerad + math.pi)), -(direction.y + math.sin(anglerad + math.pi)), direction.z)
    elseif (direction.x < 0 and direction.y < 0) then
        direction3 = Vector(-(direction.x + math.cos(anglerad + math.pi)), -(direction.y + math.sin(anglerad + math.pi)), direction.z)
    else
        direction3 = Vector(-(direction.x + math.cos(anglerad + 2*math.pi)), -(direction.y + math.sin(anglerad + 2*math.pi)), direction.z)
    end
    direction3 = direction3:Normalized()
    info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,

        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        vVelocity = direction3 * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
    ---------------------
    -- Projectile 5
    -- 120 degrees up
    ---------------------
    if (direction.x > 0 and direction.y > 0) then 
        direction4 = Vector(direction.x + math.cos(anglerad), direction.y + math.sin(anglerad), direction.z)
    elseif (direction.x < 0 and direction.y > 0) then
        --pi + -80 = 100
        direction4 = Vector(direction.x + math.cos(anglerad + math.pi), direction.y + math.sin(anglerad + math.pi), direction.z)
    elseif (direction.x < 0 and direction.y < 0) then
        direction4 = Vector(direction.x + math.cos(anglerad + math.pi), direction.y + math.sin(anglerad + math.pi), direction.z)
    else
        direction4 = Vector(direction.x + math.cos(anglerad + 2*math.pi), direction.y + math.sin(anglerad + 2*math.pi), direction.z)
    end
    direction4 = direction4:Normalized()
    info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,

        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        vVelocity = direction4 * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
    
    --[[info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,
        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        vVelocity = Vector(-(direction.x+math.cos(anglerad * 2)), -(direction.y+math.sin(anglerad * 2)), direction.z) * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
    info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,

        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        vVelocity = Vector(direction.x+math.cos(anglerad * 4), direction.y+math.sin(anglerad * 4), direction.z) * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
    info = 
    { 
        Ability = self,
        EffectName = "particles/hero_snapfire_cookie_projectile_linear.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = caster,
        bHasFrontalCone = true,

        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        --flip the sign on the x and y value to flip the direction
        vVelocity = Vector(-(direction.x+math.cos(anglerad * 4)), -(direction.y+math.sin(anglerad * 4)), direction.z) * projectile_speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)]]
end

--stun friends of targets
--leave a kiss that hurts target's team

--jump really far, out of the stage
function morty_cookie_blast:OnProjectileHit(hTarget, vLocation)
    print("[morty_cookie_blast:OnProjectileHit(hTarget, vLocation)] called")
    PrintTable(hTarget)
    --don't call the function if the target hit is the caster
    if hTarget == self.caster then
        --do nothing
        return false
    elseif hTarget ~= nil then
        -- load data
        local duration = self:GetSpecialValueFor( "jump_duration" )
        local height = self:GetSpecialValueFor( "jump_height" )
        local distance = self:GetSpecialValueFor( "jump_horizontal_distance" )
        local stun = self:GetSpecialValueFor( "impact_stun_duration" )
        local damage = self:GetSpecialValueFor( "impact_damage" )
        local radius = self:GetSpecialValueFor( "impact_radius" )

        --jumping motion
        --hTarget even though it didn't hit anything
        local knockback = hTarget:AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_knockback_custom", -- modifier name
            {
                distance = distance,
                height = height,
                duration = duration,
                direction_x = hTarget:GetForwardVector().x,
                direction_y = hTarget:GetForwardVector().y,
                IsStun = true,
            } -- kv
        )

        -- on landing
        local callback = function()
            print("[cookie_base:OnProjectileHit] callback called")
            -- precache damage
            local damageTable = {
                -- victim = target,
                attacker = self:GetCaster(),
                damage = damage,
                damage_type = self:GetAbilityDamageType(),
                ability = self, --Optional.
            }

            -- find enemies
            local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(),	-- int, your team number
                hTarget:GetOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                0,	-- int, flag filter
                0,	-- int, order filter
                false	-- bool, can grow cache
            )

            --stun target's friends; not the target itself
            for _,enemy in pairs(enemies) do
                if enemy == hTarget then
                    --nothing
                else
                    print("[cookie_base:OnProjectileHit] enemy found")
                    -- apply damage
                    damageTable.victim = enemy
                    ApplyDamage(damageTable)

                    -- stun
                    enemy:AddNewModifier(
                        self:GetCaster(), -- player source
                        self, -- ability source
                        "modifier_stunned", -- modifier name
                        { duration = stun } -- kv
                    )
                end
            end

            -- destroy trees
            GridNav:DestroyTreesAroundPoint( hTarget:GetOrigin(), radius, true )

            -- play effects
            -- cookie landing
            self:PlayEffects3( hTarget, radius )
        end
        knockback:SetEndCallback( callback )
        --destroy projectile
        return true
    end
end





--------------------------------------------------------------------------------
function morty_cookie_blast:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function morty_cookie_blast:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf"
	local sound_target = "Hero_Snapfire.FeedCookie.Consume"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, target )

	-- Create Sound
	EmitSoundOn( sound_target, target )

	return effect_cast
end

function morty_cookie_blast:PlayEffects3( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf"
	local sound_location = "Hero_Snapfire.FeedCookie.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_location, target )
end

--------------------------------------------------------------------------------
function morty_cookie_blast:PlayEffectsKisses( loc, owner )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf"
	local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, owner )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, owner )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, owner )
end


--------------------------------------------------------------------------------
function morty_cookie_blast:PlayEffectsCalldown( owner )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, owner, owner:GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, owner:GetOrigin() )
    --ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius*(self.max_travel/time) ) )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 500, 0, -500*(2/time) ) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time, 0, 0 ) )
end