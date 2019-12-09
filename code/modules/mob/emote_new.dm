var/list/emotes_mob = list()		//Emotes specific to a type of mob.
var/list/emotes_special = list()	//Emotes otherwise acquired. These override any counterparts that might exist in emotes_mob
var/list/emotes_active = list()		//Special emotes as assigned to creatures.
var/list/emotes_tags_active = list()
var/list/emotes_general = list()	//Miscellaneous emotes, sorted only by tag.
var/list/emotes_help = list()		//Used for the *help command.


/proc/instantiate_emotes()
	var/datum/emote/emote
	for(var/E in typesof(/datum/emote/))
		emote = new E
		emote.Initialize()

/datum/emote/
	var/flags = 0
	var/parameter_flags = 0	//Passed to handle_emote_param()
	var/vicinity = 0	//Ditto
	var/cooldown = 0 //Measured in deciseconds.
	var/mob_type
	var/name = "emote"
	var/tag	//Used for grouping special emotes.
	var/list/triggers = list()
	var/message = ""
	var/sound
	var/sound_male
	var/sound_female
	var/message_target = ""	//Text to append if a target is selected.
	var/message_restrained = ""	//Message to give if the mob attempts this emote while restrained.
	var/message_muzzled = ""	//Etc.
	var/help_text = ""		//Info to append if an emote takes special parameters.
/datum/emote/complex
	var/messages = list()





/datum/emote/proc/Initialize()
	if(!triggers.len)
		qdel(src)
		return
	var/list/L
	var/list/tr = triggers.Copy()
	var/i = 1
	if(help_text)
		help_text = "-[help_text]"
	for(var/tg in triggers)
		i++
		if(findtext(tg, "(s)"))
			var/tg2 = replacetext(tg, "(s)", "")
			var/tg3 = replacetext(tg, "(s)", "s")
			if(!emotes_help[tg2])
				emotes_help[tg2] = "[tg][help_text ? [message ? "-(none)/mob" : "-mob"] : "[help_text]"]"
				emotes_help[tg3] = ""
			tr.Insert(i, tg3)
			tr[i - 1] = tg2
			i++
		else if(findtext(tg, "(es)"))
			var/tg2 = replacetext(tg, "(es)", "")
			var/tg3 = replacetext(tg, "(es)", "es")
			if(!emotes_help[tg2])
				emotes_help[tg2] = "[tg][help_text ? [message ? "-(none)/mob" : "-mob"] : "[help_text]"]"
				emotes_help[tg3] = ""
			tr.Insert(I, tg3)
			tr[i - 1] = tg2
			i++
		else if(!emotes_help[tg])
			emotes_help[tg] = "[tg][help_text ? [message ? "-(none)/mob" : "-mob"] : "[help_text]"]"

	if(mob_type)
		if(!emotes_mob[mob_type])
			L = list()
			for(var/M in typesof(mob_type))
				emotes_mob[M] = L
		else
			L = emotes_mob[mob_type]
		for(var/tg in tr)
			L[tg] = src
	else if(tag)
		if(emotes_special[tag])
			L = emotes_special[tag]
		else
			L = list()
			emotes_special[tag] = L
		L += src
		for(var/P in emotes_tags_active)
			var/mob/M = P
			if(tag in emotes_tags_active[M])
				M.add_special_emote(emote = src)
	else
		qdel(src)
		return

