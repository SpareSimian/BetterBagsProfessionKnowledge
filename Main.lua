local addonName, addon = ...
LibStub('AceAddon-3.0'):NewAddon(addon, addonName, 'AceConsole-3.0')

-- required API to do tooltip scanning
if not C_TooltipInfo or not C_TooltipInfo.GetOwnedItemByID then
  return
end

local bb = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
local categories = bb:GetModule('Categories')
-- local L = bb:GetModule('Localization')

-- section title color: 6 hex digits here for RRGGBB, could come from a setting
addon.color = "00c0ff"

-- example string:
--   Use: Study to increase your Dragon Isles mining Knowledge by 1

categories:RegisterCategoryFunction("ProfessionKnowledgeFilter", function (data)

   -- avoid tooltip scan for older stuff
   if data.itemInfo.expacID < LE_EXPANSION_DRAGONFLIGHT then
      return nil
   end

   local tooltipInfo = C_TooltipInfo.GetOwnedItemByID(data.itemInfo.itemID)
  
   for k,v in pairs(tooltipInfo.lines) do
      if v.type == 0 then
         -- we cheat and assume expansion is two words. Fix pattern if that assumption breaks with a future expansion
         local found, _, expansion, profession, amount = string.find(v.leftText, "Use: Study to increase your (%a+ %a+) (%a+) Knowledge by (%d+)")
         -- addon:Print(data.itemInfo.itemName .. ": '" .. v.leftText .. "' " .. tostring(found))
         if found then
            return "|cff" .. addon.color .. "Knowledge - " .. profession .. " - " .. expansion .. "|r"
         end
      end
   end

   return nil
end)
