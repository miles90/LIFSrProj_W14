use <write/Write.scad>
/*

This file had been created by Tim Chandler a.k.a. 2n2r5 and is
being shared under the creative commons - attribution license.
Any and all icons, references to 2n2r5.com, 2n2r5.net, Tim
Chandler ,2n2r5 or Trademarks must remain in the the end product.
This script is free to use for any and all purposes, both
commercial and non-commercial provided that the above conditions
are met.


Please refer to http://creativecommons.org/licenses/by/3.0/
for more information on this license.
*/

/*

*** Script created by: Tim Chandler (2n2r5)
*** Modified by Dani Furrer

Filename: threadless_ball_screw.scad
Date of Creation: 7/26/13		(Tim Chandler)
...
...
Last modification: 10/11/13 	(Dani Furrer)

*** Description:
The original Scipt (Tim Chandler) created a customizable version of thing:112718. Tne modified version (Dani Furrer) creates only the essential geometry for the threadless ballscrew (bearing mounts with precise angles), all the other modifications were done in tinkercad. 
Result here thing: 

*** To be done:
- More Testing, if parameters are correct.
- Clean up the code, delete unused stuf.

*** Customize Your part here:

/* [Base Shape and Size] */
Base_Height = 15;		// Height of Base 
Box_Y_Width = 45;		// Y width of Base
Box_X_Width = 40;		// X width of Base
Bed_Hole_Size = 10;		// Bed Hole Size, greater than rod!
Base_Shape= "box"; 		// ["round":Round,"box":Box] 

/* [Bearing & Smooth Rod Options] */
Smooth_Rod_Diameter = 5 ; 		// [mm] Rod Diameter
Bearing_Pitch = 2 ; 				// MM lead per rotation?
Reverse_Thread = "no" ; 			// ["yes"/"no"] Reverse Direction
// Snug: Use this to move the bearing in to create a tight fit
snug = 0; 						// [.05,.1,.15,.2,.25,.3,.35,.4]
// Tilt: Makes bearing tilt by X degrees inward or outward
Bearing_Tilt = 0 ; 				// [-5:5]

/* [Bearing & Smooth Rod Options] */
Bearing_Outer_Diameter = 16 ; 	// Bearing Outer Diameter
Bearing_Inner_Diameter = 5.25 ; 		// Bearing Inner Diameter
Bearing_Width = 5 ;				// Bearing Width ;
Number_of_Bearings = 3; 			// Number of Bearings
Bearing_Nut_Size = 9; 			// Nut Size: [9:M5, 8:M4,6.3:M3]




/* ----- other (unused??) options... need to cleanup here ---- */
//Use this to rotate the bearings if they are not in a friendly place
Bearing_Rotation_Adjustment = 0;
//Screw Length
Screw_Length = 15;


/* [Mounting Options] */
//Which bed type? Other will only give a custom 4 hole option.
Solidoodle_Bed_Type = "other" ; //[aluminum, wood, other]
// ---------------- "Other" Platform Options -----------
//Distance Between mounting holes from center
Other_Bed_Mounting = 17 ;
//Mounting screw size (M3 is standard)
Mount_Screw_Size = 3 ;// [3:M3,4:M4,5:M5]
//Bed mounting screw hole depth
Bed_Mounting_Hole_Depth = 30 ;

/* [Global] */
//Show Text Summary
text = "true" ; //[true,false]


/* ------------------- Rookie Line (Do not cross unless you know what you are doing) --------------------- */

/* [hidden] */

/* Variable Clean-up (makes pretty variables usable) */

BaseShape = Base_Shape	;
mss = Mount_Screw_Size	;
sdbt = Solidoodle_Bed_Type;
mhd = Bed_Mounting_Hole_Depth;
bh = Base_Height		;
bic = Bearing_Incut	;
bhs = Bed_Hole_Size		;
byw = Box_Y_Width		;
bxw = Box_X_Width		;
bwr = Round_Base_Width	;
bod = Bearing_Outer_Diameter;
bid = Bearing_Inner_Diameter;
bw = Bearing_Width		;
nob = Number_of_Bearings;
bnd = Bearing_Nut_Size	;
srd = Smooth_Rod_Diameter;
rotAdj = Bearing_Rotation_Adjustment;
pitch = Bearing_Pitch	;
obmx = Other_Bed_Mounting ;
rt = Reverse_Thread;
bt = Bearing_Tilt		;
sl = Screw_Length		;
//Mounting holes 
mhfc = [[ -12.5,7.5,-(bh-mhd)/2 ],[ -12.5,-7.5,-(bh-mhd)/2 ],[ 12.5,7.5,-(bh-mhd)/2],[12.5,-7.5,-(bh-mhd)/2 ]] ; 						

