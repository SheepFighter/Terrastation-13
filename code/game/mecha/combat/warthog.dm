/obj/mecha/combat/warthog
	desc = "Heavy-duty, top-of-the-line combat exosuit, developed just recently on space station 12."
	name = "Warthog"
	icon_state = "warthog"
	step_in = 5
	health = 1000
	deflect_chance = 40
	max_temperature = 8000
	infra_luminosity = 3
	var/zoom = 0
	var/thrusters = 0
	var/smoke = 5
	var/smoke_ready = 1
	var/smoke_cooldown = 100
	var/datum/effects/system/harmless_smoke_spread/smoke_system = new
	//operation_req_access = list(access_cent_specops)
	wreckage = "/obj/decal/mecha_wreckage/warthog"
	//add_req_access = 0
	internal_damage_threshold = 25
	force = 45
	max_equip = 9


/obj/mecha/combat/warthog/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/gatling
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/gatling
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/heatray
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/flamethrower
	ME.attach(src)
	ME = new /obj/
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack_fast
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack_fast
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster(src)
	ME.attach(src)
	src.smoke_system.set_up(3, 0, src)
	src.smoke_system.attach(src)
	return


/*/obj/mecha/combat/warthog/relaymove(mob/user,direction)
	if(user != src.occupant) //While not "realistic", this piece is player friendly.
		user.loc = get_turf(src)
		user << "You climb out from [src]"
		return 0
	if(!can_move)
		return 0
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while connected to the air system port")
			last_message = world.time
		return 0
	if(!thrusters && src.pr_inertial_movement.active())
		return 0
	if(state || !get_charge())
		return 0
	var/tmp_step_in = step_in
	var/tmp_step_energy_drain = step_energy_drain
	var/move_result = 0
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		move_result = step_rand(src)
	else if(src.dir!=direction)
		src.dir=direction
		move_result = 1
	else
		move_result	= step(src,direction)
	if(move_result)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
				if(thrusters)
					src.pr_inertial_movement.set_process_args(list(src,direction))
					tmp_step_energy_drain = step_energy_drain*2

		can_move = 0
		spawn(tmp_step_in) can_move = 1
		use_power(tmp_step_energy_drain)
		return 1
	return 0*/

/obj/mecha/combat/warthog/relaymove(mob/user,direction)
	if(src.remote_controlled) //If remote controlled by the ai.
		//world << "Relaying AI mecha move."
		if(user != remote_controlled) //Invalid user.
			return 0
		if(!can_move) //If can't move.
			return 0
		if(zoom)
			if(world.time - last_message > 20)
				src.occupant_message("Unable to move while in zoom mode.")
				last_message = world.time
			return 0
		if(connected_port)
			if(world.time - last_message > 20)
				src.occupant_message("Unable to move while connected to the air system port")
				last_message = world.time
			return 0
		if(!thrusters && src.pr_inertial_movement.active())
			return 0
		if(state || !get_charge())
			return 0
		var/tmp_step_in = step_in
		var/tmp_step_energy_drain = step_energy_drain
		var/move_result = 0
		if(internal_damage&MECHA_INT_CONTROL_LOST)
			move_result = step_rand(src)
		else if(src.dir!=direction)
			src.dir=direction
			move_result = 1
		else
			move_result	= step(src,direction)
		if(move_result)
			can_move = 0
			use_power(step_energy_drain)
			if(istype(src.loc, /turf/space))
				if(!src.check_for_support())
					src.pr_inertial_movement.start(list(src,direction))
					if(thrusters)
						src.pr_inertial_movement.set_process_args(list(src,direction))
						tmp_step_energy_drain = step_energy_drain*2


			can_move = 0
			spawn(tmp_step_in) can_move = 1
			use_power(tmp_step_energy_drain)
			return 1

		return 0

	else
		//world << "Relaying occupant mecha move."
		if(user != src.occupant) //While not "realistic", this piece is player friendly.
			user.loc = get_turf(src)
			user << "You climb out from [src]"
			return 0
		if(!can_move)
			return 0
		if(zoom)
			if(world.time - last_message > 20)
				src.occupant_message("Unable to move while in zoom mode.")
				last_message = world.time
			return 0
		if(connected_port)
			if(world.time - last_message > 20)
				src.occupant_message("Unable to move while connected to the air system port")
				last_message = world.time
			return 0
		if(!thrusters && src.pr_inertial_movement.active())
			return 0
		if(state || !get_charge())
			return 0
		var/tmp_step_in = step_in
		var/tmp_step_energy_drain = step_energy_drain
		var/move_result = 0
		if(internal_damage&MECHA_INT_CONTROL_LOST)
			move_result = step_rand(src)
		else if(src.dir!=direction)
			src.dir=direction
			move_result = 1
		else
			move_result	= step(src,direction)
		if(move_result)
			can_move = 0
			use_power(step_energy_drain)
			if(istype(src.loc, /turf/space))
				if(!src.check_for_support())
					src.pr_inertial_movement.start(list(src,direction))
					if(thrusters)
						src.pr_inertial_movement.set_process_args(list(src,direction))
						tmp_step_energy_drain = step_energy_drain*2


			can_move = 0
			spawn(tmp_step_in) can_move = 1
			use_power(tmp_step_energy_drain)
			return 1
		return 0


