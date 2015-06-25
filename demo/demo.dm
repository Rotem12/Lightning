#define DEBUG

world
	fps       = 10
	icon_size = 32

turf
	grass
		icon       = '1.dmi'
		icon_state = "grass"



mob
	icon       = '1.dmi'
	icon_state = "person"

	Stat()
		stat("CPU:", world.cpu)

	verb
		setColor(i_Color as color)

			c = i_Color

	verb
		setMode()
			mode++
			if(mode == 4)
				mode = 0
			if(mode == 0)
				world << "Draw lines"
				lines = list()
			else if(mode == 1)
				clear()
				world << "Draw bolts"
			else if(mode == 2)
				world << "Draw branched bolts"
			else if(mode == 3)
				world << "Draw branched bolts towards near mobs"

var/list/lines
proc/clear()
	for(var/obj/segment/s in lines)
		s.loc = null

var
	vector2
		A
		B

var/c = "#E4CCFF"
var/mode = 1

obj
	segment
		icon = 'segment.dmi'


turf
	Click()
		var/vector/start = new (usr.x * world.icon_size, usr.y * world.icon_size)
		var/vector/dest  = new (src.x * world.icon_size, src.y * world.icon_size)

		if(mode == 0)

			var/line/l = new(start, dest)
			lines += l.Draw(usr.z, /obj/segment, c)

		else if(mode == 1)

			var/bolt/b = new(start, dest, 50)
			b.Draw(usr.z, /obj/segment, c)

		else if(mode == 2)

			var/BranchedBolt/b = new(start, dest, 50)
			b.Draw(usr.z, /obj/segment, c)

		else if(mode == 3)

			var/BranchedBolt/b = new(start, dest, 50, ohearers())
			b.Draw(usr.z, /obj/segment, c)

