t = 2.5;
od = 25;
d1 = 16;
h1 = 8;
d2 = 10;
h2 = 10;
h = 100;
id = 2;
sr = od/2 - t;
fn = 80;
ld = 6;
lh = 4;
fl = 18.15;
packageH = 3.25;
ch = h1+h2+fl-packageH;
pw = 12.5;

*difference(){
	union(){
		cylinder(r = od/2, h=h, $fn=fn);
		cylinder(r=od*2/3,h=sr*2+t);
	}
	cylinder(r = id/2, h= h+h1+h2, $fn=fn);
	translate([sr/3,sr/3,sr+t]) sphere(r=sr,$fn=fn);
	translate([0,0,h-h1]) cylinder(r = d1/2+.3, h=h1, $fn=fn);
	cylinder(r=2,h=10,$fn=fn);
}
*difference(){
union(){
	cylinder(r = d1/2, h= 2*h1, $fn=fn);
	translate([0,0,h1*2]) cylinder(r = d2/2-.1, h= h2, $fn=fn);
}
cylinder(r = id/2, h= h+h1+h2, $fn=fn);
}

 
rotate(90,[1,0,0]) difference(){
	union(){
		translate([0,0,ch/2]) cube([d1,d1-.6,ch],center=true);
		translate([0,0,-h1]) cylinder(r = d1/2-.3, h= 2*h1, $fn=fn);
	}
	translate([0,0,h1+h2]) union(){
		cylinder(r=ld/2+.25, h=lh+.5,$fn=fn);
		translate([-(ld/2+.25),0,0]) cube([ld+.5,d1/2,lh+.5]);
		translate([0,0,lh/2+.25]) rotate([90,0,0]) cylinder(r=.5,h=d1/2,$fn=20);
	}
	translate([0,0,h1+h2+lh]) cylinder(r=ld/3,h=fl,$fn=fn);
	translate([0,0,-h1]) cylinder(r=id/2,h=ch+h1, $fn=fn);
	translate([-pw/2,-d1/2,ch-t]) cube([pw,d1,t]);
}

