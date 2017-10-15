----------------------------------------------------------------------
--  PoisonPouch
-- 	Author: lithander (lithander@gmx.de)
--  Based partially on code and concepts from the following addons:
--	#RogueTracker
--  #TrinketMaster.
----------------------------------------------------------------------

----------------------------------------------------------------------
--  vars
----------------------------------------------------------------------
POISONPOUCH_VERSION = "1.2.0";
POISONPOUCH_HIDE_MENU_TIMEOUT = 0.2;

PoisonPouch_IsScaling	 		= false;
PoisonPouch_MainHandSlotId		= 16;
PoisonPouch_OffHandSlotId		= 17;
PoisonPouch_PoisonBtnCount		= 0;
PoisonPouch_LastUpdate 			= 0;
PoisonPouch_TimeCounter			= POISONPOUCH_HIDE_MENU_TIMEOUT;
PoisonPouch_ScalingLength		= 0;

----------------------------------------------------------------------
--  PoisonPouch_Button_OnLoad()
----------------------------------------------------------------------
function PoisonPouch_Button_OnLoad()

	-- saved vars
	POISONPOUCH_SAVED = { }
	POISONPOUCH_SAVED.ENABLED 				= true
	POISONPOUCH_SAVED.DEBUG_ENABLED 		= false
	POISONPOUCH_SAVED.DRAGLOCK				= false
	POISONPOUCH_SAVED.AUTOCONFIRM 			= true
	POISONPOUCH_SAVED.MAPSNAP				= true
	POISONPOUCH_SAVED.LastMainHandBuff		= ""
	POISONPOUCH_SAVED.LastOffHandBuff		= ""
	POISONPOUCH_SAVED.PoisonIconPosX		= - 80*cos(30) + Minimap:GetWidth() / 2
	POISONPOUCH_SAVED.PoisonIconPosY 		= 80*sin(30) + Minimap:GetHeight() / 2
	POISONPOUCH_SAVED.Scale		 			= 1
	POISONPOUCH_SAVED.Direction 			= "DOWN";
	
	
    this:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    this:RegisterForDrag("LeftButton")
end

----------------------------------------------------------------------
--  PoisonPouch_OnLoad()
----------------------------------------------------------------------
function PoisonPouch_OnLoad()

	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("PoisonPouch v"..POISONPOUCH_VERSION.." loaded");
	end

	PoisonPouch_PoisonButton = getglobal("PoisonPouchPoisonButton");
	PoisonPouch_PoisonText = getglobal("PoisonPouchPoisonText");	
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	
	SLASH_POISONPOUCH1 = "/pp";
	SLASH_POISONPOUCH2 = "/poisonpouch";
	SlashCmdList["POISONPOUCH"] = function(msg)
		PoisonPouch_ChatCommandHandler(msg);	
	end
end

----------------------------------------------------------------------
--  PoisonPouch_OnEvent()
----------------------------------------------------------------------
function PoisonPouch_OnEvent()
    if (event == "PLAYER_ENTERING_WORLD") then
		PoisonPouch_UpdatePoisonButton();
       	PoisonPouch_ButtonSetLocation();
	end
end

----------------------------------------------------------------------
--  PoisonPouch_UpdatePoisonButton()
----------------------------------------------------------------------
function PoisonPouch_UpdatePoisonButton()
	
	if (POISONPOUCH_SAVED.ENABLED == true) then
		PoisonPouch_PoisonText:Show(); 			
		PoisonPouch_PoisonButton:Show();
	else
		PoisonPouch_PoisonText:Hide();        
		PoisonPouch_PoisonButton:Hide();           
	end
	
end

