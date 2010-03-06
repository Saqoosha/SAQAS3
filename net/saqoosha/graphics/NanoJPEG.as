package net.saqoosha.graphics {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	
	/**
	 * Pure AS3 JPEG decoder ported from C++ version of NanoJPEG.
	 * @author Saqoosha
	 * @see http://keyj.s2000.ws/?p=137
	 * @see http://www.h4ck3r.net/2009/12/02/mini-jpeg-decoder/
	 */
	public class NanoJPEG {
		
		
		public static const RESULT_OK:String = 'OK';
		public static const RESULT_NOT_A_JPEG:String = 'Not a JPEG';
		public static const RESULT_UNSUPPORTED:String = 'Unsupported';
		public static const RESULT_OUT_OF_MEMORY:String = 'Out of memory';
		public static const RESULT_INTERNAL_ERROR:String = 'Internal error';
		public static const RESULT_SYNTAX_ERROR:String = 'Syntax error';
		public static const RESULT_INTERNAL_FINISHED:String = 'Internal finished';
		
		
		//
		
		
		private static const ZZ:Vector.<int> = Vector.<int>([
			 0,	 1,	 8, 16,	 9,	 2,	 3, 10,
			17, 24, 32, 25, 18, 11,	 4,	 5,
			12, 19, 26, 33, 40, 48, 41, 34,
			27, 20, 13,	 6,	 7, 14, 21, 28,
			35, 42, 49, 56, 57, 50, 43, 36,
			29, 22, 15, 23, 30, 37, 44, 51,
			58, 59, 52, 45, 38, 31, 39, 46,
			53, 60, 61, 54, 47, 55, 62, 63
		]);
		
		
		//
		
		
		private var ctx:Context;

		
		public function NanoJPEG() {
			ctx = new Context();
		}
		
		
		public function decode(jpegData:ByteArray):BitmapData {
			ctx.data = jpegData;
			ctx.data.position = 0;
			ctx.data.endian = Endian.BIG_ENDIAN;
			ctx.size = jpegData.length;
			if (ctx.size < 2) { throw new Error(RESULT_NOT_A_JPEG); }
			if ((ctx.data.readUnsignedByte() ^ 0xff) | (ctx.data.readUnsignedByte() ^ 0xD8)) { throw new Error(RESULT_NOT_A_JPEG); }
			_Skip(2);
			while (!ctx.completed) {
				if ((ctx.size < 2) || (ctx.data.readUnsignedByte() != 0xff)) { throw new Error(RESULT_SYNTAX_ERROR); }
				var b:int = ctx.data.readUnsignedByte();
				_Skip(2);
				switch (b) {
					case 0xC0: _DecodeSOF(); break;
					case 0xC4: _DecodeDHT(); break;
					case 0xDB: _DecodeDQT(); break;
					case 0xDD: _DecodeDRI(); break;
					case 0xDA: _DecodeScan(); break;
					case 0xFE: _SkipMarker(); break;
					default:
						if ((b & 0xF0) == 0xE0) {
							_SkipMarker();
						} else {
							throw new Error(RESULT_UNSUPPORTED);
						}
				}
			}
			_Convert();
			return ctx.image;
		}

		
		private function _DecodeSOF():void {
			var i:int;
			var ssxmax:int = 0;
			var ssymax:int = 0;
			var c:Component;
			_DecodeLength();
			if (ctx.length < 9) { throw new Error(RESULT_SYNTAX_ERROR); }
			if (ctx.data.readUnsignedByte() != 8) { throw new Error(RESULT_SYNTAX_ERROR); }
			ctx.height = ctx.data.readUnsignedShort();
			ctx.width = ctx.data.readUnsignedShort();
			ctx.ncomp = ctx.data.readUnsignedByte();
			_Skip(6);
			switch (ctx.ncomp) {
				case 1:
				case 3:
					break;
				default:
					throw new Error(RESULT_UNSUPPORTED);
			}
			if (ctx.length < ctx.ncomp * 3) { throw new Error(RESULT_SYNTAX_ERROR); }
			for (i = 0; i < ctx.ncomp; ++i) {
				c = ctx.comp[i];
				c.cid = ctx.data.readUnsignedByte();
				var b:int = ctx.data.readUnsignedByte();
				if (!(c.ssx = b >> 4)) { throw new Error(RESULT_SYNTAX_ERROR); }
				if (c.ssx & (c.ssx - 1)) { throw new Error(RESULT_UNSUPPORTED); }
				if (!(c.ssy = b & 15)) { throw new Error(RESULT_SYNTAX_ERROR); }
				if (c.ssy & (c.ssy - 1)) { throw new Error(RESULT_UNSUPPORTED); }
				if ((c.qtsel = ctx.data.readUnsignedByte()) & 0xFC) { throw new Error(RESULT_SYNTAX_ERROR); }
				_Skip(3);
				ctx.qtused |= 1 << c.qtsel;
				if (c.ssx > ssxmax) ssxmax = c.ssx;
				if (c.ssy > ssymax) ssymax = c.ssy;
			}
			ctx.mbsizex = ssxmax << 3;
			ctx.mbsizey = ssymax << 3;
			ctx.mbwidth = (ctx.width + ctx.mbsizex - 1) / ctx.mbsizex;
			ctx.mbheight = (ctx.height + ctx.mbsizey - 1) / ctx.mbsizey;
			for (i = 0; i < ctx.ncomp; ++i) {
				c = ctx.comp[i];
				c.width = (ctx.width * c.ssx + ssxmax - 1) / ssxmax;
				c.stride = (c.width + 7) & 0x7FFFFFF8;
				c.height = (ctx.height * c.ssy + ssymax - 1) / ssymax;
				c.stride = ctx.mbwidth * ctx.mbsizex * c.ssx / ssxmax;
				if (((c.width < 3) && (c.ssx != ssxmax)) || ((c.height < 3) && (c.ssy != ssymax))) { throw new Error(RESULT_UNSUPPORTED); }
				c.pixels = new ByteArray();
				c.pixels.length = c.stride * (ctx.mbheight * ctx.mbsizey * c.ssy / ssymax);
			}
			if (ctx.ncomp == 3) {
				ctx.rgb = new ByteArray();
				ctx.rgb.length = ctx.width * ctx.height * 4;
			}
			ctx.data.position += ctx.length;
			_Skip(ctx.length);
		}

		
		private function _DecodeDHT():void {
			var codelen:int, currcnt:int, remain:int, spread:int, i:int, j:int;
			var counts:ByteArray = new ByteArray();
			_DecodeLength();
			while (ctx.length >= 17) {
				i = ctx.data.readUnsignedByte();
				if (i & 0xEC) { throw new Error(RESULT_SYNTAX_ERROR); }
				if (i & 0x02) { throw new Error(RESULT_UNSUPPORTED); }
				i = (i | (i >> 3)) & 3;	 // combined DC/AC + tableid value
				ctx.data.readBytes(counts, 0, 16);
				_Skip(17);
				
				var vlcs:Vector.<VlcCode> = ctx.vlctab[i];
				remain = spread = 65536;
				for (codelen = 1; codelen <= 16; ++codelen) {
					spread >>= 1;
					currcnt = counts[codelen - 1];
					if (!currcnt) continue;
					if (ctx.length < currcnt) { throw new Error(RESULT_SYNTAX_ERROR); }
					remain -= currcnt << (16 - codelen);
					if (remain < 0) { throw new Error(RESULT_SYNTAX_ERROR); }
					for (i = 0;	 i < currcnt;  ++i) {
						var code:int = ctx.data.readUnsignedByte();
						for (j = spread; j; --j) {
							vlcs.push(new VlcCode(codelen, code));
						}
					}
					_Skip(currcnt);
				}
				while (remain--) {
					vlcs.push(new VlcCode());
				}
			}
			if (ctx.length) { throw new Error(RESULT_SYNTAX_ERROR); }
		}

		
		private function _DecodeDQT():void {
			var i:int;
			var t:ByteArray;
			_DecodeLength();
			while (ctx.length >= 65) {
				i = ctx.data.readUnsignedByte();
				if (i & 0xFC) { throw new Error(RESULT_SYNTAX_ERROR); }
				ctx.qtavail |= 1 << i;
				t = ctx.qtab[i];
				ctx.data.readBytes(t, 0, 64);
				_Skip(65);
			}
			if (ctx.length) { throw new Error(RESULT_SYNTAX_ERROR); }
		}

		
		private function _DecodeDRI():void {
			_DecodeLength();
			if (ctx.length < 2) { throw new Error(RESULT_SYNTAX_ERROR); }
			ctx.rstinterval = ctx.data.readUnsignedShort();
			ctx.data.position += ctx.length - 2;
			_Skip(ctx.length);
		}

		
		private function _DecodeScan():void {
			var i:int, mbx:int, mby:int, sbx:int, sby:int;
			var rstcount:int = ctx.rstinterval, nextrst:int = 0;
			var c:Component;
			var b:int;
			_DecodeLength();
			if (ctx.length < (4 + 2 * ctx.ncomp)) { throw new Error(RESULT_SYNTAX_ERROR); }
			if (ctx.data.readUnsignedByte() != ctx.ncomp) { throw new Error(RESULT_UNSUPPORTED); }
			_Skip(1);
			for (i = 0;	 i < ctx.ncomp;	 ++i) {
				c = ctx.comp[i];
				if (ctx.data.readUnsignedByte() != c.cid) { throw new Error(RESULT_SYNTAX_ERROR); }
				if ((b = ctx.data.readUnsignedByte()) & 0xEE) { throw new Error(RESULT_SYNTAX_ERROR); }
				c.dctabsel = b >> 4;
				c.actabsel = (b & 1) | 2;
				_Skip(2);
			}
			var d0:int = ctx.data.readUnsignedByte();
			var d1:int = ctx.data.readUnsignedByte();
			var d2:int = ctx.data.readUnsignedByte();
			if (d0 || (d1 != 63) || d2) { throw new Error(RESULT_UNSUPPORTED); }
			_Skip(ctx.length);
			for (mby = 0;  mby < ctx.mbheight;	++mby) {
				for (mbx = 0;  mbx < ctx.mbwidth;  ++mbx) {
					for (i = 0;	 i < ctx.ncomp;	 ++i) {
						c = ctx.comp[i];
						for (sby = 0;  sby < c.ssy;	 ++sby) {
							for (sbx = 0;  sbx < c.ssx;	 ++sbx) {
								c.pixels.position = ((mby * c.ssy + sby) * c.stride + mbx * c.ssx + sbx) << 3;
								_DecodeBlock(c, c.pixels);
							}
						}
					}
					if (ctx.rstinterval && !(--rstcount)) {
						_ByteAlign();
						i = _GetBits(16);
						if (((i & 0xFFF8) != 0xFFD0) || ((i & 7) != nextrst)) { throw new Error(RESULT_SYNTAX_ERROR); }
						nextrst = (nextrst + 1) & 7;
						rstcount = ctx.rstinterval;
						for (i = 0; i < 3; ++i) {
							ctx.comp[i].dcpred = 0;
						}
					}
				}
			}
			ctx.completed = true;
		}

		
		private function _DecodeBlock(c:Component, out:ByteArray):void {
			var code:IntValue = new IntValue();
			var value:int, coef:int = 0;
			ctx.block = Vector.<int>(new Array(64));
			c.dcpred += _GetVLC(ctx.vlctab[c.dctabsel], null);
			ctx.block[0] = c.dcpred * ctx.qtab[c.qtsel][0];
			do {
				value = _GetVLC(ctx.vlctab[c.actabsel], code);
				if (!code.value) break;
				if (!(code.value & 0x0F) && (code.value != 0xF0)) { throw new Error(RESULT_SYNTAX_ERROR); }
				coef += (code.value >> 4) + 1;
				if (coef > 63) { throw new Error(RESULT_SYNTAX_ERROR); }
				ctx.block[int(ZZ[coef])] = value * ctx.qtab[c.qtsel][coef];
			} while (coef < 63);
			for (coef = 0; coef < 64; coef += 8) {
				_RowIDCT(ctx.block, coef);
			}
			for (coef = 0;	coef < 8;  ++coef) {
				_ColIDCT(ctx.block, out, coef, c.stride);
			}
		}

		
		private function _GetVLC(vlc:Vector.<VlcCode>, code:IntValue):int {
			var value:int = _ShowBits(16);
			var bits:int = vlc[value].bits;
			if (!bits) { throw new Error(RESULT_SYNTAX_ERROR); }
			_SkipBits(bits);
			value = vlc[value].code;
			if (code) code.value = value;
			bits = value & 15;
			if (!bits) return 0;
			value = _GetBits(bits);
			if (value < (1 << (bits - 1)))
				value += ((-1) << bits) + 1;
			return value;
		}

		
		private static const W1:int = 2841;
		private static const W2:int = 2676;
		private static const W3:int = 2408;
		private static const W5:int = 1609;
		private static const W6:int = 1108;
		private static const W7:int = 565;
		
		private function _RowIDCT(blk:Vector.<int>, offset:int):void {
			var x0:int, x1:int, x2:int, x3:int, x4:int, x5:int, x6:int, x7:int, x8:int;
			var i0:int = offset;
			var i1:int = offset + 1;
			var i2:int = offset + 2;
			var i3:int = offset + 3;
			var i4:int = offset + 4;
			var i5:int = offset + 5;
			var i6:int = offset + 6;
			var i7:int = offset + 7;
			if (!((x1 = blk[i4] << 11)
				| (x2 = blk[i6])
				| (x3 = blk[i2])
				| (x4 = blk[i1])
				| (x5 = blk[i7])
				| (x6 = blk[i5])
				| (x7 = blk[i3])))
			{
				blk[i0] = blk[i1] = blk[i2] = blk[i3] = blk[i4] = blk[i5] = blk[i6] = blk[i7] = blk[i0] << 3;
				return;
			}
			x0 = (blk[i0] << 11) + 128;
			x8 = W7 * (x4 + x5);
			x4 = x8 + (W1 - W7) * x4;
			x5 = x8 - (W1 + W7) * x5;
			x8 = W3 * (x6 + x7);
			x6 = x8 - (W3 - W5) * x6;
			x7 = x8 - (W3 + W5) * x7;
			x8 = x0 + x1;
			x0 -= x1;
			x1 = W6 * (x3 + x2);
			x2 = x1 - (W2 + W6) * x2;
			x3 = x1 + (W2 - W6) * x3;
			x1 = x4 + x6;
			x4 -= x6;
			x6 = x5 + x7;
			x5 -= x7;
			x7 = x8 + x3;
			x8 -= x3;
			x3 = x0 + x2;
			x0 -= x2;
			x2 = (181 * (x4 + x5) + 128) >> 8;
			x4 = (181 * (x4 - x5) + 128) >> 8;
			blk[i0] = (x7 + x1) >> 8;
			blk[i1] = (x3 + x2) >> 8;
			blk[i2] = (x0 + x4) >> 8;
			blk[i3] = (x8 + x6) >> 8;
			blk[i4] = (x8 - x6) >> 8;
			blk[i5] = (x0 - x4) >> 8;
			blk[i6] = (x3 - x2) >> 8;
			blk[i7] = (x7 - x1) >> 8;
		}

		
		private function _ColIDCT(blk:Vector.<int>, out:ByteArray, offset:int, stride:int):void {
			var x0:int, x1:int, x2:int, x3:int, x4:int, x5:int, x6:int, x7:int, x8:int;
			var p:int = out.position + offset;
			if (!((x1 = blk[8*4+offset] << 8)
				| (x2 = blk[8*6+offset])
				| (x3 = blk[8*2+offset])
				| (x4 = blk[8*1+offset])
				| (x5 = blk[8*7+offset])
				| (x6 = blk[8*5+offset])
				| (x7 = blk[8*3+offset])))
			{
				x1 = _Clip(((blk[offset] + 32) >> 6) + 128);
				for (x0 = 8;  x0;  --x0) {
					out[p] = x1;
					p += stride;
				}
				return;
			}
			x0 = (blk[offset] << 8) + 8192;
			x8 = W7 * (x4 + x5) + 4;
			x4 = (x8 + (W1 - W7) * x4) >> 3;
			x5 = (x8 - (W1 + W7) * x5) >> 3;
			x8 = W3 * (x6 + x7) + 4;
			x6 = (x8 - (W3 - W5) * x6) >> 3;
			x7 = (x8 - (W3 + W5) * x7) >> 3;
			x8 = x0 + x1;
			x0 -= x1;
			x1 = W6 * (x3 + x2) + 4;
			x2 = (x1 - (W2 + W6) * x2) >> 3;
			x3 = (x1 + (W2 - W6) * x3) >> 3;
			x1 = x4 + x6;
			x4 -= x6;
			x6 = x5 + x7;
			x5 -= x7;
			x7 = x8 + x3;
			x8 -= x3;
			x3 = x0 + x2;
			x0 -= x2;
			x2 = (181 * (x4 + x5) + 128) >> 8;
			x4 = (181 * (x4 - x5) + 128) >> 8;
			out[p] = _Clip(((x7 + x1) >> 14) + 128); p += stride;
			out[p] = _Clip(((x3 + x2) >> 14) + 128); p += stride;
			out[p] = _Clip(((x0 + x4) >> 14) + 128); p += stride;
			out[p] = _Clip(((x8 + x6) >> 14) + 128); p += stride;
			out[p] = _Clip(((x8 - x6) >> 14) + 128); p += stride;
			out[p] = _Clip(((x0 - x4) >> 14) + 128); p += stride;
			out[p] = _Clip(((x3 - x2) >> 14) + 128); p += stride;
			out[p] = _Clip(((x7 - x1) >> 14) + 128);		
		}

		
		private function _Convert():void {
			var i:int;
			var c:Component;
			for (i = 0;	 i < ctx.ncomp;	 ++i) {
				c = ctx.comp[i];
				while ((c.width < ctx.width) || (c.height < ctx.height)) {
					if (c.height < ctx.height) _UpsampleV(c);
					if (c.width < ctx.width) _UpsampleH(c);
				}
				if ((c.width < ctx.width) || (c.height < ctx.height)) { throw new Error(RESULT_INTERNAL_ERROR); }
			}
			if (ctx.ncomp == 3) {
				// convert to RGB
				var x:int, yy:int;
				const prgb:ByteArray = ctx.rgb;
				const py:ByteArray	= ctx.comp[0].pixels;
				const pcb:ByteArray = ctx.comp[1].pixels;
				const pcr:ByteArray = ctx.comp[2].pixels;
				var iprgb:int = 0;
				var ipy:int = 0;
				var ipcb:int = 0;
				var ipcr:int = 0;
				for (yy = ctx.height;  yy;	--yy) {
					for (x = 0;	 x < ctx.width;	 ++x) {
						var y:int = py[ipy + x] << 8;
						var cb:int = pcb[ipcb + x] - 128;
						var cr:int = pcr[ipcr + x] - 128;
						prgb[iprgb++] = 255; // alpha
						prgb[iprgb++] = _Clip((y			+ 359 * cr + 128) >> 8); // red
						prgb[iprgb++] = _Clip((y -	88 * cb - 183 * cr + 128) >> 8); // green
						prgb[iprgb++] = _Clip((y + 454 * cb			   + 128) >> 8); // blue
					}
					ipy += ctx.comp[0].stride;
					ipcb += ctx.comp[1].stride;
					ipcr += ctx.comp[2].stride;
				}
				
				ctx.image = new BitmapData(ctx.width, ctx.height, true, 0x0);
				ctx.image.setPixels(ctx.image.rect, ctx.rgb);
				
			} else if (ctx.comp[0].width != ctx.comp[0].stride) {
				throw new Error(RESULT_UNSUPPORTED);
//				  // grayscale -> only remove stride
//				  unsigned char *pin = &ctx.comp[0].pixels[ctx.comp[0].stride];
//				  unsigned char *pout = &ctx.comp[0].pixels[ctx.comp[0].width];
//				  int y;
//				  for (y = ctx.comp[0].height - 1;	y;	--y) {
//					  memcpy(pout, pin, ctx.comp[0].width);
//					  pin += ctx.comp[0].stride;
//					  pout += ctx.comp[0].width;
//				  }
//				  ctx.comp[0].stride = ctx.comp[0].width;
			}
		}

		
		private static const CF4A:int = -9;
		private static const CF4B:int = 111;
		private static const CF4C:int = 29;
		private static const CF4D:int = -3;
		private static const CF3A:int = 28;
		private static const CF3B:int = 109;
		private static const CF3C:int = -9;
		private static const CF3X:int = 104;
		private static const CF3Y:int = 27;
		private static const CF3Z:int = -3;
		private static const CF2A:int = 139;
		private static const CF2B:int = -11;
		
		private function CF(x:int):int {
			return _Clip((x + 64) >> 7);
		}
		
		
		private function _UpsampleH(c:Component):void {
			const xmax:int = c.width - 3;
			var x:int, y:int;
			var org:ByteArray = c.pixels;
			var out:ByteArray = new ByteArray();
			out.length = ((c.width * c.height) << 1) * 4;
			var iorg:int = 0;
			var iout:int = 0;
			for (y = c.height;	y;	--y) {
				out[iout + 0] = CF(CF2A * org[iorg + 0] + CF2B * org[iorg + 1]);
				out[iout + 1] = CF(CF3X * org[iorg + 0] + CF3Y * org[iorg + 1] + CF3Z * org[iorg + 2]);
				out[iout + 2] = CF(CF3A * org[iorg + 0] + CF3B * org[iorg + 1] + CF3C * org[iorg + 2]);
				for (x = 0;	 x < xmax;	++x) {
					out[iout + (x << 1) + 3] = CF(CF4A * org[iorg + x] + CF4B * org[iorg + x + 1] + CF4C * org[iorg + x + 2] + CF4D * org[iorg + x + 3]);
					out[iout + (x << 1) + 4] = CF(CF4D * org[iorg + x] + CF4C * org[iorg + x + 1] + CF4B * org[iorg + x + 2] + CF4A * org[iorg + x + 3]);
				}
				iorg += c.stride;
				iout += c.width << 1;
				out[iout - 3] = CF(CF3A * org[iorg - 1] + CF3B * org[iorg - 2] + CF3C * org[iorg - 3]);
				out[iout - 2] = CF(CF3X * org[iorg - 1] + CF3Y * org[iorg - 2] + CF3Z * org[iorg - 3]);
				out[iout - 1] = CF(CF2A * org[iorg - 1] + CF2B * org[iorg - 2]);
			}
			c.width <<= 1;
			c.stride = c.width;
			c.pixels = out;
		}

		
		private function _UpsampleV(c:Component):void {
			const w:int = c.width;
			const s1:int = c.stride;
			const s2:int = s1 + s1;
			var x:int, y:int;
			var org:ByteArray = c.pixels;
			var out:ByteArray = new ByteArray();
			out.length = ((c.width * c.height) << 1) * 4;
			var iorg:int = 0;
			var iout:int = 0;
			for (x = 0;	 x < w;	 ++x) {
				iorg = x;
				iout = x;
				out[iout] = CF(CF2A * org[iorg + 0] + CF2B * org[iorg + s1]);	 iout += w;
				out[iout] = CF(CF3X * org[iorg + 0] + CF3Y * org[iorg + s1] + CF3Z * org[iorg + s2]);  iout += w;
				out[iout] = CF(CF3A * org[iorg + 0] + CF3B * org[iorg + s1] + CF3C * org[iorg + s2]);  iout += w;
				iorg += s1;
				for (y = c.height - 3;	y;	--y) {
					out[iout] = CF(CF4A * org[iorg - s1] + CF4B * org[iorg + 0] + CF4C * org[iorg + s1] + CF4D * org[iorg + s2]);	iout += w;
					out[iout] = CF(CF4D * org[iorg - s1] + CF4C * org[iorg + 0] + CF4B * org[iorg + s1] + CF4A * org[iorg + s2]);	iout += w;
					iorg += s1;
				}
				iorg += s1;
				out[iout] = CF(CF3A * org[iorg + 0] + CF3B * org[iorg - s1] + CF3C * org[iorg - s2]);	iout += w;
				out[iout] = CF(CF3X * org[iorg + 0] + CF3Y * org[iorg - s1] + CF3Z * org[iorg - s2]);	iout += w;
				out[iout] = CF(CF2A * org[iorg + 0] + CF2B * org[iorg - s1]);
			}
			c.height <<= 1;
			c.stride = c.width;
			c.pixels = out;
		}

		
		//

		
		private function _Clip(x:int):int {
			return (x < 0) ? 0 : ((x > 0xFF) ? 0xFF : x);
		}

		
		private function _SkipMarker():void {
			_DecodeLength();
			ctx.data.position += ctx.length;
			_Skip(ctx.length);
		}

		
		private function _Skip(count:int):void {
			// bytearray automaticaly increments its position during readBytes method. (or anoter read methods)
			// so, I don't increment position in this method.
			// ctx.pos += count;
			ctx.size -= count;
			ctx.length -= count;
			if (ctx.size < 0) { throw new Error(RESULT_SYNTAX_ERROR); }
		}

		
		private function _DecodeLength():void {
			if (ctx.size < 2) { throw new Error(RESULT_SYNTAX_ERROR); }
			ctx.length = ctx.data.readUnsignedShort();
			if (ctx.length > ctx.size) { throw new Error(RESULT_SYNTAX_ERROR); }
			_Skip(2);
		}

		
		private function _ByteAlign():void {
			ctx.bufbits &= 0xF8;
		}

		
		private function _ShowBits(bits:int):int {
			var newbyte:int;
			if (!bits) return 0;
			while (ctx.bufbits < bits) {
				if (ctx.size <= 0) {
					ctx.buf = (ctx.buf << 8) | 0xFF;
					ctx.bufbits += 8;
					continue;
				}
				newbyte = ctx.data.readUnsignedByte();
				ctx.size--;
				ctx.bufbits += 8;
				ctx.buf = (ctx.buf << 8) | newbyte;
				if (newbyte == 0xFF) {
					if (ctx.size) {
						var marker:int = ctx.data.readUnsignedByte();
						ctx.size--;
						switch (marker) {
							case 0: break;
							case 0xD9: ctx.size = 0; break;
							default:
								if ((marker & 0xF8) != 0xD0) {
									throw new Error(RESULT_SYNTAX_ERROR);
								} else {
									ctx.buf = (ctx.buf << 8) | marker;
									ctx.bufbits += 8;
								}
						}
					} else {
						throw new Error(RESULT_SYNTAX_ERROR);
					}
				}
			}
			return (ctx.buf >> (ctx.bufbits - bits)) & ((1 << bits) - 1);
		}

		
		private function _GetBits(bits:int):int {
			var res:int = _ShowBits(bits);
			_SkipBits(bits);
			return res;
		}

		
		private function _SkipBits(bits:int):void {
			if (ctx.bufbits < bits) {
				_ShowBits(bits);
			}
			ctx.bufbits -= bits;
		}
	}
}

