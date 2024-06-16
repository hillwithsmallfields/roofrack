/* Dimensions in millimetres */

/* roofrack dimensions */

shim = 3;

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

/* ladder dimensions */

ladder_height = 3000;
ladder_width = 410;             /* from a web advert */
ladder_rail_depth = 60;
ladder_rail_width = 20;
ladder_rung_diameter = 35;
ladder_rung_radius = ladder_rung_diameter/2;

ladder_rungs = 9;
ladder_rung_spacing = ladder_height / (ladder_rungs - 1);

ladder_cutout_width = ladder_width + box*2;

/* parts */

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

module floating(gapped) {
     /* the halves of this are not indentical, so we can't just flip
      * half of it like the standing ones. */
     translate([0, -inner_half_width, 0]) {
          transverse(inner_half_width);
          upright(rack_height);
     }
     translate([0, inner_half_width-box, 0]) {
          upright(rack_height);
     }
     transverse(inner_half_width - (gapped ? ladder_cutout_width : 0));
}


module ladder_rail () {
     cube([ladder_height, ladder_rail_width, ladder_rail_depth]);
}

module ladder_rung() {
     translate([0, 0, ladder_rail_depth/2]) rotate([-90, 0, 0]) cylinder(ladder_width, ladder_rung_radius, ladder_rung_radius);
}

/* assemblies */

module roofrack() {
     for (section=[0:1:sections]) {
          translate([section*section_length, 0, 0]) {
               if (section<=standing_sections) {
                    standing();
               } else {
                    floating(section>sections-2);
               }
          }
     }
     translate([0, -box/2, 0]) longitudinal(length); /* central rail */
     for (flip=[1,-1]) {
          scale([1, flip, 1]) {
               translate([0, -inner_half_width, 0]) {
                    longitudinal(length); /* lower rail */
                    translate([0, 0, rack_height-box]) longitudinal(length); /* upper rail */
               }
          }
     }
     translate([0, -inner_half_width/2, 0]) longitudinal(length); /* offside intermediate rail */
     translate([0, inner_half_width/2, 0]) longitudinal(length-section_length*2); /* nearside intermediate rail */
     translate([length-section_length*2, inner_half_width-ladder_cutout_width, 0]) longitudinal(section_length*2);
}

module ladder() {
     ladder_rail();
     translate([0, ladder_width-ladder_rail_width, 0]) ladder_rail();
     for (rung=[0:1:ladder_rungs-2]) {
               translate([ladder_rung_spacing * (rung+0.5), 0, 0])
                    ladder_rung();
          }

}

color("green") roofrack();
color("yellow") translate([0, inner_half_width-ladder_width-box-shim, -ladder_rail_depth-shim]) ladder();
