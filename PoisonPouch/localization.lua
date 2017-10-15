----------------------------------------------------------------------
--  localization.lua
----------------------------------------------------------------------


-- french localization
if ( GetLocale() == "frFR" ) then
poisonNames = {
		'Poison instantan\195\169',
		'Poison affaiblissant',
		'Poison mortel',
		'Poison de distraction mentale',
		'Poison douloureux',
		'Pierre \195\160 aiguiser',
		'Caillou',
		'Huile de sorcier',
		'Huile de mana'
	}
	POISONPOUCH_POISONBUTTON_TIP1	= "Poison Pouch\nClick Gauche: show selection\nClick Droit: smart rebuff";
	POISONPOUCH_RESIZEBUTTON_TIP1	= "Drag to scale and change direction\n"
	POISONPOUCH_POISON_SPELLNAME	= "Poisons";
	POISONPOUCH_APPLYING_DESC1		= "J'applique ";
	POISONPOUCH_APPLYING_DESC2		= " \195\160 ";

	POISONPOUCH_ACTIVATE_DESC		= " Activ\195\169";
	POISONPOUCH_DEACTIVATE_DESC		= " D\195\169sactiv\195\169";
	POISONPOUCH_ON_DESC				=  "Activ\195\169";
	POISONPOUCH_OFF_DESC			= "D\195\169sactiv\195\169";
	POISONPOUCH_BUTTONS_LOCK_DESC 	= "boutons verrouill\195\169s";
	POISONPOUCH_BUTTONS_UNLOCK_DESC	= "boutons d\195\169verrouill\195\169s";
	POISONPOUCH_VERSION_CMD_DESC	= "Affiche votre version de PoisonPouch.";
	POISONPOUCH_ON_OFF_CMD_DESC		= ". Active ou d\195\169sactive PoisonPouch.";
	POISONPOUCH_LOCK_CMD_DESC		= ". Verrouille ou d\195\169verrouille les ic\195\180nes de la minicarte afin d\'\195\170tre d\195\169plac\195\169s.";
	POISONPOUCH_RESET_CMD_DESC		= ". R\195\169initialise les ic\195\180nes \195\160 leur position par d\195\169faut.";
	POISONPOUCH_AUTOCONFIRM_CMD_DESC= ". Enable or disable supression of the confirmation dialog that shows when a weapon buff is about to be overridden.";
	POISONPOUCH_MAPSNAP_CMD_DESC	= ". Enable or disable automatic snapping to the border of the minimap when dragged near."; 
	POISONPOUCH_BUTTONRESET_DESC	= "R\195\169initialiser la position de le bouton";

	POISONPOUCH_LEFTMOUSE	= "Click Gauche: main principale";
	POISONPOUCH_RIGHTMOUSE	= "Click Droit: main secondaire";
	POISONPOUCH_CONSUMABLE	= "Consommable";
	POISONPOUCH_TRADEGOOD	= "Artisanat"; 

