package sh.saqoo.geom {
	import flash.display.Graphics;
	import flash.geom.Point;

	
	/**
	 * Rounded Nonuniform Spline (RNS) Curve
	 * @author Saqoosha
	 * @see Game Programming Gems 4 - Section 2.4
	 */
	public class RoundedNonuniformSpline {
		
		
		public static function draw(graphics:Graphics, points:Vector.<Point>):void {
			new RoundedNonuniformSpline(points).draw(graphics);
		}

		
		//
		
		
		protected var _points:Vector.<HermiteCurvePoint>;
		protected var _curves:Vector.<CubicHermite>;
		protected var _totalDistance:Number;
		protected var _buildRequired:Boolean;
		
		
		public function RoundedNonuniformSpline(points:Vector.<Point> = null) {
			_points = new Vector.<HermiteCurvePoint>();
			_totalDistance = 0;
			
			if (points) {
				for each (var p:Point in points) {
					addPoint(p);
				}
			}
		}

		
		public function addPoint(point:Point):void {
			var n:int = _points.length;
			if (n > 0) {
				--n;
				_points[n].distance = Point.distance(_points[n].position, point);
				_totalDistance += _points[n].distance;
			}
			_points.push(new HermiteCurvePoint(point));
			_buildRequired = true;
		}
		
		
		public function getPointAt(t:Number, out:Point = null):Point {
			if (_buildRequired) _buildCurves();
			
			var distance:Number = t * _totalDistance;
			var currentDistance:Number = 0;
			var i:int = 0;
			while (currentDistance + _points[i].distance < distance && i < _points.length - 2) {
				currentDistance += _points[i].distance;
				++i;
			}
			t = (distance - currentDistance) / _points[i].distance;
			
			return _curves[i].getPointAt(t, out);
		}
		
		
		public function getTangentAt(t:Number, out:Point = null):Point {
			if (_buildRequired) _buildCurves();
			
			var distance:Number = t * _totalDistance;
			var currentDistance:Number = 0;
			var i:int = 0;
			while (currentDistance + _points[i].distance < distance && i < _points.length - 2) {
				currentDistance += _points[i].distance;
				++i;
			}
			t = (distance - currentDistance) / _points[i].distance;
			
			return _curves[i].getTangentAt(t, out);
		}

		
		public function draw(graphics:Graphics, segmentLength:Number = 5, moveToFirst:Boolean = true):void {
			if (_buildRequired) _buildCurves();			
			if (moveToFirst) {
				graphics.moveTo(_points[0].position.x, _points[0].position.y);
			}
			
			var numSegments:int = _totalDistance / segmentLength;
			var idx:int = 0;
			var distance:Number = 0;
			var nextDistance:Number = _points[0].distance;
			var curve:CubicHermite = _curves[0];
			var p:Point = new Point();
			for (var i:int = 0; i <= numSegments; ++i) {
				var t:Number = i / numSegments;
				var d:Number = t * _totalDistance;
				if (nextDistance < d) {
					++idx;
					distance = nextDistance;
					nextDistance += _points[idx].distance;
					curve = _curves[idx];
				}
				t = (d - distance) / _points[idx].distance;
				curve.getPointAt(t, p);
				graphics.lineTo(p.x, p.y);
			}
		}
		
		
		public function debugDraw(graphics:Graphics):void {
			if (_buildRequired) _buildCurves();
			for each (var curve:CubicHermite in _curves) {
				curve.debugDraw(graphics);
			}
		}

		
		private function _buildCurves():void {
			var i:int;
			var n:int = _points.length;
			if (n < 2) throw new Error('Required more than 2 points.');
			
			var p:HermiteCurvePoint;
			if (2 < n) {
				for (i = 1; i < n - 1; ++i) {
					p = _points[i];
					var vNext:Point = _points[i + 1].position.subtract(p.position);
					vNext.normalize(1);
					var vPrev:Point = _points[i - 1].position.subtract(p.position);
					vPrev.normalize(1);
					p.velocity = vNext.subtract(vPrev);
					p.velocity.normalize(1);
				}
			}
			_points[0].velocity = _calcEdgeVelocity(_points[0].position, _points[1].position, _points[0].distance, _points[1].velocity);
			_points[n - 1].velocity = _calcEdgeVelocity(_points[n - 2].position, _points[n - 1].position, _points[n - 2].distance, _points[n - 2].velocity);
			
			_curves = new Vector.<CubicHermite>();
			for (i = 0; i < n - 1; ++i) {
				p = _points[i];
				var v0:Point = p.velocity.clone();
				v0.x *= p.distance;
				v0.y *= p.distance;
				var v1:Point = _points[i + 1].velocity.clone();
				v1.x *= p.distance;
				v1.y *= p.distance;
				_curves.push(new CubicHermite(p.position, v0, _points[i + 1].position, v1));
			}
			
			_buildRequired = false;
		}
		
		
		private function _calcEdgeVelocity(p0:Point, p1:Point, distance:Number, v:Point):Point {
			var t:Number = 3.0 * (1.0 / distance);
			return new Point(
				((p1.x - p0.x) * t - v.x) * 0.5,
				((p1.y - p0.y) * t - v.y) * 0.5
			);
		}
		
		
		public function get totalLength():Number {
			return _totalDistance;
		}
	}
}
