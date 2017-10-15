--[[ __________StylePoints by Tigs (Kronos1)__________
	This addon loads 5 32x32 tga files from /images/
	( 1.tga, 2.tga, 3.tga, 4.tga & 5.tga )
	and displays them on 5 frames which are shown or hidden depending
	on how many combo points you have on your current target.
	Some of the technical stuff in this addon was nicked from 
	ComboEnergyBar by CrowGoblin. Thanks go to him!
	The mushroom tga's were nicked from Mofified Power Auras by Shiro.

	Change the images to whatever you like! but make sure your images
	are sized by a power of 2. (32x32 .. 64x64 etc) --]]

local StylePoints_Version = 1.0;	-- 26/10/16
local SP_color = "|cffffaa22Style|r|cffeedd00Points|r:  "
local SP_framesize = 32;

--[[ functions:
StylePoints_OnLoad()			-- registers the events & slash command
StylePoints_SlashHandler 		-- handles slash commands (duh!)
StylePoints_ReDrawFrames() 		-- reposition / resize frames if settings change
StylePoints_UpdateComboFrames()	-- hide or show frames based on combo points 
StylePoints_OnEvent() 			-- event handler
StylePoints_CreateFrames() 		-- creates the 5 frames and sets the textures
StylePoints_ChangeSetting(msg) 	-- change one of the settings via slash cmd (/set)
StylePoints_ListSettings()		-- list current settings (/list)
StylePoints_Print(msg)			-- print a message in current default chat frames (if there is one) --]]

local StylePoints_DefaultConfig = {	-- the matching saved variable is just StylePoints_Config
	version = StylePoints_Version,
	hpad = 34,						-- (horizontal padding) default is 34, 32 px wide plus a 2 px gap
	vpad = 0,						-- (vertical padding) default zero for horizontal arrangement
	hpos = 0,						-- (horizontal position) default zero for centre screen
	vpos = -150,					-- (vertical position) default 150 px under centre screen
	scale = 1,						-- 0 -> 1 -> whatever, default 1
	alpha = 1,						-- 0 -> 1, default full solid (1)
	singlemode = false				-- if set to true, only the image for the current number of points is diplayed
};

-- other vars (not saved)
local combo_points = 0;
local test_mode = false;

local SPRogueClass = "Rogue";		-- check for rogue or druid class 
local SPDruidClass = "Druid";		-- nicked from ComboEnergyBar by CrowGoblin
if (GetLocale() == "frFR") then		-- Thanks to Morgeagnac e Arkantor for the French translation
	SPRogueClass = "Voleur";
	SPDruidClass = "Druide";
elseif (GetLocale() == "deDE") then	-- Thanks to Cherub and Dwain for the German translation
	SPRogueClass = "Schurke";
	SPDruidClass = "Druide";
end

function StylePoints_OnLoad()
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("VARIABLES_LOADED");			-- once the frame info is loaded create the frames
	this:RegisterEvent("PLAYER_AURAS_CHANGED");		-- druids only, to check for form change
	this:RegisterEvent("PLAYER_TARGET_CHANGED");	-- target change means combo point change
	this:RegisterEvent("PLAYER_ENTERING_WORLD");	-- check player class, unregister events as required
	SlashCmdList["StylePointsCOMMAND"] = StylePoints_SlashHandler;
	SLASH_StylePointsCOMMAND1 = "/stylepoints";
	SLASH_StylePointsCOMMAND2 = "/stp";
end

