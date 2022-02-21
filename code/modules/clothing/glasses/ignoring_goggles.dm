/obj/item/clothing/glasses/chameleon/ignoring
	name = "\improper ignoring goggles"
	desc = "Not only do these goggles turn you into a nerd emoji, they also let you ignore the haters."
	actions_types = list(/datum/action/item_action/ignore_mob, /datum/action/item_action/unignore_mob)
	var/list/image/ignored_images

/datum/action/item_action/ignore_mob
	name = "Ignore Mob"
	desc = "Use this to ignore some asshole you really want to see gone."

/datum/action/item_action/unignore_mob
	name = "Unignore Mob"
	desc = "Use this to stop ignoring someone."

/obj/item/clothing/glasses/chameleon/ignoring/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_EYES)
		return
	ignore_chads(user)
	RegisterSignal(user, COMSIG_MOB_CLIENT_LOGIN, .proc/client_logged_in)

/obj/item/clothing/glasses/chameleon/ignoring/dropped(mob/user)
	. = ..()
	acknowledge_chads(user)
	UnregisterSignal(user, COMSIG_MOB_CLIENT_LOGIN)

/obj/item/clothing/glasses/chameleon/ignoring/ui_action_click(mob/user, actiontype)
	. = ..()
	if(istype(actiontype, /datum/action/item_action/ignore_mob))
		var/list/mobs_in_view = list()
		for(var/mob/mob_in_view in (view(7, user)-user))
			if(mob_in_view.invisibility > user.see_invisible)
				continue
			if(mob_in_view.render_target && (mob_in_view.render_target in ignored_images))
				continue
			mobs_in_view["[mob_in_view.name]"] = mob_in_view
		var/input = tgui_input_list(user, "Ignore which mob?", "Ignoring Goggles", mobs_in_view)
		if(input)
			var/mob/ignored = mobs_in_view["[input]"]
			if(ignored)
				ignore_chad(ignored, user)
	if(istype(actiontype, /datum/action/item_action/unignore_mob))
		var/list/ignored_mobs = list()
		for(var/datum/weakref/weakref as anything in ignored_images)
			var/mob/ignored = weakref.resolve()
			if(!ignored)
				continue
			ignored_mobs["[ignored.name]"] = ignored
		var/input = tgui_input_list(user, "Unignore which mob?", "Ignoring Goggles", ignored_mobs)
		if(input)
			var/mob/unignored = ignored_mobs["[input]"]
			if(unignored)
				unignore_chad(unignored, user)

/obj/item/clothing/glasses/chameleon/ignoring/proc/ignore_chad(mob/ignored, mob/user)
	var/image/ignoring_image = image(loc = ignored)
	ignoring_image.override = TRUE
	LAZYADDASSOC(ignored_images, WEAKREF(ignored), ignoring_image)
	if(user)
		ignore_chads(user)

/obj/item/clothing/glasses/chameleon/ignoring/proc/unignore_chad(mob/unignored, mob/user)
	var/weakref = WEAKREF(unignored)
	var/ignoring_image = LAZYACCESS(ignored_images, weakref)
	user.client.images -= ignoring_image
	LAZYREMOVE(ignored_images, weakref)
	if(user)
		ignore_chads(user)

/obj/item/clothing/glasses/chameleon/ignoring/proc/ignore_chads(mob/user)
	for(var/weakref in ignored_images)
		var/image/ignored_image = ignored_images[weakref]
		user.client?.images |= ignored_image

/obj/item/clothing/glasses/chameleon/ignoring/proc/acknowledge_chads(mob/user)
	for(var/weakref in ignored_images)
		var/image/ignored_image = ignored_images[weakref]
		user.client?.images -= ignored_image

/obj/item/clothing/glasses/chameleon/ignoring/proc/client_logged_in(client/logged)
	ignore_chads(logged.mob)