----------------------------------------------------------------------
--  PoisonPouch_OnUpdate(elapsed)
----------------------------------------------------------------------
function PoisonPouch_OnUpdate(elapsed)
	
	-- using my own damn timer
	local PoisonPouch_TimeLeft = 0;
	
	if (PoisonPouchSelection:IsVisible()) then
		PoisonPouch_TimeCounter = PoisonPouch_TimeCounter - elapsed;
		--PoisonPouchDebug("Visible drop down");
		if (MouseIsOver(PoisonPouchSelection) or MouseIsOver(PoisonPouchPoisonButton)) then
			PoisonPouch_TimeCounter = POISONPOUCH_HIDE_MENU_TIMEOUT;
		end
	end
	if (PoisonPouch_TimeCounter <= 0 and not PoisonPouch_IsScaling) then
		PoisonPouchSelection:Hide();
		PoisonPouch_TimeCounter = POISONPOUCH_HIDE_MENU_TIMEOUT;			
	end
end

---------------------------------------------------------------------------------
-- PoisonPouch_ButtonSetLocation
---------------------------------------------------------------------------------
function PoisonPouch_ButtonSetLocation()
	
	PoisonPouchPoisonButton:SetPoint("CENTER","Minimap","BOTTOMLEFT",POISONPOUCH_SAVED.PoisonIconPosX, POISONPOUCH_SAVED.PoisonIconPosY);
end

---------------------------------------------------------------------------------
-- PoisonPouch_ResetButtonLocations
-- Move the interface buttons back to their default locations
---------------------------------------------------------------------------------
function PoisonPouch_ResetButtonLocations()
	ChatFrame1:AddMessage("PoisonPouch: "..POISONPOUCH_BUTTONRESET_DESC);	
	POISONPOUCH_SAVED.PoisonIconPosX		= - 80*cos(30) + Minimap:GetWidth() / 2
	POISONPOUCH_SAVED.PoisonIconPosY 		= 80*sin(30) + Minimap:GetHeight() / 2		
	PoisonPouch_ButtonSetLocation()
end


-----------------------------------------------------------------------------------
-- PoisonPouch_OnPoisonButtonClick(button)
-- Right-click: Open the poisons menu
-- Left-click: Reapplies a weapon buff
-----------------------------------------------------------------------------------
function PoisonPouch_OnPoisonButtonClick(button)
	
	if (button == "LeftButton") then
		PoisonPouchSelection:ClearAllPoints();
		PoisonPouchSelection:SetPoint("LEFT", "PoisonPouchPoisonButton", "LEFT", -170, 0);
		PoisonPouch_ConstructPoisonMenu();
	
	elseif (button == "RightButton") then
		PoisonPouch_Rebuff();	  			
	end
end

-----------------------------------------------------------------------------------
-- PoisonPouch_Rebuff
-- Reaplies a Weapon buff. 
-- Checks for a weapon that has been buffed allready this session
-- If one of your weapons are buffed the one with the shortest duration is rebuffed
-- If both buffs have run out it will start with the mainhand
-----------------------------------------------------------------------------------
function PoisonPouch_Rebuff()
	
	mhbuffed,mhduration,mhcharges, ohbuffed,ohduration,ohcharges = GetWeaponEnchantInfo();
	if (POISONPOUCH_SAVED.LastMainHandBuff ~= "") and (POISONPOUCH_SAVED.LastOffHandBuff ~= "") then
		-- both have been poisoned. wich one has the shortest duration?
		local mhdur = 0
		if mhbuffed then
			mhdur = mhduration
		end
		local ohdur = 1
		if ohbuffed then
			ohdur = ohduration
		end
		if mhdur < ohdur then
			-- reapply mainhand
			bag, slot, cnt = PoisonPouch_FindItemBagSlotByName(POISONPOUCH_SAVED.LastMainHandBuff)
			if cnt > 0 then
				PoisonPouch_Apply(POISONPOUCH_SAVED.LastMainHandBuff, bag, slot, PoisonPouch_MainHandSlotId)
			end
		else
			-- reapply offhand
			bag, slot, cnt = PoisonPouch_FindItemBagSlotByName(POISONPOUCH_SAVED.LastOffHandBuff)
			if cnt > 0 then
				PoisonPouch_Apply(POISONPOUCH_SAVED.LastOffHandBuff, bag, slot, PoisonPouch_OffHandSlotId)
			end
		end
		
	elseif POISONPOUCH_SAVED.LastMainHandBuff ~= "" then
		-- only mainhand has been poisoned yet
		bag, slot, cnt = PoisonPouch_FindItemBagSlotByName(POISONPOUCH_SAVED.LastMainHandBuff)
		if cnt > 0 then
			PoisonPouch_Apply(POISONPOUCH_SAVED.LastMainHandBuff, bag, slot, PoisonPouch_MainHandSlotId)
		end
		
	elseif POISONPOUCH_SAVED.LastOffHandBuff ~= "" then
		-- only offhand has been poisoned yet
		bag, slot, cnt = PoisonPouch_FindItemBagSlotByName(POISONPOUCH_SAVED.LastOffHandBuff)
		if cnt > 0 then
			PoisonPouch_Apply(POISONPOUCH_SAVED.LastOffHandBuff, bag, slot, PoisonPouch_OffHandSlotId)
		end		
	end
