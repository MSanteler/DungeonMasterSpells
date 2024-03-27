local function OnSessionLoaded()
    ---------------------------------------------------------------------------------------------------

    --                                             DM Spells                                      --

    ---------------------------------------------------------------------------------------------------

    --------------------------------------------- Adds Spells --------------------------------------------
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local Party = Osi.DB_PartyMembers:Get(nil)
        for i = #Party, 1, -1 do 
            AddPlaceCreatureSpells(Party[i][1])
        end
    end)

    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
        AddPlaceCreatureSpells(character)
    end)

    function AddPlaceCreatureSpells(target)
        for _, container in ipairs(SPELL_CONTAINERS) do
            if Osi.HasSpell(target, container) == 0 then
                Osi.AddSpell(target, container, 1, 1)
            end
        end
    end

    ------------------------------------------------- Place Creature ---------------------------------------
    Ext.Osiris.RegisterListener("UsingSpellAtPosition", 8, "after", function(caster, x, y, z, spell, spellType, spellElement, storyActionID)
        local creatureGuid = SPELL_CREATURE_MAP[spell]
        if creatureGuid then
            local creature = CreateAt(creatureGuid, x, y, z, 0, 0, "")
            Osi.SetFaction(creature, 'a66b2d45-1b6c-082d-8a01-c6d975ead314') -- neutral
            Osi.SetCanJoinCombat(creature, 0)
        end
    end)

    -------------------------------------------- Update Combat ---------------------------------------
    Ext.Osiris.RegisterListener("StatusApplied", 4, "before", function(target, statusID, source, _)
        if statusID == "STATUS_DMSP_Util_CanJoinCombat_Yes" then
            Osi.SetCanJoinCombat(target, 1)
            Osi.RemoveStatus(target, 'STATUS_DMSP_Util_CanJoinCombat_Yes', '')
        elseif statusID == "STATUS_DMSP_Util_CanJoinCombat_No" then
            Osi.SetCanJoinCombat(target, 0)
            Osi.RemoveStatus(target, 'STATUS_DMSP_Util_CanJoinCombat_No', '')
        end
    end)

    -------------------------------------------- Update Faction (Alignment) ---------------------------------------
    Ext.Osiris.RegisterListener("StatusApplied", 4, "before", function(target, statusID, source, _)
        if statusID == "STATUS_DMSP_Util_MakeGood" then
            Osi.SetFaction(target, 'b37bfd4c-baed-08f4-9866-290f8bb39e62') -- good
            Osi.RemoveStatus(target, 'STATUS_DMSP_Util_MakeGood', '')
        elseif statusID == "STATUS_DMSP_Util_MakeNeutral" then
            Osi.SetFaction(target, 'a66b2d45-1b6c-082d-8a01-c6d975ead314') -- nuetral
            Osi.RemoveStatus(target, 'STATUS_DMSP_Util_MakeNeutral', '')
        elseif statusID == "STATUS_DMSP_Util_MakeEvil" then
            Osi.SetFaction(target, '4be9261a-e481-8d9d-3528-f36956a19b17') -- evil
            Osi.RemoveStatus(target, 'STATUS_DMSP_Util_MakeEvil', '')
        end
    end)

    Ext.Osiris.RegisterListener("StatusApplied", 4, "before", function(target, statusID, source, _)
        if statusID == "STATUS_DMSP_Util_MakeFollow" then
            Osi.AddPartyFollower(target, source)
            Osi.RemoveStatus(target, 'STATUS_DMSP_Util_MakeFollow', '')
        elseif statusID == "STATUS_DMSP_Util_MakeUnfollow" then
            Osi.RemovePartyFollower(target, source)
            Osi.RemoveStatus(target, 'STATUS_DMSP_Util_MakeUnfollow', '')
        end
    end)
    
end
Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)