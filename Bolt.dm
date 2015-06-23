/**
 * A lightning bolt drawn between two vectors
 */

bolt
	var
		list/segments
		fade

	/**
	 * Constructs the bolt, from vector source to vector dest
	 *
	 * @param source source vector, where the bolt starts
	 * @param dest   destination vector, where the bold ends
	 * @param fade   assigns fade out rate, default of 50
	 */
	New(vector/source, vector/dest, fade = 50)
		..()

		segments    = createBolt(source, dest)
		src.fade    = 50

	proc
		/**
		 * Draws a bolt of type with a color between two assigned vectors on z
		 *
		 * @param z     the map z level to draw on
		 * @param type  basic segment to use when drawing
		 * @param color color of the segment
		 */
		Draw(z, type, color = "#fff")
			for(var/line/segment in segments)
				var/obj/o = segment.Draw(z, type, color)
				Effect(o)

		/**
		 * Applys animation to lightning bolt segment
		 * this could be overriden by child types to allow different animations to the lightning bolt
		 * by default, a lightning bolt will fade out then be disposed
		 *
		 * @param o  the object segment, each lightning bolt is made of several segments
		 */
		Effect(obj/o)
			animate(o, alpha = 0, time = 255 / fade, loop = 1)
			Dispose(o)

		/**
		 * Handles soft deletion of lightning bolt segments
		 * by default after a lightning bolt faded it will be disposed
		 *
		 * @param o  the object segment to dispose
		 */
		Dispose(obj/o)
			spawn(255 / fade)
				o.loc = null

		/**
		 * Returns a list of segments from vector source to vector dest
		 *
		 * @param source source vector, where the bolt starts
		 * @param dest   destination vector, where the bolt ends
		 */
		createBolt(vector/source, vector/dest)
			var/list/results = list()

			var/vector/tangent = vectorSubtract(dest, source)
			var/vector/normal  = vectorNormalize(new (tangent.Y, -tangent.X))

			var/length = tangent.Length()

			var/list/positions = list(0)

			var/growth = max(1 / (length / 4), 0.005)
			var/p = 0
			for(var/i = 1 to length / 4)
				var/r = Rand(growth, growth * 4)
				p += r
				positions += p

				if(p >= 1) break

			var/const/Sway       = 80
			var/const/Jaggedness = 1 / Sway

			var/vector/prevPoint = source
			var/prevDisplacement  = 0
			for(var/i = 2 to positions.len)
				var/pos = positions[i]

				// used to prevent sharp angles by ensuring very close positions also have small perpendicular variation.
				var/scale = ((length) * Jaggedness) * (pos - positions[i - 1])

				// defines an envelope. Points near the middle of the bolt can be further from the central line.
				var/envelope = pos > 0.95 ? 20 * (1 - pos) : 1

				var/displacement = Rand(-Sway, Sway)

				displacement -= (displacement - prevDisplacement) * (1 - scale)
				displacement *= envelope


				var/vector/point = new (source.X + (tangent.X * pos) + (normal.X * displacement), source.Y + (tangent.Y * pos) + (normal.Y * displacement))

				var/line/l = new(prevPoint, point)
				results   += l

				prevPoint        = point
				prevDisplacement = displacement

			var/line/l = new(prevPoint, dest)
			results += l

			return results

		/**
		 * Returns a segment at a given fraction 0 to 1, 0 being the start of the bolt and 1 being the end
		 *
		 * @param fraction 0 to 1, 0 being the start of the bolt and 1 being the end
		 */
		GetPoint(var/fraction)
			var/index = round(fraction * segments.len)

			index = min(index, segments.len)
			index = max(index, 1)

			var/line/l = segments[index]

			return l.A

		/**
		 * Returns a list of turfs between the bolt's starting vector to the bolt's end vector
		 * because this only checks first and last vectors it returns a form of line between both vectors and can be inaccurate if bolt segments stray too far
		 * It can return null if no turfs are found.
		 *
		 * @param z         the map z level to search
		 * @param accurate  controlls the accurecy of this function, lower number means more accurate results however it reduces performance
		 *                  1 being the minimum, it should be noted even at 1 this will not be too accurate, use GetAllTurfs() for a more accurate result
		 */
		GetTurfs(z, accurate = 16)
			var/line/start = segments[1]
			var/line/end = segments[segments.len]

			return vectorGetTurfs(start.A, end.B, z, accurate)

		/**
		 * Returns a list of turfs between the bolt's starting vector to the bolt's end vector checking all segments
		 * It can return null if no turfs are found.
		 *
		 * @param z         the map z level to search
		 * @param accurate  controlls the accurecy of this function, lower number means more accurate results however it reduces performance
		 *                  1 being the minimum
		 */
		GetAllTurfs(z, accurate = 16)
			var/list/locs = list()

			for(var/line/segment in segments)
				locs = locs|segment.GetTurfs(z, accurate)

			return locs.len ? locs : null