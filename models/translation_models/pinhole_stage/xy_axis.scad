include <z_axis.scad>;
include <../components/5v_stepper_motor.scad>;
vert_drive_rod_length = 105;
vert_static_rod_length = 115;
horz_rod_length = 80;
static_rod_radius = 9.54/2;
static_vert_rod_loc = 0;
lin_bearing_or = lin_bearing_od/2;

/*
difference() {
	Z_AXIS_TRANS_STAGE();
	color("cyan") translate([-mount_position-10,0,20]) smooth_rod(10, rod_radius);
}
XY_AXIS_TRANS_STAGE();
	union() {
		tbs_mount_z_axis();
		frame();
	}
*/

module tbs_mount_z_axis() {
	difference() {
			translate([0,0,40]) cube([20,25,25],center=true);
			translate([static_vert_rod_loc,0,80]) smooth_rod(vert_static_rod_length, static_rod_radius);
	}
	difference() {
		union() {
			translate([-30,-12.5,-22.5]) cube([60,20,5]);
			translate([-30,-12.5,23.5]) cube([60,25,5]);
		}
		translate([17.5,0,0]) cylinder(h=100,r=3,center=true,$fn=50);
		translate([-17.5,0,0]) cylinder(h=100,r=3,center=true,$fn=50);
	}
}

module XY_AXIS_TRANS_STAGE() {
	vert_stage();
	//color("grey") translate([0,0,97]) rotate([0,90,0]) smooth_rod(horz_rod_length, rod_radius);
	//translate([0,0,130]) pinhole();
	//translate([-40,0,75]) horz_stage();
	//translate([10,37.5,75]) rotate([0,90,0]) tbs_pinhole_axis();
	//translate([10,37.5,75]) rotate([0,90,0]) tbs_adj();
	//translate([17.5,37.5,75]) rotate([0,90,0]) horz_drive_shaft_bearing(16,2);
	//translate([-33.5,37.5,75]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14,width=19);
	//translate([-17,37.5,75]) rotate([0,90,0]) coupler(coupler_dim, 2.5,2.5);
}

module vert_stage(){
	color("grey") translate([-40,0,130]) rotate([-90,0,180])  stepper_motor();

	//coupler and rods
	%translate([-40,0,115]) coupler(coupler_dim, 2.5,2.5);
	//color("grey") translate([static_vert_rod_loc,0,80]) smooth_rod(vert_static_rod_length, static_rod_radius);
	color("grey") translate([-40,0,70.5]) smooth_rod(vert_drive_rod_length, rod_radius);
	translate([-40,0,85]) rotate([0,0,90]) tbs_adj();
	union() {
		frame();
	}
	horz_platform();
	translate([-62.5,52,82]) rotate([0,-90,0]) tbs_adj();
	//TODO: Design lin bearing with platform for
	//translate([-62.5,90,77]) rotate([180,0,0]) pinhole_lin_bearing();
}

module frame() {
	top_pos = 120;
	tbs_mount_z_axis();
	union() {
		difference() {//top frame
			translate([-12.5,5,top_pos]) cube([135,35,20],center=true);
			translate([-40,0,top_pos]) cylinder(r=10,h=25,center=true,$fn=100); //motor shaft hole
			translate([static_vert_rod_loc,0,100]) smooth_rod(220, static_rod_radius); //static shaft hole
			//screw holes
			translate([-23.5,13,top_pos-10]) cube([7,20,30],center=true);//screw hole +y side
			translate([-23.5,8,top_pos]) cylinder(r=2,h=25,center=true,$fn=100); 
			translate([-56.5,13,top_pos-10]) cube([7,20,30],center=true);//screw hole +y side
			translate([-56.5,8,top_pos]) cylinder(r=2,h=25,center=true,$fn=100); 
		}
		
		//bottom frame
		translate([0,10,0]) rotate([-90,0,0]) union() {
			//-x mount
			difference() {
				rotate([0,0,180]) tbs_side_support();
				translate([85,-50,-30]) mirror([1,0,0]) cube([30,100,30]);
			}

			//+x mount
			difference() {
				union() {
					translate([0,0,-30]) rotate([180,0,0])tbs_side_support();
					translate([-40,-33,-10]) cube([35,19,25],center=true);
				}
				translate([-40,-40,-10]) rotate([90,0,0]) cylinder(h=7,r=lin_bearing_od/2+.3,center=true,$fn=100);
			}
			%translate([-40,-40,-10]) rotate([90,0,0]) bearing(2.5,8);
			
		}

		//Side support beams
		translate([23,-12.5,20]) cube([32,15,top_pos-20]);
		translate([-80,-12.5,0]) cube([15,15,top_pos+10]);
	}

	//private modules
	module tbs_side_support() {
		difference() {
			translate([-45.5,10,-15]) cube([45, 65, 15],center=true);
			translate([-rod_spacing,0,0]) cylinder(h=100,r=lin_bearing_od/2,center=true,$fn=100);
		}
		//translate([-mount_position-2.5,0,-7.5]) cube([50,45,30],center=true);
		translate([-70,0,-15]) cube([20,45,15],center=true);
	}
}