import flash.display.BitmapData;
import flash.utils.ByteArray;


class Context {
	
	public var completed:Boolean = false;
	public var data:ByteArray = null;
	public var size:int = 0;
	public var length:int = 0;
	public var width:int = 0;
	public var height:int = 0;
	public var mbwidth:int = 0;
	public var mbheight:int = 0;
	public var mbsizex:int = 0;
	public var mbsizey:int = 0;
	public var ncomp:int = 0;
	public var comp:Vector.<Component>;
	public var qtused:int;
	public var qtavail:int;
	public var qtab:Vector.<ByteArray>;
	public var vlctab:Vector.<Vector.<VlcCode>>;
	public var buf:int;
	public var bufbits:int;
	public var block:Vector.<int>;
	public var rstinterval:int;
	public var rgb:ByteArray;
	public var image:BitmapData;

	public function Context() {
		var i:int;
		comp = new Vector.<Component>();
		for (i = 0; i < 4; ++i) {
			comp.push(new Component());
		}
		qtab = new Vector.<ByteArray>();
		for (i = 0; i < 4; ++i) {
			qtab.push(new ByteArray());
		}
		vlctab = new Vector.<Vector.<VlcCode>>();
		for (i = 0; i < 4; ++i) {
			vlctab.push(new Vector.<VlcCode>());
		}
	}
}


class Component {
	
	public var cid:int;
	public var ssx:int;
	public var ssy:int;
	public var width:int;
	public var height:int;
	public var stride:int;
	public var qtsel:int;
	public var actabsel:int;
	public var dctabsel:int;
	public var dcpred:int;
	public var pixels:ByteArray;
}


class VlcCode {
	
	public var bits:int;
	public var code:int;
	
	public function VlcCode(bits:int = 0, code:int = 0):void {
		this.bits = bits;
		this.code = code;
	}
}


class IntValue {
	
	public var value:int;
	
	public function IntValue(value:int = 0) {
		this.value = value;
	}
}
