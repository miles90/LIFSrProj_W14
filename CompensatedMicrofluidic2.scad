module mrMicro(){
	//block dimensions (use for shifting)
	slice=.101; // set this to whatever slice height you are doing
	base=12*slice;
	x=14;
	y=10;
	z=7+base;
	depth=5; 
	difference(){
		translate([0,0,-base])cube([x,y,z], center =true);
		//translate([-x/2,0,0])cube([x,y,z], center =true);
		translate([.25*x,0,1])cylinder(r=.5,h=depth,$fn=50,center=true);
		translate([-.25*x,0,1])cylinder(r=.5,h=depth,$fn=50,center=true);
		translate([x/4-(x/16),0,-1.5+.15])cube([x/8+x/48,.6,.3],center=true);
		translate([(x/4-x/16),0,-1.5+.15])cube([x/8+x/48,.6,.3],center=true);
		translate([-(x/4-x/16),0,-1.5+.15])cube([x/8+x/48,.6,.3],center=true);
		translate([x*.125,0,-2.5-base/2])cube([.3,.6,z-depth],center=true);
		translate([-x*.125,0,-2.5-base/2])cube([.3,.6,z-depth],center=true);
		translate([0,0,-z/2+.15-base])cube([x*.27,.6,.3],center=true);
		translate([0,0,-base-z/2])cube([x*.27,.6,base],center=true); //added to put hole in base layer
	}
	
	



} mrMicro();

//translate([])cube([])center=true;