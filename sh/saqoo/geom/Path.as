package sh.saqoo.geom {
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class Path {
		
		private var _segments:Array;
		private var _last:Point;
		private var _length:Array;
		private var _totalLen:Number;
		
		public function Path() {
			this.clear();
		}
		
		public function clear():void {
			this._segments = [];
			this._last = new Point(0, 0);
			this._length = [];
			this._totalLen = 0;
		}
		
		public function moveTo(px:Number, py:Number):void {
			this._last.x = px;
			this._last.y = py;
		}
		
		public function lineTo(px:Number, py:Number):void {
			var l:LineSegment = new LineSegment(this._last.clone(), new Point(px, py));
			this._totalLen += l.length;
			this._length.push(this._totalLen);
			this._segments.push(l);
			this._last.x = px;
			this._last.y = py;
		}
		
		public function curveTo(cx:Number, cy:Number, px:Number, py:Number):void {
			var c:QuadraticBezier = new QuadraticBezier(this._last.clone(), new Point(cx, cy), new Point(px, py));
			this._totalLen += c.length;
			this._length.push(this._totalLen);
			this._segments.push(c);
			this._last.x = px;
			this._last.y = py;
		}
		
		public function get length():Number {
			var len:Number = 0;
			for each(var seg:IPathSegment in this._segments) {
				len += seg.length;
			}
			return len;
		}
		
		public function getPointAt(t:Number):Point {
			if (t <= 0) {
				return IPathSegment(this._segments[0]).start.clone();
			} else if (1 <= t) {
				return IPathSegment(this._segments[this._segments.length - 1]).end.clone();
			} else {
				var idx:int = 0;
				var tt:Number = 0;
				var cl:Number = t * this._totalLen;
				this._length.unshift(0);
				const n:int = this._length.length;
				for (var i:int = 1; i < n; i++) {
					if (cl < this._length[i]) {
						idx = i - 1;
						tt = (cl - this._length[i - 1]) / (this._length[i] - this._length[i - 1]);
						break;
					}
				}
				this._length.shift();
//				t *= this._segments.length;
//				const idx:int = Math.floor(t);
				const seg:IPathSegment = this._segments[idx];
				return seg.getPointAt(tt);
			}
		}
		
		public function draw(g:Graphics):void {
			for each(var seg:IPathSegment in this._segments) {
				seg.draw(g);
			}
		}

	}
	
}