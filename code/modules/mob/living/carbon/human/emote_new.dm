/datum/emote/humanoid
	mob_type = /mob/living/carbon/human/

/datum/emote/humanoid_complex/

/datum/emote/humanoid/airguitar
	flags = EMOTE_ACTIVITY
	name = "air-guitar"
	triggers = list("airguitar")
	message = "{USER} is strumming the air and headbanging like a safari chimp."

/datum/emote/humanoid/dance
	flags = EMOTE_ACTIVITY
	name = "dance"
	triggers = list("dance")


/datum/emote/humanoid/jump
	flags = EMOTE_ACTIVITY
	name = "jump"
	triggers = list("jump")
	message = "{USER} jumps!"

/datum/emote/humanoid/blink
	name = "blink"
	triggers = list("blink(s)")
	message = "{USER} blinks."

/datum/emote/humanoid/blink_r
	name = "blink"
	triggers = list("blink(s)_r")
	message = "{USER} blinks rapidly."

/datum/emote/humanoid/misc_activity/
	flags = EMOTE_STANDING
	message_restrained = "{USER} struggles to move."

/datum/emote/humanoid/misc_activity/bow
	name = "bow"
	triggers = list("bow(s)")
	message = "{USER} bows."
	message_target = "{USER} bows to {TARGET}."

/datum/emote/humanoid/misc_activity/salute
	name = "salute"
	triggers = list("salute(s)")
	message = "{USER} salutes."
	message_target = "{USER} salutes to {TARGET}."

/datum/emote/humanoid/misc_activity/hug
	name = "hug"
	triggers = list("hug(s)")
	message = "{USER} hugs \himself."

/datum/emote/humanoid/misc_activity/wave
	name = "wave"
	triggers = list("wave(s)")
	message = "{USER} waves."
	message_target = "{USER} waves at {TARGET}."

/datum/emote/humanoid/misc_activity/glare
	name = "glare"
	triggers = list("glare(s)")
	message = "{USER} glares."
	message_target = "{USER} glares at {TARGET}."

/datum/emote/humanoid/misc_activity/stare
	name = "stare"
	triggers = list("stare(s)")
	message = "{USER} stares."
	message_target = "{USER} stares at {TARGET}."

/datum/emote/humanoid/misc_activity/look
	name = "look"
	triggers = list("look(s)")
	message = "{USER} looks about."
	message_target = "{USER} looks at {TARGET}."

/datum/emote/humanoid/misc_activity/grin
	name = "grin"
	triggers = list("grin(s)")
	message = "{USER} grins."
	message_target = "{USER} grins at {TARGET}."

/datum/emote/humanoid/misc_activity/nod
	name = "nod"
	triggers = list("nod(s)")
	message = "{USER} nods."
	message_target = "{USER} nods at {TARGET}."

/datum/emote/humanoid/misc_activity/frown
	name = "frown"
	triggers = list("frown(s)")
	message = "{USER} frowns."
	message_target = "{USER} frowns at {TARGET}."


/datum/emote/humanoid/choke
	name = "choke"
	triggers = list("choke(s)")
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN
	message = "{USER} chokes!"
	message_muzzled = "{USER} makes a strong noise."

/datum/emote/humanoid/choke/mime
	flags = 0
	mob_type = null
	tag = "mime"
	message = "{USER} clutches \his throat desperately!"
	message_muzzled = ""

/datum/emote/humanoid/burp
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN
	name = "burp"
	triggers = list("burp(s)")
	message = "{USER} burps."
	message_muzzled = "{USER} makes a peculiar noise."

/datum/emote/humanoid/burp/mime
	flags = 0
	mob_type = null
	tag = "mime"
	message = "{USER} opens \his mouth rather obnoxiously."
	message_muzzled = ""

/datum/emote/humanoid/clap
	flags = EMOTE_AUDIBLE | EMOTE_ACTIVITY
	name = "clap"
	triggers = list("clap(s)")
	message = "{USER} claps."
	message_restrained = "{USER} struggles to move."

/datum/emote/humanoid/clap/mime
	mob_type = null
	flags = EMOTE_ACTIVITY
	tag = "mime"

/datum/emote/humanoid/flap
	flags = EMOTE AUDIBLE | EMOTE_ACTIVITY
	name = "flap"
	triggers = list("flap(s)")
	message = "{USER} flaps \his wings."
	message_restrained = "{USER} writhes!"
/datum/emote/humanoid/flap/mime
	mob_type = null
	flags = EMOTE_ACTIVITY
	tag = "mime"
