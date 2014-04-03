use <../threadless_ball_screws/TBS_5x2_adjustable.scad>
include <../components/5v_stepper_motor.scad>
include <../pinhole_stage/xy_axis.scad>

slide_clearance_w = 0; //Slide width is 45mm
slide_clearance_l = 15; //Slide length is 85mm
static_rod_r = 9.53/2;
outer_axis_static_rod_length = 150;
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
	color("darkGrey") translate([-mount_position-80,0,5]) rotate([180,0,0]) cylinder(h=oa_st_rod_l, r=static_rod_r, center=true, $fn=50);
	color("darkGrey") translate([45,0,5]) rotate([180,0,0]) cylinder(h=oa_st_rod_l, r=static_rod_r, center=true, $fn=50);
	//%translate([60,0,15]) rotate([0,0,90]) tbs_adj();
	rotate([-90,0,0]) union() {
		translate([0,5,0]) outer_mount(); //bearing side
		translate([-80,5,0]) mirror([1,0,0]) outer_mount(); //bearing side
		translate([0,-15,0]) mirror([0,1,0]) outer_mount(); //motor side
		mirror([1,0,0]) translate([80,-15,0]) mirror([0,1,0]) outer_mount();//motor side
	}
	translate([0,-5.75,0]) outer_axis_drive_mount();
	translate([-40,49.75,10]) rotate([0,0,-90]) tbs_adj();
	translate([-42.5,55,-90]) outer_motor_seat();
	translate([-37.5,55,100]) rotate([0,180,0]) outer_bearing_seat();
	translate([-40,50,-42.5]) rotate([90,0,0]) union(){
		stepper_motor();
		translate([0,15,0]) rotate([90,0,0]) coupler(coupler_dim, 2.5,2.5);
	}
}

module outer_motor_seat() { //holds the outer motor and attaches to outer_mounts
	difference() {
		union() {
			translate([2.5,-3,-7.5]) cube([105,36,35],center=true);
			translate([2.5,0,11]) cube([50,30,30],center=true);//make space for step motor mount
			translate([-35,-5,41.5]) rotate([-90,-90,0]) stepper_mount(30);
			translate([52.55,-15,-7.5]) cube([4.9,50,35],center=true);
			translate([32.45,-15,-7.5]) cube([4.9,50,35],center=true);
			translate([-47.55,-15,-7.5]) cube([4.9,50,35],center=true);
			translate([-27.45,-15,-7.5]) cube([4.9,50,35],center=true);
		}
		translate([50,-7,105]) rotate([90,0,0]) union() {
			translate([-80.5,-122,24]) rotate([0,90,0]) cylinder(h=200,r=3,center=true,$fn=50);
			translate([-80.5,-108,24]) rotate([0,90,0]) cylinder(h=200,r=3,center=true,$fn=50);
		}
	}
}

module outer_bearing_seat() { //holds the outer bearing and attaches to outer_mounts
	difference() {
		union() {
			translate([2.5,-3,-7.5]) cube([105,36,35],center=true);
			difference() {
				translate([2.5,-3,25]) cube([30,36,35],center=true);//bearing case
				translate([2.5,-5,40]) cylinder(h=5.5, r=lin_bearing_or, center=true, $fn=50);
			}
			%translate([2.5,-5,40]) bearing(2.5,bearing_od/2);
			translate([52.55,-15,-7.5]) cube([4.9,50,35],center=true);
			translate([32.45,-15,-7.5]) cube([4.9,50,35],center=true);
			translate([-47.55,-15,-7.5]) cube([4.9,50,35],center=true);
			translate([-27.45,-15,-7.5]) cube([4.9,50,35],center=true);
		}
		translate([50,-7,105]) rotate([90,0,0]) union() {
			translate([-80.5,-122,24]) rotate([0,90,0]) cylinder(h=200,r=3,center=true,$fn=50);
			translate([-80.5,-108,24]) rotate([0,90,0]) cylinder(h=200,r=3,center=true,$fn=50);
		}
	}
}

module outer_axis_drive_mount() {
	difference() {
		union() {//base
			translate([-41.75,40,2]) cube([152.5,25,20],center=true);
			translate([-40,52.5,2]) cube([55,50,20],center=true);
		}
		//Driver inner mount side
		translate([-102,35,2]) cube([40,25,17],center=true);
		translate([-97,35.75,0]) cylinder(h=50,r=3,center=true,$fn=50);
		translate([-110,35.75,0]) cylinder(h=50,r=3,center=true,$fn=50);
		//Static inner mount side
		translate([20,35,2]) cube([40,25,15.5],center=true);
		translate([27.5,35.75,0]) cylinder(h=50,r=3,center=true,$fn=50);
		translate([14.5,35.75,0]) cylinder(h=50,r=3,center=true,$fn=50);
		//Cutout for TBS
		translate([-40,52.5,0]) cube([46,40,25],center=true);
		translate([-22.5,52.5,5.5]) rotate([90,0,0]) cylinder(h=100,r=screw_rad,center=true,$fn=50);//screw_hole
		translate([-57.5,52.5,5.5]) rotate([90,0,0]) cylinder(h=100,r=screw_rad,center=true,$fn=50);//screw hole
	}
}
	
