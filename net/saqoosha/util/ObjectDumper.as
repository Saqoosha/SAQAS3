/**
 * デバッグ用ユーティリティクラス
 *
 * TODO:
 * -プリミティヴ型変数の判定部分が適当なので、不具合があったら直す
 *
 * @author kjirou <kjirou.web[at-mark]gmail.com>
 *                <http://kjirou.sakura.ne.jp/mt/>
 * @license MIT License http://www.opensource.org/licenses/mit-license.php
 */
package net.saqoosha.util {
	import flash.utils.ByteArray;

	
	public class ObjectDumper extends Object {

        /**
         * 変数の内容をダンプして文字列として返す
         *
         * @param foo            ダンプ対象の変数
         * @param maxObjectNests Object型の情報を何階層まで出力するか
         * @param level          現在の階層、再帰呼び出しでのみ使用するので設定不要
         * @param label          出力に付くラベル、再帰呼び出しでのみ使用するので設定不要
         */
        public static function dumpToText(data:*, maxObjectNests:Number = 5, level:int = 0, label:String = ""):String {

            var t:String = "";

            var pad:String = "";
            for (var lv:* = 0; lv < level * 4; lv++) pad += " ";

            // プリミティヴ型の場合
            if (   data is Boolean
                || data is Number
                || data is int
                || data is uint
                || data is String
                || data === undefined
                || data === null
            ) {
                t += pad + label + "(" + typeof data + ") " + data + "\n";
            // 配列型の場合
            } else if (data is Array) {
                t += pad + label + "(" + typeof data + ") [object Array] length=" + data.length + "\n";
                for (var n:* = 0; n < data.length; n++)
                    t += arguments.callee(data[n], maxObjectNests, level + 1, "[" + n + "] = ");
			// ByteArray の場合
            } else if (data is ByteArray) {
            	t += pad + label + "(bytearray) length = " + ByteArray(data).length + "\n";
            // その他の型の場合
            } else {
                t += pad + label + "(" + typeof data + ") " + data + "\n";
                    // 最大ネスト回数による判定
                    //   for ... in だとクラス定義のプロパティ・メソッドは対象外なので不要だったかも
                    if (maxObjectNests > level) {
                        for (var i:* in data)
                            t += arguments.callee(data[i], maxObjectNests, level + 1, i + " = ");
                    } else {
                        t += pad + "    ... abbreviated ...\n";
                    };
            };
            return t;
        };

        /**
         * 変数の内容をダンプする
         *
         * @param foo            dumpToText参照
         * @param maxObjectNests dumpToText参照
         */
        public static function dump(data:*, maxObjectNests:Number = 10):void {
            trace(dumpToText(data, maxObjectNests));
        }
    }
}
