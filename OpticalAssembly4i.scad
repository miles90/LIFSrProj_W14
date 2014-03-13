

/*
    Adjust parameters:
    - Wider optical rail (from 15 to 17 mm)
    - Wider DBS slot (0.5 to 0.9 mm)
    - Smaller lens slot (lenspadding from 0.5 to 0.3 mm)
    - Wider ledges for laser holder (from 2 to 4 mm)
    - Beam dump for DBS reflection! (just add a 2nd beam dump & don't worry about overlap
*/

use <Writescad/write.scad>;
use <Module_OpticalComponents.scad>;
use <ccd.scad>;

datestr = "10/11/13";
color_OpticalComponent = "LightBlue";


///////////////////////////////////
//
//  Parameter definitions
//
//////////////////////////////////

// Basic geometry parameters for optical axis and optical rail
oa = 15;  // optical axis, height from bottom of optical assembly
bpw = 5;  // beam passageway width
bph = 10; // beam passageway height
orh = oa + bph/2;  // optical rail height
orb = oa - bph/2;  // height of bottom of beam passageway
orl = 30;  //  optical rail length (laser holder-to-lens holder edge)
orw = 23;  // optical rail width
orsize = [orl,orw,orh];  // size of optical rail block
lht = 6;  // lens holder thickness
bpl = orl-lht;
bpsize = [bpl,bpw,bph];  // size of beam passageway

// Lens parameters
ld = 6.28;  // lens diameter
lr = ld/2;  // lens radius
lt = 2.44;  // lens thickness
lfl = 10.92;  // lens focal length
lhd = 4.6;  // lens hole diameter for lenses, etc.

// Laser
LaserDiameter = 8;
LaserLength = 30;
LaserPosition = [-3,0,oa]; // laser position taking into account thickness of flange it rests against
LaserSepFromBase = 2;  // height of laser above base

// 1/2" round ND filter parameters
ndfd = 12.7;  // diameter
ndft = 1.0;  // thickness
ndfposoa = 6;  // position of front face of ND filter on optical axis
ndfpos = [ndfposoa,0,oa];

// Long pass filter parameters
lpfd = 12.5;  // diameter
lpft = 2.0;  // thickness
lpfpos = [20,-9,oa-2];

// Measured camera-lens holder size
camlensw = 30.8;
camlensh = 20.2;
clhoa = 8.2+2.7; // optical axis height of camera from bottom of camera-lens holder
traypaddingw = 0.2;
traypaddingh = 0.2;

// Camera-lens tray dimensions
trayw = 37;
trayl = 52;
trayh = orh*2.5;
TraySize = [trayw,trayl,trayh];

// Dichroic beamsplitter parameters
dbsw = 17.8;  // width
dbst = 1.1;  // thickness
dbsh = 8.4;  // height
dbsposoa = 21.5;  // position of front face of DBS on optical axis
dbspos = [dbsposoa,0,oa-(orh-orb-dbsh)/2];

// Beam dump parameters
bdl = 36;
bdw = 25;
bdh = orh;
bdsize = [bdl,bdw,bdh];
bdspherer = 8;
bdholer = 2.5;

// Basic geometry parameters for base stand
baset = 2;  // base thickness
basew = bdw+orw+trayl;  // base width
baseh = 40+35;  // base height
BaseSize = [baset,basew,baseh];


///////////////////////////////////
//
//  Modules
//
//////////////////////////////////


module BeamDump2(oa,bdsize=[50,22,20],sphererad,holerad,posx1,posx2,posy) {
  $fn=40;
  separation = posx2-posx1;
  offset = 2;
  translate([posx1,posy+bdsize[1]/2,bdsize[2]/2]) difference() {
    translate([separation/2-offset,0,0]) cube(size=bdsize,center=true);
    #translate([-offset,0,0]) sphere(r=sphererad,center=true);
    #translate([0,0,oa-bdsize[2]/2]) rotate(a=[90,0,0]) cylinder(h=bdsize[1]/2+0.1,r=holerad);
    #translate([separation-offset,0,0]) sphere(r=sphererad,center=true);
    #translate([separation,0,oa-bdsize[2]/2]) rotate(a=[90,0,0]) cylinder(h=bdsize[1]/2+0.1,r=holerad);
    // Uncomment to look into spherical void
//    translate([separation/2-offset,0,oa]) cube(size=bdsize,center=true);
  }
}