/datum/emote/humanoid/flip
	name = "flip"
	triggers = list("flip(s)")
	cooldown = EMOTE_COOLDOWN
/datum/emote/humanoid/flip/execute(var/mob/M, param = "") //This is ludicrously specialized, so I don't see any value in standardizing it at present.
	set waitfor = FALSE
	if(!restrained())
		var/T = null
		if(param)
			for(var/mob/A in M.view(1, null))
				if(param == A.name)
					T = A
					break
		if(T == M)
			T = null

		if(T)
			if(M.lying)
				message = "<B>[M]</B> flops and flails around on the floor."
			else
				message = "<B>[M]</B> flips in [T]'s general direction."
				M.SpinAnimation(5,1)
		else
			if(M.lying || M.weakened)
				message = "<B>[M]</B> flops and flails around on the floor."
			else
				var/obj/item/weapon/grab/G
				if(istype(M.get_active_hand(), /obj/item/weapon/grab))
					G = M.get_active_hand()
				if(G && G.affecting)
					if(M.buckled || G.affecting.buckled)
						return
					var/turf/oldloc = M.loc
					var/turf/newloc = G.affecting.loc
					if(isturf(oldloc) && isturf(newloc))
						M.SpinAnimation(5,1)
						M.forceMove(newloc)
						G.affecting.forceMove(oldloc)
						message = "<B>[M]</B> flips over [G.affecting]!"
				else
					if(prob(5))
						message = "<B>[M]</B> attempts a flip and crashes to the floor!"
						M.SpinAnimation(5,1)
						sleep(3)
						M.Weaken(2)
					else
						message = "<B>[M]</B> does a flip!"
						M.SpinAnimation(5,1)
	..()

/datum/emote/humanoid/aflap
	flags = EMOTE_AUDIBLE | EMOTE_ACTIVITY
	name = "flap angrily"
	triggers = list("aflap(s)")
	message = "{USER} flaps \his wings ANGRILY!"
	message_restrained = "{USER} writhes angrily!"

/datum/emote/humanoid/aflap/mime
	mob_type = null
	flags = EMOTE_ACTIVITY
	tag = "mime"

/datum/emote/humanoid/drool
	name = "drool"
	triggers = list("drool(s)")
	message = "{USER} drools."
/datum/emote/humanoid/eyebrow
	triggers = list("eyebrow")
	message = "{USER} raises an eyebrow."

/datum/emote/humanoid/chuckle
	name = "chuckle"
	triggers = list("chuckle(s)")
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN
	message = "{USER} chuckles."
	message_muzzled = "{USER} makes a noise."
/datum/emote/humanoid/chuckle/mime
	mob_type = null
	flags = 0
	message = "{USER} appears to chuckle."
	tag = "mime"
	message_muzzled = ""

/datum/emote/humanoid/twitch
	name = "twitch violently"
	triggers = list("twitch(es)")
	message = "{USER} twitches violently."

/datum/emote/humanoid/twitch_s
	name = "twitch"
	triggers = list("twitch(es)_s")
	message = "{USER} twitches."

/datum/emote/humanoid/faint
	name = "faint"
	triggers = list("faint(s)")
	message = "{USER} faints."

/datum/emote/humanoid/faint/execute(var/mob/M, param = "")
	..()
	AdjustSleeping(2)

/datum/emote/humanoid/raise_hand
	name = "raise a hand"
	flags = EMOTE_ACTIVITY
	triggers = list("raise(s)", "raisehand")
	message = "{USER} raises a hand."
	message_restrained = "{USER} tries to move \his arm."

/datum/emote/humanoid/blush
	name = "blush"
	triggers = list("blush(es)")
	message = "{USER} blushes."

/datum/emote/humanoid/quiver
	name = "quiver"
	triggers = list("quiver(s)")
	message = "{USER} blushes."

/datum/emote/humanoid/gasp
	name = "gasp"
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN
	triggers = list("gasp(s)")
	message = "{USER} gasps!"
	message_muzzled = "{USER} makes a weak noise."

/datum/emote/humanoid/deathgasp
	name = "give a dying gasp"
	triggers = list("deathgasp(s)")
	message = "{USER} seizes up and falls limp, their eyes dead and lifeless..."


/datum/emote/humanoid/gasp/mime
	flags = 0
	mob_type = null
	tag = "mime"
	message = "{USER} appears to be gasping!"
	message_muzzled = ""

/datum/emote/humanoid/giggle
	name = "giggle"
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN | EMOTE_UNCONSCIOUS
	triggers = list("giggle(s)")
	message = "{USER} giggles!"
	message_muzzled = "{USER} makes a noise."

