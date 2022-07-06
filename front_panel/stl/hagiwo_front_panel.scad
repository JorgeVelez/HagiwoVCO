/*
 * Eurorack front panel, based on measurements from:
 *  http://www.doepfer.de/a100_man/a100m_e.htm
*/

// Resolution - higher = slower render.
$fn=48;

/* [Hidden] */
// Constant for 1U (rack unit) - leave unchanged
__oneU = 44.45;
// Constant for HP (horizontal pitch) - leave unchanged
__oneHP = 5.08;


/* [Panel Params] */

panelHeight = (3 * __oneU) - 4.85;  // 128.5, as per Doepfer guide

// 110mm typically gives a safe distance from rails (~9mm from top and bottom of panel)
panelInnerHeight = 110; // panelHeight - 18.5;

// Doepfer panels aren't exactly multiples of 1HP (5.08mm) but have some rounding (usually -0.3 mm tolerance, rounded to the nearest tenth of a millimeter)
panelWidth = 30.0; // [5.0:1HP, 9.80:2HP, 20.0:4HP, 30.0:6HP, 40.3:8HP, 50.5:10HP, 60.60:12HP, 70.8:14HP, 80.9:16HP, 91.3:18HP, 101.3:20HP, 106.3:21HP, 111.40:22HP, 141.90:28HP, 213.00:42HP]
panelThickness = 2.0;
hole_width = __oneHP + 2;
// Doepfer uses 7.5mm - can be less
hole_xinset = 7.5;
// Doepfer uses 3mm so holes line up with 3U rail spacing
// You shouldn't need to ever touch this unless your rails don't happen to be quite standard spacing.
hole_yinset = 3.0;   

m3_hole_loose_d=3.2;    // easy fit of M3 screw, non-tapping
m3_hole_tapping_d=2.95; // should engage screw thread

m3_r = (m3_hole_loose_d/2);

// Larger potentiometer hole radius - for a T18 knurled shaft (6mm diameter) metal Alpha pot, 3.9mm is a loose fit, can be attached with a nut.
potHoleRadius=3.9;

// Smaller potentiometer hole radius - 3.3mm is good for plastic RV09 style pots
potHoleRadiusSmall=3.3;

// 3.5mm jack hole radius. 3.25mm is a snug fit for a typical 'Thonkiconn' or simiar, secured with nut
socketRadius=3.25;

// Round LED hole - 2.65mm radius is a snug/tight fit for a 5mm LED. You may need to tune this for your specific LEDs if there is variation
ledRoundHoleWidth = 2.65;

// Square/rectangular LED hole, WxH - default is for a 5x2mm rectangular face [5.2, 2.2] is a little too tight without post-processing
ledSquareHole = [5.4, 2.4];

/* [PoCoBrick] */

// Units that may be compatible with your favorite plastic brick format
pocobrick_unit=1.6;
pocobrick_stud_height=1.8;

// Change by ~0.1mm increments to get better snap fit on studs
pocobrick_stud_diameter_tweak=0.0;
pocobrick_stud_d=(3*pocobrick_unit)+0.2 + pocobrick_stud_diameter_tweak;


module pocobrick_stud() {
    cylinder(d1=pocobrick_stud_d, d2=pocobrick_stud_d+0.1, h=pocobrick_stud_height, center=false, $fn=20);
}

module pocobrick_stud_array(pocobrickxdim, pocobrickydim) {
    for (ix=[0:pocobrickxdim-1]) {
        for (iy=[0:pocobrickydim-1]) {
            translate([ix*5*pocobrick_unit, iy*5*pocobrick_unit, 0]) pocobrick_stud();
        }
    }
}

// Round HP values to Doepfer panel widths in mm
function hp_to_mm_width (hp) = floor(((hp*__oneHP)-0.3)*10)/10;

module mountingHole(depth=panelThickness, hole_width=hole_width) {
    hw = (hole_width/2)-m3_r;
    echo(hw, hole_width, m3_r);
    linear_extrude(height = (depth*2)+0.01, 
                   center = true) {
        translate([0, hw, 0]) {
            circle(r = m3_r);
        }
        translate([0, -hw, 0]) {
            circle(r = m3_r);
        }
        square([m3_hole_loose_d, hw*2], center=true);
    }
}

// inset_topbottom should generally be 10mm or more to safely clear the rails
module reinforcementRails(w=3, depth=2, inset_sides=2) {
    inset_topbottom = (panelHeight - panelInnerHeight) / 2;
    translate([0, 0, -panelThickness]) {
        translate([inset_topbottom, inset_sides, 0]) {
            cube([panelHeight-(inset_topbottom*2), w, depth]);
        }
        translate([inset_topbottom, panelWidth-(inset_sides+w), 0]) {
            cube([panelHeight-(inset_topbottom*2), w, depth]);
        }
    }
}

