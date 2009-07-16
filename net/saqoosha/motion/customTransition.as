package net.saqoosha.motion {
	
	public function customTransition (t:Number,b:Number,c:Number,d:Number,pl:Array):Number {
		var r:Number = 200 * t/d;
		var i:Number = -1;
		var e:Object;
		while (pl[++i].Mx<=r) e = pl[i];
		var Px:Number = e.Px;
		var Nx:Number = e.Nx;
		var s:Number = (Px==0) ? -(e.Mx-r)/Nx : (-Nx+Math.sqrt(Nx*Nx-4*Px*(e.Mx-r)))/(2*Px);
		return (b-c*((e.My+e.Ny*s+e.Py*s*s)/200));
	}
	
}
