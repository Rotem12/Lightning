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
		 * Draws a line of type with a color between two assigned vectors on z
		 *
		 * @param z      the map z level to draw on
		 * @param type   basic segment to use when drawing
		 * @param color  color of the segment
		 * @return an object of given type transformed into a line between defined vectors
		 */
		Draw(z, type, color = "#fff")
			var/vector/tangent = vectorSubtract(B, A)
			var/rotation        = atan2(tangent.Y, tangent.X) - 90

			var/offsetX = A.X % 32
			var/offsetY = A.Y % 32

			var/x = (A.X - offsetX) / 32
			var/y = (A.Y - offsetY) / 32

			var/obj/o = new type (locate(x, y, z))
			o.pixel_x = offsetX
			o.pixel_y = offsetY

			var/newWidth = tangent.Length()
			var/newX     = (newWidth - 1)/2

			animate(o, transform = turn(matrix(newWidth, 0, newX, 0, 1, 0), rotation), color = color, time=0)

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