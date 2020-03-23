-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
-- Haste II has the same buff ID [33], so we have to use a toggle. 
-- gs c toggle hastemode -- Toggles whether or not you're getting Haste II

function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
    include('organizer-lib')
end


-- Setup vars that are user-independent.
function job_setup()
 	
    state.HasteMode = M{['description']='Haste Mode', 'Normal', 'Hi'}
	state.QDMode = M{['description']='Quick Draw Mode', 'Normal', 'Magic Enhance', 'STP'}
	state.LuzafRing = M(false, "Luzaf's Ring")
	state.WeaponSet = M{['description']='Current Weapon', 'LeadenRanged', 'LeadenMelee', 'Savage', 'LastStand'} 
	state.warned = M(false)
	
	include('Mote-TreasureHunter')
	
	define_roll_values()
end

function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Low', 'Mid', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Low', 'Mid', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT')
    state.MagicalDefenseMode:options('MDT')

    select_default_macro_book()

    send_command('bind @h gs c cycle HasteMode')
	send_command('bind @q gs c cycle QDMode')
	send_command('bind @` gs c toggle LuzafRing')
	send_command('bind @e gs c cycle WeaponSet')
	send_command('bind ^= gs c cycle treasuremode')
	
	send_command('bind numpad7 input /ws "Savage Blade" <t>')
	send_command('bind numpad8 input /ws "Leaden Salute" <t>')
	
	gear.RAbullet = "Eminent Bullet"
    gear.WSbullet = "Eminent Bullet"
    gear.MAbullet = "Orichalc. Bullet"
    gear.QDbullet = "Animikii Bullet"
    options.ammo_warning_limit = 10
	
	Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()

end

