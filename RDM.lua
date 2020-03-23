-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Composure
--              [ CTRL+- ]          Light Arts/Addendum: White
--              [ CTRL+= ]          Dark Arts/Addendum: Black
--              [ CTRL+; ]          Celerity/Alacrity
--              [ ALT+[ ]           Accesion/Manifestation
--              [ ALT+; ]           Penury/Parsimony
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+Q ]           Temper
--              [ ALT+W ]           Flurry II
--              [ ALT+E ]           Haste II
--              [ ALT+R ]           Refresh II
--              [ ALT+Y ]           Phalanx
--              [ ALT+O ]           Regen II
--              [ ALT+P ]           Shock Spikes
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad1 ]    Sanguine Blade
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--              Addendum Commands:
--              Shorthand versions for each strategem type that uses the version appropriate for
--              the current Arts.
--                                          Light Arts                  Dark Arts
--                                          ----------                  ---------
--              gs c scholar light          Light Arts/Addendum
--              gs c scholar dark                                       Dark Arts/Addendum
--              gs c scholar cost           Penury                      Parsimony
--              gs c scholar speed          Celerity                    Alacrity
--              gs c scholar aoe            Accession                   Manifestation
--              gs c scholar addendum       Addendum: White             Addendum: Black


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    state.CP = M(false, "Capacity Points Mode")
    state.Buff.Saboteur = buffactive.Saboteur or false
	state.Buff.Enspell = buffactive['buffs.Enfire'] or buffactive.Enblizzard or buffactive.Enaero or
		buffactive.Enstone or buffactive.Enthunder or buffactive.Enwater or false
	
    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle',
        'Frazzle II',  'Gravity', 'Gravity II', 'Silence', 'Sleep', 'Sleep II', 'Sleepga'}
    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}
    enfeebling_magic_effect = S{'Dia', 'Dia II', 'Dia III', 'Diaga'}

    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}
		
    lockstyleset = 100
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')
	state.CombatWeapon = M{['description']='Combat Weapon'}
		if S{'NIN', 'DNC'}:contains(player.sub_job) then
			state.CombatWeapon:options('Su5Daybreak', 'Su5Tauret', 'NaeglingThibron', 'MaxThibron', 'NaeglingTauret', 'NoTP', 'None')
		else
			state.CombatWeapon:options('Su5', 'None')
		end

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.CP = M(false, "Capacity Points Mode")
    state.RingLock = M(false, 'Ring Lock')

    send_command('bind !` gs c toggle MagicBurst')

    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')
	send_command('bind @e  gs c cycle CombatWeapon')

	send_command('bind numpad7 input /ma "Haste II" <stpt>')
	send_command('bind numpad8 input /ma "Refresh III" <stpt>')
	send_command('bind numpad9 input /ma "Flurry II" <stpt>')
	
    select_default_macro_book()
    set_lockstyle()
	
    state.Auto_Kite = M(false, 'Auto_Kite')  
	Haste = 0
	DW_needed = 0  
	DW = false  
	moving = false  
	update_combat_form()  
	determine_haste_group()  

