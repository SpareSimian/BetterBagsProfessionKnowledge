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

local debugging = nil
local misses = {} -- for DevTool debugging
if debugging and DevTool then DevTool:AddData(misses, "BetterBagsProfessionKnowledge misses") end -- type /dev to view the table

local function addMiss(data, reason)
   if debugging and DevTool then
      misses[data.itemInfo.itemName] = reason
   end
end

categories:RegisterCategoryFunction("ProfessionKnowledgeFilter", function (data)

   -- addMiss(data, "testing")

   -- avoid tooltip scan for older stuff
   if data.itemInfo.expacID < LE_EXPANSION_DRAGONFLIGHT then
      addMiss(data, "wrong expacID")
      return nil
   end

   local tooltipInfo = C_TooltipInfo.GetOwnedItemByID(data.itemInfo.itemID)
   local found = nil

   for k,v in pairs(tooltipInfo.lines) do
      if (v.type == 0) or (v.type == 20) or (v.type == 23) or (v.type == 29) then
         -- we cheat and assume expansion is two words. Fix pattern if that assumption breaks with a future expansion
         local found, _, expansion, profession, amount = string.find(v.leftText, "Use: Study to increase your (%a+ %a+) (%a+) Knowledge by (%d+)")
         -- addon:Print(data.itemInfo.itemName .. ": '" .. v.leftText .. "' " .. tostring(found))
         if found then
            return "|cff" .. addon.color .. "Knowledge - " .. profession .. " - " .. expansion .. "|r"
         end
      end
   end

   if debugging then
      -- dump all the tooltip lines
      addMiss(data, tooltipInfo)
   end

   return nil
end)
