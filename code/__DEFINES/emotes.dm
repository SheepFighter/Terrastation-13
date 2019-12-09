#define EMOTE_COOLDOWN 20


#define EMOTE_AUDIBLE				1 //Emotes are assumed to be visible by default.
#define EMOTE_ACTIVITY				2 //Mob cannot be restrained and use this.
#define EMOTE_SPOKEN				4 //Mob cannot be mute or gagged and use this.
#define EMOTE_STANDING				8 //Mob cannot be buckled
#define EMOTE_UNCONSCIOUS			16//This emote does not require the mob to be awake.
#define EMOTE_HIDDEN				32//This emote doesn't show up when the "*help" command is made.

//Humanoid emotes
#define EMOTE_SOUND_GENDERED		64




#define EMOTE_RESTRAINED_MESSAGE	2
#define EMOTE_MUZZLED_MESSAGE		3

//Parameter flags
#define EMOTE_PARAMETER_NOT_SELF	1
#define EMOTE_PARAMETER_RETURN_MOB	2

#define ADD_EMOTE(x, y)	for(var/trig in ##x.triggers)	emotes_active[##y][trig] = ##x