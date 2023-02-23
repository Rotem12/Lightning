bolt/half
	Draw(z, type = /obj/segment, color = "#fff", secondColor = "$fff", percent=1, thickness = 1)

		var/line/l = segments[1]
		var/obj/o = new (l.A.Locate(z))

		lastCreatedBolt = o

		var/mutable_appearance/ma = new(o)

		ma.alpha = 255

		var/obj/s = new type ()

		var/cutOff = round(segments.len * percent)

		s.color = color

		for(var/i = 1 to cutOff)
			var/line/segment = segments[i]
			ma.overlays += segment.DrawOverlay(o, s, thickness)

		s.color = secondColor

		for(var/i = cutOff+1 to segments.len)
			var/line/segment = segments[i]
			ma.overlays += segment.DrawOverlay(o, s, thickness)


		o.appearance = ma

		Effect(o)
