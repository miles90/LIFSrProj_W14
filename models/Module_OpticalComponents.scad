/////////////////////////////////////////////////////////////////////////////
//
// Lens & lens cutout
//
/////////////////////////////////////////////////////////////////////////////

// Thorlabs plastic aspheric lens. Center at origin with light path through lens in +x direction
module LensType1(paddingt=0,paddingr=0,lenst=2.44,lensr=6.28/2){
  rotate(a=[0,90,0]) cylinder(h=lenst+paddingt,r=lensr+paddingr,center=true,$fn=50);
}

// Slot & cutout for LensType1
module LensType1_cutout(paddingt=0.2,paddingr=0.2,lenst=2.44,lensr=6.28/2,height=10,clearapertr=4.5/2,wallthick=3) {
  union() {
    translate([0,0,height/2]) cube(size=[lenst+paddingt,2*(lensr+paddingr),height],center=true);
    LensType1(paddingt,paddingr,lenst,lensr);
    rotate(a=[0,90,0]) cylinder(h=lenst+paddingt+2*wallthick,r=clearapertr,center=true,$fn=50);
  }
}

/////////////////////////////////////////////////////////////////////////////
//
// Servo Tray
//
/////////////////////////////////////////////////////////////////////////////
module ServoTray() {
	length = 36;
	height = 12;
	subBoxWidth = 2.2;
	innerLength = 24;
	
//	union() {
		difference() {
			cube([length+2,10,height+4],center=true);
			translate([0,4,4])
			cube([length,subBoxWidth,height], center=true);
			translate([0,-1,4])
			cube([innerLength,10,height], center=true);
			
//		}
		translate([(length/2)-4,0,3])
		rotate(a=[0,90,90])
		cylinder(h=12, r=1,center=true,$fn=60);
		translate([(-length/2)+3,0,3])
		rotate(a=[0,90,90])
		cylinder(h=12, r=1,center=true,$fn=60);
	}
}

//ServoTray();
/////////////////////////////////////////////////////////////////////////////
//
// ND filter & cutout
//
/////////////////////////////////////////////////////////////////////////////

module NDFilter(padding,padheight,pos=[0,0,0],d=12.7,t=1) {
  adjpos = [pos[0]+sqrt(2)*t/2,pos[1],pos[2]]; // adjust position for center of ND filter
  translate(adjpos) rotate(a=[0,0,-45]) {
    rotate(a=[0,90,0]) cylinder(h=t+padding,r=d/2+padheight,center=true,$fn=40);
  }
}

module NDFilter_cutout(padding,padheight,pos=[0,0,0],d=12.7,t=1) {
  adjpos = [pos[0]+sqrt(2)*t/2,pos[1],pos[2]]; // adjust position for center of ND filter
  translate(adjpos) rotate(a=[0,0,-45]) union() {
    rotate(a=[0,90,0]) cylinder(h=t+padding,r=d/2+padheight,center=true,$fn=40);
    translate([0,0,d/2]) cube([t+padding,d+2*padheight,10],center=true);
  }
}

/////////////////////////////////////////////////////////////////////////////
//
// Dichroic beam splitter
//
/////////////////////////////////////////////////////////////////////////////

module DichroicBeamSplitter(paddingt,paddingw,padheight,pos=[0,0,0],w=17.8,t=1.1,h=8.4) {
  adjpos = [pos[0]-sqrt(2)*t/2,pos[1],pos[2]+3.5]; // adjust position for center of ND filter. 3.5 for pedestal
  translate(adjpos) rotate(a=[0,0,-45]) {
    cube([t+paddingt,w+paddingw,h+padheight],center=true);
  }
}

/////////////////////////////////////////////////////////////////////////////
//
// Long pass filter
//
/////////////////////////////////////////////////////////////////////////////
module LPFilter_cutout(padding,padheight,pos=[0,0,0],d=12.5,t=2.0) {
  adjpos = [pos[0]+sqrt(2)*t/2,pos[1],pos[2]]; // adjust position for center of ND filter
  translate(adjpos) rotate(a=[0,0,90]) union() {
    rotate(a=[0,90,0]) cylinder(h=t+padding,r=d/2+padheight,center=true,$fn=40);
    translate([0,0,d/2]) cube([t+padding,d+2*padheight,10],center=true);
  }
}

/////////////////////////////////////////////////////////////////////////////
//
// Optical rail with ND filter, dichroic beam splitter, LP Filter, & lens
//
/////////////////////////////////////////////////////////////////////////////

