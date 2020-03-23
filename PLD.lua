-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
end

-- Setup vars that are user-independent.
function job_setup()
    -- /BLU Spell Maps
    blue_magic_maps = {}

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
        'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
    blue_magic_maps.Cure = S{'Wild Carrot'}
    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}
	
	lockstyleset = 77
	
end

function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.WeaponskillMode:options('Normal', 'Acc', 'HP')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'SpellInterrupt')
    state.IdleMode:options('Normal', 'DT')
    state.PhysicalDefenseMode:options('PDT', 'HP')
    state.MagicalDefenseMode:options('MDT', 'Meva')
	
	state.WeaponLock = M(false, 'Weapon Lock')
	
	send_command('bind @w gs c toggle WeaponLock')
	
	select_default_macro_book()
	set_lockstyle()
	
end

function init_gear_sets()

	-- Precast 
	
	Rudianos_FC = {name="Rudianos's Mantle", augments={'HP+60','"Fast Cast"+10',}}
	Rudianos_PDT = {name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}
	Rudianos_STR = {name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
	
	sets.precast.JA['Sentinel'] = {feet={ name="Cab. Leggings +1", augments={'Enhances "Guardian" effect',}},}
	
	sets.precast.FC = {
		main="Malignance Sword",
		ammo="Sapience Orb",
		head=gear.Carmine_mask,
		body="Sacro Breastplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		legs={ name="Eschite Cuisses", augments={'"Mag.Atk.Bns."+25','"Conserve MP"+6','"Fast Cast"+5',}},
		feet={ name="Odyssean Greaves", augments={'Attack+29','"Fast Cast"+5','Accuracy+9',}},
		neck="Baetyl Pendant",
		waist="Creed Baudrier",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back=Rudianos_FC,
	}
	
	sets.precast.FC.HP = { -- 3121 HP
		main="Malignance Sword",
		ammo="Sapience Orb",
		head=gear.Carmine_mask,
		body="Sacro Breastplate",
		hands=gear.Souveran_hands_C,
		legs=gear.Souveran_legs_C,
		feet=gear.Souveran_feet_C,
		neck={name="Dualism Collar +1", priority=14},
		waist={name="Oneiros Belt", priority=13},
		left_ear={name="Odnowa Earring +1", priority=15},
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Moonlight Ring",
		back=Rudianos_FC,
	}
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {waist="Acerbic Sash +1",})
	
	-- Weaponskill sets
	
	sets.precast.WS = {
		ammo="Floestone",
		head=gear.Lustratio_head_A,
		body=gear.Lustratio_body_A,
		hands=gear.Odyssean_STR_hands,
		legs=gear.Odyssean_STR_legs,
		feet="Sulev. Leggings +2",
		neck="Fotia Gorget",
		waist="Prosilio Belt +1",
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back=Rudianos_STR,
	}
	
	sets.precast.WS.HP = {
		ammo="Staunch Tathlum +1",
		head="Hjarrandi Helm",
		body="Hjarrandi Breast.",
		hands=gear.Souveran_hands_C,
		legs=gear.Souveran_legs_C,
		feet="Sulev. Leggings +2",
		neck="Dualism Collar +1",
		waist="Oneiros Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
		left_ring="Moonlight Ring",
		right_ring="Regal Ring",
		back=Rudianos_STR,
	}
	
	-- Midcast
	
	sets.Enmity = {
		ammo="Sapience Orb",
		head="Loess Barbuta +1",
		body=gear.Souveran_body_C,
		hands={ name="Yorium Gauntlets", augments={'Enmity+9',}},
		legs=gear.Souveran_legs_C,
		feet={ name="Eschite Greaves", augments={'HP+70','Enmity+6','Phys. dmg. taken -3',}},
		neck="Moonbeam Necklace",
		waist="Creed Baudrier",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back=Rudianos_FC,
	}
	
	sets.Enmity.HP = {
		main="Malignance Sword",
		ammo="Sapience Orb",
		head=gear.Souveran_head_C,
		body=gear.Souveran_body_C,
		hands=gear.Souveran_hands_C,
		legs=gear.Souveran_legs_C,
		feet={ name="Eschite Greaves", augments={'HP+70','Enmity+6','Phys. dmg. taken -3',}},
		neck="Moonbeam Necklace",
		waist="Creed Baudrier",
		left_ear="Cryptic Earring",
		right_ear="Odnowa Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back=Rudianos_PDT,
	}
	
	sets.midcast.SpellInterrupt =  { -- 3159 HP
		main="Malignance Sword",
		ammo="Staunch Tathlum +1",
		head=gear.Souveran_head_C,
		body=gear.Souveran_body_C,
		hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+2','Breath dmg. taken -2%',}},
		feet=gear.Souveran_feet_C,
		neck="Moonbeam Necklace",
		waist="Rumination Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back="Moonlight Cape",
	}
	
	sets.midcast.Cure = {
		main="Deacon Sword",
		ammo="Staunch Tathlum +1",
		head=gear.Souveran_head_C,
		body=gear.Souveran_body_C,
		hands="Macabre Gaunt. +1",
		legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+2','Breath dmg. taken -2%',}},
		feet={ name="Odyssean Greaves", augments={'Attack+29','"Fast Cast"+5','Accuracy+9',}},
		neck={name="Sacro Gorget", priority=12},
		waist="Rumination Sash",
		left_ear={name="Odnowa Earring +1", priority=14},
		right_ear={name="Etiolation Earring", priority=11},
		left_ring={name="Moonbeam Ring", priority=13},
		right_ring="Moonlight Ring",
		back={name="Moonlight Cape", priority=15},
	}
	
	sets.midcast['Enlight II'] = {
		ammo="Staunch Tathlum +1",
		head=gear.Souveran_head_C,
		body="Rev. Surcoat +2",
		hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		legs=gear.Souveran_legs_C,
		feet=gear.Souveran_feet_C,
		neck="Incanter's Torque",
		waist="Tempus Fugit",
		left_ear="Odnowa Earring +1",
		right_ear="Etiolation Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonlight Cape",
	}
	
	sets.midcast['Phalanx'] = {
		main="Deacon Sword",
		sub="Priwen",
		ammo="Staunch Tathlum +1",
		head={ name="Yorium Barbuta", augments={'Spell interruption rate down -9%','Phalanx +3',}},
		body={ name="Yorium Cuirass", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands=gear.Souveran_hands_C,
		legs={ name="Yorium Cuisses", augments={'Phalanx +3',}},
		feet=gear.Souveran_feet_C,
		neck="Incanter's Torque",
		waist="Rumination Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
		left_ring="Moonbeam Ring",
		right_ring="Moonlight Ring",
		back="Weard mantle",
	}
	
	sets.midcast.Flash = sets.Enmity 
	sets.midcast.Banishga = sets.Enmity
	
	sets.midcast['Blue Magic'] = {}
    sets.midcast['Blue Magic'].Enmity = sets.Enmity
	sets.midcast['Blue Magic'].Enmity.SpellInterrupt = sets.midcast.SpellInterrupt
    sets.midcast['Blue Magic'].Cure = sets.midcast.Cure
    sets.midcast['Blue Magic'].Buff = sets.midcast['Enhancing Magic']
	
	-- Idle
	
	sets.Kiting = {legs="Carmine Cuisses +1"}
	
	sets.Idle = {}
	
	-- Defense
	
	sets.defense.PDT = {
		main="Deacon Sword",
		sub="Ochain",
		ammo="Staunch Tathlum +1",
		head=gear.Souveran_head_C,
		body=gear.Souveran_body_C,
		hands=gear.Souveran_hands_C,
		legs=gear.Souveran_legs_C,
		feet=gear.Souveran_feet_C,
		neck="Warder's Charm +1",
		waist="Flume belt",
		left_ear="Ethereal Earring",
		right_ear="Thureous Earring",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back=Rudianos_PDT,
	}
	
	sets.defense.MDT = { -- 3142 HP
		main="Malignance Sword",
		sub="Aegis",
		ammo="Staunch Tathlum +1",
		head=gear.Souveran_head_C,
		body=gear.Souveran_body_C,
		hands=gear.Souveran_hands_C,
		legs=gear.Souveran_legs_C,
		feet=gear.Souveran_feet_C,
		neck="Warder's Charm +1",
		waist="Flume belt",
		left_ear="Ethereal Earring",
		right_ear="Thureous Earring",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back=Rudianos_PDT,
	}
	
	-- Engaged
	
	sets.engaged = {
		main="Naegling",
		--sub="Aegis",
		ammo="Staunch Tathlum +1",
		head="Flam. Zucchetto +2",
		body="Hjarrandi Breast.",
		hands="Sulev. Gauntlets +2",
		legs="Volte Brayettes",
		feet="Flam. Gambieras +2",
		neck="Combatant's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Cessance Earring",
		right_ear="Brutal Earring",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back=Rudianos_PDT,
	}
	
end

function job_precast(spell, action, spellMap, eventArgs)
    if state.DefenseMode.value ~= 'None' then
        currentSpell = spell.english
        --eventArgs.handled = true
        if spell.action_type == 'Magic' then
			eventArgs.handled = true -- move if this stops working
            equip(sets.precast.FC.HP)
        elseif spell.action_type == 'Ability' then
            equip(sets.Enmity.HP)
				equip(sets.precast.JA[currentSpell])
        end
	else
		if spell.action_type == 'Ability' then
			equip(sets.Enmity)
				equip(sets.precast.JA[spell])
        end	
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
	if state.DefenseMode.value ~= 'None' and state.CastingMode.value ~= 'SpellInterrupt' then
		currentSpell = spell.english
		--eventArgs.handled = true
		if spell.english == 'Phalanx' then
			equip(sets.midcast['Phalanx'])
		elseif spell.skill == 'Healing Magic' then
			equip(sets.midcast.Cure)
		elseif spell.english == 'Flash' or spell.english == 'Banishga' or blue_magic_maps.Enmity:contains(spell.english) then
			eventArgs.handled = true -- move if this stops working
			equip(sets.Enmity.HP)
		end
	end
end

function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

function get_custom_wsmode(spell, action, spellMap)
    if spell.type == 'WeaponSkill' and state.DefenseMode.value ~= 'None' then
        return 'HP'
    end
end

function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 15)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 15)
	elseif player.sub_job == 'BLU' then
		set_macro_page(1, 15)
	else
		set_macro_page(1, 15)
	end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
