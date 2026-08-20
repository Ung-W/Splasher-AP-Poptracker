local prog_pow = false
local prog_both = false

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

	if slot_data["randomize_powers"] ~= nil then
		prog_pow = false
		prog_both = false
		local state = slot_data["randomize_powers"]
		if state == 3 then
			prog_pow = true
			if slot_data["progressive_water"] == 0 then
				print("Powers are progressive and water is not progressive")
				prog_both = true
			end
		end
		print("Slot Data Progressive Settings OK")
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
	if prog_both then
		local progPower = Tracker:FindObjectForCode("ProgressivePower")
		if progPower.CurrentStage == 0 then
			progPower.CurrentStage = 2
		end
	end
end

function hasPollutedWater()
	local water_cond = Tracker:FindObjectForCode("Water").AcquiredCount
	local progWater_state = Tracker:FindObjectForCode("ProgressiveWater").CurrentStage

	return water_cond > 0 or progWater_state >= 1
end

function hasCleanWater()
	local water_cond = Tracker:FindObjectForCode("Water").AcquiredCount
	local progWater_state = Tracker:FindObjectForCode("ProgressiveWater").CurrentStage

	
	local sticky_cond = Tracker:FindObjectForCode("StickyPaint").AcquiredCount
	local bouncy_cond = Tracker:FindObjectForCode("BouncyPaint").AcquiredCount

	return water_cond > 0 or progWater_state >= 2 or (progWater_state == 1 and (sticky_cond > 0 or bouncy_cond > 0))
end

function hasSpeedWater()
	local water_cond = Tracker:FindObjectForCode("Water").AcquiredCount
	local progWater_state = Tracker:FindObjectForCode("ProgressiveWater").CurrentStage

	return water_cond > 0 or progWater_state == 3
end

function chkPower(water_state, sticky_state, bouncy_state)
	local sticky_chk = Tracker:FindObjectForCode("StickyPaint").AcquiredCount
	local bouncy_chk = Tracker:FindObjectForCode("BouncyPaint").AcquiredCount

	return water_state
		and sticky_chk >= sticky_state
		and bouncy_chk >= bouncy_state
end

function chkPowerProg(withProgW, withoutProgW)
	if prog_pow then
		local progPow_chk = Tracker:FindObjectForCode("ProgressivePower").AcquiredCount
		if prog_both then
			return progPow_chk >= withProgW
		end
		return progPow_chk >= withoutProgW
	end
	return false
end