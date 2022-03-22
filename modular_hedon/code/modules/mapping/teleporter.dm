GLOBAL_LIST_INIT(hedon_teleporters, list())

/turf/closed/indestructible/teleporter
	///All of this is modifiable, go nuts

	/// Name
	name = "wooden door"
	/// Description
	desc = "A dusty, scratched door with a thick lock attached.\n\
			<span class='notice'>Walk towards it to go somewhere.</span>"
	/// Icon
	icon = 'icons/obj/doors/puzzledoor/wood.dmi'
	/// Icon State
	icon_state = "door1"
	/// Direction - Determines entering, leaving directions.
	dir = SOUTH
	/// Enter Message - Message to display when going into the door.
	var/enter_message = "<span class='notice'>You go through the door.</span>"
	/// Exit Message - Message to display ONLY when going elsewhere otherwise "You decide not to go anywhere.".
	var/exit_message = "<span class='notice'>You went into %LOCATION%.</span>"

/turf/closed/indestructible/teleporter/Initialize()
	. = ..()
	GLOB.hedon_teleporters["[get_area(src)]"] = src
	if(!enter_message)
		enter_message = initial(enter_message)
		message_admins("The teleporter [name] at [ADMIN_VERBOSEJMP(src)] didn't set an enter_message stupid! It will be set to the original value.")
	if(!exit_message)
		exit_message = initial(exit_message)
		message_admins("The teleporter [name] at [ADMIN_VERBOSEJMP(src)] didn't set an exit_message stupid! It will be set to the original value.")
	if(isclosedturf(get_step(src, SOUTH)))
		message_admins("The teleporter [name]'s exit ([dir2text(dir)]) at [ADMIN_VERBOSEJMP(src)] is a closed turf! This is critical, if a mob goes through this teleporter, they might suffocate in a wall or get out of bounds!")

/turf/closed/indestructible/teleporter/Destroy(force)
	. = ..()
	GLOB.hedon_teleporters -= "[get_area(src)]"

/turf/closed/indestructible/teleporter/Bumped(mob/living/person)
	. = ..()
	do_the_thing(person)

/turf/closed/indestructible/teleporter/attack_hand(mob/user, act_intent, attackchain_flags)
	. = ..()
	do_the_thing(user)

/// Basically the entire functionally of this thing is here.
/turf/closed/indestructible/teleporter/proc/do_the_thing(mob/living/person)
	if(istype(person) && (stat == CONSCIOUS))
		to_chat(person, enter_message)
		person.forceMove(pick(GLOB.newplayer_start))
		var/atom/movable/screen/fullscreen/screen = person.overlay_fullscreen("hedon_teleporter", /atom/movable/screen/fullscreen/tiled/flash/black)
		var/turf/chosen_location = GLOB.hedon_teleporters[input(person, "Where do you want to go?", "Going somewhere.") as null|anything in (GLOB.hedon_teleporters - "[get_area(src)]")]
		if(chosen_location)
			person.forceMove(get_step(chosen_location, chosen_location.dir))
			person.setDir(chosen_location.dir)
			to_chat(person, replacetext(exit_message, "%LOCATION%", get_area(chosen_location)))
		else
			person.forceMove(get_step(src, dir))
			person.setDir(dir)
			to_chat(person, "<span class='notice'>You decide to not go anywhere.</span>")
		person.clear_fullscreen("hedon_teleporter", 2 SECONDS)

/// It's just used to make your screen completely black.
/atom/movable/screen/fullscreen/tiled/flash/black
	color = "black"
