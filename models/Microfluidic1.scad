module mrMicro(){
	//block dimensions (use for shifting)
	x=14;
	y=10;
	z=7;
	depth=5; 
	difference(){
		cube([x,y,z], center =true);
		//translate([-x/2,0,0])cube([x,y,z], center =true);
		translate([.25*x,0,1])cylinder(r=.5,h=depth,$fn=50,center=true);
		translate([-.25*x,0,1])cylinder(r=.5,h=depth,$fn=50,center=true);
		translate([x/4-(x/16),0,-1.5+.15])cube([x/8+x/48,.6,.3],center=true);
		translate([(x/4-x/16),0,-1.5+.15])cube([x/8+x/48,.6,.3],center=true);
		translate([-(x/4-x/16),0,-1.5+.15])cube([x/8+x/48,.6,.3],center=true);
		translate([x*.125,0,-2.5])cube([.3,.6,z-depth],center=true);
		translate([-x*.125,0,-2.5])cube([.3,.6,z-depth],center=true);
		translate([0,0,-z/2+.15])cube([x*.25,.6,.3],center=true);
	}
	
	



} mrMicro();

//translate([])cube([])center=true;