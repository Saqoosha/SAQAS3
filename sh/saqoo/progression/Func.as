/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2009 taka:nium.jp, All Rights Reserved.
 * @version 4.0.1 Public Beta 1.3
 * @see http://progression.jp/
 * 
 * Progression Software is released under the Progression Software License:
 * http://progression.jp/ja/overview/license
 * 
 * Progression Libraries is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package sh.saqoo.progression {
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	
	/**
	 * <p>Func クラスは、指定された関数を実行するコマンドクラスです。</p>
	 * <p></p>
	 * 
	 * @example <listing version="3.0" >
	 * // Func インスタンスを作成する
	 * var com:Func = new Func();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class Func extends Command {
		
		/**
		 * <p>実行したい関数を取得します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</p>
		 * <p></p>
		 * 
		 * @see #args
		 */
		public function get func():Function { return _func; }
		public function set func( value:Function ):void { _func = value; }
		private var _func:Function;
		
		/**
		 * <p>関数を実行する際に引数として使用する配列を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</p>
		 * <p></p>
		 * 
		 * @see #func
		 */
		public function get args():Array { return _args; }
		public function set args( value:Array ):void { _args = value; }
		private var _args:Array;
		
		/**
		 * <p>処理の終了イベントを発行する IEventDispatcher インスタンスを取得します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</p>
		 * <p></p>
		 * 
		 * @see #eventType
		 * @see #listening
		 * @see #listen()
		 */
		public function get dispatcher():* { return _dispatcher; }
		private var _dispatcher:*;
		
		/**
		 * <p>発行される終了イベントの種類を取得します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</p>
		 * <p></p>
		 * 
		 * @see #dispatcher
		 * @see #listening
		 * @see #listen()
		 */
		public function get eventType():String { return _eventType; }
		private var _eventType:String;
		
		/**
		 * <p>イベント待ちをしているかどうかを取得します。</p>
		 * <p></p>
		 * 
		 * @see #dispatcher
		 * @see #eventType
		 * @see #listen()
		 */
		public function get listening():Boolean { return _listening; }
		private var _listening:Boolean = false;
		
		
		
		
		
		/**
		 * <p>新しい Func インスタンスを作成します。</p>
		 * <p>Creates a new Func object.</p>
		 * 
		 * @param func
		 * <p>実行したい関数です。</p>
		 * <p></p>
		 * @param args
		 * <p>関数を実行する際に引数として使用する配列です。</p>
		 * <p></p>
		 * @param dispatcher
		 * <p>処理の終了イベントを発行する EventDispatcher インスタンスです。</p>
		 * <p></p>
		 * @param eventType
		 * <p>発行される終了イベントの種類です。</p>
		 * <p></p>
		 * @param initObject
		 * <p>設定したいプロパティを含んだオブジェクトです。</p>
		 * <p></p>
		 */
		public function Func( func:Function, args:Array = null, dispatcher:* = null, eventType:String = null, initObject:Object = null ) {
			// 引数を設定する
			_func = func;
			_args = args;
			_dispatcher = dispatcher;
			_eventType = eventType;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
			
			if (dispatcher && !(dispatcher['addEventListener'] is Function)) {
				throw new ArgumentError('dispatcher must be IEventDispatcher or StaticEventDispatcher.');
			}
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// イベントが存在するかどうか確認する
			_listening = ( _dispatcher && _eventType );
			
			// イベントが存在すれば登録する
			if ( _listening ) {
				_dispatcher.addEventListener( _eventType, _listener );
			}
			
			// 関数を実行する
			_func.apply( this, _args );
			
			// イベントが存在すれば終了する
			if ( _listening ) { return; }
			
			// 実行中であれば
			if ( super.state > 1 ) {
				super.executeComplete();
			}
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// イベントを監視していれば
			if ( _listening ) {
				// イベントリスナーを解除する
				_dispatcher.removeEventListener( _eventType, _listener );
			}
		}
		
		/**
		 * <p>イベント待ちを設定します。</p>
		 * <p></p>
		 * 
		 * @see #dispatcher
		 * @see #eventType
		 * @see #listening
		 * 
		 * @param dispatcher
		 * <p>イベントの送出元です。</p>
		 * <p></p>
		 * @param eventType
		 * <p>送出されるのを待つイベントタイプです。</p>
		 * <p></p>
		 */
		public function listen( dispatcher:IEventDispatcher, eventType:String ):void {
			if ( _listening ) {
				_listening = false;
				_dispatcher.removeEventListener( _eventType, _listener );
			}
			
			_dispatcher = dispatcher;
			_eventType = eventType;
			
			if ( _dispatcher && _eventType ) {
				_listening = true;
				_dispatcher.addEventListener( _eventType, _listener );
			}
		}
		
		/**
		 * <p>Func インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</p>
		 * <p>Duplicates an instance of an Func subclass.</p>
		 * 
		 * @return
		 * <p>元のオブジェクトと同じプロパティ値を含む新しい Func インスタンスです。</p>
		 * <p>A new Func object that is identical to the original.</p>
		 */
		override public function clone():Command {
			return new Func( _func, _args, _dispatcher, _eventType, this );
		}
		
		/**
		 * <p>指定されたオブジェクトのストリング表現を返します。</p>
		 * <p>Returns the string representation of the specified object.</p>
		 * 
		 * @return
		 * <p>オブジェクトのストリング表現です。</p>
		 * <p>A string representation of the object.</p>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "dispatcher", "eventType" );
		}
		
		
		
		
		
		/**
		 * dispatcher の eventType イベントが発生した瞬間に送出されます。
		 */
		private function _listener( e:Event ):void {
			// イベントリスナーを解除する
			_dispatcher.removeEventListener( _eventType, _listener );
			
			// 実行中であれば
			if ( super.state > 1 ) {
				super.executeComplete();
			}
		}
	}
}
