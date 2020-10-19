-- earthling civ mod - Dremk - to fix the exhaustion bug of the noexert creatures in a squad (gargoyle/necromancer/undead militia)

if df.global.gamemode == df.game_mode.DWARF then
	for _,unit in ipairs(df.global.world.units.active) do
		if unit ~= nil then
			if dfhack.units.isCitizen(unit) then
				if df.global.world.raws.creatures.all[unit.race].caste[unit.caste].flags.NOEXERT then
					if unit.counters2.exhaustion>0 then
						unit.counters2.exhaustion = 0
					end
				end
			end
		end
	end
end
