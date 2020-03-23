-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+D ]           Toggle Death Casting Mode Toggle
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+P ]           Shock Spikes
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad0 ]    Myrkr
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


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

    degrade_array = {
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'}
        }

    lockstyleset = 80

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.CastingMode:options('Normal', 'Resistant', 'Spaekona', 'Occult')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.DeathMode = M(false, 'Death Mode')
    state.CP = M(false, "Capacity Points Mode")

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder'}

    send_command('bind ^` input /ma Stun <t>')
    send_command('bind !` gs c toggle MagicBurst')
	send_command('bind @w gs c toggle WeaponLock')
	send_command('bind @d gs c toggle DeathMode')
	
    select_default_macro_book()
    set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    ---- Precast Sets ----

    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = {
        feet="Wicce Sabots +1",
        back=gear.Taranus_MAB,
        }

    sets.precast.JA.Manafont = {}

    -- Fast cast sets for spells
    sets.precast.FC = {
    --    /RDM --15
        ammo="Sapience Orb", --2
        head=gear.Amalric_head_A, --11
        body="Zendik Robe", --13
		body=gear.Merlinic_FC_hands,
        legs="Psycloth Lappas", --7
        feet=gear.Merlinic_FC_feet,
        neck="Baetyl Pendant", --5
		ear1="Malignance Earring",
        ear2="Loquacious Earring", --2
        left_ring="Rahab Ring",
		right_ring="Kishar Ring",
		waist="Witful Belt", --3/(3)
		back="Swith Cape",
    }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
    })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {ear1="Barkaro. Earring"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ear1="Mendi. Earring", --5
        ring1="Lebeche Ring", --(2)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.Storm = set_combine(sets.precast.FC, {})

    sets.precast.FC.DeathMode = {
		main=gear.Lathi_C,
		sub="Niobid Strap",
		ammo="Psilomene",
		head=gear.Amalric_head_A,
		body="Zendik Robe",
		hands=gear.Merlinic_FC_hands,
		legs=gear.Amalric_legs_A,
		feet=gear.Amalric_feet_D,
		neck="Baetyl Pendant",
		waist="Witful Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Rahab Ring",
		right_ring="Mephitas's Ring +1",
		back="Bane Cape",
    }

    sets.precast.FC.Impact.DeathMode = set_combine(sets.precast.FC.DeathMode, {head=empty, body="Twilight Cloak"})

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Vidohunir'] = {} -- INT

    sets.precast.WS['Myrkr'] = {
		ammo="Psilomene",
		head=gear.Amalric_head_A,
		body=gear.Amalric_body_A,
		hands=gear.Amalric_hands_D,
		legs=gear.Amalric_legs_A,
		feet=gear.Amalric_feet_D,
		neck="Dualism Collar +1",
		waist="Luminary Sash",
		left_ear="Etiolation Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Mephitas's Ring +1",
		right_ring="Mephitas's Ring",
		back="Bane Cape",
	} -- Max MP


    ---- Midcast Sets ----

    sets.midcast.FastRecast = {} -- Haste

    sets.midcast.Cure = {
        ammo="Hydrocera",
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +7%','HP+42',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Nodens Gorget",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Roundel Earring",
		left_ring="Stikini Ring +1",
		right_ring="Lebeche Ring",
    }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {})

    sets.midcast['Enhancing Magic'] = {}

    sets.midcast.EnhancingDuration = {}

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {})

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head=gear.Amalric_head_A,
        --feet="Inspirited Boots",
        waist="Gishdubar Sash",
        --back="Grapevine Cape",
    })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
    })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        ammo="Staunch Tathlum +1",
        head=gear.Amalric_head_A,
		hands="Regal Cuffs",
        ring1="Freke Ring",
        ring2="Evanescence Ring",
        waist="Emphatikos Rope",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast.MndEnfeebles = {
        main=gear.Grio_enf,
		sub="Enki Strap",
		ammo="Hydrocera",
		head="Befouled Crown",
		body="Spaekona's Coat +2",
		hands="Regal Cuffs",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Medium's Sabots", augments={'MP+50','MND+10','"Conserve MP"+7','"Cure" potency +5%',}},
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.Taranus_MAB,
	}

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {}) -- INT/Magic accuracy

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dark Magic'] = {
        sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head=gear.Merlinic_nuke_head,
		body="Jhakri Robe +2",
		hands="Regal Cuffs",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=gear.Taranus_MAB,
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        feet="Merlinic Crackows",
        ear1="Hirudinea Earring",
        ring1="Evanescence Ring",
        ring2="Archon Ring",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Death = {
		main=gear.Lathi_C,
		sub="Niobid Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Mizu. Kubikazari",
		waist="Refoccilation Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Archon Ring",
		right_ring="Mephitas's Ring +1",
		back=gear.Taranus_MAB,
	}

    sets.midcast.Death.Resistant = set_combine(sets.midcast.Death, {})

    sets.midcast.Death.Occult = set_combine(sets.midcast.Death, {})

    -- Elemental Magic sets

    sets.midcast['Elemental Magic'] = {
        main=gear.Lathi_C,
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head=gear.Merlinic_nuke_head,
        body=gear.Amalric_body_A,
        hands=gear.Amalric_hands_D,
        legs=gear.Amalric_legs_A,
        feet=gear.Amalric_feet_D,
        neck="Baetyl Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Shiva Ring +1",
        back=gear.Taranus_MAB,
        waist="Refoccilation Stone",
        }

    sets.midcast['Elemental Magic'].DeathMode = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {sub="Khonsu"})

    sets.midcast['Elemental Magic'].Spaekona = set_combine(sets.midcast['Elemental Magic'], {
        body="Spaekona's Coat +2",
	})

    sets.midcast['Elemental Magic'].Occult = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
    })

    sets.midcast.Impact.Resistant = set_combine(sets.midcast['Elemental Magic'].Resistant, {})

    sets.midcast.Impact.Occult = set_combine(sets.midcast.Impact, {})

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    sets.resting = {
        main="Chatoyant Staff",
    }

    -- Idle sets

    sets.idle = {
        head="Befouled Crown",
        body="Shamash Robe",
        legs="Assid. Pants +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
    }

    sets.idle.DT = set_combine(sets.idle, {
		main="Malignance Pole",
		sub="Khonsu",
		ammo="Staunch Tathlum +1",
		neck="Loricate Torque +1",
		waist="Fucho-no-Obi",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Mephitas's Ring +1",
		back=gear.Taranus_MAB,
	})

    sets.idle.ManaWall = {
        feet="Wicce Sabots +1",
        back=gear.Taranus_MAB,
    }

    sets.idle.DeathMode = {}

    sets.idle.Town = set_combine(sets.idle, {})

    sets.idle.Weak = sets.idle.DT

    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Herald's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}
    sets.latent_dt = {}

    sets.magic_burst = {
		head=gear.Merlinic_MB_head,
        body=gear.Merlinic_MB_body, --10
        hands="Amalric Gages +1", --(6)
        legs=gear.Merlinic_MB_legs, --2
        feet=gear.Amalric_feet_D, --11
        neck="Mizu. Kubikazari", --10
        ring2="Mujin Band", --(5)
        back=gear.BLM_MAB_Cape, --5
    }

    sets.magic_burst.Resistant = {}
	
	sets.magic_burst.Spaekona = set_combine(sets.magic_burst, {
		body="Spaekona's Coat +2",
		feet="Jhakri Pigaches +2",
	})
	
    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group

    sets.engaged = {}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        waist="Gishdubar Sash", --10
        }

    sets.DarkAffinity = {head="Pixie Hairpin +1",ring2="Archon Ring"}
    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        equip(sets.precast.FC.DeathMode)
        if spell.english == "Impact" then
            equip(sets.precast.FC.Impact.DeathMode)
        end
    end
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        if spell.skill == 'Elemental Magic' then
            equip(sets.midcast['Elemental Magic'].DeathMode)
        else
            if state.CastingMode.value == "Resistant" then
                equip(sets.midcast.Death.Resistant)
            else
                equip(sets.midcast.Death)
            end
        end
    end

    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) and not state.DeathMode.value then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
    if spell.skill == 'Elemental Magic' and spell.english == "Comet" then
        equip(sets.DarkAffinity)
    end
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            if state.CastingMode.value == "Spaekona" then
                equip(sets.magic_burst.Spaekona)
            else
                equip(sets.magic_burst)
            end
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" or spell.english == "Sleepga II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" or spell.english == "Breakga" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock armor when Mana Wall buff is lost.
    if buff== "Mana Wall" then
        if gain then
            --send_command('gs enable all')
            equip(sets.precast.JA['Mana Wall'])
            --send_command('gs disable all')
        else
            --send_command('gs enable all')
            handle_equipping_gear(player.status)
        end
    end

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

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-- latent DT set auto equip on HP% change
    windower.register_event('hpp change', function(new, old)
        if new<=25 then
            equip(sets.latent_dt)
        end
    end)


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.DeathMode.value then
        idleSet = sets.idle.DeathMode
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if player.hpp <= 25 then
        idleSet = set_combine(idleSet, sets.latent_dt)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if buffactive['Mana Wall'] then
        idleSet = set_combine(idleSet, sets.precast.JA['Mana Wall'])
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.precast.JA['Mana Wall'])
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Mana Wall'] then
        defenseSet = set_combine(defenseSet, sets.precast.JA['Mana Wall'])
    end

    return defenseSet
end


-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.DeathMode.value then
        msg = msg .. ' Death: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if aspirs:contains(spell.name) then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 14)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end