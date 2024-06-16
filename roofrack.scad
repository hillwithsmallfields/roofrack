/* Dimensions in millimetres */

box = 19;
outer_width = 1470;
inner_half_width = outer_width/2 - box;

length = 3000;

sections = 6;

section_length = length/sections;

roof_front = 1500;
standing_sections = roof_front/section_length;

rack_height = 170;              /* from top to bottom of roofrack inclusive */

leg_height_total = 420;         /* from gutter to top of roofrack */

cantilever_strut_position = length/4;

pole_height = 1400;

module longitudinal(beamlen) {
     cube([beamlen, box, box]);
}

module transverse(beamlen) {
     cube([box, beamlen, box]);
}

module upright(beamlen) {
     cube([box, box, beamlen]);
}

module standing() {
     for (flip=[1,-1]) {
          scale([1, flip, 1]) {
               translate([0, -inner_half_width, 0]) {
                    transverse(inner_half_width);
                    translate([0, 0, rack_height-leg_height_total]) upright(leg_height_total);
               }
          }
     }
}

module floating() {
     for (flip=[1,-1]) {
          scale([1, flip, 1]) {
               translate([0, -inner_half_width, 0]) {
                    transverse(inner_half_width);
                    upright(rack_height);
               }
          }
     }
}

module roofrack() {
     for (section=[0:1:sections]) {
          translate([section*section_length, 0, 0]) {
               if (section<=standing_sections) {
                    standing();
               } else {
                    floating();
               }
          }
     }
     translate([0, -box/2, 0]) longitudinal(length);
     for (flip=[1,-1]) {
          scale([1, flip, 1]) {
               translate([0, -inner_half_width/2, 0]) longitudinal(length);
               translate([0, -inner_half_width, 0]) {
                    longitudinal(length);
                    translate([0, 0, rack_height-box]) longitudinal(length);
               }
          }
     }
}

roofrack();
