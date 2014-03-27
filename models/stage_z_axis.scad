use <TBS_5x2.scad>;
use <5v_stepper_motor.scad>

module tbs_with_arm() {
	union() {
		tbs(); //This is the threadless ball screw base structure
		difference() {
			translate([38.7,0,-9.41]) cube([38.7,45,11.176],center=true); //This is the extra appendage sticking out. 
			translate([40,0,-7.5]) cylinder(h=20,r=12.95/2,$fn=500,center=true); //This is the hole for the linear bearing
		}
	}
	%translate([40,0,0]) cylinder(h=100,r=9.525/2,center=true,$fn=200);
}

module joint() {
	difference() {
		cube([15,15,5]);
		translate([7.5,7.5,0]) cylinder(h=10,r=2.2,$fn=500,center=true);
	}
}

rotate([90,0,0]) joint();
rotate([90,0,0]) translate([90,0,0]) joint();
translate([32,17.5,15]) tbs_with_arm();

rotate([90,0,90]) translate([17.5,-45.5,32]) stepper_motor();

translate([0,0,-84.5]) cube([100,30,20]);
translate([0,0,65]) cube([100,30,20]);