module pinhole() {
	difference() {
		cube([40,10,40],center=true);
		rotate([90,0,0]) cylinder(h=20,r=1,center=true,$fn=100);
	}
}

module horz_platform() {
	difference() {
		union() {
			translate([-62,63.25,73]) color("lightgrey") cube([135,80,45],center=true);
			translate([-22.5,2.5,78]) color("lightgrey") cube([80,50,15],center=true);
		}
		translate([-62.5,63.25,75]) cube([100,70,45],center=true);//platform cutout
		translate([-40.5,2.75,77.5]) cube([47,41,50],center=true);
		translate([10,12,10]) union() {//motor cutout
			translate([-14,40,80]) rotate([0,90,0]) cylinder(h=20,r=14,$fn=50,center=true);
			translate([-14,40,90]) cube([20,28,20],center=true);
			%translate([-24,40,72]) rotate([90,0,0]) rotate([90,-90,0]) stepper_motor();
		}
		//bearing slot
		translate([-115,52,82]) rotate([0,90,0]) cylinder(h=6,r=8.1,$fn=50,center=true);
		//static rod
		translate([-45,92,82]) rotate([0,90,0]) cylinder(h=200,r=static_rod_radius,$fn=50,center=true);
	}
}

module pinhole_lin_bearing() {
	case_width = 14.9;
	difference() {
		union() {
			/* lin bearing casing */
			difference() {
				translate([2.5,-4.5,2]) cube([case_width,36.5,45],center=true);
				translate([0,0,7]) rotate([0,90,0]) cylinder(h=30,r=lin_bearing_or,center=true,$fn=true);//lin bear hole
				translate([2,-12.5,20]) cube([screw_nut_size+10,4,screw_nut_size],center=true);//nut hole
				translate([2,-12.5,-10]) cube([screw_nut_size+10,4,screw_nut_size],center=true);//nut hole
			}
			/* TBS Mounting arms */
			translate([2.5,25,23.25]) cube([case_width,70,2.51],center=true);
			translate([2.5,25,-19.25]) cube([case_width,70,2.5],center=true);
		}
		/* screw holes to TBS */
		translate([-.5,55,0]) cylinder(h=70,r=screw_rad+.25,center=true,$fn=50);//screw hole for tbs	
		translate([-.5,20,0]) cylinder(h=70,r=screw_rad+.25,center=true,$fn=50);//screw hole for tbs
		translate([2,-15,20]) rotate([90,0,0]) cylinder(h=40,r=screw_rad,center=true,$fn=50);//screw hole for slide arm
		translate([2,-15,-10]) rotate([90,0,0]) cylinder(h=40,r=screw_rad,center=true,$fn=50);//screw hole for slide arm
	}
}

module horz_stage(height=27.5) {
	union() {
		difference() {//Motor Seat
			difference() {
				translate([-10,35,5]) cube([30,50,height],center=true);
				translate([6.5,37.5,0]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14.5,width=34);
				translate([-5,37.5,17.5]) cube([30,29,20],center=true);
				translate([-10,23,12.5]) cube([20,10,15],center=true);
				translate([-10,52,12.5]) cube([20,10,15],center=true);
				translate([5,21,8]) rotate([0,90,0]) cylinder(h=10,r=2,center=true,$fn=100);
				translate([5,54,8]) rotate([0,90,0]) cylinder(h=10,r=2,center=true,$fn=100);
			}
		}
		difference() {//Linear Bearing Shaft
			difference() {
				translate([-5,0,5]) cube([40,30,height],center=true);
				cylinder(h=90,r=lin_bearing_or,center=true,$fn=100);
				translate([50,0,2]) rotate([0,90,0]) smooth_rod(horz_rod_length, static_rod_radius);
			}
		}
	}
}

module tbs_pinhole_axis() {
	union() {
		//tbs();
		difference() {
			translate([3,-45,-7.5]) cube([40,45,15],center=true);
			translate([-3,-37.5,-10]) cylinder(h=30,r=lin_bearing_or,center=true,$fn=100);
		}
	}
}

module horz_drive_shaft_bearing(bearing_od, screw_size) {
	screw_rad = screw_size/2;
	mount1_pos = 15;
	mount2_pos = 20;
	union() {
		difference() {//Bearing Case
			cube([20,30,10],center=true);
			cylinder(h=40,r=8,center=true,$fn=100);
		}
		difference() {//Mount 1
			
			translate([0,-12.5,mount1_pos]) cube([20,5,30],center=true);
			translate([0,-12.5,mount1_pos+10]) rotate([90,0,0]) cylinder(h=10,r=screw_rad,center=true,$fn=100);
		}
		difference() {//Mount 2
			translate([0,-mount2_pos,-2.5]) cube([20,20,5],center=true);
			translate([0,-mount2_pos-5,0]) cylinder(h=10,r=screw_rad,center=true,$fn=100);
		}
	}
	%bearing(2.5,bearing_od/2);
}

