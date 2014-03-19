//Alignment of holes
hole_distance_x = 36;
hole_distance_y = 13;
hole_y_distance_x_from_one_end = 5;
hole_radius = 1;

block_width = 23;
block_depth = 85;
block_height = 6;

cylh = 4;
cylr = 3;//hole_radius*3;

module hole() {
	cylinder(r=hole_radius, h=block_height+cylh+2, center=true);
}

module reizer() {
	cylinder(r=cylr, h=cylh+block_height, center=true);
}

module block() {
	//cylinder();
	cube(size=[block_depth, block_width, block_height], center = true);
}

$fn=100;

//union() {
//	block();
//	translate([hole_distance_x/2,0,cylh/2]) reizer();
//	translate([-hole_distance_x/2,0,cylh/2]) reizer();
//	translate([hole_distance_x/2-hole_y_distance_x_from_one_end,hole_distance_y/2,cylh/2]) reizer();
//	translate([hole_distance_x/2-hole_y_distance_x_from_one_end,-hole_distance_y/2,cylh/2]) reizer();
//}

difference() {
	block();
	translate([hole_distance_x/2,0,cylh/2]) hole();
	translate([-hole_distance_x/2,0,cylh/2]) hole();
	translate([hole_distance_x/2-hole_y_distance_x_from_one_end,hole_distance_y/2,cylh/2]) hole();
	translate([hole_distance_x/2-hole_y_distance_x_from_one_end,-hole_distance_y/2,cylh/2]) hole();
	translate([0,0,0]) cube([32,10,10], center=true);
}