function StylePoints_SlashHandler(msg)
	local cmd = string.lower(msg);
	if (cmd == "test") then							-- toggle test mode
		if (test_mode) then
			test_mode = false;
			StylePoints_Print("test mode off.");
		else
			test_mode = true;
			StylePoints_Print("test mode on.");
		end
		StylePoints_UpdateComboFrames();
		return;
	elseif (cmd == "reset") then					-- reset config to defaults (needs to be above 'set'!)
		StylePoints_Config = StylePoints_DefaultConfig;
		StylePoints_Print("settings reset.");
		StylePoints_ReDrawFrames();
		return;
	--elseif (string.find(cmd,"set")) then			-- set one of the settings
	elseif (string.sub(cmd,1,4) == "set ") then
		StylePoints_ChangeSetting(string.sub(cmd,5));			-- strip <space>set<space> from msg, pass it
		StylePoints_ReDrawFrames();
		return;
	elseif (cmd == "list") then						-- list settings
		StylePoints_ListSettings();					-- strip <space>set<space> from msg, pass it
		return;
	elseif (cmd == "singlemode") then				-- toggle singlemode
		if (StylePoints_Config.singlemode) then
			StylePoints_Config.singlemode = false;
			StylePoints_Print("singlemode off.");
		else 
			StylePoints_Config.singlemode = true;
			StylePoints_Print("singlemode on.");
		end
		StylePoints_UpdateComboFrames();
		return;
	end
	-- no cmd recognised so show the help stuff:
	StylePoints_Print("(/stp) version " .. tostring(StylePoints_Version));
	StylePoints_Print("/stp set <param> <value>");
	StylePoints_Print("(hpos, vpos, hpad, vpad, scale, alpha)");
	StylePoints_Print("/stp list 	- list current settings");
	StylePoints_Print("/stp reset 	- reset settings to default");
	StylePoints_Print("/stp test (toggle) - show all frames");
	StylePoints_Print("/stp singlemode (toggle) - show single images");

end

function StylePoints_ReDrawFrames()					-- resize / re-position frames if settings change
	local hpos = StylePoints_Config.hpos;
	local vpos = StylePoints_Config.vpos;
	local hpad = StylePoints_Config.hpad;
	local vpad = StylePoints_Config.vpad;
	local scale = StylePoints_Config.scale;
	local alpha = StylePoints_Config.alpha;
	-- frame 1
	SPFrame1:ClearAllPoints();
	SPFrame1:SetHeight(32 * scale);
	SPFrame1:SetWidth(32 * scale);
	SPFrame1:SetAlpha(alpha);
	SPFrame1:SetPoint("CENTER", hpos -(hpad *2), vpos -(vpad*2));
	-- frame 2
	SPFrame2:ClearAllPoints();
	SPFrame2:SetHeight(32 * scale);
	SPFrame2:SetWidth(32 * scale);
	SPFrame2:SetAlpha(alpha);
	SPFrame2:SetPoint("CENTER", hpos -hpad, vpos - vpad);
	-- frame 3
	SPFrame3:ClearAllPoints();
	SPFrame3:SetHeight(32 * scale);
	SPFrame3:SetWidth(32 * scale);
	SPFrame3:SetAlpha(alpha);
	SPFrame3:SetPoint("CENTER", hpos, vpos);
	-- frame 4
	SPFrame4:ClearAllPoints();
	SPFrame4:SetHeight(32 * scale);
	SPFrame4:SetWidth(32 * scale);
	SPFrame4:SetAlpha(alpha);
	SPFrame4:SetPoint("CENTER", hpos + hpad, vpos + vpad);
	-- frame 5
	SPFrame5:ClearAllPoints();
	SPFrame5:SetHeight(32 * scale);
	SPFrame5:SetWidth(32 * scale);
	SPFrame5:SetAlpha(alpha);
	SPFrame5:SetPoint("CENTER", hpos + (hpad*2), vpos + (2*vpad));
end

