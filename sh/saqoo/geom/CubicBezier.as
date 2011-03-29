package sh.saqoo.geom {

	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Saqoosha
	 */
	public class CubicBezier implements IParametricCurve {
		
		
		public static function buildFromSVGPathNode(pathNode:XML):CubicBezier {
			var d:Array = String(pathNode.@d).match(/[MmZzLlHhVvCcSsQqTtAa]|-?[\d.]+/g);
			var n:int = d.length;
			var px:Number;
			var py:Number;
			var p:Point;
			var cx:Number;
			var cy:Number;
			var segments:Vector.<CubicBezierSegment> = new Vector.<CubicBezierSegment>();
			for (var i:int = 0; i < n; ++i) {
				var c:String = d[i];
				switch (c) {
					case 'M':
						px = Number(d[++i]);
						py = Number(d[++i]);
						p = new Point(px, py);
						break;
					case 'C':
						segments.push(new CubicBezierSegment(
							p.clone(),
							new Point(Number(d[++i]), Number(d[++i])),
							new Point(cx = Number(d[++i]), cy = Number(d[++i])),
							p = new Point(px = Number(d[++i]), py = Number(d[++i]))
						));
						break;
					case 'c':
						segments.push(new CubicBezierSegment(
							p.clone(),
							new Point(px + Number(d[++i]), py + Number(d[++i])),
							new Point(cx = px + Number(d[++i]), cy = py + Number(d[++i])),
							p = new Point(px += Number(d[++i]), py += Number(d[++i]))
						));
						break;
					case 'S':
						segments.push(new CubicBezierSegment(
							p.clone(),
							new Point(px + px - cx, py + py - cy),
							new Point(cx = Number(d[++i]), cy = Number(d[++i])),
							p = new Point(px = Number(d[++i]), py = Number(d[++i]))
						));
						break;
					case 's':
						segments.push(new CubicBezierSegment(
							p.clone(),
							new Point(px + px - cx, py + py - cy),
							new Point(cx = px + Number(d[++i]), cy = py + Number(d[++i])),
							p = new Point(px += Number(d[++i]), py += Number(d[++i]))
						));
						break;
					case 'L':
						segments.push(CubicBezierSegment.buildLineSegment(p.clone(), p = new Point(px = Number(d[++i]), py = Number(d[++i]))));
						break;
					case 'l':
						segments.push(CubicBezierSegment.buildLineSegment(p.clone(), p = new Point(px += Number(d[++i]), py += Number(d[++i]))));
						break;
					case 'Z':
					case 'z':
						break;
					default:
						throw new Error('Unsupported attribute found: ' + c);
				}
			}
			return new CubicBezier(segments);
		}


		private var _segments:Vector.<CubicBezierSegment>;
		private var _length:Number;
		private var _ratio:Vector.<Number>;
		
		
		public function CubicBezier(segments:Vector.<CubicBezierSegment>) {
			_segments = segments;
			recalcLength();
		}
		
		
		public function recalcLength():void {
			_ratio = new Vector.<Number>();
			_ratio.push(0);
			_length = 0;
			for each (var seg:IParametricCurve in _segments) {
				var l:Number = seg.getLength();
				_length += l;
				_ratio.push(_length);
			}
			var n:int = _ratio.length;
			for (var i:int = 0; i < n; i++) {
				_ratio[i] = _ratio[i] / _length;
			}
		}
		
		
		public function getLength(n:uint = 2):Number {
			return _length;
		}


		public function getPointAt(t:Number, out:Point = null):Point {
			var i:int = getSegmentIndexAt(t);
			t = (t - _ratio[i]) / (_ratio[i + 1] - _ratio[i]);
			return _segments[i].getPointAt(t, out);
		}


		public function getTangentAt(t:Number, out:Point = null):Point {
			var i:int = getSegmentIndexAt(t);
			t = (t - _ratio[i]) / (_ratio[i + 1] - _ratio[i]);
			return _segments[i].getTangentAt(t, out);
		}
		
		
		public function getParameterAtLength(length:Number):Number {
			var idx:Number = getSegmentIndexAt(length / _length);
			var t:Number = _segments[idx].getParameterAtLength(length - _ratio[idx] * _length);
			return _ratio[idx] + (_ratio[idx + 1] - _ratio[idx]) * t;
		}
		
		
		public function getSegmentIndexAt(t:Number):int {
			if (t < 0 || 1 < t) throw new Error('parameter t must be between 0 to 1.');
			var r:int, m:int, l:int;
			r = 0;
			l = _ratio.length - 1;
			m = (r + l) / 2;
			while (l - r > 1) {
				if (_ratio[m] < t) {
					r = m;
				} else {
					l = m;
				}
				m = (r + l) / 2;
			}
			return m;
		}
		
		
		public function getSegmentAt(t:Number):CubicBezierSegment {
			return _segments[getSegmentIndexAt(t)];
		}
		
		
		public function getBounds():Rectangle {
			var b:Rectangle = new Rectangle();
			for each (var segment:CubicBezierSegment in _segments) {
				b = b.union(segment.getBounds());
			}
			return b;
		}
		
		
		public function transform(matrix:Matrix):void {
			for each (var segment:CubicBezierSegment in _segments) {
				segment.transform(matrix);
			}
			recalcLength();
		}
		
		
		public function clone():CubicBezier {
			var clonedsegs:Vector.<CubicBezierSegment> = new Vector.<CubicBezierSegment>();
			for each (var segs:CubicBezierSegment in _segments) {
				clonedsegs.push(segs.clone());
			}
			return new CubicBezier(clonedsegs);
		}
		
		
		public function draw(graphics:Graphics):void {
			graphics.moveTo(_segments[0].p0.x, _segments[0].p0.y);
			for each (var seg:CubicBezierSegment in _segments) {
				seg.draw2(graphics, false);
			}
		}


		public function drawStroke(graphics:Graphics, thickness:Number = 2.0, start:Number = 0, end:Number = 1):void {
			var i:int, ii:int;
			var dt:Number = end - start;
			var n:int = _length * dt;// / 2;
			var commands:Vector.<int> = new Vector.<int>(n * 2, true);
			commands[0] = GraphicsPathCommand.MOVE_TO;
			for (i = 1; i < n * 2; i++) {
				commands[i] = GraphicsPathCommand.LINE_TO;
			}
			var pt:Number = 0;
			var t:Number = start;
			var si:int = getSegmentIndexAt(t);
			var data:Vector.<Number> = new Vector.<Number>(n * 4, true);
			var p:Point = new Point();
			var tan:Point = new Point();
			var halfPI:Number = Math.PI * 0.5;
			var quatPI:Number = Math.PI * 0.25;
			var offW:Number = Math.sin(quatPI);
			var wr:Number = 1 / (1 - offW) * thickness * 0.5;
			for (i = 0; i <= n; i++) {
				t = i / n * dt + start;
				if (_ratio[si + 1] < t) {
					si++;
					pt = _ratio[si];
				}
				var tt:Number = (t - pt) / (_ratio[si + 1] - pt);
				_segments[si].getPointAt(tt, p);
				_segments[si].getTangentAt(tt, tan);
				var w:Number = (Math.sin(i / n * halfPI + quatPI) - offW) * wr;
				tan.normalize(w);
				ii = i * 2;
				data[ii] = p.x - tan.y;
				data[ii + 1] = p.y + tan.x;
				ii = n * 4 - 2 - i * 2;
				data[ii] = p.x + tan.y;
				data[ii + 1] = p.y - tan.x;
			}
			graphics.drawPath(commands, data, GraphicsPathWinding.NON_ZERO);
		}
		
		
		public function drawDebugInfo(graphics:Graphics):void {
			for each (var segment:CubicBezierSegment in _segments) {
				segment.drawDebugInfo(graphics);
			}
		}
		
		
		public function toSVG():XML {
			var d:String = '';
			var cx:Number, cy:Number;
			for each (var segment:CubicBezierSegment in _segments) {
				if (d.length == 0) {
					cx = segment.p0.x;
					cy = segment.p0.y;
					d += 'M' + _toSVGNumber(cx, false) + _toSVGNumber(cy);
				}
				d += 'c';
				var p:Point;
				for (var i:int = 1; i < 4; i++) {
					p = segment[i];
					d += _toSVGNumber(p.x - cx, i > 1);
					d += _toSVGNumber(p.y - cy);
				}
				cx = p.x;
				cy = p.y;
			}
			return <path fill="none" stroke="#000000" stroke-width="0.25" d={d}/>;
		}
		

		private function _toSVGNumber(val:Number, hoge:Boolean = true):String {
			if (val >= 0 && hoge) {
				return ',' + String(int(val * 1000) / 1000);
			} else {
				return String(int(val * 1000) / 1000);
			}
		}
		
		
		public function toString():String {
			return '[CubicBezier numSegments=' + _segments.length + ' length=' + (int(_length * 1000) / 1000) + ']';
		}
		
		
		public function get segments():Vector.<CubicBezierSegment> { return _segments; }
		public function get ratio():Vector.<Number> { return _ratio; }
	}
}
