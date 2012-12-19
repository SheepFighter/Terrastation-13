
/obj/machinery/camera
	name = "Security Camera"
	desc = "This is used to monitor rooms. Can see through walls."
	icon = 'monitors.dmi'
	icon_state = "camera"
	var/network = "SS13"
	layer = 5
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = 1.0
	var/invuln = null
	var/bugged = 0
	var/hardened = 0
	use_power = 2
	idle_power_usage = 5
	active_power_usage = 10

/obj/machinery/camera/emp_act(severity)
	if(prob(100/(hardened + severity)))
		icon_state = "cameraemp"
		network = null                   //Not the best way but it will do. I think.
		spawn(900)
			network = initial(network)
			icon_state = initial(icon_state)
		for(var/mob/living/silicon/ai/O in world)
			if (O.current == src)
				O.cancel_camera()
				O << "Your connection to the camera has been lost."
		for(var/mob/O in world)
			if (istype(O.machine, /obj/machinery/computer/security))
				var/obj/machinery/computer/security/S = O.machine
				if (S.current == src)
					O.machine = null
					S.current = null
					O.reset_view(null)
					O << "The screen bursts into static."
		..()

/obj/machinery/camera/ex_act(severity)
	if(src.invuln)
		return
	else
		..(severity)
	return

/obj/machinery/camera/blob_act()
	return

/obj/machinery/camera/attack_ai(var/mob/living/silicon/ai/user as mob)
	if (!istype(user))
		return
	if (src.network != user.network || !(src.status))
		return
	user.current = src
	user.reset_view(src)

/obj/machinery/camera/attackby(W as obj, user as mob)
	..()
	if (istype(W, /obj/item/weapon/wirecutters))
		deactivate(user)
	else if (istype(W, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/X = W
		user << "You hold a paper up to the camera ..."
		for(var/mob/living/silicon/ai/O in world)
			//if (O.current == src)
			O << "[user] holds a paper up to one of your cameras ..."
			O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
		for(var/mob/O in world)
			if (istype(O.machine, /obj/machinery/computer/security))
				var/obj/machinery/computer/security/S = O.machine
				if (S.current == src)
					O << "[user] holds a paper up to one of the cameras ..."
					O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
	else if (istype(W, /obj/item/weapon/wrench)) //Adding dismantlable cameras to go with the constructable ones. --NEO
		if(src.status)
			user << "\red You can't dismantle a camera while it is active."
		else
			user << "\blue Dismantling camera..."
			if(do_after(user, 20))
				var/obj/item/weapon/chem_grenade/case = new /obj/item/weapon/chem_grenade(src.loc)
				case.name = "Camera Assembly"
				case.path = 2
				case.state = 5
				case.anchored = 1
				case.circuit = new /obj/item/device/multitool
				if (istype(src, /obj/machinery/camera/motion))
					case.motion = 1
			del(src)
	else if (istype(W, /obj/item/weapon/camera_bug))
		if (!src.status)
			user << "\blue Camera non-functional"
			return
		if (src.bugged)
			user << "\blue Camera bug removed."
			src.bugged = 0
		else
			user << "\blue Camera bugged."
			src.bugged = 1
	else if(istype(W, /obj/item/weapon/melee/energy/blade))//Putting it here last since it's a special case. I wonder if there is a better way to do these than type casting.
		deactivate(user,2)//Here so that you can disconnect anyone viewing the camera, regardless if it's on or off.
		var/datum/effects/system/spark_spread/spark_system = new /datum/effects/system/spark_spread()
		spark_system.set_up(5, 0, loc)
		spark_system.start()
		playsound(loc, 'blade1.ogg', 50, 1)
		playsound(loc, "sparks", 50, 1)

		var/obj/item/weapon/chem_grenade/case = new /obj/item/weapon/chem_grenade(loc)
		case.name = "Camera Assembly"
		case.path = 2
		case.state = 5
		case.anchored = 1
		case.circuit = new /obj/item/device/multitool
		if (istype(src, /obj/machinery/camera/motion))
			case.motion = 1

		for(var/mob/O in viewers(user, 3))
			O.show_message(text("\blue The camera has been sliced apart by [] with an energy blade!", user), 1, text("\red You hear metal being sliced and sparks flying."), 2)
		del(src)
	return

/obj/machinery/camera/proc/deactivate(user as mob, var/choice = 1)
	if(choice==1)
		status = !( src.status )
		if (!(src.status))
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] has deactivated []!", user, src), 1)
				playsound(src.loc, 'Wirecutter.ogg', 100, 1)
			icon_state = "camera1"
		else
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] has reactivated []!", user, src), 1)
				playsound(src.loc, 'Wirecutter.ogg', 100, 1)
			icon_state = "camera"
	// now disconnect anyone using the camera
	//Apparently, this will disconnect anyone even if the camera was re-activated.
	//I guess that doesn't matter since they can't use it anyway?
	for(var/mob/living/silicon/ai/O in world)
		if (O.current == src)
			O.cancel_camera()
			O << "Your connection to the camera has been lost."
	for(var/mob/O in world)
		if (istype(O.machine, /obj/machinery/computer/security))
			var/obj/machinery/computer/security/S = O.machine
			if (S.current == src)
				O.machine = null
				S.current = null
				O.reset_view(null)
				O << "The screen bursts into static."

/proc/camera_sort(list/L)
	var/obj/machinery/camera/a
	var/obj/machinery/camera/b

	for (var/i = L.len, i > 0, i--)
		for (var/j = 1 to i - 1)
			a = L[j]
			b = L[j + 1]
			if (a.c_tag_order != b.c_tag_order)
				if (a.c_tag_order > b.c_tag_order)
					L.Swap(j, j + 1)
			else
				if (sorttext(a.c_tag, b.c_tag) < 0)
					L.Swap(j, j + 1)
	return L

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)

	for(var/obj/machinery/camera/C in oview(M))
		if(C.status)	// check if camera disabled
			return C
			break

	return null
