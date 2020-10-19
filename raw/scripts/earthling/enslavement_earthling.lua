-- earthling civ mod - Dremk - random chances to add a caged or chained sentient unit to the civ

local utils = require('utils')
local makeown = require('makeown')


-- from boltgun succubus mod - start
-- Erase the enemy links
local function clearEnemy(unit)
	hf = utils.binsearch(df.global.world.history.figures, unit.hist_figure_id, 'id')
	if not hf then return end
	for k, v in ipairs(hf.entity_links) do
		if df.histfig_entity_link_enemyst:is_instance(v) and
			(v.entity_id == df.global.ui.civ_id or v.entity_id == df.global.ui.group_id)
		then
			newLink = df.histfig_entity_link_former_prisonerst:new()
			newLink.entity_id = v.entity_id
			newLink.link_strength = v.link_strength
			hf.entity_links[k] = newLink
			v:delete()
		end
	end
	-- Make DF forget about the calculated enemies (ported from fix/loyaltycascade)
	if not (unit.enemy.enemy_status_slot == -1) then
		unit.enemy.enemy_status_slot = -1
	end
end
-- Takes down any hostility flags that makeown didn't handle
local function clearHostile(unit)
	--unit.cultural_identity = -1
	unit.flags1.marauder = false
	unit.flags1.active_invader = false
	unit.flags1.hidden_in_ambush = false
	unit.flags1.hidden_ambusher = false
	unit.flags1.invades = false
	unit.flags1.coward = false
	unit.flags1.invader_origin = false
	unit.flags2.underworld = false
	unit.flags2.visitor_uninvited = false
	unit.flags2.visitor = false
	unit.flags2.resident = false
	unit.flags2.calculated_nerves = false
	unit.flags2.calculated_bodyparts = false
	unit.invasion_id = -1
	unit.relationship_ids.GroupLeader = -1
	unit.relationship_ids.LastAttacker = -1
	unit.flags3.body_part_relsize_computed = false
	unit.flags3.body_temp_in_range = true
	unit.flags3.size_modifier_computed = false
	unit.flags3.compute_health = true
	unit.flags3.weight_computed = false
    unit.counters.soldier_mood_countdown = -1
    unit.counters.death_cause = -1
    unit.animal.population.region_x = -1
    unit.animal.population.region_y = -1
    unit.animal.population.unk_28 = -1
    unit.animal.population.population_idx = -1
    unit.animal.population.depth = -1
    unit.counters.soldier_mood_countdown = -1
    unit.counters.death_cause = -1
    unit.enemy.army_controller_id = -1
    unit.enemy.enemy_status_slot = 0
end
-- from boltgun succubus mod - end

local function clearMilitary(unit)
	unit.military.squad_id = -1
	unit.military.squad_position = -1
	unit.military.patrol_cooldown = 100000
	unit.enemy.unk_v40_sub3.controller = nil
end
local function convert_unit(unit)
	--makeown
	makeown.make_own(unit)
	--
	clearEnemy(unit)
	clearHostile(unit)
	--
	clearMilitary(unit)
	--
	--taming
	unit.flags1.tame = true
	unit.training_level = 7
	--add syndrome
	dfhack.run_script('modtools/add-syndrome', '-syndrome', 'enslaved', '-target', unit.id, '-skipImmunities')
	--
	print(unit.name.first_name..' has joined the ranks...')
end
local function check_conditions(unit)
	if unit ~= nil then
		if 
		(unit.flags1.chained or unit.flags1.caged) 
		and not unit.flags1.merchant 
		and not unit.flags1.diplomat 
		and not unit.flags1.forest 
		and dfhack.units.isAlive(unit) 
		and dfhack.units.isSane(unit) 
		and not dfhack.units.isDwarf(unit) 
		and not dfhack.units.isCitizen(unit) 
		and not dfhack.units.isTamable(unit) 
		and df.global.world.raws.creatures.all[unit.race].caste[unit.caste].flags.CAN_LEARN 
		and not df.global.world.raws.creatures.all[unit.race].caste[unit.caste].flags.SEMIMEGABEAST 
		and not df.global.world.raws.creatures.all[unit.race].caste[unit.caste].flags.MEGABEAST 
		then
			local wp = unit.status.current_soul.mental_attrs.WILLPOWER.value
			local prob_convert = math.max(0.01,math.min(1,1-wp/(wp+150)))
			if math.random()<=prob_convert then
				convert_unit(unit)
			end
		end
	end
end
local function scan_units_list()
	--df.global.world.units.all
	--df.global.world.units.active
	for _,unit in ipairs(df.global.world.units.active) do
		check_conditions(unit)
	end
end

if df.global.gamemode == df.game_mode.DWARF then
	scan_units_list()
end
