local L = LibStub("AceLocale-3.0"):GetLocale("ExtVendor", true);

local CLASS_PROFICIENCIES = {
    ["DEATHKNIGHT"] = {
        weapons = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Polearm},
    },
    ["DEMONHUNTER"] = {
        weapons = { Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Sword1H },
    },
    ["DRUID"]       = {
        weapons = { Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Unarmed },
    },
    ["HUNTER"]      = {
        weapons = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Crossbow},
    },
    ["MAGE"]        = {
        weapons = { Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Wand },
    },
    ["MONK"]        = {
        weapons = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Unarmed },
    },
    ["PALADIN"]     = {
        weapons = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Polearm },
        canUseShields = true,
    },
    ["PRIEST"]      = {
        weapons = { Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Wand },
    },
    ["ROGUE"]       = {
        weapons = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Unarmed },
    },
    ["SHAMAN"]      = {
        weapons = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Staff },
        canUseShields = true,
    },
    ["WARLOCK"]     = {
        weapons = { Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Wand },
    },
    ["WARRIOR"]     = {
        weapons = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Staff },
        canUseShields = true,
    },
};

local ARMOR_RANKS = {
    [Enum.ItemArmorSubclass.Cloth] = 1,
    [Enum.ItemArmorSubclass.Leather] = 2,
    [Enum.ItemArmorSubclass.Mail] = 3,
    [Enum.ItemArmorSubclass.Plate] = 4,
};

--========================================
-- Retrieve additional item info via the
-- item's tooltip
--========================================
function ExtVendor_GetExtendedItemInfo(link)

    --local _FULLSTART = debugprofilestop();
    --local _START = 0;

    -- set up return values
    local isKnown = false;
    local classes = {};
    local isAccountBound = false;
    local isFoodOrDrink = false;
    local foundClasses = false;

    -- generate item tooltip in hidden tooltip object
    ExtVendorHiddenTooltip:SetOwner(UIParent, "ANCHOR_LEFT");
    
    --_START = debugprofilestop();
    local itemId = ExtVendor_GetItemID(link);
    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.GetItemID = EXTVENDOR.PerfProfile.EII_Tooltip.GetItemID + (debugprofilestop() - _START); end
    
    --_START = debugprofilestop();
    local ok = pcall(ExtVendor_SetHiddenTooltip, link);
    --ExtVendor_SetHiddenTooltip(link);
    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.SetTooltip = EXTVENDOR.PerfProfile.EII_Tooltip.SetTooltip + (debugprofilestop() - _START); end
    
    if (ok) then
    
        for cl = 2, ExtVendorHiddenTooltip:NumLines(), 1 do
            --_START = debugprofilestop();
            local checkLine = _G["ExtVendorHiddenTooltipTextLeft" .. cl]:GetText();
            --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.GetText = EXTVENDOR.PerfProfile.EII_Tooltip.GetText + (debugprofilestop() - _START); end
            if (checkLine) then
                -- check for "Already Known"
                if (not isKnown) then
                    --_START = debugprofilestop();
                    if (checkLine == ITEM_SPELL_KNOWN) then
                        isKnown = true;
                    end
                    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.ParseAlreadyKnown = EXTVENDOR.PerfProfile.EII_Tooltip.ParseAlreadyKnown + (debugprofilestop() - _START); end
                end
                
                -- check if the item is food or drink
                if (not isFoodOrDrink) then
                    --_START = debugprofilestop();
                    if (string.match(checkLine, L["ITEM_USE_FOOD_BASIC"]) or string.match(checkLine, L["ITEM_USE_DRINK_BASIC"]) or string.match(checkLine, L["ITEM_USE_FOOD_DRINK_BASIC"])) then
                        isFoodOrDrink = true;
                    end
                    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.ParseFood = EXTVENDOR.PerfProfile.EII_Tooltip.ParseFood + (debugprofilestop() - _START); end
                end
                
                -- check for battle.net account binding
                if (not isAccountBound) then
                    --_START = debugprofilestop();
                    if (string.match(checkLine, ITEM_BIND_TO_BNETACCOUNT) or string.match(checkLine, ITEM_BIND_TO_ACCOUNT)) then
                        isAccountBound = true;
                    end
                    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.ParseAccountBound = EXTVENDOR.PerfProfile.EII_Tooltip.ParseAccountBound + (debugprofilestop() - _START); end
                end
                
                -- check for "Classes: xxx"
                if (not foundClasses) then
                    --_START = debugprofilestop();
                    local checkClasses = ExtVendor_GetRequiredClasses(checkLine);
                    if (checkClasses) then
                        classes = checkClasses;
                        foundClasses = true;
                    end
                    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.ParseClasses = EXTVENDOR.PerfProfile.EII_Tooltip.ParseClasses + (debugprofilestop() - _START); end
                end
            end
        end
    
    end
    
    --_START = debugprofilestop();
    ExtVendorHiddenTooltip:Hide();
    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.HideTooltip = EXTVENDOR.PerfProfile.EII_Tooltip.HideTooltip + (debugprofilestop() - _START); end
    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.Total = EXTVENDOR.PerfProfile.EII_Tooltip.Total + (debugprofilestop() - _FULLSTART); end
    --if (EXTVENDOR.PerfProfile.EII_Tooltip.Enable) then EXTVENDOR.PerfProfile.EII_Tooltip.ItemCount = EXTVENDOR.PerfProfile.EII_Tooltip.ItemCount + 1; end
    
    return isKnown, classes, itemId, isAccountBound, isFoodOrDrink;
