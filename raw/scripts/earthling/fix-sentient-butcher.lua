-- allow non-citizen sentients to be butchered again
-- author burrito25man
-- special thanks to expwnent for the bulk of his code, Atomic Chicken for his !!SCIENCE!!, and Nilsou for pointing me in the right direction
-- as well as Putnam and Fleeting Frames for guidance :D


local usage = [====[

fix-sentient-butcher
===============================
This tool fixes a current (44.02) bug that makes sentient creatures unbutcherable in fortress
mode even with correct ethics. In adventure mode, it allows butchering of sentients that aren't
part of your current civ. Elf cakes anyone?

]====]


local eventful = require 'plugins.eventful'
local utils = require 'utils'

eventful.enableEvent(eventful.eventType.UNLOAD,1)
eventful.onUnload.fixcannibal = function()
end

eventful.enableEvent(eventful.eventType.UNIT_DEATH, 1) --requires iterating through all units
eventful.onUnitDeath.fixcannibal = function(unitId)
 local unit = df.unit.find(unitId)
     if not unit then
       return
     end

corpses = {}
	 
 local entsrc = df.historical_entity.find(df.global.ui.civ_id)
 local entity = df.historical_entity.find(unit.civ_id)
  if entity ~= entsrc then
	
	
	 for _,corpses in ipairs(df.global.world.items.other.ANY_CORPSE) do
	 if corpses.unit_id == unit.id then
	 
	 
		if corpses.flags.dead_dwarf == true then
		   corpses.flags.dead_dwarf = false
				print ('dead_dwarf flag of')
				print(dfhack.TranslateName(dfhack.units.getVisibleName(unit)))
				print('was set to false.')
		end
		
		
	 end
	 
	 
 end
	
	
  end

end


validArgs = validArgs

local args = utils.processArgs({...}, validArgs)

if args.clear then
end

if args.help then
 print(usage)
 return
end

if args.item then

 local itemType
 for _,itemdef in ipairs(df.global.world.raws.itemdefs.all) do
  if itemdef.id == args.item then
   itemType = itemdef.id
   break
  end
 end
 if not itemType then
  error ('Invalid item type: ' .. args.item)
 end
 items[itemType] = true
end
if args.entity then
 local success
 for _,entity in ipairs(df.global.world.entities.all) do
  if entity.entity_raw.code == args.entity then
   success = true
   break
  end
 end
 if not success then
  error 'Invalid entity'
 end
 entities[args.entity] = true
end