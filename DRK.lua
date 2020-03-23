function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
	state.Buff.sleep = buffactive.sleep or false
	state.Buff.Stoneskin =  buffactive.stoneskin or false
	state.Buff.doom = buffactive.doom or false
	state.Buff.Souleater = buffactive.souleater or false
    state.Buff['Last Resort'] = buffactive['Last Resort'] or false
	state.Buff['Dark Seal'] = buffactive['Dark Seal'] or false
	
	state.Buff["Aftermath"] = buffactive["Aftermath"] or false
	state.Buff["Aftermath: Lv.1"] = buffactive["Aftermath: Lv.1"] or false
	state.Buff["Aftermath: Lv.2"] = buffactive["Aftermath: Lv.2"] or false
	state.Buff["Aftermath: Lv.3"] = buffactive["Aftermath: Lv.3"] or false
	
	state.ScarletDelirium = M(false, 'Damage Taken+')
	absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-ACC', 'Absorb-TP'}
	
	include('Organizer-lib.lua')
	include('Mote-TreasureHunter')
	
	lockstyleset = 86
	
end

function user_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Mid', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Mid', 'Acc')
    state.CastingMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Sphere')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'Tempus', 'Reraise')
    state.MagicalDefenseMode:options('MDT', 'MDT2')
	
	send_command('bind @` gs c toggle ScarletDelirium')
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

	-- Augmented gear
	
	Valorous_body = {name="Valorous Mail", augments={'Accuracy+30','"Dbl.Atk."+4',}}
	Valorous_feet_STP = {name="Valorous Greaves", augments={'Accuracy+17 Attack+17','"Store TP"+5','DEX+9','Accuracy+3','Attack+6',}}
	
	Odyssean_Helm_VIT = {name="Odyssean Helm", augments={'Attack+29','Weapon skill damage +3%','VIT+10',}}
	Odyssean_legs_STP = {name="Odyssean Cuisses", augments={'Accuracy+5 Attack+5','"Store TP"+7','Accuracy+12','Attack+1',}}
	Odyssean_Gauntlets_VIT = {name="Odyssean Gauntlets", augments={'Accuracy+29','Weapon skill damage +4%','VIT+13',}}
	
	Odyssean_body_FC = {name="Odyss. Chestplate", augments={'Accuracy+22','"Fast Cast"+5','DEX+13',}}
	Odyssean_feet_FC = {name="Odyssean Greaves", augments={'Attack+29','"Fast Cast"+5','Accuracy+9',}}
	
	Odyssean_legs_TH = {name="Odyssean Cuisses", augments={'MND+10','"Treasure Hunter"+1','Accuracy+12 Attack+12',}}
	Valorous_hands_TH = {name="Valorous Mitts", augments={'STR+5','Mag. Acc.+17','"Treasure Hunter"+1','Mag. Acc.+19 "Mag.Atk.Bns."+19',}}
	
	Ankou_TP = {name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	Ankou_Torc = {name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}}
	Ankou_STR = {name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	Ankou_Reso = {name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}
	
	Niht_drain = {name="Niht Mantle", augments={'Attack+8','Dark magic skill +4','"Drain" and "Aspir" potency +25',}}
	sets.Organizer = {}
	
	-- Precast sets
	-- Precast sets to enhance job abilities	
	
	sets.precast.JA['Diabolic Eye'] = {hands="Fall. Fin. Gaunt. +2"}
    sets.precast.JA['Nether Void']  = {legs="Heathen's Flanchard +1"}
    sets.precast.JA['Dark Seal']    = {head="Fallen's burgeonet +1"}
    sets.precast.JA['Souleater']    = {}
    sets.precast.JA['Weapon Bash']   = {hands="Ig. Gauntlets +2"}
    sets.precast.JA['Blood Weapon'] = {}
    sets.precast.JA['Last Resort']  = {back=Ankou_TP}
	sets.precast.JA['Arcane Circle'] = {feet="Igno. Sollerets +1"}
	
	-- Fast cast
	
	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Sacro Breastplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		legs={ name="Eschite Cuisses", augments={'"Mag.Atk.Bns."+25','"Conserve MP"+6','"Fast Cast"+5',}},
		feet=Odyssean_feet_FC,
		neck="Baetyl Pendant",
		waist="Tempus Fugit",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
	}
	
	sets.precast.FC.Impact = set_combine(sets.precast.FC, {
		head=empty,
		body="Twilight Cloak",
	})
	
	-- WS sets
	-- Great sword weapon skills
	
	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Odyssean Helm", augments={'Attack+29','Weapon skill damage +3%','VIT+10',}},
		body="Ignominy Cuirass +3",
		hands={ name="Odyssean Gauntlets", augments={'Accuracy+29','Weapon skill damage +4%','VIT+13',}},
		legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
		feet="Sulev. Leggings +2",
		neck="Abyssal Beads",
		waist="Ioskeha Belt +1",
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ankou_Torc,
	}
	
	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Flam. Zucchetto +2",
		body={ name="Argosy Hauberk", augments={'STR+10','Attack+15','"Store TP"+5',}},
		hands={ name="Argosy Mufflers", augments={'STR+15','"Dbl.Atk."+2','Haste+2%',}},
		legs="Ig. Flanchard +3",
		feet="Flam. Gambieras +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		back=Ankou_Reso,
	})
	
	sets.precast.WS['Torcleaver'] = set_combine(sets.precast.WS, {
		waist="Fotia belt",
	})
	
	sets.precast.WS['Torcleaver'].Mid = set_combine(sets.precast.WS['Torcleaver'], {
		head="Hjarrandi Helm",
	})
	
	-- Scythe weapon skills
	
	sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS, {
		head="Ratri Sallet +1",
		hands="Ratri Gadlings +1",
		feet="Ratri Sollerets +1",
		waist="Grunfeld Rope",
		back=Ankou_STR,
	})
	
	sets.precast.WS['Entropy'] = set_combine(sets.precast.WS, {
		head="Hjarrandi Helm",
		hands="Ratri Gadlings +1",
		legs="Ig. Flanchard +3",
		feet="Ratri Sollerets +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		right_ear="Brutal Earring",
		left_ring="Hetairoi Ring",
		back=Ankou_DA,
	})
	
	sets.precast.WS['Catastrophe'] = set_combine(sets.precast.WS, {
		head="Ratri Sallet +1",
		hands="Ratri Gadlings +1",
		feet="Ratri Sollerets +1",
		waist="Grunfeld Rope",
		right_ear="Brutal Earring",
		back=Ankou_STR,
	})
	
	sets.precast.WS['Quietus'] = set_combine(sets.precast.WS, {
		head="Ratri Sallet +1",
		hands="Ratri Gadlings +1",
		feet="Ratri Sollerets +1",
		waist="Grunfeld Rope",
		back=Ankou_STR,
	})
	
	sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS, {
		head="Ratri Sallet +1",
		hands="Ratri Gadlings +1",
		feet="Ratri Sollerets +1",	
		waist="Grunfeld Rope",
		back=Ankou_STR,
	})
	
	-- Great Axe weapon skills
	
	sets.precast.WS['Armor Break'] = {
		ammo="Pemphredo Tathlum",
		head="Flam. Zucchetto +2",
		body="Flamma Korazin +2",
		hands="Flam. Manopolas +2",
		legs="Flamma Dirs +2",
		feet="Flam. Gambieras +2",
		neck="Erra Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
	
	sets.precast.WS['Weapon Break'] = sets.precast.WS['Armor Break']
	sets.precast.WS['Full Break'] = sets.precast.WS['Armor Break']
	
	sets.precast.WS['Rampage'] = {
		ammo="Yetshila +1",
		head="Flamma Zucchetto +2",
		body="Hjarrandi Breast.",
		hands="Flam. Manopolas +2",
		legs="Ig. Flanchard +3",
		feet="Flam. Gambieras +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Moonshade Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
	}
	
	
	-- Midcast sets
	-- Specific spell sets
	
	sets.midcast.Utsusemi = {}

    sets.midcast['Dark Magic'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",	
		body="Carm. Sc. Mail +1",
		hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
		legs={ name="Eschite Cuisses", augments={'"Mag.Atk.Bns."+25','"Conserve MP"+6','"Fast Cast"+5',}},
		feet="Ratri Sollerets +1",
		neck="Erra Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Digni. Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back=Niht_drain,
    }
	
	sets.midcast['Dark Magic'].Acc = set_combine(sets.midcast['Dark Magic'], { })
	
    sets.midcast.Endark = set_combine(sets.midcast['Dark Magic'], {
		waist="Casso Sash",
		right_ring="Stikini Ring +1",
		back=Niht_drain,
	})

	sets.midcast['Stun'] = set_combine(sets.midcast['Dark Magic'], {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		hands="Rat. Gadlings +1",
		legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	})
	
    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast['Elemental Magic'] = {}
	
	sets.midcast['Dread Spikes'] = set_combine(sets.midcast['Dark Magic'], {
        ammo="Egoist's Tathlum",
		head="Ratri Sallet +1",
		body="Heath. Cuirass +1",
		hands="Ratri Gadlings +1",
		legs="Ratri Cuisses",
		feet="Ratri Sollerets +1",
		neck="Dualism Collar +1",
		waist="Oneiros Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
		left_ring="Moonbeam Ring",
		right_ring="Moonlight Ring",
		back="Moonlight Cape",
    })
	
	-- Drain sets
	
	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head={ name="Fall. Burgeonet +1", augments={'Enhances "Dark Seal" effect',}},
		waist="Austerity Belt +1",
		right_ear="Hirudinea Earring",
		back=Niht_drain,
    })
	
	sets.midcast.Drain.Acc = set_combine(sets.midcast.Drain, {
		waist="Eschan Stone", -- macc/matk 7
    })
	
    sets.midcast.Aspir = sets.midcast.Drain
	
    sets.midcast.Aspir.Acc = sets.midcast.Drain.Acc
	
	-- Absorbs
    sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'], {
		right_ring="Kishar Ring",
        back="Chuparrosa Mantle",
    })
	
	sets.midcast.Absorb.Acc = set_combine(sets.midcast['Dark Magic'].Acc, {
		right_ring="Kishar Ring",
        back="Chuparrosa Mantle",
	})

    sets.midcast['Absorb-TP'] = set_combine(sets.midcast.Absorb, {})

    sets.midcast['Absorb-TP'].Acc = set_combine(sets.midcast.Absorb.Acc, {})
    
	sets.midcast.Impact = {
		ammo="Pemphredo Tathlum",
		body="Twilight Cloak",
		hands="Flam. Manopolas +2",
		legs="Flamma Dirs +2",
		feet="Flam. Gambieras +2",
		neck="Erra Pendant",
		waist="Oneiros Rope",
		left_ear="Malignance Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	}
	
	-- Idle sets
	
	sets.idle = {}
	
	sets.idle.Town = set_combine(sets.engaged, {})
	
	sets.Kiting = {legs="Carmine Cuisses +1",}

	
	-- Defensive sets
	
	sets.defense.PDT = set_combine(sets.engaged, {
		ammo="Staunch Tathlum +1",
		head="Hjarrandi Helm",
		body="Hjarrandi Breast.",
		hands="Sulev. Gauntlets +2",
		legs="Ig. Flanchard +3",
		feet="Flamma Gambieras +2",
		neck="Loricate Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Cessance Earring",
		right_ear="Brutal Earring",
		left_ring="Moonlight Ring",
		right_ring="Niqmaddu Ring",
		back=Ankou_TP,
	})
	
	sets.defense.Tempus = set_combine(sets.defense.PDT, {
		waist="Tempus Fugit",
	})
	
	sets.defense.MDT = set_combine(sets.engaged, {
		ammo="Ginsen",
		head="Hjarrandi Helm",
		body="Hjarrandi Breast.",
		hands="Sulev. Gauntlets +2",
		legs="Volte Brayettes",
		feet="Flam. Gambieras +2",
		neck={ name="Abyssal Beads +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Cessance Earring",
		right_ear="Brutal Earring",
		left_ring="Moonlight Ring",
		right_ring="Niqmaddu Ring",
		back=Ankou_TP,
	})
	
	sets.defense.MDT2 = set_combine(sets.defense.MDT, {
		ammo="Hasty Pinion +1",
		waist="Sailfi Belt +1",
	})
		
	
	-- TP sets
	-- Basic defined sets for any weapon
	
	sets.engaged = {
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body=Valorous_body,
		hands="Sulev. Gauntlets +2",
		legs="Ig. Flanchard +3",
		feet="Flam. Gambieras +2",
		neck="Abyssal Beads",
		waist="Ioskeha Belt +1",
		left_ear="Cessance Earring",
		right_ear="Brutal Earring",
		left_ring="Hetairoi Ring",
		right_ring="Niqmaddu Ring",
		back=Ankou_TP
	}
	sets.engaged.Mid = set_combine(sets.engaged, {})
	sets.engaged.Acc = set_combine(sets.engaged.Mid, {})

	-- max haste gear sets
	-- need 12% gear haste with capped job ability haste
	
	sets.engaged['H: 908+'] = set_combine(sets.engaged, {body="Hjarrandi Breast.",})
	sets.engaged.Mid['H: 908+'] = set_combine(sets.engaged['H: 908+'], {})
	sets.engaged.Acc['H: 908+'] = set_combine(sets.engaged.Mid['H: 908+'], {})
	
	sets.engaged['H: 732'] = set_combine(sets.engaged, {})
	
	-- Caladbolg sets
	
	sets.engaged['Greatsword'] = set_combine(sets.engaged, {})
	sets.engaged['Greatsword'].Mid = set_combine(sets.engaged['Greatsword'], {left_ring="Flamma Ring",})
	sets.engaged['Greatsword'].Acc = set_combine(sets.engaged['Greatsword'].Mid, {left_ring="Regal Ring",})
	
	sets.engaged['Greatsword']['AM'] = set_combine(sets.engaged['Greatsword'], {ammo="Yetshila +1",})
	sets.engaged['Greatsword'].Mid['AM'] = set_combine(sets.engaged['Greatsword'], {})
	sets.engaged['Greatsword'].Acc['AM'] = set_combine(sets.engaged['Greatsword'].Mid, {})
	
	sets.engaged['Greatsword']['H: 908+'] = set_combine(sets.engaged['H: 908+'], {body="Hjarrandi Breast.",})
	sets.engaged['Greatsword'].Mid['H: 908+'] = set_combine(sets.engaged['Greatsword']['H: 908+'], {})
	sets.engaged['Greatsword'].Acc['H: 908+'] = set_combine(sets.engaged['Greatsword'].Mid['H: 908+'], {})
	
	sets.engaged['Greatsword']['H: 908+']['AM'] = set_combine(sets.engaged['Greatsword']['H: 908+'], {ammo="Yetshila +1",})
	sets.engaged['Greatsword'].Mid['H: 908+']['AM'] = set_combine(sets.engaged['Greatsword']['H: 908+']['AM'], {})
	sets.engaged['Greatsword'].Acc['H: 908+']['AM'] = set_combine(sets.engaged['Greatsword'].Mid['H: 908+']['AM'], {})
	
	-- Apocalypse
	
	sets.engaged['Apocalypse'] = set_combine(sets.engaged, {left_ring="Petrov Ring",})
	sets.engaged['Apocalypse'].Mid = set_combine(sets.engaged['Apocalypse'], {})
	sets.engaged['Apocalypse'].Acc = set_combine(sets.engaged['Apocalypse'].Mid, {})
	
	--sets.engaged['Apocalypse']['AM'] = set_combine(sets.engaged['Apocalypse'], {body="Hjarrandi Breast.", left_ring="Hetairoi Ring",})
	
	-- With capped magic haste, hasso and Apoc aftermath (H: 820), only 17% gear haste is needed
	
	sets.engaged['Apocalypse']['H: 856'] = set_combine(sets.engaged['H: 908+'], {left_ring="Hetairoi Ring",})
	sets.engaged['Apocalypse'].Mid['H: 856'] = set_combine(sets.engaged['Apocalypse']['H: 908+'], {})
	sets.engaged['Apocalypse'].Acc['H: 856'] = set_combine(sets.engaged['Apocalypse'].Mid['H: 908+'], {})
	
	-- Anguta
	-- 70 gear STP /SAM for 4 hit
	
	sets.engaged['Anguta'] = set_combine(sets.engaged, {body="Hjarrandi Breast.", hands="Flam. Manopolas +2",
		legs=Odyssean_legs_STP, neck="Ainia Collar", left_ring="Petrov Ring",})
	sets.engaged['Anguta'].Mid = set_combine(sets.engaged['Anguta'], {})
	sets.engaged['Anguta'].Acc = set_combine(sets.engaged['Anguta'].Mid, {})

	sets.engaged['Anguta']['H: 908+'] = set_combine(sets.engaged['Anguta'], {})
	sets.engaged['Anguta'].Mid['H: 908+'] = set_combine(sets.engaged['Anguta']['H: 908+'], {})
	sets.engaged['Anguta'].Acc['H: 908+'] = set_combine(sets.engaged['Anguta'].Mid['H: 908+'], {})

	-- Hybrid sets
	
	sets.engaged.DT =set_combine(sets.engaged, {
		ammo="Staunch Tathlum +1",
		head="Hjarrandi Helm",
		body="Hjarrandi Breast.",
		--neck="Loricate Torque +1",
		--left_ring="Defending Ring",
	})
	
	sets.engaged['Greatsword'].DT = sets.engaged.DT
	
	sets.engaged['Apocalypse'].DT = sets.engaged.DT
	
	sets.engaged['Anguta'].DT = sets.engaged.DT
	
	-- Utility sets
	
	sets.buff.Doom = {
		neck="Nicander's Necklace",
		waist="Gishdubar Sash"
	}

	sets.ScarletDelirium = {
		head="Ratri Sallet +1",
		body="Ratri Plate",
		hands="Ratri Gadlings +1",
		legs="Ratri Cuisses",
		feet="Ratri Sollerets +1",
		left_ring="Begrudging Ring",
	}
	
	sets.DarkSeal = {
		head="Fallen's burgeonet +1"
	}
	
	sets.TreasureHunter = {
		head="Wh. Rarab Cap +1",
		hands=Valorous_hands_TH,
		legs=Odyssean_legs_TH,
		waist="Chaac Belt",
	}
	
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_buff_change(buff, gain, buff_info)
	if state.Buff[buff] ~= nil then
		state.Buff[buff] = gain
	end
	
	if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('neck','waist')
        else
            enable('neck','waist')
            handle_equipping_gear(player.status)
        end
    end
	
	if buff == 'Scarlet Delirium' and state.ScarletDelirium.value then
		if gain then
			equip(sets.ScarletDelirium)
			disable('head', 'body', 'hands', 'legs', 'feet', 'left_ring')
		else
			enable('head', 'body', 'hands', 'legs', 'feet', 'left_ring')
			handle_equipping_gear(player.status)
		end
	end
	
	if buff == 'Dark Seal' then
		if gain then
			equip(sets.DarkSeal)
			disable('head')
		else
			enable('head')
			handle_equipping_gear(player.status)
		end
	end
	
	determine_haste_group()
	
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
    if state.Buff['Souleater'] then
        meleeSet = set_combine(meleeSet, sets.buff.Souleater)
    end
    --meleeSet = set_combine(meleeSet, select_earring())
    return meleeSet
end
  
--function customize_idle_set(idleSet) 
   --if state.Auto_Kite.value == true then  
     --idleSet = set_combine(idleSet, sets.Kiting)  
    --end  
    --return idleSet  
--end

function job_update(cmdParams, eventArgs) 
	if player.equipment.main == 'Ragnarok' or player.equipment.main == 'Caladbolg' then
		state.CombatWeapon:set('Greatsword')
	elseif player.equipment.main == 'Apocalypse' then
		state.CombatWeapon:set('Apocalypse')
	elseif player.equipment.main == 'Redemption' then
		state.CombatWeapon:set('Redemption')
	elseif player.equipment.main == 'Liberator' then
		state.CombatWeapon:set('Liberator')
	elseif player.equipment.main == 'Anguta' then
		state.CombatWeapon:set('Anguta')	
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
	
	--if buff == "Aftermath" and gain or buffactive.Aftermath then
		--classes.CustomMeleeGroups:append('AM')
    --end

	if state.Buff["Aftermath: Lv.2"] or state.Buff["Aftermath: Lv.3"] and player.equipment.main == 'Caladbolg' then
		classes.CustomMeleeGroups:append('AM')
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

function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Dark Magic' and absorbs:contains(spell.english) then
        return 'Absorb'
    end
end

function select_default_macro_book()
    -- Default macro set/book
    if player.equipment.main == 'Apocalypse' then
        set_macro_page(1, 17)
	elseif player.equipment.main == 'Anguta' then
		set_macro_page(1, 17)
	elseif player.equipment.main == 'Caladbolg' then
		set_macro_page(1, 17)
    else
        set_macro_page(1, 17)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end