// [[ -12.5,7.5,-(bh-mhd)/2 ],[ -12.5,-7.5,-(bh-mhd)/2 ],[ 12.5,7.5,-(bh-mhd)/2 ],[12.5,-7.5,-(bh-mhd)/2 ]]   <--Use this for Aluminum Bed
mhfcw = [[ -8,8,-(bh-mhd)/2 ],[ -8,-8,-(bh-mhd)/2 ],[ 8,8,-(bh-mhd)/2 ],[8,-8,-(bh-mhd)/2 ]]; // <-- Use this for Wood Bed 

//Mounting holes for bed type not Solidoodle
//mhfco = [[ -obmx,obmy,-(bh-mhd)/2 ],[ -obmx,-obmy,-(bh-mhd)/2 ],[ obmx,obmy,-(bh-mhd)/2 ],[obmx,-obmy,-(bh-mhd)/2 ]]; // This defines the "other" bed type option

//simplify base size
base = [bxw,byw,bh];

//simplify bearing
bsize = [bod/2,bid/2,bw];

//bearing mounting angle to get desired pitch
bma = round(atan(pitch / (srd * 3.141592 ))*10)/10; //Use round(var*10)/10 to round the angle down to the nearest 10th

//X distance from center of bearing
//bdfc = cos(bma)*(bod/2);

// nr. of segments for full circle
$fn=60;



echo (str("The bearing angle will be set to ", bma ," degrees."));
angleNotify = str("Bearing Angle = ", bma ," degrees");
pitchNotify = str("Pitch = ", pitch ," MM Per Rotation");
bearingSize = str("Bearing Dimensions = ",bid,":",bod,":",bw);
rtNotify = str("Reverse Thread?  ", rt );
//echo ("Bearing is " , bdfc , "Horizontally from edge.");
echo (snug);





				/* ------------- End Variables and Start Shapes Below ---------------*/

/*

			In the interest of making this script easily adaptable,
			all main shapes will be separate modules will be put
			together at the bottom of this script.

*/
/* --- This is the on-screen info Graphic since there is no option for Echo output in customizer --- */
if (text=="true"){
%color("red")
rotate([10,0,-140]){
translate([0,30,3])
rotate ([90,0,180]){
write(angleNotify,h=2,t=1,font="write/orbitron.dxf",center=true);
translate([0,3,0])
write(pitchNotify,h=2,t=1,font="write/orbitron.dxf",center=true);
translate([0,6,0])
write(bearingSize,h=2,t=1,font="write/orbitron.dxf",center=true);
translate([0,-3,0])
write(rtNotify,h=2,t=1,font="write/orbitron.dxf",center=true);
}
} } else {

}


// This builds the basic shape of the bearing For refrence and cutouts
module Bearing (bigd,smalld,bbwidth) {
	difference(){
		cylinder(r=bigd,h=bbwidth);
		%cylinder(r=smalld,h=bbwidth);
	}
}

//Main body of the nut.This acts as the Adapter between the bearing mounts and the bed mounts
module Base(){
	difference(){

		union(){
			if(BaseShape=="round"){
				cylinder(r=bwr/2,h=bh,center=true);
			} else if (BaseShape=="box"){
				translate([3,0,-bh/2]) cube(base,center=true); // base top at z=0
			} else if (BaseShape=="yourShapeHere"){
				//More shapes can be added here
			}
		}

		union(){

			//Start mounting screw cutouts here
			if (sdbt=="aluminum") {
				for(i=mhfc) {
					translate(i) {
						cylinder(r=mss/2, h=mhd, center=true);
					}		
				}
			} else if (sdbt=="wood") {
				for(g=mhfcw) {
					translate(g) {
						cylinder(r=mss/2, h=mhd, center=true);
					}		
				}
			} else if (sdbt=="other") { //This is where the "other" bed type mounting screw cutouts are.
					// add 20% to hole diameter, first hole extra big for tightening gap
//					rotate(0,[0,0,1]) translate([obmx,0,0]) cylinder(r=mss*1.2/2+0.5, h=mhd, center=true);
//					rotate(120,[0,0,1]) translate([obmx,0,0]) cylinder(r=mss*1.2/2, h=mhd, center=true);
//					rotate(240,[0,0,1]) translate([obmx,0,0]) cylinder(r=mss*1.2/2, h=mhd, center=true);
			}
			//Hole for smooth rod
			%cylinder(r=(srd/2)*1.0,h=100,center=true); //This shows the smooth rod that the bearings will be spaced for.
			translate([0,0,-bh/2]) cylinder(r=bhs/2, h=1.2*bh,center=true );  //This is the actual hole cut.

		}
	}
}


