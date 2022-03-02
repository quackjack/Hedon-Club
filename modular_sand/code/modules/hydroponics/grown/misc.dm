/obj/item/seeds/bamboo
	mutatelist = list(/obj/item/seeds/bamboo/oxyboo, /obj/item/seeds/bamboo/nitroboo, /obj/item/seeds/bamboo/plasboo)
//Oxyboo
/obj/item/seeds/bamboo/oxyboo
	name = "pack of Oxyboo seeds"
	desc = "A species of bamboo that produces elevated levels of oxygen. The gas stops being produced in difficult atmospheric conditions."
	plantname = "Oxyboo"
	genes = list()
	mutatelist = list()

/obj/item/seeds/bamboo/oxyboo/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

/obj/item/seeds/bamboo/nitroboo
	name = "pack of Nitroboo seeds"
	desc = "A species of bamboo that produces elevated levels of nitrogen. The gas stops being produced in difficult atmospheric conditions."
	plantname = "Nitroboo"
	genes = list()
	mutatelist = list()

/obj/item/seeds/bamboo/nitroboo/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

/obj/item/seeds/bamboo/plasboo
	name = "pack of Plasboo seeds"
	desc = "A species of bamboo that produces elevated levels of plasma. The gas stops being produced in difficult atmospheric conditions."
	plantname = "Plasboo"
	genes = list()
	mutatelist = list()

/obj/item/seeds/bamboo/plasboo/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

//I actually have no idea no idea why i fixed this for monstermos, but swayde, you owe me one!