/datum/emote/proc/execute(var/mob/M, param = "", ignorecooldown = FALSE)
	set waitfor = FALSE
	if(cooldown && !ignorecooldown)
		if(M.handle_emote_CD(cooldown))
			return

	var/h = handle(M)
	if(!h)
		return
	var/msg = message
	if(param && message_target)
		var/trgt = handle_emote_param(param, M, vicinity, parameter_flags)
		if(trgt)
			msg = replacetext(message_target, "{TARGET}, "[trgt]")
	if(!msg)
		return
	switch(h)
		if(EMOTE_RESTRAINED_MESSAGE)
			msg = message_restrained
		if(EMOTE_MUZZLED_MESSAGE)
			msg = message_muzzled
	msg = replacetext(msg, "{USER}", "<B>[M]</B>")

	if(flags & EMOTE_AUDIBLE)
		M.audible_message(msg)
	else
		M.visible_message(msg)

/datum/emote/proc/handle(var/mob/M)
	if(cooldown && M.emote_cd)
		return 0
	if(M.sleeping && flags & ~EMOTE_UNCONSCIOUS)
	to_chat(M, "You can't [name] while unconscious!")
		return 0
	if(flags & EMOTE_ACTIVITY && M.restrained())
		if(message_restrained)
			return EMOTE_RESTRAINED_MESSAGE
		else
			to_chat(M, "You can't [name] while restrained!")
			return 0
	if(flags & EMOTE_STANDING && (M.buckled || M.lying))
		to_chat(M, "You must be standing up to [name]!")
		return 0
	if(flags & EMOTE_SPOKEN && M.is_muzzled())
		if(message_muzzled)
			return EMOTE_MUZZLED_MESSAGE
		else
			to_chat(M, "You can't [name] while gagged!")
			return 0
	return 1
/datum/emote/proc/handle_emote_param(var/target, var/mob/M, var/vicinity, var/flags) //Only returns not null if the target param is valid.
	if(target)																		 //vicinity is the distance passed to the view proc.
		for(var/mob/A in view(vicinity, M))
			if(target == A.name && (flags & ~EMOTE_PARAMETER_NOT_SELF || (flags & EMOTE_PARAMETER_NOT_SELF && target != M.name)))
				if(flags & ~EMOTE_PARAMETER_RETURN_MOB)
					return A
				else
					return target
/datum/emote/complex
	var/complex_flags
	var/tone_min = 0
	var/tone_max = 0
	var/trigger_tags = list()
	var/list/messages = list()
	var/list/sounds = list()
	var/list/tones = list()
	/*Example:
		complex_flags = EMOTE_COMPLEX_SOUND_GENDERED
		trigger_tags = list("happy", "sad")
		messages = list("happy" = "{USER} emotes", "sad = "{USER} emotes glumly")
		sounds = list("happy_male" = 'sound/effects/emote.ogg',
		"happy_female' = 'sound/effects/emote_female.ogg',
		"sad_male" = 'sound/effects/cry_male.ogg',
		"sad_female" = 'sound/effects/cry_female.ogg')
		tones = list("happy_male" = list(50, 1, -3), "sad_female" = list(70, 0, 1))
	)
*/
/datum/emote/complex/execute(var/mob/M, param = "")
	set waitfor = FALSE
	if(!is_valid(M))
		return
	var/tg = pick(trigger_tags)
	if(complex_flags & EMOTE_COMPLEX_SOUND_GENDERED)
		switch(M.gender)
			if(FEMALE)
				tg += "_female"
			if(MALE)
				tg += "_male"

	var/msg = messages[tg]
	msg = replacetext(msg, "{USER}", "[M]")
	if(param && target_text)
		var/trgt = handle_emote_param(param)
		if(trgt)
			msg = replacetext(msg, "{TARGET_TEXT}, "[trgt]")

	if(flags & EMOTE_AUDIBLE)
		M.audible_message(msg)
	else
		M.visible_message(msg)
	if(sounds[tg])
		playsound


/mob/proc/emote(trigger = "", var/datum/emote/emote = null, param = "")
	var/datum/emote/E = null
	if(trigger)
		E = emotes_active[src][trigger]
		if(!E)
			E = emotes_mob[src.type][trigger]
		if(!E)
			return
	else if(emote)
		E = emote

	E.execute(src, param)

/mob/proc/add_special_emote(var/datum/emote/emote = null, var/tag = "", var/trigger = "")
	if(!emotes_active[src])
		emotes_active[src] = list()
	if(emote)
		ADD_EMOTE(emote, src)
		return
	else if(tag) //Add all emotes with this tag.
		var/list/L = emotes_special[tag]
		if(!L)
			return
		for(var/datum/emote/E in L)
			ADD_EMOTE(E, src) //Note that this necessarily overwrites any entries with the same trigger. This may, of course, be precisely what you intend to do.

	else if(trigger)
		var/datum/emote/E
		var/list/L = emotes_tags_active[src]
		if(L)
			for(var/tg in L)
				E = emotes_special[tg][trigger]
				if(E)
					ADD_EMOTE(E, src)
					break

	return

/mob/proc/remove_special_emote(var/datum/emote/emote = null, var/tag = "", var/trigger = "")
	if(!emotes_active[src])
		return
	if(emote)
		for(var/tr in emote.triggers)
			if(emotes_active[src][tr] == emote)
				emotes_active[src] -= tr
		return

	else if(tag)
		for(var/tr in emotes_active[src])
			emote = emotes_active[src][tr]
			if(tag == emote.tag)
				emotes_active[src] -= emotes_active[src][tr]
	else if(trigger)
		emotes_active[src] -= emotes_active[src][trigger]

/mob/proc/assign_emote_tag(tg, priority = 1)
	var/list/L
	if(!emotes_tags_active[src])
		emotes_tags_active[src] = list()
	L = emotes_tags_active[src]
	L.Insert(priority, tg)

/mob/proc/unassign_emote_tag(tg)
	var/list/L = emotes_tags_active[src]
	if(!L)
		return
	L -= tg

/mob/proc/emote_tag_swap(tag_1, tag_2)
	if(!emotes_special[tag_2])
		return
	var/datum/emote/E
	var/list/L = list()
	for(var/datum/emote/emote in emotes_special[tag_2])
		for(var/tr in emote.triggers)
			L[tr] = emote
	for(var/tr in emotes_active[src])
		E = emotes_active[src][tr]
		if(E.tag == tag_1 && L[tr])
			emotes_active[src][tr] = L[tr]

/mob/proc/emote_help()
	var/emotelist = ""
	for(var/emote in emotes_mob[src.type])
		if(emotes_help[emote])
			emotelist += "[emotelist ? ", " : ""][emotes_help[emote]]"

	if(emotes_active[src])
		for(var/emote in emotes_active[src])
			if(emotes_help[emote])
				emotelist += "[emotelist ? ", " : ""][emotes_help[emote]]"
	to_chat(src, emotelist)