end

-----------------------------------------------------------------------------------
-- PoisonPouch_FindItemBagSlotByName
-- Return the bag, slot, count of the specified item
-----------------------------------------------------------------------------------
function PoisonPouch_FindItemBagSlotByName(item)
	if ( item == nil or item == "") then
		return -1,-1,-1;
	end
	local itemBag = 0;
    local itemSlot = 0;
    local itemCount = 0;
    PoisonPouchDebug("search item: "..item);
    for checkbag=4, 0, -1 do
		local size = GetContainerNumSlots(checkbag);
		if (size > 0) then
			for checkslot=1, size, 1 do
				local _, count = GetContainerItemInfo(checkbag, checkslot);
				if (count) then
					local _,_,_,itemName = string.find(GetContainerItemLink(checkbag,checkslot) or "","item:(%d+).+%[(.+)%]");
					if itemName == item then
						itemCount = itemCount + count;
						itemBag = checkbag;
						itemSlot = checkslot;
					end
				end
			end
		end
	end
	return itemBag, itemSlot, itemCount;
end

----------------------------------------------------------------------
--  PoisonPouch_ConstructBuffList()
--	assemble a list of all buffs the user has in his bags
----------------------------------------------------------------------
function PoisonPouch_ConstructBuffList()
	local buffList = {};

	for checkbag=0, 4, 1 do
		local size = GetContainerNumSlots(checkbag);
		if size > 0 then
			for checkslot=1, size, 1 do
				local _, itemCount = GetContainerItemInfo(checkbag, checkslot);
				if itemCount then
					local _,_,itemID,itemName = string.find(GetContainerItemLink(checkbag,checkslot) or "","item:(%d+).+%[(.+)%]");
					local _,_,_,_,itemType,_,_,_,itemTexture = GetItemInfo(itemID or "")
					
					-- is it a consumable or trade good?
					if( itemType == POISONPOUCH_CONSUMABLE or itemType == POISONPOUCH_TRADEGOOD ) then
						--does it's name contain a identifier? (stored in poisonNames)
						for i=1, table.getn(poisonNames), 1 do
							if (string.find(itemName,poisonNames[i],1,true)) then
								-- IT'S A WEAPON BUFF *whohoo*
								-- assemble buff-info
								local newbuff = {
									count = itemCount;
									name = itemName;
									texture = itemTexture;
									bag = checkbag;
									slot = checkslot;
								}
								-- add it to bufflist if it's new or combine it if it exists allready
								local exists = false;
								for key, buff in buffList do 
									if buff.name == newbuff.name then
										buff.count = buff.count + newbuff.count
										exists = true
									end
								end 
								if not exists then
									table.insert(buffList, newbuff)
								end
									
								break  -- break the for-loop
							end
						end
					end
				end
			end
		end
	end
	
	return buffList;
end

