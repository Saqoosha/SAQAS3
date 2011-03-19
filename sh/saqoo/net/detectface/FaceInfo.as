package sh.saqoo.net.detectface {

	import flash.display.Graphics;
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


		public function FaceInfo(data:XML) {
			bounds = new Rectangle(parseInt(data.bounds.@x), parseInt(data.bounds.@y), parseInt(data.bounds.@width), parseInt(data.bounds.@height));
			if (data.hasOwnProperty('right-eye')) rightEye = new Point(parseInt(data['right-eye'].@x), parseInt(data['right-eye'].@y));
			if (data.hasOwnProperty('left-eye')) leftEye = new Point(parseInt(data['left-eye'].@x), parseInt(data['left-eye'].@y));
			if (data.hasOwnProperty('features')) {
				sAvg = parseFloat(data.features.attribute('s-avg'));
				sMin = parseFloat(data.features.attribute('s-min'));
				sMax = parseFloat(data.features.attribute('s-max'));
				features = new Dictionary();
				for each (var feat:XML in data.features.point) {
					var f:FeaturePoint = new FeaturePoint(feat.@id, parseInt(feat.@x), parseInt(feat.@y), parseFloat(feat.@s));
					features[f.id] = f;
				}
			}
		}
		
		
		public function getFeaturePointByName(name:String):FeaturePoint {
			return features ? features[name] || null : null;
		}


		public function debugDraw(graphics:Graphics, scale:Number = 1):void {
			// bounds
			graphics.lineStyle(0, 0xffffff);
			graphics.drawRect(bounds.x * scale, bounds.y * scale, bounds.width * scale, bounds.height * scale);
			_drawFeatures(graphics, ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10'], scale);

			// right eye
			if (rightEye) {
				graphics.lineStyle(0, 0xff0000, 0.8);
				_drawFeatures(graphics, ['ER1', 'ER2', 'ER3', 'ER4', 'ER5', 'ER6'], scale);
				graphics.lineStyle();
				graphics.beginFill(0xff0000, 0.5);
				graphics.drawCircle(rightEye.x * scale, rightEye.y * scale, 5 * scale);
				graphics.endFill();
			}

			// right eyebrow
			graphics.lineStyle(0, 0x00ff00, 0.8);
			_drawFeatures(graphics, ['BR1', 'BR2', 'BR3', 'BR4', 'BR5', 'BR6'], scale);

			// left eye
			if (leftEye) {
				graphics.lineStyle(0, 0xff0000, 0.8);
				_drawFeatures(graphics, ['EL1', 'EL2', 'EL3', 'EL4', 'EL5', 'EL6'], scale);
				graphics.lineStyle();
				graphics.beginFill(0xff0000, 0.5);
				graphics.drawCircle(leftEye.x * scale, leftEye.y * scale, 5 * scale);
				graphics.endFill();
			}

			// left eyebrow
			graphics.lineStyle(0, 0x00ff00, 0.8);
			_drawFeatures(graphics, ['BL1', 'BL2', 'BL3', 'BL4', 'BL5', 'BL6'], scale);

			// nose
			graphics.lineStyle(0, 0x0000ff, 0.8);
			_drawFeatures(graphics, ['N1', 'N5'], scale, false);
			_drawFeatures(graphics, ['N2', 'N3', 'N4'], scale, false);

			// mouth
			graphics.lineStyle(0, 0xffcc00, 0.8);
			_drawFeatures(graphics, ['M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8'], scale);
			_drawFeatures(graphics, ['M3', 'M9', 'M7'], scale, false);
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