end

function ExtVendor_ScanItemTooltip(link)
    ExtVendorHiddenTooltip:SetOwner(UIParent, "ANCHOR_LEFT");
    local itemId = ExtVendor_GetItemID(link);
    
    local ok = pcall(ExtVendor_SetHiddenTooltip, link);
    if (ok) then
        for cl = 2, ExtVendorHiddenTooltip:NumLines(), 1 do
            local checkLine = _G["ExtVendorHiddenTooltipTextLeft" .. cl]:GetText();
            if (checkLine) then
                print("[" .. cl .. "] " .. checkLine);
                if (string.match(checkLine, L["ITEM_USE_FOOD_BASIC"]) or string.match(checkLine, L["ITEM_USE_DRINK_BASIC"]) or string.match(checkLine, L["ITEM_USE_FOOD_DRINK_BASIC"])) then
                    print("THIS ITEM IS FOOD/DRINK");
                end
            end
        end
    end
    ExtVendorHiddenTooltip:Hide();
end

--========================================
-- Returns an item's ID from the given
-- link
--========================================
function ExtVendor_GetItemID(link)
    if (link) then
        local w;
        for w in string.gmatch(link, "item:(%d+):") do
            return tonumber(w);
        end
    end
    return nil;
end

--========================================
-- Returns a list of required classes
-- based on the "Classes:" line of an
-- item tooltip
--========================================
function ExtVendor_GetRequiredClasses(tooltipString)
    if (string.find(tooltipString, L["CLASSES"])) then
        local out = {};
        local i;
        local className = "";
        for i = string.len(L["CLASSES"]) + 1, string.len(tooltipString), 1 do
            local chr = string.sub(tooltipString, i, i);
            local skipChar = false;
            local finishName = false;
            if (chr == ",") then
                finishName = true;
                skipChar = true;
            elseif (i == string.len(tooltipString)) then
                finishName = true;
            end
            if (not skipChar) then
                className = className .. chr;
            end
            if (finishName) then
                table.insert(out, string.trim(className));
                className = "";
            end
        end

        return out;
    end
    return nil;
end

--========================================
-- Returns whether or not the specified
-- class is in the given list of classes
--========================================
function ExtVendor_ClassIsAllowed(class, classes)
    if (table.maxn(classes) > 0) then
        for index, name in pairs(classes) do
            if (class == name) then
                return true;
            end
        end
        return false;
    end
    return true;
end

