module stepper_motor(shaft=2.5,radius=14,width=19) {
	translate([0,-9.5,-8]) stepper_motor_model(shaft,radius,width);
}

module stepper_motor_model(shaft=2.5, radius=14, width=19) {
	color("yellow") translate([0,10,8]) rotate([0,90,90]) motor_shaft(shaft, (shaft*2)-1);
	screw_hole_pos = radius;
	union(){
		rotate([0,90,90]) cylinder(h=width, r=radius, center=true, $fn=100);
		translate([screw_hole_pos,(width-1)/2,0]) rotate([90,0,180]) motor_screw_hole();
		translate([-screw_hole_pos,(width-1)/2,0]) rotate([90,180,180]) motor_screw_hole();
		translate([0,0,-radius]) cube([20,15,width], center=true);
	}

	module motor_shaft(shaft_radius,base_radius) {
		union(){
			cylinder(h=10,r=shaft_radius,center=10,$fn=100);
			cylinder(h=1.5,r=base_radius,center=true,$fn=100);
		}
	}

	module motor_screw_hole(inner_rad=2, outer_rad=3.5, thickness=1) {
		translate([-2.5,0,0])
		union(){
			difference() {
				cylinder(h=thickness,r=outer_rad,center=true, $fn=100);
				cylinder(h=thickness+2,r=inner_rad,center=true, $fn=100);
			}
			difference() {
				translate([1,0,0]) cube([outer_rad,outer_rad*2,thickness], center=true);
				cylinder(h=thickness+2,r=inner_rad,center=true, $fn=100);
			}
		}
	}
}

module screw_hole(inner_rad=1,outer_rad=1.75,thickness=1) {
	union(){
		difference() {
			cylinder(h=thickness,r=outer_rad,center=true, $fn=100);
			cylinder(h=thickness+2,r=inner_rad,center=true, $fn=100);
		}
		difference() {
			translate([1,0,0]) cube([outer_rad,outer_rad*2,thickness], center=true);
			cylinder(h=thickness+2,r=inner_rad,center=true, $fn=100);
		}
	}
}