/datum/emote/humanoid/giggle/mime
	flags = EMOTE_UNCONSCIOUS
	mob_type = null
	tag = "mime"
	message = "{USER} giggles silently!"
	message_muzzled = ""
/datum/emote/humanoid/cry
	name = "cry"
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN
	triggers = list("cry", "cries")
	message = "{USER} cries."
	message_muzzled = "{USER} makes a weak noise. \He frowns."

/datum/emote/humanoid/cry/mime
	flag = 0
	mob_type = null
	message_muzzled = ""
	tag = "mime"

/datum/emote/humanoid/sigh
	name = "sigh"
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN
	triggers = list("sigh(s)")
	message = "{USER} sighs."
	message_target = "{USER} sighs at {TARGET}."
	message_muzzled = "{USER} makes a weak noise"

/datum/emote/humanoid/sigh/mime
	flags = 0
	mob_type = null
	message_muzzled = ""
	tag = "mime"

/datum/emote/humanoid/laugh
	name = "laugh"
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN | EMOTE_UNCONSCIOUS
	trigger = list("laugh(s)")
	message = "{USER} laughs."
	message_target = "{USER} laughs at {TARGET}."
	message_muzzled = "{USER} makes a noise."

/datum/emote/humanoid/laugh/mime
	flags = EMOTE_UNCONSCIOUS
	mob_type = null
	message = "{USER}  acts out a laugh."
	message_target = "{USER}  acts out a laugh at {TARGET}."
	message_muzzled = ""
	tag = "mime"
/datum/emote/humanoid/mumble
	name = "mumble"
	triggers = list("mumble(s)")
	flags = EMOTE_AUDIBLE
	message = "{USER} mumbles!"

/datum/emote/humanoid/mumble/mime
	flags = 0
	mob_type = null
	tag = "mime"

/datum/emote/humanoid/grumble
	name = "grumble"
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN
	triggers = list("grumble(s)")
	message = "{USER} grumbles!"
	message_target = "{USER} grumbles at {TARGET}!"
	message_muzzled = "{USER} makes a noise."

/datum/emote/humanoid/grumble/mime
	flags = 0
	mob_type = null
	message_muzzled = ""
	tag = "mime"

/datum/emote/humanoid/groan
	name = "groan"
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN | EMOTE_UNCONSCIOUS
	trigger = list("groan(s)")
	message = "{USER} groans!"
	message_muzzled = "{USER} makes a loud noise."

/datum/emote/humanoid/groan/mime
	flags = 0
	mob_type = null
	message = "{USER} appears to groan!"
	message_muzzled = ""
	tag = "mime"

/datum/emote/humanoid/moan/
	name = "moan"
	flags = EMOTE_AUDIBLE | EMOTE_UNCONSCIOUS
	trigger = list("moan(s)")
	message = "{USER} moans!"

/datum/emote/humanoid/moan/mime
	flags = EMOTE_UNCONSCIOUS
	mob_type = null
	message = "{USER} appears to moan!"
	tag = "mime"

/datum/emote/johnny	//Can only be used while smoking, natch.
	name = "take a drag"
	flags = EMOTE_AUDIBLE
	trigger = list("johnny")
	message_target = "{USER} says, \"{TARGET}, please. They had a family.\" {USER} takes a drag from a cigarette and blows their name out in smoke."


/datum/emote/johnny/mime
	flags = 0
	message_target = "{USER} takes a drag from a cigarette and blows \"{TARGET}\" out in smoke."
	tag = "mime"


/datum/emote/humanoid/shake
	parameter_flags = EMOTE_PARAMETER_NOT_SELF
	name = "head-shake"
	triggers = list("shake(s)", "head-shake")
	message = "{USER} shakes \his head."
	message_target = "{USER} shakes \his head at {TARGET}."
/datum/emote/humanoid/shrug
	name = "shrug"
	triggers = list("shrug(s)")
	message = "{USER} shrugs."









/datum/emote/humanoid/point
	name = "point"
	trigger = list("point(s)")
	flag = EMOTE_ACTIIVTY
	message = "{USER} points."


/datum/emote/humanoid/point/execute(var/mob/M, param = "", ignorecooldown = FALSE)
	set waitfor = FALSE

/datum/emote/humanoid/signal
/datum/emote/humanoid/complex/cough
	cooldown = EMOTE_COOLDOWN
	flags = EMOTE_AUDIBLE | EMOTE_SPOKEN | EMOTE_UNCONSCIOUS
	message = "{USER} coughs!"