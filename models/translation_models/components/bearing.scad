
module bearing(in_rad=2.5, out_rad=8){
	//color("blue")
	difference() {
		cylinder(h=7,r=out_rad,center=true, $fn=100);
		cylinder(h=8,r=in_rad,center=true, $fn=100);
	}
}
