function get_slot_options(slot_data)
	Tracker:FindObjectForCode('opt_splasher').AcquiredCount = slot_data["splashers_goal"]
	print("Slot Data Splasher Goal OK")
	
	if slot_data["include_medals"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_speedrun")
		local stage = slot_data["include_medals"]
		if stage >= 5 then
			stage = 0
		end
		if obj then
			obj.CurrentStage = stage
		end
		print("Slot Data Speedrun Medals OK")
	end


    if slot_data["randomize_golden_splashers"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_gold_splasher")
		local state = slot_data["randomize_golden_splashers"]
		if state then
			if obj then
            	obj.CurrentStage = state
        	end
		end
        
		print("Slot Data Gold Splashers OK")
	end

	if slot_data["include_keys"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_ek")
		local stage = slot_data["include_keys"]
		if stage >= 3 then
			stage = 0
		end
		if obj then
			obj.CurrentStage = stage
		end
		print("Slot Data Entrance Keys OK")

		if slot_data["include_speedrun_keys"] ~= nil then
			local obj = Tracker:FindObjectForCode("opt_ek_speedrun")
			local state = slot_data["include_speedrun_keys"]
			if state then
				if obj then
					obj.CurrentStage = state
				end
			end
			print("Slot Data Speedrun Keys OK")
		end
	end
end

function splasher_req()
	local splasher_goal = Tracker:FindObjectForCode('opt_splasher').AcquiredCount
	local nb_splashers = Tracker:ProviderCountForCode("Splasher")
	if splasher_goal == nil then
		return false
	end

	return splasher_goal <= nb_splashers
end

function key(entrance, zone)
	local key_cond = Tracker:FindObjectForCode("opt_ek").CurrentStage

	if key_cond > 0 then
		if key_cond == 1 then --[[ zone keys ]]
			return Tracker:FindObjectForCode(zone).Active
		elseif key_cond == 2 then --[[ entrance keys ]]
			return Tracker:FindObjectForCode(entrance).Active
		end
	else
		return false
	end
end

function speed_key(entrance, zone)
	local key_cond = Tracker:FindObjectForCode("opt_ek").CurrentStage
	local speedkey_cond = Tracker:FindObjectForCode("opt_ek_speedrun").CurrentStage

	if key_cond > 0 and speedkey_cond == 1 then
		if key_cond == 1 then --[[ zone keys ]]
			return Tracker:FindObjectForCode(zone).Active
		elseif key_cond == 2 then --[[ entrance keys ]]
			return Tracker:FindObjectForCode(entrance).Active
		end
	else
		return false
	end
end