----------------------------------------------------------------------
--  PoisonPouch_PositionPoisonMenu(itemCnt)
--  attach the elements of the PoisonSelection Frame based on its Orientaton
----------------------------------------------------------------------
function PoisonPouch_PositionPoisonMenu(itemCnt)

	if POISONPOUCH_SAVED.Direction  == "DOWN" or POISONPOUCH_SAVED.Direction  == "UP" then
		PoisonPouchSelection:SetWidth(PoisonPouchDropdownButton1:GetWidth()+14)
		PoisonPouch_ScalingLength = itemCnt * (PoisonPouchDropdownButton1:GetHeight()+2) + 22
		PoisonPouchSelection:SetHeight(PoisonPouch_ScalingLength)
		
	elseif POISONPOUCH_SAVED.Direction  == "LEFT" or POISONPOUCH_SAVED.Direction  == "RIGHT" then
		PoisonPouchSelection:SetHeight(PoisonPouchDropdownButton1:GetHeight()+14)
		PoisonPouch_ScalingLength = itemCnt * (PoisonPouchDropdownButton1:GetWidth()+2) + 22
		PoisonPouchSelection:SetWidth(PoisonPouch_ScalingLength)
	end
	
	PoisonPouchSelection:ClearAllPoints()
	PoisonPouchSelection:SetScale(POISONPOUCH_SAVED.Scale)
	PoisonPouchResizeButtonH:ClearAllPoints()
	PoisonPouchResizeButtonH:SetAlpha(0)
	PoisonPouchResizeButtonV:ClearAllPoints()
	PoisonPouchResizeButtonV:SetAlpha(0)  
	
	if POISONPOUCH_SAVED.Direction  == "DOWN" then
		PoisonPouchSelection:SetPoint("TOP","PoisonPouchPoisonButton","BOTTOM")
		PoisonPouchDropdownButton1:SetPoint("TOP",PoisonPouchSelection,"TOP",0.5,-6)
		PoisonPouchResizeButtonH:SetPoint("TOP", "PoisonPouchSelection", "BOTTOM", 0.5, 16)
		PoisonPouchResizeButtonH:SetAlpha(1)
		
	elseif POISONPOUCH_SAVED.Direction  == "UP" then
		PoisonPouchSelection:SetPoint("BOTTOM","PoisonPouchPoisonButton","TOP")
		PoisonPouchDropdownButton1:SetPoint("TOP","PoisonPouchResizeButtonH","BOTTOM",0.5,-1)
		PoisonPouchResizeButtonH:SetPoint("TOP", "PoisonPouchSelection", "TOP", 0.5, -4)
		PoisonPouchResizeButtonH:SetAlpha(1)
	
	elseif POISONPOUCH_SAVED.Direction  == "RIGHT" then
		PoisonPouchSelection:SetPoint("LEFT","PoisonPouchPoisonButton","RIGHT")
		PoisonPouchDropdownButton1:SetPoint("LEFT","PoisonPouchSelection","LEFT",7,0)
		PoisonPouchResizeButtonV:SetPoint("LEFT", "PoisonPouchSelection", "RIGHT", -16, 0)
		PoisonPouchResizeButtonV:SetAlpha(1)
		
	elseif POISONPOUCH_SAVED.Direction  == "LEFT" then
		PoisonPouchSelection:SetPoint("RIGHT","PoisonPouchPoisonButton","LEFT")
		PoisonPouchDropdownButton1:SetPoint("LEFT","PoisonPouchResizeButtonV","RIGHT",1,0)
		PoisonPouchResizeButtonV:SetPoint("LEFT", "PoisonPouchSelection", "LEFT", 5, 0)
		PoisonPouchResizeButtonV:SetAlpha(1)
	end
end

----------------------------------------------------------------------
--  PoisonPouch_ConstructPoisonMenu()
--  build a poison menu for use when accessing the poison button
----------------------------------------------------------------------
function PoisonPouch_ConstructPoisonMenu()
	
	PoisonPouchSelection:Show();
	PoisonPouch_ClearDropdownButtons();
	
	local itemCnt = 0;
	local bufflist = PoisonPouch_ConstructBuffList()
	
	for key, buff in bufflist do
		PoisonPouch_AddDropdownButton(buff);
		itemCnt = itemCnt+1;
	end
	
	if(itemCnt > 0) then
		PoisonPouch_PositionPoisonMenu(itemCnt)
	else
		PoisonPouchSelection:Hide();
	end