module BeamDump(oa,bdsize=[22,22,20],sphererad,holerad,posx,posy) {
  $fn=40;
  translate([posx,posy+bdsize[1]/2,bdsize[2]/2]) difference() {
    cube(size=bdsize,center=true);
    #sphere(r=sphererad,center=true);
    #translate([0,0,oa-bdsize[2]/2]) rotate(a=[90,0,0]) cylinder(h=bdsize[1]/2+0.1,r=holerad);
    // Uncomment to look into spherical void
    translate([0,0,oa]) cube(size=bdsize,center=true);
  }
}

module BaseStand(bsize=[10,10,10],posx,posy) {
  rotate([0,90,0])
  translate([-1,posy,-8]) 
	cube(size=bsize,center=true);
}

rad = 7;
l1 = 57.68;
h1 = 15;
l2 = 40.48;
lz1 = 62.2;
hz1 = 34.84;
lz2 = 45;
hz2 = 32;
hz3 = 18;

///////////////////////////////////
//
//  Main Program
//
//////////////////////////////////

//opticalbeam();
//color(color_OpticalComponent) {translate(ndfpos) NDFilter(0,0); translate([orl-(orl-bpl)/2,0,oa]) LensType1(); DichroicBeamSplitter(0,0,pos=dbspos); translate(LaserPosition) Laser();}
module lightBlock() {
	translate([14,-10.8,26]) cube([32,1.4,14], center=true);
}

module servoHolder() {
	difference() {
		rotate([0,0,180]) import("/Users/zaphinath/ownCloud/ee490/w2014OPTIC/soposer.stl", convexity = 5);
		translate([-60,-95,2]) cube([10,10,10], center=true);
		translate([-105,-95,2]) cube([10,12,10], center=true);
		translate([-80,-80,0]) cube([60,50,2], center=true);
	}
}
difference() {
union() {
  lightBlock();
  LaserHolder(LaserPosition,width=orw);
  OpticalRail(orsize,oa,bpsize,ndfposoa,dbsposoa,lpfpos);
  translate([dbsposoa-10,-orw/2,0]) CameraTray(oa,clhoa,TraySize,camlensw+traypaddingw);
  BeamDump2(oa,bdsize,bdspherer,bdholer,ndfposoa,dbsposoa,orw/2);
  BaseStand(BaseSize,-40,-(basew/2-orw/2-bdw));
  translate([55,55,-1]) servoHolder();

//  rotate ([90,0,-90]) translate([27,17,-19]) ccd();
  
//  translate([-40,-(basew-orw/2-bdw),0]) cube(size=[43,10,baseh]);
//  translate([-40,-(basew-orw/2-bdw)/2,0]) cube(size=[43,10,baseh]);
}
  translate([-46,-15,2]) cube([40,30,15]);
  translate([-10,30,0]) cylinder(r=2.2, h=8, center=true, $fn=60);
  translate([-10,-60,0]) cylinder(r=2.2, h=8, center=true, $fn=60);
  rotate(a=[90,0,90]) translate([-61,-2,20]) cube([2.7,36,6.8],center=true);
  translate([20,-61,10]) cylinder(h=100,r=.5,center=true);
}
//  BeamDump(oa,bdsize,bdspherer,bdholer,dbsposoa,orw/2);

// Comment out following commands before creating stl file
//{ color("Blue") DichroicBeamSplitter(0); color("Blue") NDFilter(0,0); opticalbeam(); translate([orl-lht/2,0,0]) lens(); color("Blue") laser(LaserDiameter,LaserLength,0,0); color("Blue") translate([0,-camblockw/2-orw/2,0]) CameraBoard(0,0,0);}

