#define DEBUG

world/fps = 10

turf
	grass
		icon       = '1.dmi'
		icon_state = "grass"



mob
	icon       = '1.dmi'
	icon_state = "person"


	verb
		setColor(i_Color as color)

			c = i_Color

	verb
		setMode()
			mode++
			if(mode == 3)
				mode = 0

			if(mode == 0)      world << "Draw lines"
			else if(mode == 1) world << "Draw bolts"
			else if(mode == 2) world << "Draw branched bolts"

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
		var/vector/start = new (usr.x * 32, usr.y * 32)
		var/vector/dest  = new (src.x * 32, src.y * 32)

		if(mode == 0)

			var/line/l = new(start, dest)
			l.Draw(usr.z, /obj/segment, c)

		else if(mode == 1)

			var/bolt/b = new(start, dest, 50)
			b.Draw(usr.z, /obj/segment, c)

		else if(mode == 2)

			var/BranchedBolt/b = new(start, dest, 50)
			b.Draw(usr.z, /obj/segment, c)