--========================================
-- Returns whether or not the character's
-- class can EVER wear armor of the given
-- type (e.g. mages can NEVER wear
-- leather or higher, shamans can NEVER
-- wear plate, etc.)
--========================================
function ExtVendor_IsUsableArmorType(itemClassId, itemSubClassId, slot)
    local maxArmor = select(2, ExtVendor_GetOptimalArmorType());

    if ((itemClassId == Enum.ItemArmorSubclass) and (slot ~= "INVTYPE_CLOAK")) then
        if ((itemSubClassId == Enum.ItemArmorSubclass.Cloth) or (itemSubClassId == Enum.ItemArmorSubclass.Leather) or (itemSubClassId == Enum.ItemArmorSubclass.Mail) or (itemSubClassId == Enum.ItemArmorSubclass.Plate)) then
            if (ARMOR_RANKS[itemSubClassId] > ARMOR_RANKS[maxArmor]) then
                return false;
            end
        elseif (itemSubClassId == Enum.ItemArmorSubclass.Shield) then
            local cls = select(2, UnitClass("player"));
            if (CLASS_PROFICIENCIES[cls].canUseShields) then
                return true;
            end
            return false;
        end
    end
    return true;
end

--========================================
-- Returns whether or not the character's
-- class can use the given weapon type
-- based on class proficiencies
--========================================
function ExtVendor_IsUsableWeaponType(itemClassId, itemSubClassId, slot)
    if (itemClassId == Enum.ItemClass.Weapon) then
        if ((itemSubClassId ~= Enum.ItemArmorSubclass.Generic) and (itemSubClassId ~= Enum.ItemWeaponSubclass.Fishingpole)) then
            local cls = select(2, UnitClass("player"));
            for index, wt in pairs(CLASS_PROFICIENCIES[cls].weapons) do
                if (wt == itemSubClassId) then
                    return true;
                end
            end
            return false;
        end
    end
    return true;
end

--========================================
-- Determine if a piece of armor is the
-- best type for the player's class
-- (cloth/leather/mail/plate)
--========================================
function ExtVendor_IsOptimalArmor(itemClassId, itemSubClassId, slot)
    if (itemClassId == Enum.ItemClass.Armor) then
        if (slot == "INVTYPE_CLOAK") then
            return true;
        end
        if ((itemSubClassId == Enum.ItemArmorSubclass.Cloth) or (itemSubClassId == Enum.ItemArmorSubclass.Leather) or (itemSubClassId == Enum.ItemArmorSubclass.Mail) or (itemSubClassId == Enum.ItemArmorSubclass.Plate)) then
            local opt = ExtVendor_GetOptimalArmorType();
            if (ARMOR_RANKS[itemSubClassId] < ARMOR_RANKS[opt]) then
                --DebugMessage("ExtVendor_IsOptimalArmor(\"" .. type .. "\", \"" .. subType .. "\", \"" .. slot .. "\") = FALSE");
                return false;
            end
        end
    end
    --DebugMessage("ExtVendor_IsOptimalArmor(\"" .. type .. "\", \"" .. subType .. "\", \"" .. slot .. "\") = TRUE");
    return true;
end

--========================================
-- Returns the optimal armor type for the
-- player's class (factors in level for
-- hunters, shamans, paladins and
-- warriors), as well as the highest
-- armor type the class can ever wear
-- (regardless of level)
--========================================
function ExtVendor_GetOptimalArmorType()

    local __, cls = UnitClass("player");
    local lvl = UnitLevel("player");

    local optArmor, maxArmor;

    if ((cls == "MAGE") or (cls == "WARLOCK") or (cls == "PRIEST")) then
        maxArmor = Enum.ItemArmorSubclass.Cloth;
    elseif ((cls == "ROGUE") or (cls == "DRUID") or (cls == "MONK") or (cls == "DEMONHUNTER")) then
        maxArmor = Enum.ItemArmorSubclass.Leather;
    elseif ((cls == "HUNTER") or (cls == "SHAMAN")) then
        maxArmor = Enum.ItemArmorSubclass.Mail;
    elseif ((cls == "PALADIN") or (cls == "WARRIOR") or (cls == "DEATHKNIGHT")) then
        maxArmor = Enum.ItemArmorSubclass.Plate;
    end
    optArmor = maxArmor;
    return optArmor, maxArmor;
end

