/*
  Copyright (c) 2008, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package sh.saqoo.format.fbx {

	
	public class FBXParser
	{
		
		public static function parse( s:String ):FBXNode
		{
			return new FBXParser( s ).getRoot();
		}
		
		
		/** The value that will get parsed from the JSON string */
		private var root:FBXNode;
		
		/** The tokenizer designated to read the JSON string */
		private var tokenizer:FBXTokenizer;
		
		/** The current token from the tokenizer */
		private var token:FBXToken;
		
		/**
		 * Constructs a new JSONDecoder to parse a JSON string
		 * into a native object.
		 *
		 * @param s The JSON string to be converted
		 *		into a native object
		 * @param strict Flag indicating if the JSON string needs to
		 * 		strictly match the JSON standard or not.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function FBXParser( s:String )
		{
			tokenizer = new FBXTokenizer( s );
			
			nextToken();
			if ( !token || token.type != FBXTokenType.SYMBOL )
			{
				tokenizer.parseError( "Expecting key but found " + token.value );
			}
			
			root = parseChildren(new FBXNode() );
			
			// Make sure the input stream is empty
			if ( nextToken() != null )
			{
				tokenizer.parseError( "Unexpected characters left in input stream" );
			}
		}
		
		/**
		 * Gets the internal object that was created by parsing
		 * the JSON string passed to the constructor.
		 *
		 * @return The internal object representation of the JSON
		 * 		string that was passed to the constructor
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function getRoot():FBXNode
		{
			return root;
		}
		
		/**
		 * Returns the next token from the tokenzier reading
		 * the JSON string
		 */
		private final function nextToken():FBXToken
		{
			return token = tokenizer.getNextToken();
		}
		
		/**
		 * Returns the next token from the tokenizer reading
		 * the JSON string and verifies that the token is valid.
		 */
		private final function nextValidToken():FBXToken
		{
			token = tokenizer.getNextToken();
			checkValidToken();
			
			return token;
		}
		
		/**
		 * Verifies that the token is valid.
		 */
		private final function checkValidToken():void
		{
			// Catch errors when the input stream ends abruptly
			if ( token == null )
			{
				tokenizer.parseError( "Unexpected end of input" );
			}
		}
		
		
		private final function parseChildren( parent:FBXNode ):FBXNode
		{
			while ( true )
			{
				if ( !token )
				{
					return arrengeChildren( parent );
				}
				else if ( token.type == FBXTokenType.SYMBOL )
				{
					var type:String = String( token.value );
					
					nextValidToken();
					if ( token.type == FBXTokenType.COLON )
					{
						var node:* = parseNode(type);
						
						if ( parent[ type ] is Array ) {
							parent[ type ].push( node );
						}
						else
						{
							parent[ type ] = [ node ];
						}
					}
					else
					{
						tokenizer.parseError( "Expecting : but found " + token.value );
					}
				}
				else if ( token.type == FBXTokenType.RIGHT_BRACE )
				{
					nextToken();
					return arrengeChildren( parent );
				}
				else
				{
					tokenizer.parseError( "Expecting key but found " + token.value );
				}
			}
			
			return null;
		}
		
		
		private final function arrengeChildren(node:FBXNode):FBXNode
		{
			for ( var key:String in node )
			{
				if ( node[ key ] is Array && node[ key ].length == 1)
				{
					node[ key ] = node[ key ][ 0 ];
				}
			}
			return node;
		}
		
		
		private final function parseNode(kind:String = null):* {
			var node:FBXNode = new FBXNode(kind);
			var values:Array = [];

			nextValidToken();
			while ( true )
			{
				switch ( token.type )
				{
					case FBXTokenType.SYMBOL:
					case FBXTokenType.STRING:
					case FBXTokenType.NUMBER:
						values.push( token.value );
						
						nextToken();
						if ( token )
						{
							if ( token.type == FBXTokenType.COMMA ) {
								nextValidToken();
								continue;
							}
							else if ( token.type == FBXTokenType.LEFT_BRACE )
							{
								continue;
							}
							else
							{
								if ( values.length == 1 )
								{
									return values[0];
								}
								else if ( values.length )
								{
									return values;
								}
								return null;
							}
						}
						else
						{
							return node;
						}
					
					case FBXTokenType.LEFT_BRACE:
						nextValidToken();
						node = parseChildren(node);
						if ( values.length > 0 )
						{
							node.name = values.shift();
						}
						if ( values.length == 1 )
						{
							node.value = values[0];
						}
						else if ( values.length )
						{
							node.value = values;
						}
						return node;
					
					default:
						tokenizer.parseError( "Unexpected " + token.value );
				}
			}

			return null;
		}
	}
}