module pcbMounts() {
    // PCB mounting standoffs with holes for M2 screws 
    // - inset 2mm from edge (holes 25.5 mm apart along Y)
    // - 67.6mm apart vertically along X
    mountWidth=(panelWidth/4)+2;
    mountHeight=30;
    mountThickness=6;
    vSpacing=67.6;
    hSpacing=25.5;
    holeInset=2;
    vOffset=82;
    // M2 screw hole with clearance hole at top, tapping toward bottom
    holeDbottom=1.8;
    holeDtop=2.2;
    difference() {
        translate([0, 0, panelThickness]) {
            translate([vOffset-vSpacing, 0, 0]) {
                cube([mountThickness, mountWidth, mountHeight]);
            }
            translate([vOffset, 0, 0]) {
                cube([mountThickness, mountWidth, mountHeight]);
            }
            translate([vOffset, panelWidth-mountWidth, 0]) {
                cube([mountThickness, mountWidth, mountHeight]);
            }
        }
        translate([vOffset-vSpacing+(mountThickness/2), holeInset, (mountHeight/2)+1]) {
            cylinder(d1=holeDbottom, d2=holeDtop, h=mountHeight, center=false, $fn=20);
        }
        translate([vOffset+(mountThickness/2), holeInset, (mountHeight/2)+1]) {
            cylinder(d1=holeDbottom, d2=holeDtop, h=mountHeight, center=false, $fn=20);
        }
        translate([vOffset+(mountThickness/2), 
                   holeInset+hSpacing,
                   (mountHeight/2)+1]) {
            cylinder(d1=holeDbottom, d2=holeDtop, h=mountHeight, center=false, $fn=20);
        }
    }
}

module frontPanel(width, height, thickness, n_holes=2, hole_width=hole_width) {
  difference() {
    union() {
        cube([width, height, thickness]);
        //reinforcementRails();
        pcbMounts();
    }
    
    // Screw holes top and bottom
    translate([hole_yinset, hole_xinset+m3_r, 0]) {
        mountingHole(panelThickness, hole_width);
    }
    translate([panelHeight - hole_yinset, panelWidth - hole_xinset - m3_r, 0]) {
        mountingHole(panelThickness, hole_width);
    }
    
    panelHoles();
  }
}

module trimmerPotHole() {
    linear_extrude(height = (panelThickness*2)+0.01, 
                   center = true) {
            circle(r = potHoleRadiusSmall);
    }
}

module potHole() {
    linear_extrude(height = (panelThickness*2)+0.01, 
                   center = true) {
            circle(r = potHoleRadius);
    }
}

module jackHole() {
        linear_extrude(height = (panelThickness*2)+0.01, 
                   center = true) {
            circle(r = socketRadius);
        }
}

module LED5mmHole() {
        linear_extrude(height = (panelThickness*2)+0.01, 
                   center = true) {
            circle(r = ledRoundHoleWidth);
        }
}

// Mode toggle momentary button has a ~6mm diameter metal thread 
// with nut (similar to Philips PBS-110, or maybe Shin Chin R13-24A).
module buttonHolePBS110() {
    buttonHolePBS110_radius = (6.5 + 1)/2;
    linear_extrude(height = (panelThickness*2)+0.01, 
                   center = true) {
        circle(r = buttonHolePBS110_radius);
    }
}

module panelHoles() {
    translate([17.7, panelWidth-9.0, 0]) potHole();
    translate([33.3, 9.0, 0]) potHole();
    translate([49.0, panelWidth-9.0, 0]) potHole();
    translate([64.5, 9.0, 0]) potHole();
    
    translate([panelHeight-64.5, panelWidth-7.6, 0]) buttonHolePBS110();

    translate([panelHeight-16.2-16.3-15.7, 
               panelWidth - (panelWidth/2), 
               0]) {
        LED5mmHole();
    }
    
    
    translate([panelHeight-16.2-16.3, 5.1, 0]) jackHole();
    translate([panelHeight-16.2-16.3, panelWidth/2, 0]) jackHole();
    translate([panelHeight-16.2-16.3, panelWidth-5.1, 0]) jackHole();
    
    translate([panelHeight-16.2, 5.1, 0]) jackHole();
    translate([panelHeight-16.2, panelWidth/2, 0]) jackHole();
    translate([panelHeight-16.2, panelWidth-5.1, 0]) jackHole();
}

frontPanel(panelHeight, panelWidth, panelThickness);

