use <../components/TBS_5x2.scad>
use <../components/5v_stepper_motor.scad>
use <../components/coupler.scad>
use <../components/bearing.scad>
use <../threadless_ball_screws/TBS_5x2_adjustable.scad>

//Variables
dr_rod_length = 87;
st_rod_length = 120;
rod_radius = 2.5;
st_rod_radius = 9.53/2;
rod_spacing = 40;
base_width = 200;
base_thickness = 15;
in_base_width = base_width - (2 * base_thickness);
base_length = 130;
in_base_length = 80;
base_depth = 50;
in_base_depth = 100;
bearing_od = 16;
lin_bearing_od = 16.1;
coupler_dim=[25,9];
c_1=2.5; //coupler radius 
c_2=2.5; //coupler radius 2
mount_position = 45;

//Z_AXIS_TRANS_STAGE();

//Assembly
module Z_AXIS_TRANS_STAGE() {
	rotate([0,90,90]) translate([0,rod_spacing,4.5]) smooth_rod(st_rod_length, st_rod_radius);
	rotate([0,90,90]) translate([0,-rod_spacing,4.5]) smooth_rod(st_rod_length, st_rod_radius);
	rotate([0,90,90]) translate([0,0,4.5]) smooth_rod(dr_rod_length, rod_radius);
	%rotate([0,90,90]) translate([0,0,-40]) coupler(coupler_dim,c_1,c_2);
	rotate([0,180,0]) translate([0,-55,0]) stepper_motor();
	%rotate([90,0,0])  translate([0,0,-45]) bearing(2.5,8);
	z_axis_base();
	translate([0,4.5,0]) rotate([-90,-90,0]) tbs_adj();
}


//Modules
module smooth_rod(Length,Radius) {
	cylinder(h=Length,r=Radius,center=true, $fn=100);
}

module tbs() {
	difference() {
		Base();
		bearingMounts();
	}
}

module tbs_horz_axis() {
	difference() {
		difference() {
			Base();
			bearingMounts();
		}
		translate([0,35,-8]) rotate([90,90,0]) cylinder(h=40,r=2.5,center=true,$fn=100);
	}
}

module tbs_z_axis() {
	translate([0,0,-7.5]) rotate([0,0,-90])difference() {//threadless ball screw
		Base();
		bearingMounts();
	}
}

module z_axis_base() {

	difference() {
		difference() {
			translate([0,-5,-10]) cube([base_width,base_length,base_depth],center=true);
			translate([0,0,10]) cube([in_base_width,in_base_length,in_base_depth],center=true);
		}
		translate([0,-65,40]) cube([29,40,56],center=true);
		translate([0,-35,10]) rotate([90,0,0])  cylinder(h=65,r=14.25,$fn=100);
		translate([0,-44,20]) color("blue") cube([60,25,56], center=true);//cutout for motor seat
		translate([-rod_spacing,-35,0]) rotate([90,0,0])  cylinder(h=65,r=st_rod_radius,$fn=100);
		translate([rod_spacing,-35,0]) rotate([90,0,0])  cylinder(h=65,r=st_rod_radius,$fn=100);
		translate([-rod_spacing,100,0]) rotate([90,0,0])  cylinder(h=65,r=st_rod_radius,$fn=100);
		translate([rod_spacing,100,0]) rotate([90,0,0])  cylinder(h=65,r=st_rod_radius,$fn=100);
		translate([0,100,0]) rotate([90,0,0])  cylinder(h=65,r=8.2,$fn=100);
		//static rod mount 1 (motor side)
		translate([rod_spacing+10,-45,12]) cube([4,12,12],center=true);
		translate([rod_spacing+13,-45,11]) rotate([0,90,0]) cylinder(h=50,r=2.5,center=true,$fn=50);
		translate([rod_spacing,-43,12]) cube([1.5,100,20],center=true);
		//static rod mount 2 (motor side)
		translate([-(rod_spacing+10),-45,12]) cube([4,12,12],center=true);
		translate([-(rod_spacing+13),-45,11]) rotate([0,90,0]) cylinder(h=50,r=2.5,center=true,$fn=50);
		translate([-rod_spacing,-43,12]) cube([1.5,100,20],center=true);
		//static rod mount 3 (opposite motor side)
		translate([(rod_spacing+10),45,12]) cube([4,12,12],center=true);
		translate([rod_spacing,43,12]) cube([1.5,100,20],center=true);
		translate([(rod_spacing+13),45,11]) rotate([0,90,0]) cylinder(h=50,r=2.5,center=true,$fn=50);
		translate([(rod_spacing-20),45,11]) cube([26,11,11],center=true);
		//static rod mount 4 (opposite motor side)
		translate([-(rod_spacing+10),45,12]) cube([4,12,12],center=true);
		translate([-rod_spacing,43,12]) cube([1.5,100,20],center=true);
		translate([-(rod_spacing+13),45,11]) rotate([0,90,0]) cylinder(h=50,r=2.5,center=true,$fn=50);
		translate([-(rod_spacing-20),45,11]) cube([26,11,11],center=true);
	}
}
