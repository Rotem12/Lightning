#define DEBUG

world
	fps       = 20
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
			if(mode == 6)
				mode = 0

			if(mode == 0)
				world << "Draw lines"
				lines = list()
			if(mode == 1)
				world << "Draw beams"
				clear()
			else if(mode == 2)
				world << "Draw bolts"
			else if(mode == 3)
				world << "Draw branched bolts"
			else if(mode == 4)
				world << "Draw branched bolts towards near mobs"
			else if(mode == 5)
				world << "Draw two colored bolt"

var/list/lines
proc/clear()
	for(var/obj/segment/s in lines)
		s.loc = null

var/c = "#E4CCFF"
var/mode = 2

turf
	Click()
		var/vector/start = new (usr.x * world.icon_size, usr.y * world.icon_size)
		var/vector/dest  = new (src.x * world.icon_size, src.y * world.icon_size)

		// shoot from hand
		start.X += (WEST & usr.dir) ? 10 : 22
		start.Y += 14

		// middle of clicked turf
		dest.X += 16
		dest.Y += 16

		if(mode == 0)

			var/line/l = new(start, dest)
			lines += l.Draw(usr.z, color = c)

		else if(mode == 1)

			var/beam/b = new(start, dest, speed=20, fade=50)
			b.Draw(usr.z, color = c, thickness = 3)

		else if(mode == 2)

			var/bolt/b = new(start, dest, 50)
			b.Draw(usr.z, color = c)

		else if(mode == 3)

			var/BranchedBolt/b = new(start, dest, 50)
			b.Draw(usr.z, color = c)

		else if(mode == 4)

			var/BranchedBolt/b = new(start, dest, 50, ohearers())
			b.Draw(usr.z, color = c)
		else if(mode == 5)

			var/bolt/half/b = new(start, dest, 50)
			b.Draw(usr.z, color = "#30ff30", secondColor = "#ff3030", percent=0.5, thickness = 1)


