
/obj/item/weapon/cleaner
	desc = "Space Cleaner!"
	icon = 'janitor.dmi'
	name = "space cleaner"
	icon_state = "cleaner"
	item_state = "cleaner"
	flags = ONBELT|TABLEPASS|OPENCONTAINER|FPRINT|USEDELAY
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10

/obj/item/weapon/cleaner/New()
	var/datum/reagents/R = new/datum/reagents(250)
	reagents = R
	R.my_atom = src
	R.add_reagent("cleaner", 250)

/obj/item/weapon/cleaner/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/cleaner/afterattack(atom/A as mob|obj, mob/user as mob)
	if (istype(A, /obj/item/weapon/storage/backpack ))
		return
	else if (src.reagents.total_volume < 1)
		user << "\blue [src] is empty!"
		return

	var/obj/decal/D = new/obj/decal(get_turf(src))
	D.create_reagents(5)
	src.reagents.trans_to(D, 5)

	var/list/rgbcolor = list(0,0,0)
	var/finalcolor
	for(var/datum/reagent/re in D.reagents.reagent_list) // natural color mixing bullshit/algorithm
		if(!finalcolor)
			rgbcolor = GetColors(re.color)
			finalcolor = re.color
		else
			var/newcolor[3]
			var/prergbcolor[3]
			prergbcolor = rgbcolor
			newcolor = GetColors(re.color)

			rgbcolor[1] = (prergbcolor[1]+newcolor[1])/2
			rgbcolor[2] = (prergbcolor[2]+newcolor[2])/2
			rgbcolor[3] = (prergbcolor[3]+newcolor[3])/2

			finalcolor = rgb(rgbcolor[1], rgbcolor[2], rgbcolor[3])
			// This isn't a perfect color mixing system, the more reagents that are inside,
			// the darker it gets until it becomes absolutely pitch black! I dunno, maybe
			// that's pretty realistic? I don't do a whole lot of color-mixing anyway.
			// If you add brighter colors to it it'll eventually get lighter, though.

	D.name = "chemicals"
	D.icon = 'chempuff.dmi'

	D.icon += finalcolor

	playsound(src.loc, 'spray2.ogg', 50, 1, -6)

	spawn(0)
		for(var/i=0, i<3, i++)
			step_towards(D,A)
			D.reagents.reaction(get_turf(D))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)
			sleep(3)
		del(D)

	if(isrobot(user)) //Cyborgs can clean forever if they keep charged
		var/mob/living/silicon/robot/janitor = user
		janitor.cell.charge -= 20
		var/refill = src.reagents.get_master_reagent_id()
		spawn(600)
			src.reagents.add_reagent(refill, 10)

	return

/obj/item/weapon/cleaner/examine()
	set src in usr
	for(var/datum/reagent/R in reagents.reagent_list)
		usr << text("\icon[] [] units of [] left!", src, round(R.volume), R.name)
	//usr << text("\icon[] [] units of cleaner left!", src, src.reagents.total_volume)
	..()
	return
