function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
	state.Buff.sleep = buffactive.sleep or false
	state.Buff.Stoneskin =  buffactive.stoneskin or false
	state.Buff.doom = buffactive.doom or false

	include('Organizer-lib.lua')
	include('Mote-TreasureHunter')
	
	lockstyleset = 82
	
end

function user_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Mid', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Mid', 'Acc')
    state.CastingMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Sphere')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT')
    state.MagicalDefenseMode:options('MDT')
	
	send_command('bind ^= gs c cycle treasuremode')

	--state.Auto_Kite = M(false, 'Auto_Kite')  
	Haste = 0
	DW_needed = 0  
	DW = false  
	--moving = false  
	update_combat_form()  
	determine_haste_group()  
	
	select_default_macro_book()
    set_lockstyle()

end 

function user_unload()
end

function init_gear_sets()

	Cichol_DA = {name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	Cichol_STR = {name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
	Cichol_VIT = {name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}}
	
	Valorous_body = {name="Valorous Mail", augments={'Accuracy+30','"Dbl.Atk."+4',}}
	Valorous_mask = {name="Valorous Mask", augments={'Weapon skill damage +3%','STR+15','Accuracy+15','Attack+13',}}
	Valorous_body_crit = {name="Valorous Mail", augments={'Accuracy+18','Crit. hit damage +3%','STR+10',}}
	Valorous_legs_crit = {name="Valor. Hose", augments={'Crit. hit damage +2%','STR+10','Accuracy+11',}}
	Valorous_greaves_crit = {name="Valorous Greaves", augments={'Accuracy+18','Crit. hit damage +2%','STR+14','Attack+7',}}
	
	Ody_legs_VIT = {name="Odyssean Cuisses", augments={'Weapon skill damage +4%','VIT+15','Attack+3',}}
	Ody_legs_STR = {name="Odyssean Cuisses", augments={'Attack+8','Weapon skill damage +4%','STR+10','Accuracy+15',}}
	Ody_hands_STR = {name="Odyssean Gauntlets", augments={'Accuracy+9','Weapon skill damage +3%','STR+14',}}
	Ody_hands_VIT = {name="Odyssean Gauntlets", augments={'Accuracy+29','Weapon skill damage +4%','VIT+13',}}
	
	sets.TreasureHunter = {
		head="Wh. Rarab Cap +1",
		hands={ name="Valorous Mitts", augments={'STR+5','Mag. Acc.+17','"Treasure Hunter"+1','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
		legs={ name="Odyssean Cuisses", augments={'MND+10','"Treasure Hunter"+1','Accuracy+12 Attack+12',}},
		waist="Chaac Belt",
	}
	
	-- Sets to apply to arbitrary JAs
	sets.precast.JA['Berserk'] = {body="Pumm. Lorica +2", feet={ name="Agoge Calligae", augments={'Enhances "Tomahawk" effect',}}, back=Cichol_DA,}
	sets.precast.JA['Aggressor'] = {head="Pumm. Mask +1", body={ name="Agoge Lorica +3", augments={'Enhances "Aggressive Aim" effect',}},}
	sets.precast.JA['Warcry'] = {head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},}
	sets.precast.JA['Mighty Strikes'] = {hands={ name="Agoge Mufflers", augments={'Enhances "Mighty Strikes" effect',}},}
	
	-- Weaponskill sets
	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body="Pumm. Lorica +2",
		hands=Ody_hands_STR,
		legs=Ody_legs_STR,
		feet="Sulev. Leggings +2",
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Cichol_STR,
	}
	
	-- Great Axe weaponskill sets
	
	sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS, {})
	sets.precast.WS['King\'s Justice'] = set_combine(sets.precast.WS, {})
	sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {})
	
	sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {
		ammo="Yetshila +1",
		head="Flam. Zucchetto +2",
		body="Hjarrandi Breast.",
		hands="Flam. Manopolas +2",
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		left_ring="Begrudging Ring",
		back=Cichol_DA,
	})
	
	sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {
		hands=Ody_hands_VIT,
		legs=Ody_legs_VIT,
		back=Cichol_VIT,
	})
	
	sets.precast.WS['Upheaval'].HighTp = sets.precast.WS['Upheaval']
	
	sets.precast.WS['Upheaval'].MightyStrikes = set_combine(sets.precast.WS['Upheaval'], {
		body=Valorous_body_crit,
		legs=Valorous_legs_crit,
		feet=Valorous_greaves_crit,
	})
	
	sets.precast.WS['Shield Break'] = set_combine(sets.precast.WS, {
		ammo="Pemphredo Tathlum",
		head="Flam. Zucchetto +2",
		body="Flamma Korazin +2",
		hands="Flam. Manopolas +2",
		legs="Flamma Dirs +2",
		feet="Flam. Gambieras +2",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	})
																	
	sets.precast.WS['Armor Break'] = sets.precast.WS['Shield Break']
	sets.precast.WS['Weapon Break'] = sets.precast.WS['Shield Break']
	sets.precast.WS['Full Break'] = sets.precast.WS['Shield Break']
	
	-- Axe weaponskill sets
	-- Great Sword weaponskill sets
	
	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Flam. Zucchetto +2",
		body="Flamma Korazin +2",
		hands="Sulev. Gauntlets +2",
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Cessance Earring",
		back=Cichol_DA,
	})
	
	sets.precast.WS['Resolution'].MightyStrikes = set_combine(sets.precast.WS['Resolution'], {
		body=Valorous_body_crit,
		legs=Valorous_legs_crit,
		feet=Valorous_greaves_crit,
	})
	
	-- Polearm weaponskills
	
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
		body="Hjarrandi Breast.",
		hands="Flam. Manopolas +2",
	})
	
	sets.precast.WS['Impulse Drive'].HighTp = set_combine(sets.precast.WS, {})
	
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Flam. Zucchetto +2",
		body="Flamma Korazin +2",
		hands="Sulev. Gauntlets +2",
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Cessance Earring",
		back=Cichol_DA,
	})
	
	sets.precast.WS['Stardiver'].ShiningOne = set_combine(sets.precast.WS, {
		ammo="Yetshila +1",
		head="Flam. Zucchetto +2",
		body="Hjarrandi Breast.",
		hands="Flam. Manopolas +2",
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Cessance Earring",
		left_ring="Begrudging Ring",
		back=Cichol_DA,
	})
	
	-- Sword weaponskill sets
	
	-- Defensive sets
	sets.defense.PDT = {
		ammo="Staunch Tathlum +1",
		head="Hjarrandi Helm",
		body="Hjarrandi Breast.",
		hands="Sulev. Gauntlets +2",
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist="Tempus Fugit",
		left_ear="Cessance Earring",
		right_ear="Brutal Earring",
		left_ring="Moonlight Ring",
		right_ring="Niqmaddu Ring",
		back=Cichol_DA,
	}
	
	-- Idle sets
	
	sets.Idle = {}
	sets.Idle.Town = {}
	sets.Kiting = {feet="Hermes' Sandals"}
	
	-- Engaged sets
	
	sets.engaged = {
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Agoge Lorica +3",
		hands="Sulev. Gauntlets +2",
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Cessance Earring",
		right_ear="Brutal Earring",
		left_ring="Moonlight Ring",
		right_ring="Niqmaddu Ring",
		back=Cichol_DA,
	}
	
	sets.engaged.Mid = {}
	sets.engaged.Acc = {}
	
	sets.engaged['FighterRoll'] = set_combine(sets.engaged, {body="Hjarrandi Breast.", right_ear="Dedition Earring",})
	sets.engaged.Mid['FighterRoll'] = set_combine(sets.engaged['FighterRoll'], {right_ear="Telos Earring",})
	sets.engaged.Acc['FighterRoll'] = set_combine(sets.engaged['FighterRoll'].Mid, {})
	
	
	sets.engaged['GreatAxe'] = set_combine(sets.engaged, {})
	sets.engaged['GreatAxe'].Mid = set_combine(sets.engaged['GreatAxe'], {})
	sets.engaged['GreatAxe'].Acc = set_combine(sets.engaged['GreatAxe'].Mid, {})
	
	sets.engaged['GreatAxe']['FighterRoll'] = set_combine(sets.engaged['FighterRoll'], {body="Hjarrandi Breast.", right_ear="Dedition Earring",})
	sets.engaged['GreatAxe'].Mid['FighterRoll'] = set_combine(sets.engaged['GreatAxe']['FighterRoll'], {right_ear="Telos Earring",})
	sets.engaged['GreatAxe'].Acc['FighterRoll'] = set_combine(sets.engaged['GreatAxe'].Mid['FighterRoll'], {})
	
	sets.engaged['Polearm'] = set_combine(sets.engaged, {})
	sets.engaged['Polearm'].Mid = set_combine(sets.engaged['Polearm'], {})
	sets.engaged['Polearm'].Acc = set_combine(sets.engaged['Polearm'].Acc, {})
	
	sets.engaged['Polearm']['FighterRoll'] = set_combine(sets.engaged['FighterRoll'], {body="Hjarrandi Breast.", right_ear="Dedition Earring",})
	sets.engaged['Polearm'].Mid['FighterRoll'] = set_combine(sets.engaged['Polearm']['FighterRoll'], {right_ear="Telos Earring",})
	sets.engaged['Polearm'].Acc['FighterRoll'] = set_combine(sets.engaged['Polearm'].Acc['FighterRoll'], {})
	
	-- other sets
	
	sets.TreasureHunter = {
		head="Wh. Rarab Cap +1",
		hands=Valorous_hands_TH,
		legs=Odyssean_legs_TH,
		waist="Chaac Belt",
	}
	
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if player.equipment.main == "Chango" then
		TPBonus = 500
	elseif player.equipment.main == "Lycurgos" then
		TPBonus = 450
	else
		TPBonus = 0
	end

	if buffactive['Warcry'] then
		TPBonus = TPBonus + 700
	end

	if player.equipment.left_ear == 'Moonshade Earring' or player.equipment.right_ear == 'Moonshade Earring' then
		TPBonus = TPBonus + 250
	end

	--if spell.type == "WeaponSkill" then
		--if spell.english == "Upheaval" then
			--TPBonus = TPBonus + 250
			--CurrentTP = player.tp + TPBonus
			--send_command("@input /echo TP Bonus " .. TPBonus .. " CurrentTP " .. CurrentTP)
			--if buffactive["Mighty Strikes"] then
				--equip(sets.precast.WS['Upheaval'].MightyStrikes)
				--send_command("@input /echo Upheaval Crit Set")
			--if CurrentTP > 1500 then
				--equip(sets.precast.WS['Upheaval'].HighTp)
				--send_command("@input /echo Upheaval WSD Set")
			--else
				--equip(sets.precast.WS['Upheaval'])
				--send_command("@input /echo Upheaval DA Set")
			--end
		--elseif spell.english == "Impulse Drive" then
			--TPBonus = TPBonus + 250
			--CurrentTP = player.tp + TPBonus
			--if buffactive['Blood Rage'] then
				--equip(sets.precast.WS['Impulse Drive'].HighTp)
			--elseif CurrentTP > 1500 then
				--equip(sets.precast.WS['Impulse Drive'].HighTp)
			--else
				--equip(sets.precast.WS['Impulse Drive'])
			--end
		--end	
	--end
 
	if spell.english == 'Upheaval' and (player.tp > 1750) then
		equipSet = sets.precast.WS['Upheaval'].HighTp
		equip(equipSet)
	elseif spell.english == "King's Justice" and (player.tp > 1750) then
		equipSet = sets.precast.WS['King\s Justice'].HighTp
		equip(equipSet)
	elseif spell.english and (player.tp > 1750 or buffactive['Blood Rage']) then
		equipSet = sets.precast.WS['Impulse Drive'].HighTp
		equip(equipSet)
	end

