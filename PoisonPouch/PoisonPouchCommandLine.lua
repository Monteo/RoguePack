----------------------------------------------------------------------
--  PoisonPouchCommandLine.lua
--  command line processing functions
----------------------------------------------------------------------

---------------------------------------------------------------------------------
--
-- Break a chat command into its command and variable parts (i.e. "debug on"
-- breaks into command = "debug" and variable = "on"
-- 
---------------------------------------------------------------------------------
function PoisonPouch_ParseCommand(msg)
    firstSpace = string.find(msg, " ", 1, true);
    if (firstSpace) then
        local command = string.sub(msg, 1, firstSpace - 1);
        local var  = string.sub(msg, firstSpace + 1);
        return command, var
    else
        return msg, "";
    end
end

---------------------------------------------------------------------------------
--
-- A simple chat command handler that can take commands in the form: "/slashCommand command var"
-- 
---------------------------------------------------------------------------------
function PoisonPouch_ChatCommandHandler(msg)
	local command, var = PoisonPouch_ParseCommand(msg);
	if ((not command) and msg) then
		command = msg;
	end
	if (command) then
		command = string.lower(command);
		if (command == "debug") then
			PoisonPouch_ToggleDebug();
		elseif (command == "debug on") then
			PoisonPouch_ToggleDebug(true);
		elseif (command == "debug off") then
			PoisonPouch_ToggleDebug(false);
			
		elseif (command == "autoconfirm") then
			PoisonPouch_ToggleAutoConfirm();
		elseif (command == "autoconfirm on") then
			PoisonPouch_ToggleAutoConfirm(true);
		elseif (command == "autoconfirm off") then
			PoisonPouch_ToggleAutoConfirm(false);
			
		elseif (command == "mapsnap") then
			PoisonPouch_ToggleMapSnap();
		elseif (command == "mapsnap on") then
			PoisonPouch_ToggleMapSnap(true);
		elseif (command == "mapsnap off") then
			PoisonPouch_ToggleMapSnap(false);
		
		elseif (command == "") then
			PoisonPouch_Toggle();
		elseif (command == "on") then
			PoisonPouch_Toggle(true);
		elseif (command == "off") then
			PoisonPouch_Toggle(false);
			
		elseif (command == "version") then
			ChatFrame1:AddMessage("PoisonPouch Version "..POISONPOUCH_VERSION, 1.0, 1.0, 0.5);
			
		elseif (command == "lock" or command == "unlock") then
			PoisonPouch_ToggleLockedForDragging(command);
			
		elseif (command == "reset") then
			PoisonPouch_ResetButtonLocations();    
			
		elseif (command == "help" or command == "?") then
			if (ChatFrame1) then
				ChatFrame1:AddMessage("PoisonPouch", 1.0, 1.0, 0.5);
				ChatFrame1:AddMessage("Usage: /pp", 1.0, 1.0, 0.5);
				ChatFrame1:AddMessage("/pp version. "..POISONPOUCH_VERSION_CMD_DESC, 1.0, 1.0, 0.5);
				ChatFrame1:AddMessage("/pp on|off "..POISONPOUCH_ON_OFF_CMD_DESC, 1.0, 1.0, 0.5);
				ChatFrame1:AddMessage("/pp lock|unlock "..POISONPOUCH_LOCK_CMD_DESC, 1.0, 1.0, 0.5);
				ChatFrame1:AddMessage("/pp reset"..POISONPOUCH_RESET_CMD_DESC, 1.0, 1.0, 0.5);
				ChatFrame1:AddMessage("/pp autoconfirm on|off"..POISONPOUCH_AUTOCONFIRM_CMD_DESC, 1.0, 1.0, 0.5);
				ChatFrame1:AddMessage("/pp mapsnap on|off"..POISONPOUCH_MAPSNAP_CMD_DESC, 1.0, 1.0, 0.5);
			end
		end
	end
end

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              TOGGLING FUNCTIONS                                    --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- Handle the toggling on and off of various aspects of the plugin
--
-----------------------------------------------------------------------------------
function PoisonPouch_Toggle(toggle)
	
	if (not toggle) then
		if (POISONPOUCH_SAVED.ENABLED == true) then
			toggle = false;
		else
			toggle = true;
		end
	end
	if (toggle == true) then
		ChatFrame1:AddMessage("PoisonPouch:"..POISONPOUCH_ACTIVATE_DESC, 1.0, 1.0, 0.5);
	else
		ChatFrame1:AddMessage("PoisonPouch:"..POISONPOUCH_DEACTIVATE_DESC, 1.0, 1.0, 0.5);
	end
	POISONPOUCH_SAVED.ENABLED = toggle;


	if (POISONPOUCH_SAVED.ENABLED) then
		PoisonPouch_PoisonButton:Show();
		PoisonPouch_PoisonText:Show();
	else
		PoisonPouch_PoisonButton:Hide();
		PoisonPouch_PoisonText:Hide();
		PoisonPouch_PoisonButton:SetAlpha(1.0);
		PoisonPouch_PoisonText:SetAlpha(1.0);  
	end  

end


-----------------------------------------------------------------------------------
--
-- Toggle Debug Messages
--
-----------------------------------------------------------------------------------
function PoisonPouch_ToggleDebug(toggle)
	if (not toggle) then
		if (POISONPOUCH_SAVED.DEBUG_ENABLED == true) then
			toggle = false;
		else
			toggle = true;
		end
	end
	
	if (toggle == true) then
		ChatFrame1:AddMessage("PoisonPouch: Debug "..POISONPOUCH_ON_DESC, 1.0, 1.0, 0.5);
	else
		
		ChatFrame1:AddMessage("PoisonPouch: Debug "..POISONPOUCH_OFF_DESC, 1.0, 1.0, 0.5);
	end
	POISONPOUCH_SAVED.DEBUG_ENABLED = toggle;
end


-----------------------------------------------------------------------------------
--
-- Toggle Auto Confirm
--
-----------------------------------------------------------------------------------
function PoisonPouch_ToggleAutoConfirm(toggle)
	if (not toggle) then
		if (POISONPOUCH_SAVED.AUTOCONFIRM == true) then
			toggle = false;
		else
			toggle = true;
		end
	end
	
	if (toggle == true) then
		ChatFrame1:AddMessage("PoisonPouch: AutoConfirm "..POISONPOUCH_ON_DESC, 1.0, 1.0, 0.5);
	else
		
		ChatFrame1:AddMessage("PoisonPouch: AutoConfirm "..POISONPOUCH_OFF_DESC, 1.0, 1.0, 0.5);
	end
	POISONPOUCH_SAVED.AUTOCONFIRM = toggle;
	
end

-----------------------------------------------------------------------------------
--
-- Toggle MapSnap
--
-----------------------------------------------------------------------------------
function PoisonPouch_ToggleMapSnap(toggle)
	if (not toggle) then
		if (POISONPOUCH_SAVED.MAPSNAP == true) then
			toggle = false;
		else
			toggle = true;
		end
	end
	
	if (toggle == true) then
		ChatFrame1:AddMessage("PoisonPouch: MapSnap "..POISONPOUCH_ON_DESC, 1.0, 1.0, 0.5);
	else
		
		ChatFrame1:AddMessage("PoisonPouch: MapSnap "..POISONPOUCH_OFF_DESC, 1.0, 1.0, 0.5);
	end
	POISONPOUCH_SAVED.MAPSNAP = toggle;
	
end

---------------------------------------------------------------------------------
--
-- Toggle the lock / unlock status of the interface
-- 
---------------------------------------------------------------------------------
function PoisonPouch_ToggleLockedForDragging(theCommand)
    if (theCommand == "lock") then
		POISONPOUCH_SAVED.DRAGLOCK = true;
		ChatFrame1:AddMessage("PoisonPouch: "..POISONPOUCH_BUTTONS_LOCK_DESC, 1.0, 1.0, 0.5);
    elseif (theCommand == "unlock") then
        POISONPOUCH_SAVED.DRAGLOCK = false;        
		ChatFrame1:AddMessage("PoisonPouch: "..POISONPOUCH_BUTTONS_UNLOCK_DESC, 1.0, 1.0, 0.5);
    end
end


