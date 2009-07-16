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

    public class ObjectDumper extends Object {

        /**
         * 変数の内容をダンプして文字列として返す
         *
         * @param foo            ダンプ対象の変数
         * @param maxObjectNests Object型の情報を何階層まで出力するか
         * @param level          現在の階層、再帰呼び出しでのみ使用するので設定不要
         * @param label          出力に付くラベル、再帰呼び出しでのみ使用するので設定不要
         */
        public static function dumpToText(foo:*, maxObjectNests:Number = 5, level:int = 0, label:String = ""):String {

            var t:String = "";

            var pad:String = "";
            for (var lv:* = 0; lv < level * 4; lv++) pad += " ";

            // プリミティヴ型の場合
            if (   foo is Boolean
                || foo is Number
                || foo is int
                || foo is uint
                || foo is String
                || foo === undefined
                || foo === null
            ) {
                t += pad + label + "(" + typeof foo + ") " + foo + "\n";
            // 配列型の場合
            } else if (foo is Array) {
                t += pad + label + "(" + typeof foo + ") [object Array]\n";
                for (var n:* = 0; n < foo.length; n++)
                    t += arguments.callee(foo[n], maxObjectNests, level + 1, "[" + n + "] = ");
            // その他の型の場合
            } else {
                t += pad + label + "(" + typeof foo + ") " + foo + "\n";
                    // 最大ネスト回数による判定
                    //   for ... in だとクラス定義のプロパティ・メソッドは対象外なので不要だったかも
                    if (maxObjectNests > level) {
                        for (var i:* in foo)
                            t += arguments.callee(foo[i], maxObjectNests, level + 1, i + " = ");
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
        public static function dump(foo:*, maxObjectNests:Number = 10):void {
            trace(dumpToText(foo, maxObjectNests));
        }
        
    }
    
}

