function get_slot_options(slot_data)
	Tracker:FindObjectForCode('opt_splasher').AcquiredCount = slot_data["splashers_goal"]
	
    -- to implement this -> visibility rules
	--[[ if slot_data["include_medals"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_speedrun")
		local stage = slot_data["include_medals"]
		if stage >= 4 then
			stage = 0
		end
		if obj then
			obj.CurrentStage = stage
		end

    -- to implement this -> visibility rules
    --[[ if slot_data["randomize_golden_splashers"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_gold_splasher")
		local state = slot_data["randomize_golden_splashers"]
		if state then
			state = 0
        else
            state = 1
		end
        if obj then
            obj.CurrentStage = state
        end ]]
end

function splasher_req()
	local splasher_goal = Tracker:FindObjectForCode('opt_splasher').AcquiredCount
	local nb_splashers = Tracker:ProviderCountForCode("Splasher")
	if splasher_goal == nil then
		return false
	end

	return splasher_goal <= nb_splashers
end