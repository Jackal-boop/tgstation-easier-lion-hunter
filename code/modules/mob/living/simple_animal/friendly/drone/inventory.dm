
///////////////////
//DRONE INVENTORY//
///////////////////
//Drone inventory
//Drone hands


/mob/living/simple_animal/drone/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	if(..())
		update_held_items()
		if(I == head)
			head = null
			update_worn_head()
		if(I == internal_storage)
			internal_storage = null
			update_inv_internal_storage()
		return TRUE
	return FALSE


/mob/living/simple_animal/drone/can_equip(obj/item/I, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE, ignore_equipped = FALSE, indirect_action = FALSE)
	switch(slot)
		if(ITEM_SLOT_HEAD)
			if(head)
				return FALSE
			if(!((I.slot_flags & ITEM_SLOT_HEAD) || (I.slot_flags & ITEM_SLOT_MASK)))
				return FALSE
			return TRUE
		if(ITEM_SLOT_DEX_STORAGE)
			if(internal_storage)
				return FALSE
			return TRUE
	..()


/mob/living/simple_animal/drone/get_item_by_slot(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_HEAD)
			return head
		if(ITEM_SLOT_DEX_STORAGE)
			return internal_storage

	return ..()

/mob/living/simple_animal/drone/get_slot_by_item(obj/item/looking_for)
	if(internal_storage == looking_for)
		return ITEM_SLOT_DEX_STORAGE
	if(head == looking_for)
		return ITEM_SLOT_HEAD
	return ..()

/mob/living/simple_animal/drone/equip_to_slot(obj/item/equipping, slot, initial = FALSE, redraw_mob = FALSE, indirect_action = FALSE)
	if(!slot)
		return
	if(!istype(equipping))
		return

	var/index = get_held_index_of_item(equipping)
	if(index)
		held_items[index] = null
	update_held_items()

	if(equipping.pulledby)
		equipping.pulledby.stop_pulling()

	equipping.screen_loc = null // will get moved if inventory is visible
	equipping.forceMove(src)
	SET_PLANE_EXPLICIT(equipping, ABOVE_HUD_PLANE, src)

	switch(slot)
		if(ITEM_SLOT_HEAD)
			head = equipping
			update_worn_head()
		if(ITEM_SLOT_DEX_STORAGE)
			internal_storage = equipping
			update_inv_internal_storage()
		else
			to_chat(src, span_danger("You are trying to equip this item to an unsupported inventory slot. Report this to a coder!"))
			return

	//Call back for item being equipped to drone
	equipping.equipped(src, slot)

/mob/living/simple_animal/drone/getBackSlot()
	return ITEM_SLOT_DEX_STORAGE

/mob/living/simple_animal/drone/getBeltSlot()
	return ITEM_SLOT_DEX_STORAGE