extends Node


var sfx_volume = 0
var music_volume = 0

const sound_dictionary = {
	"BGM": {
		"reeling_em_in": preload("uid://domx4xdpapir"),
		"pier": preload("uid://domx4xdpapir"),
		"stadium": preload("uid://domx4xdpapir"),
		"whirlpool": preload("uid://domx4xdpapir"),
	},
	
	"SFX": {
		
		"speak": {
			"player": preload("uid://domx4xdpapir"),
			"business_fish": preload("uid://domx4xdpapir"),
			"business_wife_fish": preload("uid://domx4xdpapir"),
			"futbol_fish": preload("uid://domx4xdpapir"),
		},
		
		"salmon_peeling_dying": preload("uid://domx4xdpapir"),
		"salmon_glorious": preload("uid://domx4xdpapir"),
		"goalie_noises": preload("uid://domx4xdpapir"),
		
		"rod_reeling": preload("uid://domx4xdpapir"),
		"caught_fish": preload("uid://domx4xdpapir"),
		
		"explosion": preload("uid://dwhjp6piyj1xb")
		
	}
}

const art_dictionary = {
	"background": {
		"peeling_salmon": {
			"ancestor": preload("uid://6pk6tps1g15o"),
			"ashes": preload("uid://dl7ktff17qw3d")
		}
	}
}

const visual_novel_scene = preload("uid://bhbbqp2bl8i8l")