end

----------------------------------------------------------------------
--  PoisonPouch_AddDropdownButton(info)
--  show a dropdown button that displays the poison identified by info
----------------------------------------------------------------------
function PoisonPouch_AddDropdownButton(info)
	local button = nil
	local label = nil
	local btnNr = 0
	local reuseButton = false
	for i=1, PoisonPouch_PoisonBtnCount, 1 do
		label = getglobal("PoisonPouchDropdownButton"..i.."Label");
		button = getglobal("PoisonPouchDropdownButton"..i);
		if ( not button:IsVisible() ) then
			reuseButton = true
			btnNr = i
			break
		end
	end
	
	-- if we can't reuse a button generate one and a label frame too
	if( not reuseButton ) then
		PoisonPouch_PoisonBtnCount = PoisonPouch_PoisonBtnCount + 1
		btnNr = PoisonPouch_PoisonBtnCount
		local newButtonName = "PoisonPouchDropdownButton"..PoisonPouch_PoisonBtnCount
		PoisonPouchDebug("Create Button"..newButtonName)
		button = CreateFrame("CheckButton", newButtonName, PoisonPouchSelection, "PoisonPouchDropdownButtonTemplate")
		CreateFrame("Frame", nil, button, "PoisonPouchLabelTemplate")
		label = getglobal(newButtonName.."Label")
	end
	
	-- If it's not the first button attach it to the previous one
	if btnNr > 1 then
		button:ClearAllPoints()
		if POISONPOUCH_SAVED.Direction  == "DOWN" or POISONPOUCH_SAVED.Direction  == "UP" then
			button:SetPoint("TOP", "PoisonPouchDropdownButton"..btnNr-1, "BOTTOM",0,-2)
		elseif POISONPOUCH_SAVED.Direction  == "LEFT" or POISONPOUCH_SAVED.Direction  == "RIGHT" then
			button:SetPoint("LEFT", "PoisonPouchDropdownButton"..btnNr-1, "RIGHT",2,0)
		end
	end
	
	--set the icon
	getglobal(button:GetName().."Icon"):SetTexture(info.texture);
	button.buff = info.name;
	button.tooltip = info.name.."\n"..POISONPOUCH_LEFTMOUSE.."\n"..POISONPOUCH_RIGHTMOUSE;
	button.bag = info.bag;
	button.slot = info.slot;
	button:SetChecked(0);
	button:Show();
	--display count
	label:SetText(info.count);
	if (info.count > 9) then
		label:SetTextColor(0.0, 1.0, 0.0)
	elseif (info.count > 4) then
		label:SetTextColor(1.0, 1.0, 0.0)
	else
		label:SetTextColor(1.0, 0.0, 0.0)
	end;
end

----------------------------------------------------------------------
--  PoisonPouch_ClearDropdownButtons()
--  hide all dropdown buttons
----------------------------------------------------------------------
function PoisonPouch_ClearDropdownButtons()
	for i=1, PoisonPouch_PoisonBtnCount, 1 do
		local button = getglobal("PoisonPouchDropdownButton"..i);
		button:Hide();
	end
end

----------------------------------------------------------------------
--  PoisonPouch_PoisonOnClick(button)
--  react to a click on a DropdownButton
----------------------------------------------------------------------
function PoisonPouch_PoisonOnClick(button)
	if (button == "LeftButton") then
		PoisonPouch_Apply(this.buff, this.bag, this.slot, PoisonPouch_MainHandSlotId);
	elseif (button == "RightButton") then
		PoisonPouch_Apply(this.buff, this.bag, this.slot, PoisonPouch_OffHandSlotId);	  			
	end
	PoisonPouchSelection:Hide();
end

