/**
 * a line drawn between two vectors
 */

line
	var
		vector
			A
			B

	/**
	 * Constructs the line, assigns both vectors A and B
	 *
	 * @param a first vector
	 * @param b second vector
	 */
	New(a, b)
		..()

		A = a
		B = b

	proc
		/**
		 * Draws a line of type with a color between two assigned vectors on z or client screen
		 *
		 * @param z          the map z level to draw on, if z is client it will draw on client screen
		 * @param type       basic segment to use when drawing
		 * @param color      color of the segment
		 * @param thickness  thickness of the segment
		 * @return an object of given type transformed into a line between defined vectors
		 */
		Draw(z = 1, type = /obj/segment, color = "#fff", thickness = 1)
			var/vector/tangent  = vectorSubtract(B, A)
			var/rotation        = atan2(tangent.Y, tangent.X) - 90

			var/obj/o = new type

			var/offsetX = A.X % world.icon_size
			var/offsetY = A.Y % world.icon_size

			var/x = (A.X - offsetX) / world.icon_size
			var/y = (A.Y - offsetY) / world.icon_size

			if(isnum(z))
				o.loc = locate(x, y, z)
				o.pixel_x = offsetX
				o.pixel_y = offsetY
			else
				var/client/c = z
				o.screen_loc = "[x]:[offsetX],[y]:[offsetY]"
				c.screen += o

			var/newWidth = tangent.Length()
			var/newX     = (newWidth - 1)/2

			animate(o, transform = turn(matrix(newWidth, 0, newX, 0, thickness, 0), rotation), color = color, alpha = 255, time=0)

			return o

		/**
		 * Returns a list of turfs the line passes through
		 * returns null if no turfs are found
		 *
		 * @param z         the map z level to search
		 * @param accurate  controlls the accurecy of this function, lower number means more accurate results however it reduces performance
		 *                  1 being the minimum
		 * @return a list of turfs the line passes on
		 */
		GetTurfs(z, accurate = 16)
			return vectorGetTurfs(A, B, z, accurate)

		/**
		 * Rotates the line
		 *
		 * @param angle the angle to rotate thel line by
		 */
		Rotate(angle)
			var/vector/diff     = vectorSubtract(B, A)
			var/vector/rotatedB = vectorRotate(diff, angle)

			B = vectorAdd(rotatedB, A)