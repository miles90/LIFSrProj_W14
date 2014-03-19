module ccd() {
	union() {
		difference() {
			//Top Cube
			translate([0,0,-1])
			cube([30,30,18], center=true);
			translate([0,0,2.6])
			//Inner Cube
			cube([20,20,16], center=true);
			translate([10.5,0,4])
			//CCD Tray
			cube([5.5,25.5,27.9], center=true);
			//Lense Shaft
			translate([-12.5,0,6])
			cube([3,8,15], center=true);
			//Lens 
			rotate([0,90,0])
			translate([2.5,0,-12])
			cylinder(h=10, r=2.5,center=true,$fn=60);
			//hole push out
			translate([-12,0,0])
			cylinder(h=20,r=.5,center=true,$fn=50);
		}
		translate([18,0,0])
		difference() {
			translate([0,0,-1])
			cube([6,30,18], center=true);
			translate([-1,0,5])
			//bolt hole
			cube([4,10,20],center=true);
			//Bolt holes
			rotate([0,90,0])
			translate([0,0,2])
			cylinder(r=2.2, h=8, center=true, $fn=60);	
			//Remove HOle
			translate([-1,0,-5])
			cylinder(r=.5, h=18, center=true, $fn=50);
	
		}
		translate([25,0,-9.5])
		cube([10,30,1],center=true);
		translate([25,13,-1])
		cube([10,4,18], center=true);
		translate([25,-13,-1])
		cube([10,4,18], center=true);
	}
}


ccd();