----------------------------------------------------------------------
--  PoisonPouch_Apply(buff, bag, slot, invslot)
--  aplay a buff to a weapon
----------------------------------------------------------------------
function PoisonPouch_Apply(buff, bag, slot, invslot)

	-- print what player is applying poison to
	local slotString = nil;
	if (PoisonPouch_MainHandSlotId == invslot) then
		slotString = "MainHandSlot";
	else
		slotString = "SecondaryHandSlot";
	end
	local slotId = GetInventorySlotInfo(slotString);
	local link = GetInventoryItemLink("player", slotId)
	
	if link then
		PoisonPouch_ShowApplyMessage(buff, link)
		
		UseContainerItem(bag,slot);
		if ( SpellIsTargeting() ) then
			PickupInventoryItem(invslot);
		
			-- auto confirm?
			if POISONPOUCH_SAVED.AUTOCONFIRM then
				ReplaceEnchant()
			end
			
			-- remember that buff
			if slotString == "MainHandSlot" then
				POISONPOUCH_SAVED.LastMainHandBuff = buff
				PoisonPouchDebug("mainhand--->"..buff)
			elseif slotString == "SecondaryHandSlot" then
				POISONPOUCH_SAVED.LastOffHandBuff	= buff
				PoisonPouchDebug("offhand--->"..buff)
			end
			
		end
		
	end
	
end

----------------------------------------------------------------------
--  PoisonPouch_ShowApplyMessage(buff, target)
--  show a message on the screen about what buff is applied to what target
----------------------------------------------------------------------
function PoisonPouch_ShowApplyMessage(buff, target)
	if GetLocale() == "deDE" then
		UIErrorsFrame:AddMessage(target..POISONPOUCH_APPLYING_DESC1.."-"..buff.."-"..POISONPOUCH_APPLYING_DESC2, 0.92, 0.75, 0.05, 1.0, 12);
	else
		UIErrorsFrame:AddMessage(POISONPOUCH_APPLYING_DESC1.."-"..buff.."-"..POISONPOUCH_APPLYING_DESC2..target, 0.92, 0.75, 0.05, 1.0, 12);
	end;
end

----------------------------------------------------------------------
--  PoisonPouch_PoisonDraggingFrames_OnUpdate(arg1)
--	Calculate a new position for the PoisonIcon
----------------------------------------------------------------------
function PoisonPouch_PoisonDraggingFrame_OnUpdate(arg1)
	if (POISONPOUCH_SAVED.DRAGLOCK == false) then
		-- calculate the new position
		local xpos,ypos = GetCursorPosition()
		local xmin,ymin = Minimap:GetLeft() or 400, Minimap:GetBottom() or 400	
		
		POISONPOUCH_SAVED.PoisonIconPosX = xpos/UIParent:GetEffectiveScale() - xmin
		POISONPOUCH_SAVED.PoisonIconPosY = ypos/UIParent:GetEffectiveScale() - ymin
			
		if POISONPOUCH_SAVED.MAPSNAP then
			xpos = xmin-xpos/UIParent:GetEffectiveScale()+70
			ypos = ypos/UIParent:GetEffectiveScale()-ymin-70
			local angle = math.deg(math.atan2(ypos,xpos))
			xpos = - 80*cos(angle) + Minimap:GetWidth() / 2
			ypos = 80*sin(angle) + Minimap:GetHeight() / 2
			if (math.abs(POISONPOUCH_SAVED.PoisonIconPosX - xpos) < 25) and (math.abs(POISONPOUCH_SAVED.PoisonIconPosY - ypos) < 25) then
				POISONPOUCH_SAVED.PoisonIconPosX = xpos
				POISONPOUCH_SAVED.PoisonIconPosY = ypos
			end
		end
		
		PoisonPouch_ButtonSetLocation();
	end
end

----------------------------------------------------------------------
--  PoisonPouch_SwapDirection(newDir)
--  swap the direction of the PoisonSelection Frame
----------------------------------------------------------------------
function PoisonPouch_SwapDirection(newDir)
	if POISONPOUCH_SAVED.Direction  ~= newDir then
		POISONPOUCH_SAVED.Direction  = newDir
		PoisonPouch_ConstructPoisonMenu()
	end
