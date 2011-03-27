package sh.saqoo.net.detectface {

	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author Saqoosha
	 */
	public class FaceInfo {
		
		
		public var bounds:Rectangle;
		public var rightEye:Point;
		public var leftEye:Point;
		public var features:Dictionary;
		
		public var sAvg:Number;
		public var sMin:Number;
		public var sMax:Number;


		public function FaceInfo(data:XML, scale:Number = 1.0) {
			bounds = new Rectangle(parseInt(data.bounds.@x) * scale, parseInt(data.bounds.@y) * scale, parseInt(data.bounds.@width) * scale, parseInt(data.bounds.@height) * scale);
			if (data.hasOwnProperty('right-eye')) rightEye = new Point(parseInt(data['right-eye'].@x) * scale, parseInt(data['right-eye'].@y) * scale);
			if (data.hasOwnProperty('left-eye')) leftEye = new Point(parseInt(data['left-eye'].@x) * scale, parseInt(data['left-eye'].@y) * scale);
			if (data.hasOwnProperty('features')) {
				sAvg = parseFloat(data.features.attribute('s-avg'));
				sMin = parseFloat(data.features.attribute('s-min'));
				sMax = parseFloat(data.features.attribute('s-max'));
				features = new Dictionary();
				for each (var feat:XML in data.features.point) {
					var f:FeaturePoint = new FeaturePoint(feat.@id, parseInt(feat.@x) * scale, parseInt(feat.@y) * scale, parseFloat(feat.@s));
					features[f.id] = f;
				}
			}
		}
		
		
		public function getFeaturePointByName(name:String):FeaturePoint {
			return features ? features[name] || null : null;
		}
		
		
		public function getFeaturePoints(names:Array, full:Boolean = true):Vector.<Point> {
			var tmp:Vector.<Point> = new Vector.<Point>();
			for each (var name:String in names) {
				var fp:FeaturePoint = getFeaturePointByName(name);
				if (full && !fp) return null;
				tmp.push(fp);
			}
			return tmp;
		}
		
		
		public function getAverageScore(names:Array):Number {
			var score:Number = 0;
			for each (var name:String in names) {
				var fp:FeaturePoint = getFeaturePointByName(name);
				if (fp) score += fp.s;
			}
			score /= names.length;
			return score;
		}
		
		
		public function transform(mtx:Matrix):void {
			if (!features) return;
			var keys:Array = [];
			for (var key:String in features) keys.push(key);
			for each (key in keys.sort()) {
				var fp:FeaturePoint = features[key];
				var p:Point = mtx.transformPoint(fp);
				fp.x = p.x;
				fp.y = p.y;
			}
			if (rightEye) rightEye = mtx.transformPoint(rightEye);
			if (leftEye) leftEye = mtx.transformPoint(leftEye);
		}


		public function drawDebugInfo(graphics:Graphics, scale:Number = 1):void {
			// bounds
			graphics.lineStyle(0, 0xffffff);
//			graphics.drawRect(bounds.x * scale, bounds.y * scale, bounds.width * scale, bounds.height * scale);
			
			// face
			_drawFeatures(graphics, PointNames.FACE, scale);

			// right eye
			if (rightEye) {
				graphics.lineStyle(0, 0xff0000, 0.8);
				_drawFeatures(graphics, PointNames.RIGHT_EYE, scale);
				graphics.lineStyle(0, 0x00aaff, 0.8);
				graphics.moveTo((rightEye.x - 8) * scale, (rightEye.y - 8) * scale);
				graphics.lineTo((rightEye.x + 8) * scale, (rightEye.y + 8) * scale);
				graphics.moveTo((rightEye.x + 8) * scale, (rightEye.y - 8) * scale);
				graphics.lineTo((rightEye.x - 8) * scale, (rightEye.y + 8) * scale);
			}
			var p:FeaturePoint = getFeaturePointByName('PR');
			if (p) {
				graphics.lineStyle(0, 0xff0000, 0.8);
				graphics.moveTo((p.x - 3) * scale, p.y * scale);
				graphics.lineTo((p.x + 3) * scale, p.y * scale);
				graphics.moveTo(p.x * scale, (p.y - 3) * scale);
				graphics.lineTo(p.x * scale, (p.y + 3) * scale);
			}

			// right eyebrow
			graphics.lineStyle(0, 0x00ff00, 0.8);
			_drawFeatures(graphics, PointNames.RIGHT_BROW, scale);

			// left eye
			if (leftEye) {
				graphics.lineStyle(0, 0xff0000, 0.8);
				_drawFeatures(graphics, PointNames.LEFT_EYE, scale);
				graphics.lineStyle(0, 0x00aaff, 0.8);
				graphics.moveTo((leftEye.x - 8) * scale, (leftEye.y - 8) * scale);
				graphics.lineTo((leftEye.x + 8) * scale, (leftEye.y + 8) * scale);
				graphics.moveTo((leftEye.x + 8) * scale, (leftEye.y - 8) * scale);
				graphics.lineTo((leftEye.x - 8) * scale, (leftEye.y + 8) * scale);
			}
			p = getFeaturePointByName('PL');
			if (p) {
				graphics.lineStyle(0, 0xff0000, 0.8);
				graphics.moveTo((p.x - 3) * scale, p.y * scale);
				graphics.lineTo((p.x + 3) * scale, p.y * scale);
				graphics.moveTo(p.x * scale, (p.y - 3) * scale);
				graphics.lineTo(p.x * scale, (p.y + 3) * scale);
			}

			// left eyebrow
			graphics.lineStyle(0, 0x00ff00, 0.8);
			_drawFeatures(graphics, PointNames.LEFT_BROW, scale);

			// nose
			graphics.lineStyle(0, 0x0000ff, 0.8);
			_drawFeatures(graphics, PointNames.NOSE_VERTICAL_LINE, scale, false);
			_drawFeatures(graphics, PointNames.NOSE_BOTTOM_LINE, scale, false);

			// mouth
			graphics.lineStyle(0, 0xffcc00, 0.8);
			_drawFeatures(graphics, PointNames.MOUTH_ROUND, scale);
			_drawFeatures(graphics, PointNames.MOUTH_MIDDLE_LINE, scale, false);
		}


		private function _drawFeatures(graphics:Graphics, pointIds:Array, scale:Number = 1, close:Boolean = true):void {
			if (!features) return;
			if (close) pointIds.push(pointIds[0]);
			try {
				var f:FeaturePoint = features[pointIds[0]];
				graphics.moveTo(f.x * scale, f.y * scale);
				var n:int = pointIds.length;
				for (var i:int = 1; i < n; i++) {
					f = features[pointIds[i]];
					graphics.lineTo(f.x * scale, f.y * scale);
				}
			} catch (e:Error) {
				trace('draw error:', pointIds, pointIds[i]);
			}
		}
	}
}