/* Bearing mounts are all made positive and will be subtracted from base */
module bearingMounts(){
	
// --------------- ***** For anything that will be used in a rotational translate loop (I.E. bearing cut out, mounting screw, mounting nut) ****** ----------- //
	for (j= [0:nob]) {
//	for (j= [0:0]) {

		if (rt=="yes") { //"Reverse Thread" option
			rotate([-bma,bt,j*360/nob+rotAdj]) translate([(srd/2)+bdfc-snug,0,bh/2-bic]){  //snug is used to apply force between the bearing and the smooth rod
		
			#Bearing(bod/2*(1.10),bid/2,bw); //Main Bearings as defined in bearing module plus 10% to keep slack around the bearing
			translate([0,0,-bh/2])cylinder(r=bid/2,h=bh,center=true); //Shaft for bolt/screw to hold the bearing
			translate([0,0,-bh+bnd/3])cylinder(r=bnd*1.15/2,h=bh/2,$fn=6,center=true); //Retainer for nut bearing bolt, plus 15% to keep slack
		}
		}  else if (rt=="no") { //"Regular Thread" option
//			rotate([bma,bt,j*360/nob+rotAdj]) translate([(srd/2)+bdfc-snug,0,bh/2-bic]){ 
//			rotate([bma,bt,j*360/nob+rotAdj]) translate([(srd/2)+bdfc-snug,0,bw/2]){ 
			translate([0,0,bw/2-sin(bma)*bod/2]) 
			rotate([bma,0,j*360/nob+rotAdj])
			translate([(srd/2)+bod/2-snug,0,0]){ 

//			%Bearing(bod/2*(1.00),bid/2,bw); //Main Bearings in actual size

			translate([0,0,-bw/2]) %Bearing(bod/2,bid/2,bw); //Main Bearings in actual size
			translate([0,0,-bw/2]) Bearing(1.10*bod/2,bid/2,bw); //Main Bearings plus 10% to keepout around the bearing
			translate([0,0,-0.5*bh]) #cylinder(r=bid/2,h=2*bh,center=true); //Shaft for bolt/screw to hold the bearing
// cutouts from the bottom side
			#translate([0,0,-bh-bw+0.3*bnd]) #cylinder(r=bnd*1.15/2,h=0.8*bnd,$fn=6,center=false); //Retainer for nut bearing bolt, plus 10% to keep slack

			//%translate([0,0,-bh-bw+2*bic])Bearing(bod/2*(1.00),bid/2,bw); //Main Bearings in actual size
			//#translate([0,0,-bh-bw+2*bic])Bearing(bod/2*(1.10),bid/2,bw); //Main Bearings as defined in bearing module plus 

			}
			translate([0,0,bw/2-sin(bma)*bod/2]) 
			rotate([bma,0,j*360/nob+rotAdj])
//			rotate([bma,0,rotAdj])
			translate([(srd/2)+bod/2-snug,0,0]){ 
				#translate([10,0,-bh-bw+0.7*bnd]) #cube([20,bnd*1.0,0.8*bnd],center=true); // Slot for inserting nut
			}

		}
	}
}

/* Cut the object into two halfs -> this is the support frame! */
module cutBase(){
	#cube([bwr,bwr,fh],center=true);
}

// Part assembly starts here
difference(){
	Base();
	bearingMounts();
	//translate([0,0,-2*bh]) rotate([180,0,0]) bearingMounts();;
}


