//L=length, R=Total Radius, c1=radius of 1st coupler, c2=radius of 2nd coupler

module coupler(dim, c1, c2) {
	difference(){
		difference(){
			cylinder(h=dim[0], r=dim[1], center=true, $fn=100);
			translate([0,0,-(dim[0]-dim[0]/2.1)]) cylinder(h=dim[0], r=c1, center=true, $fn=100);
		}
		translate([0,0,dim[0]-dim[0]/2]) cylinder(h=dim[0], r=c2, center=true, $fn=100);
	}
}