end

function get_custom_wsmode(spell, spellMap, default_wsmode)
	local wsmode
		
		if player.equipment.main == 'Shining One' then
			wsmode = 'ShiningOne'
		end
		
		if buffactive['Mighty Strikes'] then
			wsmode = 'MightyStrikes'
		end
		
	return wsmode
end

function job_buff_change(buff, gain, buff_info)
	if state.Buff[buff] ~= nil then
		state.Buff[buff] = gain
	end
	
	if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            --send_command('@input /p Doomed.')
            disable('neck','waist')
        else
            enable('neck','waist')
            handle_equipping_gear(player.status)
        end
    end
	
	determine_haste_group()
	--customize_melee_set()
	
end

function job_status_change(new_status, old_status)
	--table.vprint(sets)
	handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    
    update_combat_form()
    determine_haste_group()
    --check_moving()
	
end

function customize_melee_set(meleeSet)
    --meleeSet = set_combine(meleeSet, select_earring())
	--if buffactive['Fighter\'s Roll'] then
		--classes.CustomMeleeGroups:append('FighterRoll')
	--end
	
    return meleeSet
end
  
--function customize_idle_set(idleSet) 
   --if state.Auto_Kite.value == true then  
     --idleSet = set_combine(idleSet, sets.Kiting)  
    --end  
    --return idleSet  
