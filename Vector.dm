/**
 * a simple 2D vector
 */

vector
	var
		X
		Y

	/**
	 * Constructs the vector, assigns X and Y.
	 *
	 * @param x the vector's x
	 * @param y the vector's y
	 */
	New(x, y)
		..()

		X = x
		Y = y


	proc
		/**
		* Returns the length of the vector
	 	*/
		Length()
			return max(sqrt(X*X + Y*Y), 1)


proc
	/**
	 * Returns true if vector
	 *
	 * @param v value to check
	 */
	isVector(v)
		return istype(v, /vector)

	/**
	 * Returns a new vector equal to the sum of the two vectors
	 *
	 * @param v1 first vector
	 * @param v2 second vector
	 */
	vectorAdd(vector/v1, vector/v2)
		return new /vector (v1.X + v2.X, v1.Y + v2.Y)
	/**
	 * Returns a new vector equal to second vector subtracted from first
	 *
	 * @param v1 first vector to subtract from
	 * @param v2 second vector
	 */
	vectorSubtract(vector/v1, vector/v2)
		return new/vector(v1.X - v2.X, v1.Y - v2.Y)

	/**
	 * Return new vector from the result of multiplying the vector by a factor
	 *
	 * @param v   vector to multiply
	 * @param num number to multiply by
	 */
	vectorMultiply(vector/v, num)
		return new/vector(v.X * num, v.Y * num)

	/**
	 * Returns the distance between two factors
	 *
	 * @param v1 first vector
	 * @param v2 second vector
	 */
	vectorDistance(vector/v1, vector/v2)
		return sqrt((v1.X - v2.X) ** 2 + (v1.Y - v2.Y) ** 2)

	/**
	 * Returns the distance between two factors
	 *
	 * @param v1 first vector
	 * @param v2 second vector
	 */
	vectorNormalize(vector/v)
		return new/vector(v.X / v.Length(), v.Y / v.Length())

	/**
	 * Rotates a vector by an angle
	 *
	 * @param v     the vector to rotate
	 * @param angle the angle to rotate by
	 */
	vectorRotate(vector/v, angle)
		return new/vector(v.X * cos(angle) - v.Y * sin(angle), v.X * sin(angle) + v.Y * cos(angle))

	/**
	 * Returns a list of turfs between both vectors
	 * returns null if no turfs are found
	 *
	 * @param start     first vector
	 * @param end       second vector
	 * @param z         the z level on the map
	 * @param accurate  controlls the accurecy of this function, lower number means more accurate results however it reduces performance
	 *                  1 being the minimum
	 */
	vectorGetTurfs(vector/start, vector/end, z, accurate = 16)
		var/list/locs
		var/distance    = vectorDistance(start, end)
		var/vector/diff = vectorSubtract(end, start)

		for(var/i = 1 to distance step accurate)
			var/x = (start.X + diff.X * (i / distance)) / 32
			var/y = (start.Y + diff.Y * (i / distance)) / 32

			var/turf/t = locate(x, y, z)

			if(t)
				if(!locs)
					locs  = list(t)
				else if(!(t in locs))
					locs += t

		return locs