end


----------------------------------------------------------------------
--  PoisonPouch_SelectionScaleFrame_OnUpdate(arg1)
--  Called when the Resize Button is dragged. Sets Scaling and Orientation
----------------------------------------------------------------------
function PoisonPouch_SelectionScaleFrame_OnUpdate(arg1)
	local xpos,ypos = GetCursorPosition()

	-- Calculate the POISONPOUCH_SAVED.Direction 
	local xcenter, ycenter =  PoisonPouchPoisonButton:GetCenter()
	local dx = xpos - xcenter
	local dy = ypos - ycenter
	local length = math.sqrt(dx * dx + dy * dy)
	local alpha = math.acos(dy / length)
	if dx < 0 then
		alpha = 2 * math.pi - alpha
	end
	-- get rid of the pi
	alpha = alpha / math.pi
	-- Set a new Directon
	local mindist = (PoisonPouch_ScalingLength + 80)*0.4
	
	if (alpha > 1.80 or alpha < 0.20) and math.abs(dy) > mindist then
		PoisonPouch_SwapDirection("UP")
	elseif (alpha > 0.30 and alpha < 0.70) and math.abs(dx) > mindist then
		PoisonPouch_SwapDirection("RIGHT")
	elseif (alpha > 0.80 and alpha < 1.20) and math.abs(dy) > mindist then
		PoisonPouch_SwapDirection("DOWN")
	elseif (alpha > 1.30 and alpha < 1.70) and math.abs(dx) > mindist then
		PoisonPouch_SwapDirection("LEFT")
	end
	
	-- Calculate the Scaling
	local scale = 0
	
	if POISONPOUCH_SAVED.Direction  == "DOWN" then
		local ymin =  PoisonPouchPoisonButton:GetBottom() + 6
		scale = (ymin - ypos/UIParent:GetEffectiveScale()) / PoisonPouch_ScalingLength
	
	elseif POISONPOUCH_SAVED.Direction  == "UP" then	
		local ymin =  PoisonPouchPoisonButton:GetTop() - 6
		scale = -(ymin - ypos/UIParent:GetEffectiveScale()) / PoisonPouch_ScalingLength
	
	elseif POISONPOUCH_SAVED.Direction  == "RIGHT" then	
		local xmin =  PoisonPouchPoisonButton:GetRight() - 6
		scale = -(xmin - xpos/UIParent:GetEffectiveScale()) / PoisonPouch_ScalingLength
	
	elseif POISONPOUCH_SAVED.Direction  == "LEFT" then	
		local xmin =  PoisonPouchPoisonButton:GetLeft() + 6
		scale = (xmin - xpos/UIParent:GetEffectiveScale()) / PoisonPouch_ScalingLength
	end
	
	POISONPOUCH_SAVED.Scale = PoisonPouch_FitScale(scale)
	PoisonPouchSelection:SetScale(POISONPOUCH_SAVED.Scale)
end

----------------------------------------------------------------------
--  PoisonPouch_FitScale(scale)
--	Clamp and snap the scale factor
----------------------------------------------------------------------
function PoisonPouch_FitScale(scale)
	--clamp
	local sf = math.max(scale, 0.4)
	sf = math.min(sf, 2)
	--snap
	local sfsnap = math.ceil(sf * 5 - 0.5) / 5
	if math.abs(sf - sfsnap) > 0.05 then
		return sf
	else
		return sfsnap
	end
end


----------------------------------------------------------------------
--  PoisonPouchDebug(msg)
--	display a debug message in the default chatframe
----------------------------------------------------------------------
function PoisonPouchDebug(msg)
	if (POISONPOUCH_SAVED.DEBUG_ENABLED) then
		if( DEFAULT_CHAT_FRAME ) then
			DEFAULT_CHAT_FRAME:AddMessage(msg);
		end
	end
end