--end

function job_update(cmdParams, eventArgs) 
	if player.equipment.main == 'Lycurgos' or player.equipment.main == 'Chango' then
		state.CombatWeapon:set('GreatAxe')
	elseif player.equipment.main == 'Shining One' then
		state.CombatWeapon:set('Polearm')
	else -- use regular set
		state.CombatWeapon:reset()
	end
	
	handle_equipping_gear(player.status)  
	th_update(cmdParams, eventArgs)
	
end

function update_combat_form()  
	if DW == true then  
		state.CombatForm:set('DW')  
	elseif DW == false then  
		state.CombatForm:reset()  
	end  
end

function check_moving()
	if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
		if state.Auto_Kite.value == false and moving then
			state.Auto_Kite:set(true)
		elseif state.Auto_Kite.value == true and moving == false then
			state.Auto_Kite:set(false)
		end
	end
end

function determine_haste_group()

	classes.CustomMeleeGroups:clear()
	-- Choose gearset based on DW needed
    if Haste >= 908 then
		classes.CustomMeleeGroups:append('H: 908+')
	elseif Haste > 855 and Haste < 908 then
		classes.CustomMeleeGroups:append('H: 856')
	elseif Haste > 819 and Haste < 856 then
		classes.CustomMeleeGroups:append('H: 819')
	end
	
	--if DW == true then
		--if DW_needed <= 5 then
			--classes.CustomMeleeGroups:append('DW: 5-0')
		--elseif DW_needed > 5 and DW_needed < 12 then
			--classes.CustomMeleeGroups:append('DW: 6-11')
		--elseif DW_needed > 11 and DW_needed < 22 then
			--classes.CustomMeleeGroups:append('DW: 12-21')
		--elseif DW_needed > 21 and DW_needed < 37 then
			--classes.CustomMeleeGroups:append('DW: 22-36')
		--elseif DW_needed > 36 then
			--classes.CustomMeleeGroups:append('DW: 37+')
		--end
	--end
	
	if buffactive['Fighter\'s Roll'] then
		classes.CustomMeleeGroups:append('FighterRoll')
	end
	
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)

    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
                DW_needed = tonumber(cmdParams[2])
                DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if type(tonumber(cmdParams[5])) == 'number' then
            if tonumber(cmdParams[5]) ~= MA_needed then
                MA_needed = tonumber(cmdParams[5])
                H2H = true
            end
        elseif type(cmdParams[5]) == 'string' then
            if cmdParams[5] == 'false' then
                MA_needed = 0
                H2H = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

function select_default_macro_book()
    -- Default macro set/book
    if player.equipment.main == 'Lycurgos' then
        set_macro_page(1, 8)
	elseif player.equipment.main == 'Shining One' then
		set_macro_page(1, 8)
    else
        set_macro_page(1, 8)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end