/obj/mecha/combat/warthog/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle thrusters"
	set src in view(0)
	if(usr!=src.occupant && usr != src.occupant)
		return
	if(src.occupant || src.remote_controlled)
		if(get_charge() > 0)
			thrusters = !thrusters
			src.log_message("Toggled thrusters.")
			src.occupant_message("<font color='[src.thrusters?"blue":"red"]'>Thrusters [thrusters?"en":"dis"]abled.")
	return


/obj/mecha/combat/warthog/verb/smoke()
	set category = "Exosuit Interface"
	set name = "Smoke"
	set src in view(0)
	if(usr!=src.occupant && usr != src.remote_controlled)
		return
	if(smoke_ready && smoke>0)
		src.smoke_system.start()
		smoke--
		smoke_ready = 0
		spawn(smoke_cooldown)
			smoke_ready = 1
	return

/obj/mecha/combat/warthog/verb/zoom()
	set category = "Exosuit Interface"
	set name = "Zoom"
	set src in view(0)
	if(usr!=src.occupant && usr != src.remote_controlled)
		return
	if(src.occupant)
		if(src.occupant.client)
			src.zoom = !src.zoom
			src.log_message("Toggled zoom mode.")
			src.occupant_message("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
			if(zoom)
				src.occupant.client.view = 12
				src.occupant << sound('imag_enh.ogg',volume=50)
			else
				src.occupant.client.view = world.view//world.view - default mob view size
	else
		if(src.remote_controlled.client)
			src.zoom = !src.zoom
			src.log_message("Toggled zoom mode.")
			src.occupant_message("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
			if(zoom)
				src.remote_controlled.client.view = 12
				src.remote_controlled << sound('imag_enh.ogg',volume=50)
			else
				src.remote_controlled.client.view = world.view//world.view - default mob view size

	return


/obj/mecha/combat/warthog/go_out()
	if(src.occupant && src.occupant.client)
		src.occupant.client.view = world.view
		src.zoom = 0
	else if(src.remote_controlled && src.remote_controlled.client)
		src.remote_controlled.client.view = world.view
		src.zoom = 0
	..()
	return

/obj/mecha/combat/warthog/get_stats_part()
	var/output = ..()
	output += {"<b>Smoke:</b> [smoke]
					<br>
					<b>Thrusters:</b> [thrusters?"on":"off"]
					"}
	return output


/obj/mecha/combat/warthog/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_thrusters=1'>Toggle thrusters</a><br>
						<a href='?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/warthog/Topic(href, href_list)
	..()
	if (href_list["toggle_thrusters"])
		src.toggle_thrusters()
	if (href_list["smoke"])
		src.smoke()
	if (href_list["toggle_zoom"])
		src.zoom()
	return