function StylePoints_UpdateComboFrames()	-- this runs when player target changes, or combo points change

	combo_points = GetComboPoints();					-- get current combo points on target
	
	if (StylePoints_Config.singlemode) then				-- singlemode - just show current combo point frame
		if (combo_points == 1) or (test_mode) then		
			SPFrame1:Show();
		else
			SPFrame1:Hide();
		end
		if (combo_points == 2) or (test_mode) then
			SPFrame2:Show();
		else
			SPFrame2:Hide();
		end
		if (combo_points == 3) or (test_mode) then
			SPFrame3:Show();
		else
			SPFrame3:Hide();
		end
		if (combo_points == 4) or (test_mode) then
			SPFrame4:Show();
		else
			SPFrame4:Hide();
		end
		if (combo_points == 5) or (test_mode) then
			SPFrame5:Show();
		else
			SPFrame5:Hide();
		end
	else												-- normal mode - show from 1 to current number of combo points
		if (combo_points >= 1) or (test_mode) then		
			SPFrame1:Show();
		else
			SPFrame1:Hide();
		end
		if (combo_points >= 2) or (test_mode) then
			SPFrame2:Show();
		else
			SPFrame2:Hide();
		end
		if (combo_points >= 3) or (test_mode) then
			SPFrame3:Show();
		else
			SPFrame3:Hide();
		end
		if (combo_points >= 4) or (test_mode) then
			SPFrame4:Show();
		else
			SPFrame4:Hide();
		end
		if (combo_points >= 5) or (test_mode) then
			SPFrame5:Show();
		else
			SPFrame5:Hide();
		end
	end
end

function StylePoints_OnEvent(event)						-- event handler
	if (event == "PLAYER_COMBO_POINTS") then			-- player combo points have changed
		StylePoints_UpdateComboFrames();
	elseif (event == "PLAYER_TARGET_CHANGED") then		-- player has changed targets
		StylePoints_UpdateComboFrames();
	elseif (event == "VARIABLES_LOADED") then -- <- nicked from ComboEnergyBar by CrowGoblin, good way to handle config changes / saving config
		if ((not StylePoints_Config) or (not StylePoints_Config.version) or (StylePoints_Config.version ~= StylePoints_Version)) then
			StylePoints_Config = StylePoints_DefaultConfig;
		end
		StylePoints_CreateFrames();				-- variables loaded (so frame details are in) so create the frames now.
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local cl = UnitClass("player");
		if ((cl ~= SPRogueClass) and (cl ~= SPDruidClass)) then		-- if class is NOT druid or rogue
			this:UnregisterEvent("PLAYER_COMBO_POINTS");			-- unhook all the events
			this:UnregisterEvent("VARIABLES_LOADED");				
			this:UnregisterEvent("PLAYER_TARGET_CHANGED");
			this:UnregisterEvent("PLAYER_ENTERING_WORLD");
			this:UnregisterEvent("PLAYER_AURAS_CHANGED");
			--StylePoints_Print("class: " .. tostring(cl) .. " detected. disabled.");
		elseif (cl == SPRogueClass) then							-- class is a rogue	so unhook PLAYER_AURAS_CHANGED
			this:UnregisterEvent("PLAYER_AURAS_CHANGED");			-- cos this is just for druid form change
		end
	elseif (event == "PLAYER_AURAS_CHANGED") then					-- only left hooked for druids, to fire on druid form shift 
		StylePoints_UpdateComboFrames();							-- you might be a bear
	end
end

