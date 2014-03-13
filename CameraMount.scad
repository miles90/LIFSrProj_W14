// Base with inset for camera PCB
w = 20.4;		// Camera PCB Width
h = 28.6;		// Camera PCB Height
d = 5;			// Camera PCB Depth
fenceW = 3;	// 2 x width of the fence around inset PCB

translate([-(w + fenceW)/2, -(h+fenceW)/2+1.2, 0])
difference() {
	cube(size=[w+fenceW, h, d]);
	translate([fenceW/2, fenceW/2-1.5, fenceW/2]) cube(size=[w, h, d]);
}

// Posts aligned with screw holes
postRad = 0.9;	// Post radius
postSepX = 16.8;	// X distance between posts
postSepY = 24.9;	// Y distance between posts

translate([postSepX/2,postSepY/2,0]) cylinder(h=d,r=postRad,$fn=20);		//Post 1
translate([-postSepX/2,postSepY/2,0]) cylinder(h=d,r=postRad,$fn=20);		//Post 2
translate([postSepX/2,-postSepY/2,0]) cylinder(h=d,r=postRad,$fn=20);		//Post 3
translate([-postSepX/2,-postSepY/2,0]) cylinder(h=d,r=postRad,$fn=20);	//Post 4