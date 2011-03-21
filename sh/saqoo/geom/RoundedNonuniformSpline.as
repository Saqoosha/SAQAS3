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
		protected var _distance:Vector.<Number>;
		protected var _curves:Vector.<CubicHermite>;
		protected var _totalDistance:Number; // = _distance[_distance.length - 1]
		protected var _buildRequired:Boolean;
		
		
		public function RoundedNonuniformSpline(points:Vector.<Point> = null) {
			_points = new Vector.<HermiteCurvePoint>();
			_distance = new Vector.<Number>();
			_distance.push(0);
			_curves = new Vector.<CubicHermite>();
			_totalDistance = 0;
			_buildRequired = false;
			
			if (points) {
				for each (var p:Point in points) {
					addPoint(p);
				}
			}
		}

		
		public function addPoint(point:Point):void {
			_points.push(new HermiteCurvePoint(point));
			var n:int = _points.length;
			_distance.length = n;
			if (n > 1) {
				var d:Number = Point.distance(_points[n - 2].position, _points[n - 1].position);
				_distance[n - 1] = _distance[n - 2] + d;
				_totalDistance += d;
			}
			_buildRequired = true;
		}
		
		
		public function addCurve(curve:CubicHermite):void {
			if (_buildRequired) build();
			if (_curves.length) {
				var conn:CubicHermite = CubicHermite.getSmoothConnection(_curves[_curves.length - 1], curve);
				if (conn) {
					_curves.push(conn);
					_totalDistance += conn.getLength();
					_distance.push(_totalDistance);
				}
			}
			_curves.push(curve);
			_totalDistance += curve.getLength();
			_distance.push(_totalDistance);
		}

		
		public function append(spline:RoundedNonuniformSpline):void {
			var n:int = spline.numCurves;
			for (var i:int = 0; i < n; i++) {
				addCurve(spline.getCurveAt(i));
			}
		}

		
		public function getCurveAt(index:int):CubicHermite {			if (_buildRequired) build();
			return _curves[index];
		}

		
		public function getPositionAt(t:Number, out:Point = null):Point {
			if (_buildRequired) build();
			
			var distance:Number = t * _totalDistance;
			var i:int = 0;
			while (_distance[i + 1] < distance) i++;
			t = (distance - _distance[i]) / (_distance[i - 1] - _distance[i]);
			return _curves[i].getPointAt(t, out);
		}
		
		
		public function getTangentAt(t:Number, out:Point = null):Point {
			if (_buildRequired) build();
			
			var distance:Number = t * _totalDistance;
			var i:int = 0;
			while (_distance[i + 1] < distance) i++;
			t = (distance - _distance[i]) / (_distance[i - 1] - _distance[i]);
			return _curves[i].getTangentAt(t, out);
		}

		
		public function draw(graphics:Graphics, segmentLength:Number = 5, moveToFirst:Boolean = true):void {
			if (_buildRequired) build();			
			if (moveToFirst) {
				graphics.moveTo(_curves[0].p0.x, _curves[0].p0.y);
			}
			
			var numSegments:int = _totalDistance / segmentLength;
			var idx:int = 0;
			var curve:CubicHermite = _curves[0];
			var p:Point = new Point();
			for (var i:int = 0; i <= numSegments; ++i) {
				var t:Number = i / numSegments;
				var d:Number = t * _totalDistance;
				if (_distance[idx + 1] < d) {
					++idx;
					curve = _curves[idx];
				}
				t = (d - _distance[idx]) / (_distance[idx + 1] - _distance[idx]);
				curve.getPointAt(t, p);
				graphics.lineTo(p.x, p.y);
			}
		}
		
		
		public function debugDraw(graphics:Graphics):void {
			if (_buildRequired) build();
			for each (var curve:CubicHermite in _curves) {
				curve.debugDraw(graphics);
			}
		}

		
		public function build():void {
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
			_points[0].velocity = calcEdgeVelocity(_points[0].position, _points[1].position, _distance[1], _points[1].velocity);
			_points[n - 1].velocity = calcEdgeVelocity(_points[n - 2].position, _points[n - 1].position, _distance[n - 1] - _distance[n - 2], _points[n - 2].velocity);
			
			_curves.length = n - 1;
			for (i = 0; i < n - 1; ++i) {
				p = _points[i];
				var v0:Point = p.velocity.clone();
				var d:Number = _distance[i + 1] - _distance[i];
				v0.x *= d;
				v0.y *= d;
				var v1:Point = _points[i + 1].velocity.clone();
				v1.x *= d;
				v1.y *= d;
				var curve:CubicHermite = _curves[i] || new CubicHermite();
				curve.p0 = p.position;
				curve.v0 = v0;
				curve.p1 = _points[i + 1].position;
				curve.v1 = v1;
				_curves[i] = curve;
			}
			
			_buildRequired = false;
		}
		
		
		public function calcEdgeVelocity(p0:Point, p1:Point, distance:Number, v:Point):Point {
			var t:Number = 3.0 / distance;
			return new Point(
				((p1.x - p0.x) * t - v.x) * 0.5,
				((p1.y - p0.y) * t - v.y) * 0.5
			);
		}
		
		
		public function reverse():void {
			_points.reverse();
			_curves.reverse();
			for each (var c:CubicHermite in _curves) {
				c.reverse();
			}
		}

		
		public function clone():RoundedNonuniformSpline {
			var copy:RoundedNonuniformSpline = new RoundedNonuniformSpline();
			for each (var curve:CubicHermite in _curves) {
				copy.addCurve(curve.clone());
			}
			return copy;
		}
		
		
		public function toCubicBezier():Vector.<CubicBezierSegment> {
			if (_buildRequired) build();
			var bez:Vector.<CubicBezierSegment> = new Vector.<CubicBezierSegment>();
			for each (var hermite:CubicHermite in _curves) {
				bez.push(hermite.toCubicBezier());
			}
			return bez;
		}
		
		
		public function get totalLength():Number {
			return _totalDistance;
		}
		
		
		public function get numPoints():int {
			return _points.length;
		}

		
		public function get numCurves():int {
			return _curves ? _curves.length : 0;
		}
	}
}