end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
	send_command('unbind !e')
	send_command('unbind !r')
	send_command('unbind @f8')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	Succelos_MND = {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}}
	Succelos_INT = {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}}
	Succelos_TP = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Damage taken-5%',}}
	Succelos_STP = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	Succelos_WS_MND = {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}}
	Succelos_WS_STR = {name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	Succelos_crit = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Crit.hit rate+10',}}
	
	Ghostfyre = {name="Ghostfyre Cape", augments={'Enfb.mag. skill +2','Enha.mag. skill +9','Mag. Acc.+5','Enh. Mag. eff. dur. +17',}}
	
	-- Weapon sets
	sets.weapons = {}
	sets.weapons.None = {}
	sets.weapons.Su5Daybreak = {main="Crocea Mors", sub='Daybreak'}
	sets.weapons.Su5Tauret = {main="Crocea Mors", sub='Ternion Dagger +1'}
	sets.weapons.NaeglingThibron = {main='Naegling',  sub={name="Thibron", augments={'TP Bonus +1000',}}}
	sets.weapons.MaxThibron = {main='Maxentius',  sub={name="Thibron", augments={'TP Bonus +1000',}}}
	sets.weapons.NaeglingTauret = {main='Naegling', sub='Ternion Dagger +1'}
	sets.weapons.Su5 = {main="Crocea Mors", sub='Genmei Shield'}
	sets.weapons.NoTP = {main="Aern Dagger", sub="Wind Knife +1"}
	
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},}

    -- Fast cast sets for spells

    -- Fast cast sets for spells
    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		legs="Gyve Trousers",
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		left_ear="Malignance Earring",
		right_ear="Etiolation Earring",
		left_ring="Rahab Ring",
		right_ring="Kishar Ring",
		back="Swith Cape",
	}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ear1="Mendi. Earring", --5
        ring1="Lebeche Ring", --(2)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC['Healing Magic'] = sets.precast.FC.Cure
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})
	
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {
		head=empty,
		body="Twilight Cloak",
	})
	
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {
		main="Daybreak",
	})
	
    sets.precast.Storm = set_combine(sets.precast.FC)

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		head={name="Viti. Chapeau +3"},
		hands="Atrophy Gloves +3",
		back=Succelos_WS_MND,
	}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
		ammo="Yetshila +1",
		head={ name="Taeon Chapeau", augments={'Accuracy+25','Crit.hit rate+2','Crit. hit damage +3%',}},
		body="Ayanmo Corazza +2",
		hands="Malignance Gloves",
		legs={ name="Taeon Tights", augments={'Accuracy+23','"Triple Atk."+2','DEX+9',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Mache Earring",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back=Succelos_crit,
	})

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {})

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		ammo="Regal Gem",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Caro Necklace",
		waist="Prosilio Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Shukuyu Ring",
		right_ring="Epaminondas's Ring",
		back=Succelos_WS_STR,
	})

    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {})

    sets.precast.WS['Death Blossom'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Death Blossom'].Acc = sets.precast.WS['Savage Blade'].Acc

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        ear2="Sherida Earring",
        })

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {})

    sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body=gear.Amalric_body_A,
		hands="Jhakri Cuffs +2",
		legs=gear.Amalric_legs_A,
		feet=gear.Amalric_feet_D,
		neck="Baetyl Pendant",
		waist="Refoccilation Stone",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back=Succelos_WS_MND,
	}

	sets.precast.WS['Seraph Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {
		head="Jhakri Coronal +2",
		right_ring="Shiva Ring +1",
		right_ear="Moonshade Earring",
		right_ring="Weather. Ring",
	})
	
	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {}

    sets.midcast.Cure = {
		ammo="Regal Gem",
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Kaykaus Cuffs +1",
		legs="Atrophy Tights +1",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Nodens Gorget",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Roundel Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=Succelos_MND,
	}

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
		main="Chatoyant Staff",
		waist="Hachirin-no-Obi",
	})

    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
        waist="Gishdubar Sash", -- (10)
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})

    sets.midcast.StatusRemoval = {}

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, { 
		neck="Malison medallion",
		left_ring="Ephedra Ring",
		right_ring="Ephedra Ring",
	})

    sets.midcast['Enhancing Magic'] = {
		main=gear.Colada_enh,
		sub="Ammurapi Shield",
		head="Leth. Chappel +1",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Leth. Fuseau +1",
		feet="Leth. Houseaux +1",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		back=Ghostfyre,
	}

    sets.midcast.EnhancingDuration = {
		main=gear.Colada_enh,
		sub="Ammurapi Shield",
		head="Leth. Chappel +1",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'Spell interruption rate down -3%','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +1",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		back=Ghostfyre,
	}

    sets.midcast.EnhancingSkill = {
		main="Pukulatmuj +1",
		sub="Pukulatmuj",
		head="Befouled Crown",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Viti. Gloves +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Leth. Houseaux +1",
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=Ghostfyre,
	}
	

    sets.midcast.GainSpell = {
        hands="Viti. Gloves +2",
    }


    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {})

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
		head=gear.Amalric_head_A,
		body="Atrophy Tabard +3",
		legs="Leth. Fuseau +1",
	})

    sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
        waist="Gishdubar Sash",
    })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
    })

    sets.midcast['Phalanx'] = set_combine(sets.midcast.EnhancingDuration, {
		head={ name="Taeon Chapeau", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		body={ name="Taeon Tabard", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'Phalanx +3',}},
		legs={ name="Taeon Tights", augments={'Phalanx +3',}},
		feet={ name="Taeon Boots", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	})

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
		head=gear.Amalric_head_A,
		hands="Regal Cuffs",
	})
	
    sets.midcast.Storm = sets.midcast.EnhancingDuration
    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

     -- Custom spell classes
    sets.midcast.MndEnfeebles = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enhances "Dia III" effect','Enhances "Slow II" effect',}},
		body="Atrophy Tabard +3",
		hands="Kaykaus Cuffs +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','MND+8','Mag. Acc.+9','"Mag.Atk.Bns."+10',}},	
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=Succelos_MND,
	}

    sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
		main="Daybreak",
		sub="Ammurapi Shield",
		range="Ullr",
		ammo=empty,
		head={ name="Viti. Chapeau +3", augments={'Enhances "Dia III" effect','Enhances "Slow II" effect',}},
		body="Atrophy Tabard +3",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','MND+8','Mag. Acc.+9','"Mag.Atk.Bns."+10',}},	
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
	})
	
    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		main="Maxentius",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+28','INT+12',}},
		back=Succelos_INT,
	})

    sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.MndEnfeeblesAcc, {
		main="Maxentius",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+28','INT+12',}},
		back=Succelos_INT,
	})

    sets.midcast.SkillEnfeebles = {
		main=gear.Grio_enf,
		sub="Mephitis Grip",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Snotra Earring",
		right_ear="Vor Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=Succelos_MND,
	}

    sets.midcast.EffectEnfeebles = {
		main=gear.Grio_enf,
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enhances "Dia III" effect','Enhances "Slow II" effect',}},
		body="Lethargy Sayon +1",
		hands="Kaykaus Cuffs +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','MND+8','Mag. Acc.+9','"Mag.Atk.Bns."+10',}},	
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=Succelos_MND,
	}

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dia III'] = set_combine(sets.midcast.MndEnfeebles, sets.midcast.EffectEnfeebles, {})
    sets.midcast['Paralyze II'] = set_combine(sets.midcast.MndEnfeebles, {body="Atrophy Tabard +3"})
    sets.midcast['Slow II'] = set_combine(sets.midcast.MndEnfeebles, {body="Atrophy Tabard +3"})

    sets.midcast['Dark Magic'] = {}

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Aspir = sets.midcast.Drain
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {waist="Luminary Sash"})

    sets.midcast['Elemental Magic'] = {
		main="Maxentius",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Mag. Acc.+13','"Mag.Atk.Bns."+15',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs=gear.Amalric_legs_A,
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Refoccilation Stone",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Shiva Ring +1",
		back=Succelos_MND,
	}

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast.Impact = set_combine(sets.midcast.MndEnfeeblesAcc, {
		head=empty,
		body="Twilight Cloak",	
	})
	
	sets.midcast.Dispelga = set_combine(sets.midcast.MndEnfeeblesAcc, {
		main="Daybreak",
		sub="Ammurapi Shield",
	})
	
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    -- Job-specific buff sets
    sets.buff.ComposureOther = {
		main=gear.Colada_enh,
		sub="Ammurapi Shield",
		head="Leth. Chappel +1",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Leth. Fuseau +1",
		feet="Leth. Houseaux +1",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		back=Ghostfyre,
	}

    sets.buff.Saboteur = {hands="Leth. Gantherots +1"}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enhances "Dia III" effect','Enhances "Slow II" effect',}},
		body="Shamash Robe",
		hands={ name="Chironic Gloves", augments={'MND+1','"Avatar perpetuation cost" -3','"Refresh"+1','Accuracy+6 Attack+6','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		feet={ name="Chironic Slippers", augments={'AGI+1','Attack+18','"Refresh"+1','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonlight Cape",
	}
	

    sets.idle.DT = set_combine(sets.idle, {
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Digni. Earring",
		left_ring="Defending Ring",
		right_ring="Hetairoi Ring",
		back=Succelos_STP,
	})

    sets.idle.Town = set_combine(sets.idle, {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Shamash Robe",
		hands="Regal Cuffs",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Chironic Slippers", augments={'AGI+1','Attack+18','"Refresh"+1','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonlight Cape",
	})

    sets.idle.Weak = sets.idle.DT

    sets.resting = set_combine(sets.idle, {})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.magic_burst = {
		main="Maxentius",
		sub="Genmei Shield",
		ammo="Pemphredo Tathlum",
		head=gear.Merlinic_MB_head,
		body=gear.Merlinic_MB_body,
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs=gear.Merlinic_MB_legs,
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Mizu. Kubikazari",
		waist="Refoccilation Stone",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back="Seshaw Cape",
	}

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		back=Succelos_TP,
	}

    sets.engaged.MidAcc = set_combine(sets.engaged, {})

    sets.engaged.HighAcc = set_combine(sets.engaged, {})

	-- DW sets
    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = set_combine(sets.engaged, {
		--legs="Carmine Cuisses +1",
		--feet=gear.Taeon_DW,
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		back=Succelos_TP,
	}) --41

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW, {})
    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {})

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {}) --41
    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {})
    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {})

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
		legs="Malignance Tights",
		feet="Malignance Boots",
	}) --41
    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {})
    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {})

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {}) --26
    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {})
    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {})

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW, {
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		back=Succelos_TP,
	}) --10

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
	})

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		neck="Combatant's Torque",
		waist="Reiki Yotai",
		right_ear="Digni. Earring",
		back=Succelos_STP,
	})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        neck="Loricate Torque +1", --6/6
        ring2="Defending Ring", --10/10
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
    }

    sets.Obi = {waist="Hachirin-no-Obi"}
	sets.ObiMelee = {hands="Aya. Manopolas +2", waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
	sets.Orpheus = {waist="Orpheus's Sash"}
	sets.OrpheusMelee = {hands="Aya. Manopolas +2", waist="Orpheus's Sash"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
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
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.name == 'Dispelga' then
		equip(sets.precast.FC.Dispelga)
	end
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
    if spell.english == "Phalanx II" and spell.target.type == 'SELF' then
        cancel_spell()
        send_command('@input /ma "Phalanx" <me>')
    end
	if spell.type == 'WeaponSkill' then
		if spell.english == 'Sanguine Blade' or spell.english == 'Seraph Blade' then
			if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
				equip(sets.Obi)
			elseif spell.target.distance < (1.7 + spell.target.model_size) then
				equip(sets.Orpheus)
			elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip(sets.Obi)
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip(sets.Orpheus)
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip(sets.Obi)
            end	
		end
	end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' then
        if enfeebling_magic_skill:contains(spell.english) or enfeebling_magic_effect:contains(spell.english) then
            if spell.type == "WhiteMagic" then
                equip(sets.midcast.MndEnfeeblesAcc)
            else
                equip(sets.midcast.IntEnfeeblesAcc)
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' then
        if enfeebling_magic_skill:contains(spell.english) then
            equip(sets.midcast.SkillEnfeebles)
        elseif enfeebling_magic_effect:contains(spell.english) then
            equip(sets.midcast.EffectEnfeebles)
        end
        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end
    end
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
                if spell.target.type == 'SELF' then
                    equip (sets.midcast.RefreshSelf)
                end
            end
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        elseif spell.english:startswith('Gain') then
            equip(sets.midcast.GainSpell)
        end
        if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure then
            equip(sets.buff.ComposureOther)
        end
    end
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end
	
	if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
	
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub', 'range')
    else
        enable('main','sub', 'range')
    end
    if state.RingLock.value == true then
        disable('ring1','ring2')
    else
        enable('ring1','ring2')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == 'Engaged' then
        update_combat_form()
    end
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    
    update_combat_form()
    determine_haste_group()
    --check_moving()

end

function job_update(cmdParams, eventArgs)
    update_combat_form()
	determine_haste_group()
	handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == "WhiteMagic" then
                if  enfeebling_magic_effect:contains(spell.english) then
                    return "EffectEnfeebles"
                elseif not enfeebling_magic_skill:contains(spell.english) then
                    if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                        return "MndEnfeeblesAcc"
                    else
                        return "MndEnfeebles"
                    end
                end
            elseif spell.type == "BlackMagic" then
                if  enfeebling_magic_effect:contains(spell.english) then
                    return "EffectEnfeebles"
                elseif not enfeebling_magic_skill:contains(spell.english) then
                    if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                        return "IntEnfeeblesAcc"
                    else
                        return "IntEnfeebles"
                    end
                end
            elseif spell.name == "Frazzle II" then
				return "MndEnfeeblesAcc"
			else
                return "MndEnfeebles"
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
     elseif state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

--function to equip set weapons when engaging 
function customize_melee_set(meleeSet)
	if state.CombatWeapon.value ~= 'None' then
		meleeSet = set_combine(meleeSet, sets.weapons[state.CombatWeapon.value])
	end
	
	if player.equipment.main == 'Crocea Mors' then
		if buffactive[94] then --Enfire
			if world.weather_element == "Fire" and get_weather_intesity() == 2 then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			elseif world.day_element == "Fire" and world.weather_element == "Fire" then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			else
				meleeSet = set_combine(meleeSet, sets.OrpheusMelee)
			end
		elseif buffactive[95] then --Enblizzard
			if world.weather_element == "Ice" and get_weather_intensity() == 2 then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			elseif world.day_element == "Ice" and world.weather_element == "Ice" then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			else
				meleeSet = set_combine(meleeSet, sets.OrpheusMelee)
			end
		elseif buffactive[96] then --Enaero
			if world.weather_element == "Wind" and get_weather_intensity() == 2 then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			elseif world.day_element == "Wind" and world.weather_element == "Wind" then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			else
				meleeSet = set_combine(meleeSet, sets.OrpheusMelee)
			end
		elseif buffactive[97] then --Enstone
			if world.weather_element == "Earth" and get_weather_intensity() == 2 then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			elseif world.day_element == "Earth" and world.weather_element == "Earth" then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			else
				meleeSet = set_combine(meleeSet, sets.OrpheusMelee)
			end
		elseif buffactive[98] then --Enthunder
			if world.weather_element == "Lightning" and get_weather_intensity() == 2 then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			elseif world.day_element == "Lightning" and world.weather_element == "Lightning" then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			else
				meleeSet = set_combine(meleeSet, sets.OrpheusMelee)
			end
		elseif buffactive[99] then --Enwater
			if world.weather_element == "Water" and get_weather_intensity() == 2 then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			elseif world.day_element == "Water" and world.weather_element == "Water" then
				meleeSet = set_combine(meleeSet, sets.ObiMelee)
			else
				meleeSet = set_combine(meleeSet, sets.OrpheusMelee)
			end
		end
	end
	
	return meleeSet 
end

function get_weather_intensity()
	return gearswap.res.weather[world.weather_id].intensity
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
--function display_current_job_state(eventArgs)
    --display_current_caster_state()
    --eventArgs.handled = true
--end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = '[ Melee'

    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end

    msg = msg .. ': '

    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value .. ' ]'

    if state.DefenseMode.value ~= 'None' then
        msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
    end

    if state.IdleMode.value ~= 'None' then
        msg = msg .. '[ Idle: ' .. state.IdleMode.value .. ' ]'
    end

    if state.Kiting.value then
        msg = msg .. '[ Kiting Mode: ON ]'
    end

    add_to_chat(060, msg)

	display_current_caster_state()
	
    eventArgs.handled = true
end

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
            classes.CustomMeleeGroups:append('MaxHaste')
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

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 9)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end