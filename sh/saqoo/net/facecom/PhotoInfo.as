package sh.saqoo.net.facecom {

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author Saqoosha
	 */
	public class PhotoInfo {


		private var _width:Number;
		private var _height:Number;
		private var _pid:String;
		private var _url:String;
		private var _tags:Vector.<Tag>;


		public function PhotoInfo(data:Object, width:Number = 0, height:Number = 0) {
			_width = width || data.width;
			_height = height || data.height;
			_pid = data.pid;
			_url = data.url;
			_tags = new Vector.<Tag>();
			for each (var tag:Object in data.tags) {
				_tags.push(new Tag(tag, _width, _height));
			}
		}
		
		
		public function transform(mtx:Matrix):void {
			for each (var tag:Tag in _tags) {
				tag.transform(mtx);
			}
		}


		public function extractFace(original:BitmapData, index:uint, mtx:Matrix = null):BitmapData {
			var tag:Tag = _tags[index];
			mtx ||= new Matrix();
			mtx.identity();
			mtx.translate(-tag.center.x, -tag.center.y);
			mtx.rotate(-tag.roll);
			mtx.translate(tag.width / 2, tag.height / 2);
			var face:BitmapData = new BitmapData(tag.width, tag.height);
			face.draw(original, mtx, null, null, null, true);
			return face;
		}


		public function extractMouth(image:BitmapData, index:uint, mtx:Matrix = null):BitmapData {
			var tag:Tag = _tags[index];
			mtx ||= new Matrix();
			mtx.identity();
			mtx.translate(-tag.mouthCenter.x, -tag.mouthCenter.y);
			var p:Point = tag.mouthRight.subtract(tag.mouthLeft);
			mtx.rotate(-Math.atan2(p.y, p.x));
			var left:Point = mtx.transformPoint(tag.mouthLeft);
			var right:Point = mtx.transformPoint(tag.mouthRight);
			var len:Number = p.length;
			var mouth:BitmapData = new BitmapData(len * 1.3, len * 0.66 * 1.3);
			mtx.translate(-(right.x + left.x) * 0.5 + mouth.width * 0.5, mouth.height * 0.5);
			mouth.draw(image, mtx, null, null, null, true);
			return mouth;
		}


		public function extractEye(image:BitmapData, index:uint, left:Boolean = true, mtx:Matrix = null):BitmapData {
			var tag:Tag = _tags[index];
			if (tag.eyeRight && tag.eyeLeft && tag.mouthRight && tag.mouthLeft) {
				mtx ||= new Matrix();
				mtx.identity();
				var e:Point = left ? tag.eyeLeft: tag.eyeRight;
				mtx.translate(-e.x, -e.y);
				var p:Point = tag.eyeRight.subtract(tag.eyeLeft);
				mtx.rotate(-Math.atan2(p.y, p.x));
				var len:Number = Point.distance(tag.mouthLeft, tag.mouthRight);
				var eye:BitmapData = new BitmapData(len, len * 0.66);
				mtx.translate(eye.width * 0.5, eye.height * 0.5);
				eye.draw(image, mtx, null, null, null, true);
				return eye;
			} else {
				return null;
			}
		}


		public function extractNose(image:BitmapData, index:uint, mtx:Matrix = null):BitmapData {
			var tag:Tag = _tags[index];
			mtx ||= new Matrix();
			mtx.identity();
			mtx.translate(-tag.nose.x, -tag.nose.y);
			mtx.rotate(-tag.roll * Math.PI / 180);
			var len:Number = Point.distance(tag.mouthRight, tag.mouthLeft);
			var nose:BitmapData = new BitmapData(len, len * 0.8);
			mtx.translate(len * 0.5, len * 0.6);
			nose.draw(image, mtx, null, null, null, true);
			return nose;
		}
		
		
		public function drawDebugInfo(graphics:Graphics):void {
			for each (var tag:Tag in _tags) {
				var r:Number = tag.width * 0.03;
				graphics.lineStyle(0, 0xFF53FF, 0.8);
				graphics.beginFill(0xFF53FF, 0.5);
				graphics.drawCircle(tag.eyeLeft.x, tag.eyeLeft.y, r);
				graphics.drawCircle(tag.eyeRight.x, tag.eyeRight.y, r);
				graphics.endFill();
				graphics.lineStyle(0, 0x29FFFF, 0.8)
				graphics.beginFill(0x29FFFF, 0.5);
				graphics.drawCircle(tag.nose.x, tag.nose.y, r);
				graphics.endFill();
				graphics.lineStyle(r * 0.5, 0xA358FF, 0.8);
				graphics.moveTo(tag.mouthRight.x, tag.mouthRight.y);
				graphics.lineTo(tag.mouthCenter.x, tag.mouthCenter.y);
				graphics.lineTo(tag.mouthLeft.x, tag.mouthLeft.y);
			}
		}
		
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		public function get pid():String { return _pid; }
		public function get url():String { return _url; }
		public function get tags():Vector.<Tag> { return _tags; }
		public function get numTags():uint { return _tags.length; }
	}
}
