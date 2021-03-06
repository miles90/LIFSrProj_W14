  use <../threadless_ball_screws/TBS_5x2_adjustable.scad>
include <../components/5v_stepper_motor.scad>
include <../pinhole_stage/xy_axis.scad>

slide_clearance_w = 0; //Slide width is 45mm
slide_clearance_l = 15; //Slide length is 85mm
static_rod_r = 9.53/2;
outer_axis_static_rod_length = 200;
outer_axis_drive_rod_length = 110; 
inner_axis_drive_rod_length = 110;
inner_axis_static_rod_length = 140;
drive_rod_r = 2.5;

oa_dr_rod_l = outer_axis_drive_rod_length;
oa_st_rod_l = outer_axis_static_rod_length;
ia_dr_rod_l = inner_axis_drive_rod_length;
ia_st_rod_l = inner_axis_static_rod_length;
slide_length=95;
screw_diameter=5;
screw_rad=screw_diameter/2;
screw_nut_size=15;
lin_bearing_or = 8.1;

//color("cyan") translate([-60,-75,-23]) cube([85,45,10]);

rotate([90,0,0]) two_axis_slide_stage();
//translate([-30,-100,0]) cube([150,30,30],center=true);
//translate([0,70,0]) cube([200,30,30],center=true);
module two_axis_slide_stage() {
	translate([0,-7,7]) rotate([-90,0,0]) inner_axis();
	outer_axis();
}

module outer_axis() {
	translate([mount_position+15,0,60]) rotate([-90,0,90])  stepper_motor();
	translate([60,0,45]) coupler(coupler_dim, 2.5,2.5);
	color("lightGrey") translate([-mount_position-80,0,15-10]) smooth_rod(oa_st_rod_l, static_rod_r);
	color("darkGrey") translate([60,0,42]) rotate([180,0,0]) cylinder(h=oa_dr_rod_l, r=drive_rod_r, $fn=50);
	%translate([60,0,15]) rotate([0,0,90]) tbs_adj();
	rotate([-90,0,0]) outer_drive_mount();
	rotate([90,0,0]) outer_static_mount();
}

module outer_static_mount() {
	outer_static_mount_br();
	outer_static_mount_st();
}