module OpticalRail(size,oa,bpsize,ndfposition,dbsposition,lpfposition) {
  lenspadding = 0.3;
  difference () {
    translate([0,-size[1]/2,0]) cube(size); // initial block
    translate([-0.01,-bpsize[1]/2,size[2]-bpsize[2]+0.01]) cube(bpsize); // beam pathway
    translate([size[0]-(size[0]-bpsize[0])/2,0,oa]) LensType1_cutout(paddingt=2*lenspadding,paddingr=lenspadding,height=size[2]-oa+0.3,wallthick=(size[0]-bpsize[0])/2); // lens cutout
    NDFilter_cutout(0.5,0.5,pos=[ndfposition,0,oa]); // ND filter cutout
    LPFilter_cutout(0.5,0.5,pos=lpfposition); // LP filter cutout
    translate([ndfposition-bpsize[1]/2,0.1,size[2]-bpsize[2]]) cube([bpsize[1],size[1]/2,bpsize[2]+0.1]); // beam path to beam dump
    DichroicBeamSplitter(0.5,0.9,5,pos=[dbsposition,0,oa]); // dichroic beam splitter cutout
    translate([dbsposition+2.5-bpsize[1]/2,-size[1]/2-0.1+10,size[2]-bpsize[2]+5]) rotate(a=[90,0,0]) cylinder(h=10,r=2.5,$fn=40);
//cube([bpsize[1],size[1]/2,bpsize[2]+0.1]); // beam path to camera
    translate([dbsposition-bpsize[1]/2,+0.1,size[2]-bpsize[2]]) cube([bpsize[1],size[1]/2,bpsize[2]+0.1]); // beam opposite to camera
  }
}

/////////////////////////////////////////////////////////////////////////////
//
// Tray for camera-lens module
//
/////////////////////////////////////////////////////////////////////////////

module CameraTray(oa,clhoa,blocksize=[28,60,20],cutoutw=23.7) {
  traybaset = oa-clhoa;
  cutouth = blocksize[2]-traybaset;
  translate([2,-blocksize[1]/2,0]) {
  difference() {
//    translate([-2,0,blocksize[2]/2]) cube(size=blocksize,center=true);
    translate([-2,0,blocksize[2]/2]) cube(size=blocksize,center=true);
    translate([-0.1,-0.1,blocksize[2]-cutouth-5]) translate([-2.5,0,cutouth/2]) cube(size=[cutoutw+5,blocksize[1]+0.3,cutouth+0.1+10],center=true);
    }

	translate([0,-0.1,blocksize[2]-cutouth]) translate([-15,-26,-2]) {
		difference() {
			cube(size=[cutoutw,6,32]);

			translate([22,3,13]) rotate(a=[90,0,90]){
			rotate(a=[0,90,0]) cylinder(h=2.7,r=3.4,center=true,$fn=40);
//			translate([0,-18,0]) cube([2.7,36,6.8],center=true);
			translate([-5,0,0]) rotate(a=[0,90,0]) cylinder(h=10,r=2,$fn=40);
			}
		}
	}
  }
}

/////////////////////////////////////////////////////////////////////////////
//
// Laser & laser holder
//
/////////////////////////////////////////////////////////////////////////////

// Aixiz 5 mW laser in 8 x 30 mm housing
module Laser(lasdiam=8,laslength=30,paddingdiam=0,paddinglength=0) {
 rotate(a=[0,-90,0]) cylinder(h=laslength+paddinglength,r=(lasdiam+paddingdiam)/2,$fn=40); 
}

module LaserHolder(laserpos=[0,0,0],length=38,width=15,height=20,lasdiam=8,laslength=30,paddingdiam=0,paddinglength=0) { 
  holderrimoutert = 3;  // holder rim outer thickness
  holderriminnert = 4;  // holder rim inner thickness
  l1 = length-holderrimoutert;
  h1 = height-laserpos[2];
  l2 = laslength-2*holderriminnert;
  h2 = height-laserpos[2]+lasdiam/2+2;
  pos2 = [length-l2-holderrimoutert-holderriminnert,-0.1,height-h2];
  l3 = length-laslength-2*holderrimoutert;
  l4 = holderrimoutert;
  w4 = lasdiam-2;
  pos4 = [length-laslength-2*holderrimoutert-0.1,(width-w4)/2,height-h2];
  difference() { // create everything but laser cutout
    translate([laserpos[0]-(length-holderrimoutert),laserpos[1]-width/2,0]) {
      difference() { 
      cube(size=[length,width,height]); //begin with main block
      translate([-0.1,-0.1,laserpos[2]]) cube(size=[l1+0.1,width+0.2,h1+0.1]); // remove top part
      translate(pos2) cube([l2,width+0.2,h2]); // remove underneath laser
      translate([-0.1,-0.1,height-h2]) cube([l3+0.1,width+0.2,h2]); // remove behind laser
      translate(pos4) cube([l4+0.2,w4,height-h2]);
      translate([length-l4-0.1,width/2,laserpos[2]]) rotate(a=[0,90,0]) cylinder(h=l4+0.2,r=(lasdiam-1)/2,$fn=40); // hole for laser beam
      }
    } // move and add laser cutout
    translate(laserpos) Laser(lasdiam,laslength,0.3,0.4);
  }
}