function init_gear_sets()

	sets.CapacityMantle = { back="Mecisto. Mantle" }
	
	-- Precast 
	
    sets.precast.JA['Snake Eye'] = {legs={ name="Lanun Trews", augments={'Enhances "Snake Eye" effect',}},}
    sets.precast.JA['Wild Card'] = {feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},}
    sets.precast.JA['Random Deal'] = {body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},}

    
    sets.precast.CorsairRoll = {
		head={ name="Lanun Tricorne +1", augments={'Enhances "Winning Streak" effect',}},
		--body="Emet Harness +1",
		hands="Chasseur's Gants +1",
		--legs="Meg. Chausses +2",
		--feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+4','Attack+14',}},
		neck="Regal Necklace",
		--waist="Flume Belt",
		left_ring="Defending Ring",
		back={ name="Camulus's Mantle", augments={'Eva.+20 /Mag. Eva.+20','"Snapshot"+10',}},
	}
	
	sets.precast.CorsairRoll.Gun = {range={ name="Compensator", augments={'DMG:+15','AGI+15','Rng.Acc.+15',}},}
	sets.precast.CorsairRoll["Allies Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
	sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1",})
	sets.precast.LuzafRing = set_combine(sets.precast.CorsairRoll, {right_ring="Luzaf's Ring"})
	
	--FC 
		sets.precast.FC = {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket", augments={'HP+80','"Fast Cast"+7','Magic dmg. taken -3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		feet={ name="Carmine Greaves", augments={'HP+60','MP+60','Phys. dmg. taken -3',}},
		neck="Baetyl Pendant",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Rahab Ring",
		right_ring="Kishar Ring",
	}
	
	-- (10% Snapshot from JP Gifts)
    sets.precast.RA = {  
		ammo=gear.RAbullet,
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body="Oshosi Vest",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
		feet="Meg. Jam. +2",
		neck="Commodore Charm",
		waist="Impulse Belt",
		back={ name="Camulus's Mantle", augments={'Eva.+20 /Mag. Eva.+20','"Snapshot"+10',}},
	}

    sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
		body="Laksa. Frac +3",
		legs={ name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
		feet="Meg. Jam. +2",
		waist="Yemaya Belt",
    })

    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
		head="Chass. Tricorne +1",
		legs={ name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
		feet="Meg. Jam. +2",
    })
	
	--sets.precast.CorsairShot = {ammo=gear.QDBullet}
	
	-- WS sets
	sets.precast.WS = {
		ammo=gear.WSbullet,
		head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'Rng.Atk.+28','Weapon skill damage +2%','AGI+6','Rng.Acc.+15',}},
		feet="Meg. Jam. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Enervating Earring",
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}},
	}


    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Last Stand'] = {
		ammo=gear.WSbullet,
		head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet="Meg. Jam. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}},
	}

    sets.precast.WS['Wildfire'] = {
		ammo=gear.MAbullet,
		head=gear.Herc_helm_MAB_WS,
		body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Herculean Trousers", augments={'Attack+9','Mag. Acc.+16','Weapon skill damage +8%','Accuracy+15 Attack+15','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Commodore Charm",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear="Crematio Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
	}

    sets.precast.WS['Leaden Salute'] = {
		ammo=gear.MAbullet,
		head="Pixie Hairpin +1",
		body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Herculean Trousers", augments={'Attack+9','Mag. Acc.+16','Weapon skill damage +8%','Accuracy+15 Attack+15','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Commodore Charm",
		waist="Svelt. Gouriz +1",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Archon Ring",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
	}
	
	sets.precast.WS['Leaden Salute'].FullTP = {}
    
	sets.precast.WS['Savage Blade'] = {
		head={ name="Herculean Helm", augments={'Accuracy+28','Weapon skill damage +3%','STR+11',}},
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'Accuracy+20 Attack+20','Weapon skill damage +3%','STR+15','Accuracy+5',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Commodore Charm",
		waist="Prosilio Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
	
	sets.precast.WS['Savage Blade'].Low = set_combine(sets.precast.WS['Savage Blade'], {
		waist="Grunfeld Rope",
	})
	
	sets.precast.WS['Savage Blade'].Mid = set_combine(sets.precast.WS['Savage Blade'].Low, {
		left_ring="Rufescent Ring",
	})
	
	sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'].Mid, {
		neck="Combatant's Torque",
		right_ear="Digni. Earring",
	})
	
	sets.precast.WS['Circle Blade'] = set_combine(sets.precast.WS['Savage Blade'], {
		waist="Grunfeld Rope",
	})
		
	sets.precast.WS['Evisceration'] = {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Begrudging Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	
	sets.precast.WS['Aeolian Edge'] = {
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+23','Pet: INT+9','Accuracy+6 Attack+6','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
		body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Herculean Trousers", augments={'Attack+9','Mag. Acc.+16','Weapon skill damage +8%','Accuracy+15 Attack+15','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Dingir Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	}
	
	-- Midcast sets
	
	sets.midcast.RA = { 
		ammo=gear.RAbullet,
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Yemaya Belt",
		left_ear="Enervating Earring",
		right_ear="Neritic Earring",
		left_ring="Dingir Ring",
		right_ring="Ilabrat Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}},
	}

    sets.midcast.RA.Acc = {
		ammo=gear.RAbullet,
		head="Malignance Chapeau",
		body="Mummu Jacket +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Yemaya Belt",
		left_ear="Enervating Earring",
		right_ear="Neritic Earring",
		left_ring="Hajduk Ring",
		right_ring="Hajduk Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}},
	}
	
	sets.midcast['Dia II'] = {
		ammo="Animikii Bullet",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Digni. Earring",
		right_ear="Gwati Earring",
		left_ring="Mummu Ring",
		right_ring="Petrov Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}},
	}
	
	sets.midcast.CorsairShot = {
		ammo=gear.QDbullet,
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+23','Pet: INT+9','Accuracy+6 Attack+6','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
		body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs="Malignance Tights",
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear="Crematio Earring",
		left_ring="Fenrir Ring +1",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
    }

    sets.midcast.CorsairShot.Acc = {
		ammo=gear.QDbullet,
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Commodore Charm",
		waist="Kwahu Kachina Belt",
		left_ear="Digni. Earring",
		right_ear="Gwati Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
	}

    sets.midcast.CorsairShot['Light Shot'] = {
		ammo=gear.QDbullet,
    }

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']
	
	sets.midcast.CorsairShot.Enhance = set_combine(sets.midcast.CorsairShot.Acc, {feet="Chass. Bottes +1",})
	
	sets.midcast.CorsairShot.STP = set_combine(sets.midcast.CorsairShot, {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Yemaya Belt",
		left_ear="Dedition Earring",
		right_ear="Neritic Earring",
		left_ring="Ilabrat Ring",
		right_ring="Petrov Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}},
	})
	
	sets.TripleShot = {
		head="Oshosi Mask",
		body="Chasseur's Frac +1",
		hands="Oshosi Gloves",
		legs="Oshosi Trousers",
	}
	
	sets.engaged = {
	}
	
	-- Engaged Sets
	--0% haste
	sets.engaged.DW = {
		head={ name="Herculean Helm", augments={'Accuracy+26','"Dual Wield"+3','DEX+9',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Taeon Boots", augments={'Accuracy+24','"Dual Wield"+5','STR+7 DEX+7',}},
		neck="Iskur Gorget",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	
	sets.engaged.DW.Low = set_combine(sets.engaged.DW, {
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
	})
	
	sets.engaged.DW.Mid = set_combine(sets.engaged.DW.Low, {
		--head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		left_ring="Ilabrat Ring",
	})
	
	sets.engaged.DW.Acc = set_combine(sets.engaged.DW.Mid, {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Combatant's Torque",
		left_ear="Cessance Earring",
	})
	
	--45% Magic Haste
	sets.engaged.DW.MaxHaste = {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+20','"Triple Atk."+4','STR+9','Attack+7',}},
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Suppanomimi",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	
	sets.engaged.DW.Low.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Lissome Necklace",
	})
	
	sets.engaged.DW.Mid.MaxHaste = set_combine(sets.engaged.DW.Low.MaxHaste, {
		waist="Kentarch Belt +1",
		left_ring="Ilabrat Ring",
	})
	
	sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Mid.MaxHaste, {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Combatant's Torque",
		left_ear="Cessance Earring",
	})
	
	--35% Haste
	sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW.MaxHaste, {
		feet={ name="Taeon Boots", augments={'Accuracy+24','"Dual Wield"+5','STR+7 DEX+7',}},
		waist="Reiki Yotai",
		--left_ear="Suppanomimi",
		right_ear="Eabani Earring",
	})
	
	sets.engaged.DW.Low.HighHaste = set_combine(sets.engaged.DW.HighHaste, {})
	sets.engaged.DW.Mid.HighHaste = set_combine(sets.engaged.DW.Low.HighHaste, {})
	sets.engaged.DW.Acc.HighHaste= set_combine(sets.engaged.DW.Mid.HighHaste, {
		neck="Combatant's Torque",
	})
	
	--30% Haste
	sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW.MaxHaste, {
		feet={ name="Taeon Boots", augments={'Accuracy+24','"Dual Wield"+5','STR+7 DEX+7',}},
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
	})
	
	sets.engaged.DW.Low.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Lissome Necklace",
	})
	
	sets.engaged.DW.Mid.MidHaste = set_combine(sets.engaged.DW.Low.MidHaste, {
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		left_ring="Ilabrat Ring",
	})
	sets.engaged.DW.Acc.MidHaste = set_combine(sets.engaged.DW.Mid.MidHaste, {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Combatant's Torque",
		left_ear="Cessance Earring",
	})
	
	--15% Haste
	sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
	})
	
	sets.engaged.DW.Low.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Lissome Necklace",
	})
	
	sets.engaged.DW.Mid.LowHaste = set_combine(sets.engaged.DW.Low.LowHaste, {
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		left_ring="Ilabrat Ring",
	})
	
	sets.engaged.DW.Acc.LowHaste = set_combine(sets.engaged.DW.Mid.LowHaste, {
		neck="Combatant's Torque",
	})
	
	-- Hybrid Sets
	
	sets.engaged.Hybrid = {
		--feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+4','Attack+14',}},
		neck="Loricate Torque +1",
		left_ring="Defending Ring",
	}
	
	sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
	
	sets.engaged.DW.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
	sets.engaged.DW.Low.DT = set_combine(sets.engaged.DW.Low, sets.engaged.Hybrid)
	sets.engaged.DW.Mid.DT = set_combine(sets.engaged.DW.Mid, sets.engaged.Hybrid)
	sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)
	
	sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Low.DT.MaxHaste = set_combine(sets.engaged.DW.Low.MaxHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Mid.DT.MaxHaste = set_combine(sets.engaged.DW.Mid.MaxHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Acc.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)
	
	sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Low.DT.HighHaste = set_combine(sets.engaged.DW.Low.HighHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Mid.DT.HighHaste = set_combine(sets.engaged.DW.Mid.HighHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Acc.DT.HighHaste = set_combine(sets.engaged.DW.Acc.HighHaste, sets.engaged.Hybrid)
	
	
	sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Low.DT.MidHaste = set_combine(sets.engaged.DW.Low.MidHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Mid.DT.MidHaste = set_combine(sets.engaged.DW.Mid.MidHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Acc.DT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)
	
	sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Low.DT.LowHaste = set_combine(sets.engaged.DW.Low.LowHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Mid.DT.LowHaste = set_combine(sets.engaged.DW.Mid.LowHaste, sets.engaged.Hybrid)
	sets.engaged.DW.Acc.DT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)
	
	-- Defensive Sets
	
	sets.defense.PDT = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Brutal Earring",
		left_ring="Defending Ring",
		right_ring="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	
	sets.defense.MDT = {
		head="Malignance Chapeau",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		left_ring="Defending Ring",
	}
	
	-- Special Sets
	
	sets.Obi = {waist="Hachirin-no-Obi"}
	
	sets.Kiting = {
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},	
	}
	
	sets.TreasureHunter = {
		head="Wh. Rarab Cap +1",
		hands={ name="Herculean Gloves", augments={'Pet: DEX+7','Enmity+2','"Treasure Hunter"+1','Accuracy+11 Attack+11','Mag. Acc.+11 "Mag.Atk.Bns."+11',}},
		legs={ name="Herculean Trousers", augments={'Potency of "Cure" effect received+1%','Phys. dmg. taken -2%','"Treasure Hunter"+1','Accuracy+11 Attack+11','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		waist="Chaac Belt",
	}
	 
	sets.LeadenRanged = {
		main="Naegling",
		sub="Tauret",
		range="Molybdosis",
	}
	
	sets.LeadenMelee = {
		main="Tauret",
		sub="Blurred Knife +1",
		range="Molybdosis",
	}
	
	sets.Savage = {
		main="Naegling",
		sub="Blurred Knife +1",
		range={ name="Anarchy +2", augments={'Delay:+60','TP Bonus +1000',}},
	}
	
	sets.LastStand = {
		main="Kustawi +1",
		sub="Nusku Shield",
		range={ name="Holliday", augments={'"Store TP"+5','AGI+2','Rng.Acc.+6','Rng.Atk.+20','DMG:+23',}},
	}
	
	sets.Evisceration = {
		main="Tauret",
		sub="Blurred Knife +1",
		range={ name="Anarchy +2", augments={'Delay:+60','TP Bonus +1000',}},
	}
	
end

---

--customize_melee_set
	--if players.sub_job == 'DNC' then	
		--meleeSet = set_combine(meleeSet, sets.CapacityMantle)
	--end
--end

function job_pretarget(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
end

function job_precast(spell, action, spellMap, eventArgs)
	if (spell.type == 'CorsairRoll' or spell.english == "Double Up") then
		if player.status ~= 'Engaged' then
			equip(sets.precast.CorsairRoll.Gun)
		end
		if state.LuzafRing.value then
			equip(sets.precast.LuzafRing)
		end
	end
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end
	
	if spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
	end
	
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
	
	equip(sets[state.WeaponSet.current])
	
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if (spell.type == 'CorsairRoll' or spell.english == "Double Up") then
		if player.status ~= 'Engaged' then
			equip(sets.precast.CorsairRoll.Gun)
		end
	end
	-- check for flurry
    if spell.action_type == 'Ranged Attack' then
        if flurry == 2 then
            equip(sets.precast.RA.Flurry2)
        elseif flurry == 1 then
            equip(sets.precast.RA.Flurry1)
        end
    -- Equip obi if weather/day matches for WS.
    elseif spell.type == 'WeaponSkill' then
        if spell.english == 'Leaden Salute' then
            if world.weather_element == 'Dark' or world.day_element == 'Dark' then
                equip(sets.Obi)
            end
            if player.tp > 2900 then
                equip(sets.precast.WS['Leaden Salute'].FullTP)
            end
        elseif spell.english == 'Wildfire' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
            equip(sets.Obi)
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Equip obi if weather/day matches for Quick Draw.
    if spell.type == 'CorsairShot' then
        if (spell.element == world.day_element or spell.element == world.weather_element) and
        (spell.english ~= 'Light Shot' and spell.english ~= 'Dark Shot') then
            equip(sets.Obi)
        end
		if state.QDMode.value == 'Magic Enhance' then
			equip(sets.midcast.CorsairShot.Enhance)
		elseif state.QDMode.value == 'STP' then
			equip(sets.midcast.CorsairShot.STP)
		end
    elseif spell.action_type == 'Ranged Attack' then
        if buffactive['Triple Shot'] then
            equip(sets.TripleShot)
        end
    end
	--equip(sets[state.Weapons.current])
end


function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
	equip(sets[state.WeaponSet.current])
end



--function customize_melee_set(meleeSet)
	--if player.status = Engaged and if player.sub_job = 'DNC' then
		--meleeSet = set_combine(meleeSet, sets.DNCcape)
	--end
--end
			
			
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
-- If we gain or lose any flurry buffs, adjust gear.
    if S{'flurry'}:contains(buff:lower()) then
        if not gain then
            flurry = nil
            --add_to_chat(122, "Flurry status cleared.")
        end
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

end

-- 

function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function job_update(cmdParams, eventArgs) 
  handle_equipping_gear(player.status)  
end

function job_update(cmdParams, eventArgs)
   equip(sets[state.WeaponSet.current])
   handle_equipping_gear(player.status)  
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end
--

function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'Offense: '..state.OffenseMode.current
    msg = msg .. ', Hybrid: '..state.HybridMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    if state.HasteMode.value ~= 'Normal' then
        msg = msg .. ', Haste: '..state.HasteMode.current
    end
    if state.RangedMode.value ~= 'Normal' then
        msg = msg .. ', Rng: '..state.RangedMode.current
    end
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(123, msg)
    eventArgs.handled = true
end

windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
                end
            end
        end
    end)
	
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
	 if Haste >= 908 then
		classes.CustomMeleeGroups:append('H: 908+')
	elseif Haste > 855 and Haste < 908 then
		classes.CustomMeleeGroups:append('H: 856')
	elseif Haste > 819 and Haste < 856 then
		classes.CustomMeleeGroups:append('H: 819')
	end
	
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MaxHastePlus')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 27 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
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
    end
end
	
function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=4, unlucky=8, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
		["Naturalist's Roll"] = {lucky=3, unlucky=7, bonus="Enhancing Magic Duration"},
		["Runeist's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Evasion"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]

    if rollinfo then
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end

function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1

    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.english == 'Wildfire' or spell.english == 'Leaden Salute' then
                -- magical weaponskills
                bullet_name = gear.MAbullet
            else
                -- physical weaponskills
                bullet_name = gear.WSbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end

    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]

    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end

    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end

    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) -- Aeolian Edge
        --(category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        --(category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 13)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 13)
    elseif player.sub_job == 'RUN' then
        set_macro_page(1, 13)
    else
        set_macro_page(1, 13)
    end
end
