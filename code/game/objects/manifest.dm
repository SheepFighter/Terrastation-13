
/obj/manifest
	name = "manifest"
	icon = 'screen1.dmi'
	icon_state = "x"
	unacidable = 1//Just to be sure.

/obj/manifest/New()

	src.invisibility = 101
	return

/obj/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in world)
		dat += text("    <B>[]</B> -  []<BR>", M.name, M.get_assignment())
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew Manifest'"
	//SN src = null
	del(src)
	return