-- german localization
elseif ( GetLocale() == "deDE" ) then
   	poisonNames = {
		'Sofort wirkendes Gift',
		'Wundgift',
		'T\195\182dliches Gift',
		'Gedankenbenebelndes Gift',
		'Verkr\195\188ppelndes Gift',
		'Wetzstein',
		'Gewichtsstein',
		'Elementarwetzstein',
		'Mana\195\182l',
		'Zauber\195\182l'
	}

	POISONPOUCH_POISONBUTTON_TIP1	= "Poison Pouch\nLinksklick: Auswahl anzeigen\nRechtsklick: smart rebuff";
	POISONPOUCH_RESIZEBUTTON_TIP1	= "Ziehen um Größe und Orientierung zu ändern\n"
	POISONPOUCH_POISON_SPELLNAME	= "Gifte";
	POISONPOUCH_APPLYING_DESC1 		= " wird mit ";
	POISONPOUCH_APPLYING_DESC2 		= " versehen";
	
	POISONPOUCH_ACTIVATE_DESC		=   " aktiviert";
	POISONPOUCH_DEACTIVATE_DESC		= " deaktiviert";
	POISONPOUCH_ON_DESC				=  "an";
	POISONPOUCH_OFF_DESC			= "aus";
	POISONPOUCH_BUTTONS_LOCK_DESC	= "buttons fixiert";
	POISONPOUCH_BUTTONS_UNLOCK_DESC = "buttons beweglich";
	POISONPOUCH_VERSION_CMD_DESC	= "Zeigt die benutzte Version von PoisonPouch an.";
	POISONPOUCH_ON_OFF_CMD_DESC		= ". Schaltet PoisonPouch an oder aus.";
	POISONPOUCH_LOCK_CMD_DESC		= ". Fixiert oder macht den Minimap-Button beweglich.";
	POISONPOUCH_RESET_CMD_DESC		= ". Setzt den Minimap-Button wieder auf seine Standardposition.";
	POISONPOUCH_AUTOCONFIRM_CMD_DESC= ". Legt fest ob die Warnung beim \195\156berschreiben eines Waffen Buffs unterdr\195\188ckt werden soll.";
	POISONPOUCH_MAPSNAP_CMD_DESC	= ". Legt fest ob der Minimap-Button beim Verschieben automatisch an den Rand der Map springt wenn in der N\195\164he."; 
	POISONPOUCH_BUTTONRESET_DESC	= "Position des Button wurde zur\195\188ckgesetzt";

	POISONPOUCH_LEFTMOUSE	= "Linksklick: Waffenhand";
	POISONPOUCH_RIGHTMOUSE	= "Rechtsklick: Nebenhand"; 
	POISONPOUCH_CONSUMABLE	= "Verbrauchbar";
	POISONPOUCH_TRADEGOOD	= "Handwerkswaren";

-- default (english) localization
else
	poisonNames = {
		'Instant Poison',
		'Wound Poison',
		'Deadly Poison',
		'Mind-numbing Poison',
		'Crippling Poison',
		'Sharpening Stone',
		'Weightstone',
		'Mana Oil',
		'Wizard Oil'
   	}

	POISONPOUCH_POISONBUTTON_TIP1 = "Poison Pouch\nLeft click: show selection\nRight click: smart rebuff";
	POISONPOUCH_RESIZEBUTTON_TIP1 = "Drag to scale and change direction\n"
	POISONPOUCH_POISON_SPELLNAME = "Poisons";
	--using poison on weapons
	POISONPOUCH_APPLYING_DESC1 = "Applying ";
	POISONPOUCH_APPLYING_DESC2 = " to ";
	
	-- various aspects of the plugin
	POISONPOUCH_POISON_TOGGLE_DESC	= "Poison";
	POISONPOUCH_ACTIVATE_DESC 		=   " Enabled";
	POISONPOUCH_DEACTIVATE_DESC		= " Disabled";
	POISONPOUCH_ON_DESC				=  "on";
	POISONPOUCH_OFF_DESC			= "off";
	POISONPOUCH_BUTTONS_LOCK_DESC	= "buttons locked";
	POISONPOUCH_BUTTONS_UNLOCK_DESC = "buttons unlocked";
	POISONPOUCH_VERSION_CMD_DESC	= "Display what version of PoisonPouch you are using.";
	POISONPOUCH_ON_OFF_CMD_DESC		= ". Turns PoisonPouch on or off, or toggles on/off.";
	POISONPOUCH_LOCK_CMD_DESC		= ". Locks or unlocks the minimap icon so it can be moved.";
	POISONPOUCH_RESET_CMD_DESC		= ". Resets the icon back to the default positions.";
	POISONPOUCH_AUTOCONFIRM_CMD_DESC= ". Enable or disable supression of the confirmation dialog that shows when a weapon buff is about to be overridden.";
	POISONPOUCH_MAPSNAP_CMD_DESC	= ". Enable or disable automatic snapping to the border of the minimap when dragged near."; 
	POISONPOUCH_BUTTONRESET_DESC 	= "button location reset";
	
	POISONPOUCH_LEFTMOUSE	= "Left click: Main Hand";
	POISONPOUCH_RIGHTMOUSE	= "Right click: Off Hand"; 
	POISONPOUCH_CONSUMABLE	= "Consumable";
	POISONPOUCH_TRADEGOOD	= "Trade Goods";

end