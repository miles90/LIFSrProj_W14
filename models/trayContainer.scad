mod_length = 85;


module boltBox() {
	cube(size=[10,4,20], center=true);
}

module clipHole() {
	cylinder(r=2.2, h=8, center=true);
}

module removeHole() {
	cylinder(d=4, h=6, center=true);
}

module trayContainer() {
	difference() {
		cube(size=[mod_length,10,45], center=true);
		translate([0,1,5]) 
			cube(size=[mod_length+.2,8,25.9], center=true);
		//
		translate([0,0,5]) 
			cube(size=[41,12,16], center=true);
		//Inner holder
		translate([0,0,5])
			cube(size=[51.3,8,25.9], center=true);
		// Screw Holes
		translate([mod_length/2.5, 15-8, -15])
			rotate([90,0,0]) 
				clipHole();
		translate([-mod_length/2.5, 15-8, -15])
			rotate([90,0,0]) 
				clipHole();			
		//Bolt holes
		translate([-mod_length/2.5,1,-20])
			boltBox();
		translate([mod_length/2.5,1,-20])
			boltBox();
		//Remove holes
		translate([-mod_length/2.5,1,-10])
			removeHole();
		translate([mod_length/2.5,1,-10])
			removeHole();
		//big screw hole
		translate([0,1,20])
			cube([10,10,10], center=true);
	}
}



$fn=100;
trayContainer();	