module outer_static_mount_br() { //bearing side
	difference() {
		translate([-30+62.5,-90,0]) cube([125,50,30],center=true);
		translate([-30,-60,0]) cube([120,60,35],center=true);
		translate([92.5,-90,0]) cube([28,51,31],center=true);// non-essential cutout
		rotate([90,0,0]) translate([mount_position+15,0,68]) cylinder(h=9,r=bearing_od/2+.25,center=true,$fn=50); //bearing(2.5,bearing_od/2);
		// Frame Mounting Holes 1
		translate([-25+25,-115+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([-25+25,-115+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([-25+25,-115+14.75,-5]) cube([5.25,100,2.5],center=true);
		// Frame Mounting Holes 2
		translate([15+25,-115+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([15+25,-115+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([15+25,-115+14.75,-5]) cube([5.25,100,2.5],center=true);
	}
	difference() { // Mounting holes for static rod side
		translate([-26.25,-102.5,0]) cube([7.5,25,60],center=true);
		translate([-32.5,-100,22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
		translate([-32.5,-100,-22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
	}
}

module outer_static_mount_st() { //static rod side
	difference() {
		translate([-30-62.5,-90,0]) cube([125,50,30],center=true);
		translate([-30,-60,0]) cube([120,60,35],center=true);
		rotate([90,0,0]) translate([-mount_position-80,0,15-10]) smooth_rod(oa_st_rod_l, static_rod_r+.25);
		translate([-155,-90,0]) cube([28,51,31],center=true);// non-essential cutout
		translate([-140,-90,0]) cube([30,51,1],center=true);//adj gap
		translate([-135,-74,0]) cylinder(h=70,r=screw_rad,center=true,$fn=50);//screw hole
		translate([-135,-72,-8]) cube([screw_nut_size,screw_nut_size+3.1,4],center=true);//nut hole
		// Frame Mounting Holes 1
		translate([-45-60,-115+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([-45-60,-115+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([-45-60,-115+14.75,-5]) cube([5.25,100,2.5],center=true);
		// Frame Mounting Holes 2
		translate([10-60,-115+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([10-60,-115+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([10-60,-115+14.75,-5]) cube([5.25,100,2.5],center=true);
	}
	difference() { // Mounting holes for bearing side
		translate([-33.75,-102.5,0]) cube([7.5,25,60],center=true);
		translate([-32.5,-100,22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
		translate([-32.5,-100,-22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
	}
	
}

module outer_drive_mount() {
	outer_drive_mount_mt();
	translate([0,0,0]) outer_drive_mount_st();
}
	
module outer_drive_mount_mt() { //motor side
	difference() {
		union() {
			translate([62.5,-97.5,0]) cube([65,65,50],center=true);
			difference() {
				translate([-40+62.5,-105,0]) cube([125,50,30],center=true);
				translate([-30,-65,0]) cube([120,70,35],center=true);
			}
		}
		translate([80,-75,0]) cube([65,21,28],center=true);
		// Motor mounting holes
		translate([68,-75,16.5]) rotate([90,0,0]) cylinder(h=30,r=2,center=true,$fn=50);//screw hole
		translate([68,-70,16.5]) cube([8,3,20],center=true);//nut hole
		translate([68,-75,-16.5]) rotate([90,0,0]) cylinder(h=40,r=2,center=true,$fn=50);//screw hole
		translate([68,-70,-16.5]) cube([8,3,20],center=true);//nut hole
		// Frame Mounting Holes 1
		translate([-15,-130+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([-15,-130+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([-15,-130+14.75,5]) cube([5.25,100,2.5],center=true);
		// Frame Mounting Holes 2
		translate([10,-130+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([10,-130+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
		translate([10,-130+14.75,5]) cube([5.25,100,2.5],center=true);
	}
	difference() { //Mounting holes for static rod side
		translate([-36.25,-115,0]) cube([7.5,30,60],center=true);
		translate([-32.5,-115,22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
		translate([-32.5,-115,-22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
	}
}

module outer_drive_mount_st() { //static rod side
	difference() {
		union() {
			difference() {
				translate([-40-62.5,-97.5,0]) cube([125,65,30],center=true);
				translate([-30,-65,0]) cube([120,70,35],center=true);
				rotate([90,0,0]) translate([-mount_position-80,0,15-10]) smooth_rod(oa_st_rod_l, static_rod_r+.25);
				translate([-155,-90,0]) cube([28,81,31],center=true);// non-essential cutout
				translate([-140,-90,0]) cube([30,51,1],center=true);//adj gap
				translate([-135,-74,0]) cylinder(h=70,r=screw_rad,center=true,$fn=50);//screw hole
				translate([-135,-72,-8]) cube([screw_nut_size,screw_nut_size+3.1,4],center=true);//nut hole
				// Frame Mounting Holes 1
				translate([-25-80,-130+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
				translate([-25-80,-130+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
				translate([-25-80,-130+14.75,5]) cube([5.25,150,2.5],center=true);
				// Frame Mounting Holes 2
				translate([10-80,-130+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
				translate([10-80,-130+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
				translate([10-80,-130+14.75,5]) cube([5.25,100,2.5],center=true);
			}
		}
	}
	difference() { //Mounting holes for motor side
		translate([-43.75,-115,0]) cube([7.5,30,60],center=true);
		translate([-32.5,-115,22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
		translate([-32.5,-115,-22.5]) rotate([0,90,0]) cylinder(h=50,r=3,center=true,$fn=50);
	}
}

module inner_axis() {
	color("slateGrey") translate([40,0,7]) rotate([0,-90,0]) cylinder(h=ia_st_rod_l, r=static_rod_r,$fn=50);
	color("slateGrey") translate([45,37.5,5]) rotate([0,-90,0]) cylinder(h=ia_dr_rod_l, r=2.5,$fn=50);
	translate([-30,37.5+slide_clearance_w,5]) rotate([180,90,0]) tbs_adj();
	translate([-25,0,0]) sample_lin_bearing();
	translate([-25,-13,0]) sample_arm();
	translate([-35,0,0]) inner_axis_drive_mount();
	translate([-83.5,37.5+slide_clearance_w,5]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14,width=19);
	translate([-65,37.5+slide_clearance_w,5]) rotate([0,90,0]) coupler(coupler_dim, 2.5,2.5);
	translate([37.5,37.5,5]) rotate([0,90,0]) inner_axis_static_mount(16,2);
}

module inner_axis_drive_mount() {
	difference() {
		union() {
			translate([-55,slide_clearance_w,3.75]) inner_stepper_mount(30);
			translate([-15,20,7]) lin_bearing_case();
		}
	translate([40,0,7]) rotate([0,-90,0]) cylinder(h=105, r=static_rod_r,$fn=50);
	translate([-50,0,20]) cube([22,1,20],center=true);
		translate([-45,10,20]) cube([11,11,11],center=true);
		translate([-45,-9,20]) cube([screw_nut_size,5,screw_nut_size],center=true);
		translate([-45,-20,20]) rotate([90,0,0]) cylinder(h=50,r=screw_rad,center=true,$fn=50);
	}
}

module inner_axis_static_mount() {
	difference() {
		union() { //Mount
			difference() {//Bearing Case 
				translate([-27.5,-57,-15]) cube([45,75+slide_clearance_w,30]);
				translate([0,slide_clearance_w,0]) cylinder(h=100,r=8,center=true,$fn=100);
				translate([-5,-49.5,22.5]) rotate([90,180,0]) cube([40,45,40],center=true);
				translate([-2,-37.5,0]) cylinder(h=50,r=static_rod_r,center=true,$fn=100);
				translate([10,-55,-10]) rotate([0,0,-60]) cube([40,1,30],center=true);//adj gap
				translate([10,-45,-5]) rotate([0,0,-60]) cube([screw_nut_size,3,screw_nut_size],center=true);//nut slot
				translate([10,-40,-5]) rotate([30,-90,0]) cylinder(h=50,r=screw_rad,center=true,$fn=50);//screw hole
			}
			difference() {//Back Plate
				translate([-27.5,-30.5,0]) cube([45,5,45]);
				translate([-2.5,-25,45]) cube([12,12,60],center=true);//cylinder(r=6,h=20,center=true,$fn=50);
			}
			union() {//tbs mounts
				translate([-26.25,-37.5,22.5]) cube([2.5,19,45],center=true);
				translate([16.25,-37.5,22.5]) cube([2.5,19,45],center=true);
			}
		}
		translate([0,-40.8,-15]) rotate([90,0,0]) union() {
			translate([5.5,55,0]) rotate([0,90,0]) cylinder(h=70,r=screw_rad,center=true,$fn=50);	
			translate([5.5,20,0]) rotate([0,90,0]) cylinder(h=70,r=screw_rad,center=true,$fn=50);	
		}
		translate([-14-2,-58,-5]) rotate([0,0,-60]) cube([screw_nut_size+5,20+5,screw_nut_size+30],center=true);//screw head opening
	}
	%translate([0,0,5]) bearing(2.5,bearing_od/2);
}

module inner_stepper_mount(height=27.5) {
	union() {
		difference() {//Motor Seat
			difference() {
				translate([-10,35,5]) cube([30,50,height],center=true);
				translate([6.5,37.5,0]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14.5,width=34);
				translate([-5,37.5,17.5]) cube([30,29,20],center=true);
				translate([-10,23,12.55]) cube([20,10,15],center=true);
				translate([-10,52,12.55]) cube([20,10,15],center=true);
				translate([5,20.5,8]) rotate([0,90,0]) cylinder(h=11,r=2,center=true,$fn=100);
				translate([5,54.5,8]) rotate([0,90,0]) cylinder(h=11,r=2,center=true,$fn=100);
			}
		}
		translate([-5,0,5]) cube([40,30,height],center=true);
	}
}

module lin_bearing_case(){
	difference() {
		translate([-65,-10,1.75]) cube([60,16.3,30],center=true);
		translate([-75,-10,0]) rotate([90,0,0]) cylinder(h=30,r=lin_bearing_or,center=true,$fn=50);
	}
}

module sample_lin_bearing() {
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

module sample_arm() {
	/* slide back */
	difference() {
		translate([2.5,-23,4.5]) cube([slide_length-8,12,40],center=true);
		translate([2.5,-30,-10.5]) cube([slide_length+10,15,10],center=true);
		translate([2,-20,20]) rotate([90,0,0]) cylinder(h=40,r=screw_rad,center=true,$fn=50);
		translate([2,-20,-10]) rotate([90,0,0]) cylinder(h=40,r=screw_rad,center=true,$fn=50);
		translate([2,-22,-10]) rotate([90,0,0]) cylinder(h=4,r=screw_rad+2,center=true,$fn=50);
	}
	/* slide bottom */
//	difference() {
//		translate([2.5,-50,-18]) cube([slide_length,45,5.1],center=true);
//		translate([2.5,-40,-18]) cube([slide_length/1.7,25,10],center=true);
//	}
	/* slide border */
//	translate([-45,-72.5,-15.5]) cube([5,55,10]);
//	translate([-30,-72.5,-15.5]) rotate([0,0,90]) cube([5,10.1,10]);
//	translate([45,-72.5,-15.5]) cube([5,55,11]);
//	translate([45,-72.5,-15.5]) rotate([0,0,90]) cube([5,10,10]);
  /* fattening edges */
  translate([-41,-29,-15.5]) cube ([38,12,10]);
  translate([8,-29,-15.5]) cube ([38,12,10]);
}