function StylePoints_CreateFrames()			-- create the 5 frames to display the images
	
	local hpos = StylePoints_Config.hpos;	-- just for readability
	local vpos = StylePoints_Config.vpos;
	local hpad = StylePoints_Config.hpad;
	local vpad = StylePoints_Config.vpad;
	local scale = StylePoints_Config.scale;
	local alpha = StylePoints_Config.alpha;
	
	-- combo 1 frame
	SPFrame1 = CreateFrame("Frame","SPFrame1");
	SPFrame1:ClearAllPoints();
	SPFrame1:SetHeight(SP_framesize * scale);
	SPFrame1:SetWidth(SP_framesize * scale);
	SPFrame1:SetAlpha(alpha);
	SPFrame1:SetPoint("CENTER", hpos -(hpad *2), vpos -(vpad*2));
	local t = SPFrame1:CreateTexture("Texture","BACKGROUND");
	t:SetTexture("Interface\\AddOns\\StylePoints\\Images\\1.tga");
	t:SetAllPoints(SPFrame1);
	-- combo 2 frame
	SPFrame2 = CreateFrame("Frame","SPFrame2");
	SPFrame2:ClearAllPoints();
	SPFrame2:SetHeight(SP_framesize * scale);
	SPFrame2:SetWidth(SP_framesize * scale);
	SPFrame2:SetAlpha(alpha);
	SPFrame2:SetPoint("CENTER", hpos -hpad, vpos - vpad);
	local t2 = SPFrame2:CreateTexture("Texture","BACKGROUND");
	t2:SetTexture("Interface\\AddOns\\StylePoints\\Images\\2.tga");
	t2:SetAllPoints(SPFrame2);
	-- combo 3 frame
	SPFrame3 = CreateFrame("Frame","SPFrame3");
	SPFrame3:ClearAllPoints();
	SPFrame3:SetHeight(SP_framesize * scale);
	SPFrame3:SetWidth(SP_framesize * scale);
	SPFrame3:SetAlpha(alpha);
	SPFrame3:SetPoint("CENTER", hpos, vpos);
	local t3 = SPFrame3:CreateTexture("Texture","BACKGROUND");
	t3:SetTexture("Interface\\AddOns\\StylePoints\\Images\\3.tga");
	t3:SetAllPoints(SPFrame3);
	-- combo 4 frame
	SPFrame4 = CreateFrame("Frame","SPFrame4");
	SPFrame4:ClearAllPoints();
	SPFrame4:SetHeight(SP_framesize * scale);
	SPFrame4:SetWidth(SP_framesize * scale);
	SPFrame4:SetAlpha(alpha);
	SPFrame4:SetPoint("CENTER", hpos + hpad, vpos + vpad);
	local t4 = SPFrame4:CreateTexture("Texture","BACKGROUND");
	t4:SetTexture("Interface\\AddOns\\StylePoints\\Images\\4.tga");
	t4:SetAllPoints(SPFrame4);
	-- combo 5 frame
	SPFrame5 = CreateFrame("Frame","SPFrame5");
	SPFrame5:ClearAllPoints();
	SPFrame5:SetHeight(SP_framesize * scale);
	SPFrame5:SetWidth(SP_framesize * scale);
	SPFrame5:SetAlpha(alpha);
	SPFrame5:SetPoint("CENTER", hpos + (hpad*2), vpos + (2*vpad));
	local t5 = SPFrame5:CreateTexture("Texture","BACKGROUND");
	t5:SetTexture("Interface\\AddOns\\StylePoints\\Images\\5.tga");
	t5:SetAllPoints(SPFrame5);
	
	-- hide all frames by default (assume you dont log on with combo points)
	SPFrame1:Hide();
	SPFrame2:Hide();
	SPFrame3:Hide();
	SPFrame4:Hide();
	SPFrame5:Hide();

end

function StylePoints_ChangeSetting(msg)		-- change one of the settings in StylePoints_Config
	local matchfound = false;
	local value = 0;
	for k,v in pairs(StylePoints_Config) do							-- step thru all key names, check for a match
		if not (k=="version") and not (k=="singlemode") then		-- ok not all, ignore singlemode and version
			if string.find(msg,string.lower(k)) then				-- if one of the keys is found in msg
				matchfound = true;
				msg = string.sub(msg,string.len(k)+2);				-- attempt to get a number from the rest of the string
				value = tonumber(msg);
				if (value) then										-- a valid number exists so set it
					StylePoints_Config[k] = value;
					StylePoints_Print(k .. " set to " .. tostring(value));
				else
					StylePoints_Print(k .. " value invalid."); -- stat name was valid, but number wasn't. output fail message
				end
			end
		end
	end
	if (not matchfound) then					-- no valid param found, so list them
		StylePoints_Print("parameter not found. valid params:");
		StylePoints_Print("hpos, vpos, hpad, vpad, alpha, scale");
	end
end

function StylePoints_ListSettings()				-- list current settings
	for k,v in pairs(StylePoints_Config) do
		StylePoints_Print(k .. " : " .. tostring(v));
	end
end

function StylePoints_Print(msg)
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(SP_color .. msg);
	end
end