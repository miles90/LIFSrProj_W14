 	use <../../sample_stage/slide_translation1.scad>
use <../../../trayContainer.scad>

translate([0,20,0]) sample_arm();
rotate([90,0,180]) translate([-2.5,-10.5,-27]) trayContainer();