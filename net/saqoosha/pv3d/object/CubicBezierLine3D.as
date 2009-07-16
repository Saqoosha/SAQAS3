package net.saqoosha.pv3d.object {
	
	import net.saqoosha.geom.CubicBezier3D;
	import net.saqoosha.geom.Point3D;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;

	public class CubicBezierLine3D extends Lines3D {
		
		private var _bezier:CubicBezier3D;
		protected var _segments:Array;
		private var _numSegments:int;
		private var _size:Number;
		private var _start:Number;
		private var _end:Number;
		private var _invalid:Boolean;
		
		public function CubicBezierLine3D(p0:Point3D = null, p1:Point3D = null, p2:Point3D = null, p3:Point3D = null, numSegments:int = 10, material:LineMaterial=null, size:Number = 1, name:String=null) {
			super(material, name);
			this._bezier = new CubicBezier3D(p0, p1, p2, p3);
			this._numSegments = numSegments;
			this._size = size;
			this._start = 0;
			this._end = 1;
			this._buildLines();
		}
		
		private function _buildLines():void {
			var vertices:Array = [];
			var i:int;
			for (i = 0; i <= this._numSegments; i++) {
				var p:Point3D = this._bezier.getPointAt(i / this._numSegments);
				vertices.push(new Vertex3D(p.x, p.y, p.z));
			}
			this._segments = [];
			for (i = 0; i < this._numSegments; i++) {
				var line:Line3D = new Line3D(this, LineMaterial(this.material), this._size, vertices[i], vertices[i + 1]);
				this.addLine(line);
				this._segments.push(line);
			}
//			this.lines.splice(0, int.MAX_VALUE);
			this._invalid = true;
		}
		
		public function invalidate():void {
			this._invalid = true;
		}
		
		public function update():void {
			var st:Number = this._start * this._numSegments;
			var vSt:int = Math.floor(st);
			var stP:Number = st - vSt;
			var et:Number = this._end * this._numSegments;
			var vEd:int = Math.ceil(et);
			var edP:Number = et - (vEd - 1);
			var v:Vertex3D;
			var p:Point3D = new Point3D();
			var i:int;
			for (i = vSt; i <= vEd; i++) {
				this._bezier.getPointAt(i / this._numSegments, p);
				v = this.geometry.vertices[i];
				v.x = p.x;
				v.y = p.y;
				v.z = p.z;
			}
			this.lines.splice(0, int.MAX_VALUE);
			vEd--;
			if (vSt == vEd) {
				edP = (edP - stP) / (1 - stP);
			}
			var line:Line3D;
			for (i = vSt; i <= vEd; i++) {
				line = this._segments[i];
				if (i == vSt) {
					v = line.v0;
					v.x = (v.x + (line.v1.x - v.x) * stP);
					v.y = (v.y + (line.v1.y - v.y) * stP);
					v.z = (v.z + (line.v1.z - v.z) * stP);
				}
				if (i == vEd) {
					line.v1.x = line.v0.x + (line.v1.x - line.v0.x) * edP;
					line.v1.y = line.v0.y + (line.v1.y - line.v0.y) * edP;
					line.v1.z = line.v0.z + (line.v1.z - line.v0.z) * edP;
				}
				this.lines.push(line);
			}
			this._invalid = false;
		}
		
		public override function project(parent:DisplayObject3D, renderSessionData:RenderSessionData):Number {
			if (this._invalid) {
				this.update();
			}
			return super.project(parent, renderSessionData);
		}
		
		public function destroy():void {
			this.removeAllLines();
			this._segments = null;
		}
		
		public function get start():Number {
			return this._start;
		}
		public function set start(value:Number):void {
			if (this._start != value) {
				this._start = value;
				this._invalid = true;
			}
		}
		
		public function get end():Number {
			return this._end;
		}
		public function set end(value:Number):void {
			if (this._end != value) {
				this._end = value;
				this._invalid = true;
			}
		}
		
		public function get p0():Point3D {
			return this._bezier.start;
		}
		public function set p0(value:Point3D):void {
			this._bezier.start = value;
		}
		public function get p1():Point3D {
			return this._bezier.control1;
		}
		public function set p1(value:Point3D):void {
			this._bezier.control1 = value;
		}
		public function get p2():Point3D {
			return this._bezier.control2;
		}
		public function set p2(value:Point3D):void {
			this._bezier.control2;
		}
		public function get p3():Point3D {
			return this._bezier.end;
		}
		public function set p3(value:Point3D):void {
			this._bezier.end = value;
		}
	}
}