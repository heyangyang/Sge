package com.sunny.game.engine.utils
{
	public class RootFindingUtils
	{
		public static const MACHINE_EPSILON:Number = 2E-16;
		protected static const ERROR_BRENTS_INPUT:Error = new Error( "The function brentsMethod assumes that f(a) and f(b) have different signs." );
		protected static const ERROR_OVER_MAX_ITERATIONS:Error = new Error( "Maximum number of iterations reached." );
		
		public static function brentsMethod( f:Function, a:Number, b:Number, tolerance:Number=1E-8, maxIterations:uint=100 ):Number
		{
			var c:Number;
			var d:Number;
			var e:Number;
			var t:Number;
			var m:Number;
			var s:Number;
			var p:Number;
			var q:Number;
			var r:Number;
			var v1:Number;
			var v2:Number;
			var fa:Number = f( a );
			var fb:Number = f( b );
			var fc:Number = fb;
			if ( ( fa * fb ) > 0 )
			{
				throw ( ERROR_BRENTS_INPUT );
			}
			var i:uint;
			while ( i < maxIterations )
			{
				if ( ( ( ( ( fb * fc ) > 0 ) ) || ( ( ( fb * fc ) > 0 ) ) ) )
				{
					c = a;
					fc = fa;
					e = ( b - a );
					d = e;
				}
				if ( ( ( ( fc < 0 ) ) ? -( fc ) : fc ) < ( ( ( fb < 0 ) ) ? -( fb ) : fb ) )
				{
					a = b;
					b = c;
					c = a;
					fa = fb;
					fb = fc;
					fc = fa;
				}
				t = ( ( ( 2 * MACHINE_EPSILON ) * ( ( ( b < 0 ) ) ? -( b ) : b ) ) + tolerance );
				m = ( 0.5 * ( c - b ) );
				if ( ( ( ( ( ( ( m < 0 ) ) ? -( m ) : m ) > t ) ) && ( !( ( fb == 0 ) ) ) ) )
				{
					if ( ( ( ( ( ( ( e < 0 ) ) ? -( e ) : e ) < t ) ) || ( ( ( ( ( fa < 0 ) ) ? -( fa ) : fa ) <= ( ( ( fb < 0 ) ) ? -( fb ) : fb ) ) ) ) )
					{
						e = m;
						d = e;
					}
					else
					{
						s = ( fb / fa );
						if ( a == c )
						{
							p = ( ( 2 * m ) * s );
							q = ( 1 - s );
						}
						else
						{
							q = ( fa / fc );
							r = ( fb / fc );
							p = ( s * ( ( ( ( 2 * m ) * q ) * ( q - r ) ) - ( ( b - a ) * ( r - 1 ) ) ) );
							q = ( ( ( q - 1 ) * ( r - 1 ) ) * ( s - 1 ) );
						}
						if ( p > 0 )
						{
							q = -( q );
						}
						else
						{
							p = -( p );
						}
						s = e;
						e = d;
						v1 = ( t * q );
						v2 = ( ( 0.5 * s ) * q );
						if ( ( ( ( ( 2 * p ) < ( ( ( 3 * m ) * q ) - ( ( ( v1 < 0 ) ) ? -( v1 ) : v1 ) ) ) ) && ( ( p < ( ( ( v2 < 0 ) ) ? -( v2 ) : v2 ) ) ) ) )
						{
							d = ( p / q );
						}
						else
						{
							e = m;
							d = e;
						}
					}
					a = b;
					fa = fb;
					if ( ( ( ( d < 0 ) ) ? -( d ) : d ) > t )
					{
						b = ( b + d );
					}
					else
					{
						if ( m > 0 )
						{
							b = ( b + t );
						}
						else
						{
							b = ( b - t );
						}
					}
					fb = f( b );
				}
				else
				{
					return ( b );
				}
				i++;
			}
			throw ( ERROR_OVER_MAX_ITERATIONS );
		}
	}
}