--========================================
-- Returns if the item in a given bag slot
-- is a part of an equipment set
--========================================
function ExtVendor_IsItemInEquipmentSet(bag, slot)

    local numSets = C_EquipmentSet.GetNumEquipmentSets();
    if (numSets < 1) then return false; end
    
    local setIDs = C_EquipmentSet.GetEquipmentSetIDs();
    --ExtVendor_Message(numSets .. " equipment sets");

    local i, j;
    local infoArray = {};
    for i = 1, numSets do
        local setID = setIDs[i];
        local setName = C_EquipmentSet.GetEquipmentSetInfo(setID);
        --print("Set #" .. setID .. ": " .. setName);
        infoArray = C_EquipmentSet.GetItemLocations(setID, infoArray);
        if (infoArray ~= nil) then
            for j = 0, 19 do
                if (infoArray[j]) then
                    --print("      infoArray " .. j .. ": " .. infoArray[j]);
                    if ((infoArray[j] ~= -1) and (infoArray[j] ~= 0) and (infoArray[j] ~= 1)) then
                        local locIsPlayer, locIsBank, locIsBags, locIsVoidStorage, locSlot, locBag = EquipmentManager_UnpackLocation(infoArray[j]);
                        if (locIsPlayer and locIsBags) then
                            if ((locBag == bag) and (locSlot == slot)) then return true, setName; end
                        end
                    end
                end
            end
        end
    end
    
    return false;

end

--========================================
-- Returns if a given level is 'outdated'
-- (e.g. below a previous level cap from
-- the player's current level)
--========================================
function ExtVendor_IsOutdatedItemLevel(itemLevel, playerLevel)
    local playerExpac = GetExpansionForLevel(playerLevel) or GetServerExpansionLevel()
    local itemExpac = GetExpansionForLevel(itemLevel) or GetServerExpansionLevel()
    -- ToDo:  test above logic (changes were required for 9.0.1

    if (itemExpac > playerExpac) then
        return false, itemExpac, playerExpac
    elseif (itemExpac < (playerExpac - 1)) then
        return true, itemExpac, playerExpac
    else
        return (itemLevel <= playerLevel - 10), itemExpac, playerExpac
    end
end

--========================================
-- Returns whether an item is of a type
-- that can be transmogrified (armor or
-- weapon - excluding rings, etc.)
--========================================
function ExtVendor_ItemIsValidForTransmog(itemClassId, itemSubClassId, equipSlot)
    if ((itemClassId ~= Enum.ItemClass.Armor) and (itemClassId ~= Enum.ItemClass.Weapon)) then return false; end
    if ((equipSlot ~= "INVTYPE_HEAD") and
        (equipSlot ~= "INVTYPE_SHOULDER") and
        (equipSlot ~= "INVTYPE_CLOAK") and
        (equipSlot ~= "INVTYPE_CHEST") and (equipSlot ~= "INVTYPE_ROBE") and
        (equipSlot ~= "INVTYPE_BODY") and
        (equipSlot ~= "INVTYPE_TABARD") and
        (equipSlot ~= "INVTYPE_WRIST") and
        (equipSlot ~= "INVTYPE_HAND") and
        (equipSlot ~= "INVTYPE_WAIST") and
        (equipSlot ~= "INVTYPE_LEGS") and
        (equipSlot ~= "INVTYPE_FEET") and
        (equipSlot ~= "INVTYPE_WEAPON") and
        (equipSlot ~= "INVTYPE_2HWEAPON") and
        (equipSlot ~= "INVTYPE_WEAPONMAINHAND") and
        (equipSlot ~= "INVTYPE_WEAPONOFFHAND") and
        (equipSlot ~= "INVTYPE_HOLDABLE") and
        (equipSlot ~= "INVTYPE_SHIELD") and
        (equipSlot ~= "INVTYPE_RANGED") and
        (equipSlot ~= "INVTYPE_RANGEDRIGHT")) then return false; end
    return true;
end

--========================================
-- Returns whether the player has
-- collected the appearance for the
-- specified item, and/or any other items
-- that share the same appearance
--========================================
function ExtVendor_ItemAppearanceIsOwned(itemId)
    if (not itemId) then return false, false; end
    local itemVisualId, itemSourceId = C_TransmogCollection.GetItemInfo(itemId);
    local sourceInfo = C_TransmogCollection.GetSourceInfo(itemSourceId);
    local found = sourceInfo.isCollected;
    local foundAlt = false;
    local itemName = sourceInfo.name;
    local sources = C_TransmogCollection.GetAllAppearanceSources(sourceInfo.visualID);
    for i, sourceID in ipairs(sources) do
        local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
        if sourceInfo.isCollected then
            foundAlt = true;
        end
    end
    return found, foundAlt;
end
