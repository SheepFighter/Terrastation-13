
/obj/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank"
	icon = 'objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",1000)
