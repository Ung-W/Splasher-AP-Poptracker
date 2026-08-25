function get_slot_options(slot_data)
	Tracker:FindObjectForCode('opt_splasher').AcquiredCount = slot_data["splashers_goal"]
	print("Slot Data Splasher Goal OK")
	
	if slot_data["include_medals"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_speedrun")
		local stage = slot_data["include_medals"]
		
		if stage >= 5 then
			stage = 0
		end
		obj.CurrentStage = stage

		print("Slot Data Speedrun Medals OK")
	end

    if slot_data["randomize_golden_splashers"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_gold_splasher")
		local state = slot_data["randomize_golden_splashers"]
		
		if state then
            	obj.CurrentStage = state
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
				obj.CurrentStage = state
			end

			print("Slot Data Speedrun Keys OK")
		end
	end

	if slot_data["randomize_powers"] ~= nil then
		local state = slot_data["randomize_powers"]

		if state == 3 then
			local obj = Tracker:FindObjectForCode("opt_prog_powers")
			obj.CurrentStage = 1
		end

		print("Slot Data Progressive Powers OK")
	end

	if slot_data["progressive_water"] ~= nil then
		local state = slot_data["progressive_water"]

		if state then
			local obj = Tracker:FindObjectForCode("opt_prog_water")
			obj.CurrentStage = state
		end
		
		print("Slot Data Progressive Water OK")
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
		return true
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
		return true
	end
end

function waterIcon()
	local progWater = Tracker:FindObjectForCode("ProgressiveWater")
	progWater.CurrentStage = 2
end

function powerIcon()
	local obj = Tracker:FindObjectForCode("opt_prog_water")
	if obj.CurrentStage == 0 then
		local progPower = Tracker:FindObjectForCode("ProgressivePower")
		if progPower.CurrentStage == 0 then
			progPower.CurrentStage = 2
		end
	end
end

function hasNoWater()
	return true
end

function hasPollutedWater()
	local progWater_state = Tracker:FindObjectForCode("ProgressiveWater").CurrentStage

	return progWater_state >= 1
end

function hasCleanWater()
	local progWater_state = Tracker:FindObjectForCode("ProgressiveWater").CurrentStage

	local sticky_cond = Tracker:FindObjectForCode("StickyPaint").CurrentStage
	local bouncy_cond = Tracker:FindObjectForCode("BouncyPaint").CurrentStage

	return progWater_state >= 2
end

function hasSpeedWater()
	local progWater_state = Tracker:FindObjectForCode("ProgressiveWater").CurrentStage

	return progWater_state == 3
end

local water_checks = {
	[0] = hasNoWater,
	[1] = hasPollutedWater,
	[2] = hasCleanWater,
	[3] = hasSpeedWater
}

function chkPower(water_state, sticky_state, bouncy_state)
	water_state = tonumber(water_state)
	sticky_state = tonumber(sticky_state)
	bouncy_state = tonumber(bouncy_state)

    local water_check = water_checks[water_state]

	if not water_check then
		print("Water check Failed")
        return false
    end

	local water_res = water_check()

	local sticky_chk = Tracker:FindObjectForCode("StickyPaint").CurrentStage
	local bouncy_chk = Tracker:FindObjectForCode("BouncyPaint").CurrentStage

	return water_res
		and sticky_chk >= sticky_state
		and bouncy_chk >= bouncy_state
end

function chkPowerProg(progReq)
	progReq = tonumber(progReq)

	local prog_chk = Tracker:FindObjectForCode("ProgressivePower").CurrentStage
	
	return prog_chk >= progReq
end

function chkPowerDebug(water_state, sticky_state, bouncy_state)
	water_state = tonumber(water_state)
	sticky_state = tonumber(sticky_state)
	bouncy_state = tonumber(bouncy_state)

    local water_check = water_checks[water_state]

	if not water_check then
		print("Water check Failed")
        return false
    end

	local water_res = water_check()

	print("water_state = ", water_state, "| water_res = ", water_res)

	local sticky_chk = Tracker:FindObjectForCode("StickyPaint").CurrentStage
	local bouncy_chk = Tracker:FindObjectForCode("BouncyPaint").CurrentStage

	print("sticky_state = ", sticky_state, "| sticky_chk = ", sticky_chk)
	
	print("bouncy_state = ", bouncy_state, "| bouncy_chk = ", bouncy_chk)

	return water_res
		and sticky_chk >= sticky_state
		and bouncy_chk >= bouncy_state
end