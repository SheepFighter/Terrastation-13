
/obj/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'stationobjs.dmi'
	icon_state = "morguet"
	density = 1
	layer = 2.0
	var/obj/morgue/connected = null
	anchored = 1.0

/obj/m_tray/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover, /obj/item/weapon/dummy))
		return 1
	else
		return ..()

/obj/m_tray/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/m_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.loc = src.connected
			//Foreach goto(26)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		del(src)
		return
	return

/obj/m_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
		return
	if (!ismob(O))
		return
	O.loc = src.loc
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				B << text("\red [] stuffs [] into []!", user, O, src)
			//Foreach goto(99)
	return