module outer_mount() { 
	union() {
		difference() {
			translate([-102.5,-97.5,0]) cube([125,65,30],center=true);
			translate([-30,-75,0]) cube([137,50,35],center=true);//cutout for sample arm to move
			rotate([90,0,0]) translate([-mount_position-80,0,15-10]) smooth_rod(oa_st_rod_l, static_rod_r+.25);
			translate([-155,-90,0]) cube([28,81,31],center=true);// outside edge cutout
			translate([-140,-90,0]) cube([30,51,1],center=true);//adj gap
			translate([-135,-74,0]) cylinder(h=70,r=screw_rad,center=true,$fn=50);//screw hole
			translate([-135,-72,-8]) cube([screw_nut_size,screw_nut_size+3.1,4],center=true);//nut hole
			// Frame Mounting Holes 1
			translate([-25-80,-130+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
			translate([-25-80,-130+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
			translate([-25-80,-130+14.75,5]) cube([5.25,150,2.5],center=true);
			// Frame Mounting Holes 2
			translate([20-80,-130+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
			translate([20-80,-130+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
			translate([20-80,-130+14.75,5]) cube([5.25,100,2.5],center=true);
			// Frame Mounting Holes 3
			translate([-256.25+5.25,0,0]) rotate([0,0,90]) union() {
				translate([-100,-130+5.25,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
				translate([-100,-130+14.75,0]) cylinder(h=100,r=2,center=true,$fn=50);//screw hole
				translate([-100,-130+14.75,10]) cube([5.75,25,2.5],center=true);
			}
		}
		difference() { //mounts for motor and bearing seat
			translate([-80,-115,24]) cube([15,30,20],center=true);
			translate([-80.5,-122,24]) rotate([0,90,0]) cylinder(h=40,r=3,center=true,$fn=50);
			translate([-80.5,-108,24]) rotate([0,90,0]) cylinder(h=40,r=3,center=true,$fn=50);
		}
	}
	difference() { //Mounting holes to connect both two sides together
		translate([-43.75,-115,0]) cube([7.5,30,60],center=true);
		translate([-32.5,-115,22.5]) rotate([0,90,0]) cylinder(h=40,r=3,center=true,$fn=50);
		translate([-32.5,-115,-22.5]) rotate([0,90,0]) cylinder(h=40,r=3,center=true,$fn=50);
	}
}


module inner_axis() {
	color("slateGrey") translate([40,-5,7]) rotate([0,-90,0]) cylinder(h=ia_st_rod_l, r=static_rod_r,$fn=50);
	color("slateGrey") translate([45,32.5,5]) rotate([0,-90,0]) cylinder(h=ia_dr_rod_l, r=2.5,$fn=50);
	translate([-30,32.5+slide_clearance_w,5]) rotate([180,90,0]) tbs_adj();
	translate([-25,-5,0]) sample_lin_bearing();
	//translate([-25,-8,0]) sample_arm();
	translate([-35,-5,0]) inner_axis_drive_mount();
	translate([-83.5,32.5+slide_clearance_w,5]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14,width=19);
	translate([-65,32.5+slide_clearance_w,5]) rotate([0,90,0]) coupler(coupler_dim, 2.5,2.5);
	translate([42.5,32.5,5]) rotate([0,90,0]) inner_axis_static_mount(16,2);
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
				//color("gold")translate([5,-51,-15]) cube([3,10,10],center=true);//nut
	difference() {
		union() { //Mount
			difference() {//Bearing Case 
				translate([-22.5,-57,-35]) cube([40,75+slide_clearance_w,50]);
				translate([-2,-27.5,2]) rotate([90,0,0]) cylinder(h=100, r=lin_bearing_or, center=true, $fn=50);
				translate([-2,-37.5,-15]) cylinder(h=50,r=static_rod_r+.5,center=true,$fn=100);
				translate([0,slide_clearance_w,-13]) cylinder(h=20,r=8,center=true,$fn=100);
				translate([-5,-49.5,22.5]) rotate([90,180,0]) cube([50,60,40],center=true);
				translate([-5,5.5,22.5]) rotate([90,180,0]) cube([50,60,40],center=true);
				translate([-2.5,-50,-15]) cube([1.5,20,45],center=true);//adj gap
				translate([-22,-50,-15]) cube([20,20,45],center=true);//cutout for easy screw access
				translate([5,-52.5,-13.5]) cube([3,13.7,13.7],center=true);//nut hole
				translate([-2.5,-50,-15]) rotate([0,90,0]) cylinder(h=60,r=screw_rad,center=true,$fn=50);//screw hole
			}
		}
	}
	difference() {
		translate([-30,-27.5,-21.25]) cube([27.5,15,27.5],center=true);//center drive mounting point
		translate([-32,-27,-15]) rotate([90,0,0]) cylinder(h=50,r=3,center=true,$fn=50);//screw holes
		translate([-32,-27,-28]) rotate([90,0,0]) cylinder(h=50,r=3,center=true,$fn=50);//screw holes
	}
	%translate([0,0,-11]) bearing(2.5,bearing_od/2);
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

module stepper_mount(height=27.5) {
	difference() {
		translate([-10,37.5,5]) cube([30,50,height],center=true);
		translate([6.5,37.5,0]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14.5,width=34);
		translate([-5,37.5,17.5]) cube([30,29,20],center=true);
		translate([-5,20.5,8]) rotate([0,90,0]) cylinder(h=21,r=1.75,center=true,$fn=100);
		translate([-5,54.5,8]) rotate([0,90,0]) cylinder(h=21,r=1.75,center=true,$fn=100);
		translate([-2,20.5,30]) cube([2.5,5.25,50],center=true);
		translate([-2,54.5,30]) cube([2.5,5.25,50],center=true);
	}
}

module lin_bearing_case(){
	difference() {
		translate([-65,-10,14.2]) cube([48,15,55],center=true);
		translate([-75,-10,0]) rotate([90,0,0]) cylinder(h=30,r=lin_bearing_or,center=true,$fn=50);
		translate([-80,-10,29.25]) cube([22,17,25],center=true);
		translate([-60,-10,30]) rotate([90,0,0]) cylinder(h=30,r=3,center=true,$fn=50);
		translate([-47,-10,30]) rotate([90,0,0]) cylinder(h=30,r=3,center=true,$fn=50);
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
