<<< PoisonPouch 1.2.0 >>>

--Description--

This is a World of Warcraft Interface mod that makes applying buffs to your weapons 
a lot easier. I designed it to speed up the combat preperation of my rogue but it 
supports not only poisons but other weapon buffs like stones or caster oils too. 
Installing the addon will add a new button to your minimap wich gives access to 
2 features: 

+++ Chose from a list +++
If you left-click the button a list of available weapon buffs appears. Just 
left-click on one of the displayed buffs and it will apply it to your mainhand 
weapon. Right click will apply it to your offhand weapon.
You can customize the size and orientaton of the selection frame by dragging the
resize handle.

+++ The Smart-Rebuff(TM) feature +++
If you right-click the minimap button the addon attempts to be smart: It will try 
to rebuff one of your weapons automatically.
If you are dual wielding it will rebuff the weapon with the shorter duration on 
its current buff. If both your offhand and your mainhand are not currently buffed 
the addon will buff the mainhand. Once it has decided for the slot to buff, it 
will just reapply the last known buff that was applied to that slot.

After you have chosen a buff from the list or used the Smart-Rebuff feature the 
addon will start to apply the buff to your weapon. It will display a message of 
the form "Applying X to Y". Make sure you read it and cancel the application by
hitting Esc if it's not what you hoped for. 
Notice that if you don't disable Autoconfirm with the matching command there will 
be no confirmation dialog before the addon overrides an existing weapon buff.


--Commands--

There are a couple of slash commands:

/pp help			- Shows a little command help
/pp unlock 			- Unlocks the Minimap button so you can drag it into a 
					  position you like
/pp lock 			- Locks the Minimap button so you can't drag it anymore
/pp off				- Disables the Addon. Use that for characters where you 
					  don't plan to use PoisonPouch.
/pp on 				- Enable the Addon.
/pp mapsnap on		- Enable snapping to the minimap border when you drag the 
					  button
/pp mapsnap off		- Disable snapping to the minimap border when you drag the 
					  button
/pp autoconfirm on 	- Enable automatic confirmation of override buff warnings
/pp autoconfirm off - Disable automatic confirmation of override buff warnings
/pp reset 			- Resets the Minimap button to it's default position.


--Changelog--
1.2.0 released 9/17/06
- It's now possible to freely move the Minimap button by dragging it. It will snap 
  to the map border if it's moved close. You can disable snapping via slash command.
- Added a handle to the Poison-Selection that can be dragged to customize the 
  frames orientation and size.

1.1.1 released 8/24/06
- Toc updated to work with patch 1.12
- Unregisters BAG_UPDATE event when player leaves world. (zone speed increase)

1.1.0 released 8/14/06 
- More weapon buffs should be supported now, including mana and wizard oil 
  and various stones.
- Different ranks of poison are now listed separately
- Smart-Rebuff feature added. Right-clicking the minimap button will now
  cause the addon to directly rebuff one of your weapons.
- The dialog that asks you to confirm the application of a buff that would 
  override an existing weapon buff is now supressed by default. You can change 
  that behavior with the /pp autoconfirm command.

1.0.0 released 8/4/06 
- initial release


Have fun,
  Lithander (lithander@gmx.de)