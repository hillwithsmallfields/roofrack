/* Dimensions in millimetres */

/* Add to design:
   ramps for cover
   upper guide for cover
   handle for cover
   sideways extension of cover to fit into main roofrack structure --- take this offboard as well as onboard
   mesh panels
   hole in mesh for downpipe
   mounting for junction box
   seat mountings
   solar shower mountings
   awning mountings
   windbreak pole sockets
   mountings for lamps over front doors
   mountings for driving lamps
   mounting for number plate
   winch mounting plate
   hatch in mesh for winch access
   pulleys for winch
   bracket for ladder lamp
   general-purpose plates with bolt holes at the corners, also serving to brace it for galvanizing
   galvanizing braces
 */

clarifying_gap = 0;

/* roofrack dimensions */

shim = 3;

box = 19;
outer_width = 1470;
inner_half_width = outer_width/2 - box;

bumper = 3000;
length = 3200; 

sections = 7;

section_length = length/sections;

roof_front = 1500;
standing_sections = 3;
standing_section_length = roof_front / standing_sections;

floating_sections = sections - standing_sections;
floating_length = length - roof_front;
floating_section_length = floating_length / floating_sections;

rack_height = 170;              /* from top to bottom of roofrack inclusive */

leg_height_total = 420;         /* from gutter to top of roofrack */

cantilever_strut_position = length/4;

pole_height = 1400;
pole_radius = box/2;

bracing_height = 900;
bracing_radius = box/2;
bracing_angle=35;

/* ladder dimensions */

ladder_height = 3000;
ladder_width = 410;             /* from a web advert */
ladder_rail_depth = 60;
ladder_rail_width = 20;
ladder_rung_diameter = 35;
ladder_rung_radius = ladder_rung_diameter/2;

ladder_rungs = 9;
ladder_rung_spacing = ladder_height / (ladder_rungs - 1);

ladder_cutout_width = ladder_width + box*4;
ladder_cutout_length = section_length*5/4;

ladder_cutout_cover_side_gap = 25;
ladder_cutout_cover_end_gap = 50;

ladder_cutout_cover_width = ladder_cutout_width-box*3 - ladder_cutout_cover_side_gap*2;
ladder_cutout_cover_front_width = inner_half_width-box*5;
ladder_cutout_cover_length = ladder_cutout_length - ladder_cutout_cover_end_gap;

/* accessories */

light_bar_width = 1050;
light_bar_depth = 91;

winch_length = 260;
winch_depth = 100;
winch_height = 100;

winch_plate_depth = 100;
winch_plate_length = 130;
winch_plate_thickness = 3;
winch_plate_hole_offset = 50;

winch_hatch_width = 200;

winch_cylinder_diameter = 80;
winch_cylinder_offset = 20;

fairlead_roller_centre_height = 10; /* TODO: measure this */
fairlead_roller_length = 80;
fairlead_roller_diameter = 15;
fairlead_roller_centre_spacing = 30;

/* positions calculated relative to ladder cutout */
light_bar_position = length-ladder_cutout_length;
front_of_winch_position = light_bar_position - light_bar_depth - box;
back_of_winch_position = front_of_winch_position - winch_depth;

/* parts */

module longitudinal(beamlen, name="along") {
     echo("box", beamlen, "longitudinal", name);
     translate([clarifying_gap, 0, 0])
          cube([beamlen-2*clarifying_gap, box, box]);
}

 module transverse(beamlen, name="across") {
     echo("box", beamlen, "transverse", name);
     translate([0, clarifying_gap, 0])
          cube([box, beamlen-2*clarifying_gap, box]);
}

module upright(beamlen, name="up") {
     echo("box", beamlen, "upright", name);
     translate([0, 0, clarifying_gap])
          cube([box, box, beamlen-2*clarifying_gap]);
}

module flat(flatlen, name="flat") {
     echo("flat", flatlen, "flat", name);
     cube([flatlen, box, shim]);
}

module wideflat(flatlen, flatwidth, name="wideflat") {
     echo("wideflat", flatlen, "flat", name);
     cube([flatlen, flatwidth, shim]);
}

module ladder_carrier() {
     translate([0, inner_half_width-ladder_cutout_width, -(ladder_rail_depth+box)]) {
          upright(ladder_rail_depth+box, "ladder carrier");
          /* transverse(ladder_cutout_width, "ladder carrier"); */
     }
}

module standing() {
     for (flip=[1,-1]) {
          scale([1, flip, 1]) {
               translate([0, -inner_half_width, 0]) {
                    transverse(inner_half_width, "half of main crosspiece for standing section");
                    translate([0, 0, rack_height-leg_height_total]) upright(leg_height_total, "standing section leg");
               }
          }
     }
     ladder_carrier();
}

module floating(gapped) {
     /* the halves of this are not indentical, so we can't just flip
      * half of it like the standing ones. */
     translate([0, -inner_half_width, 0]) {
          transverse(inner_half_width, "half of main crosspiece for floating section");
          upright(rack_height, "floating side");
     }
     translate([0, inner_half_width-box, 0]) {
          upright(rack_height, "floating side");
     }
     transverse(inner_half_width - (gapped ? ladder_cutout_width : 0), "half of main crosspiece for floating section");
     if (!gapped) {
          ladder_carrier();
     }
}

module pole() {
     cylinder(pole_height, pole_radius, pole_radius);
}

module bracing() {
     cylinder(bracing_height, bracing_radius, bracing_radius);
}

module ladder_rail () {
     cube([ladder_height, ladder_rail_width, ladder_rail_depth]);
}

module ladder_rung() {
     translate([0, 0, ladder_rail_depth/2]) rotate([-90, 0, 0]) cylinder(ladder_width, ladder_rung_radius, ladder_rung_radius);
}

module light_bar() {
     translate([-light_bar_depth, -light_bar_width/2, 0]) cube([light_bar_depth, light_bar_width, light_bar_depth]);
}

/* assemblies */

module inner_cover_track() {
     translate([length-ladder_cutout_length, 0, 0]) {
          flat(box*4, "cover inner track");
     }
     /* ramps */
     translate([length+box*2-ladder_cutout_length, 0, 0]) {
          rotate([0, 225, 0]) flat(box*1.4, "cover inner track");
     }
     translate([length-ladder_cutout_length*2, 0, 0]) {
          translate([0, 0, box]) flat(ladder_cutout_length+box, "cover inner track");
     }
}

module outer_cover_track() {
     flat(ladder_cutout_length+box, "cover outer track");
     translate([ladder_cutout_length+box*2, 0, -box]) rotate([0, 225, 0]) flat(box*1.4, "cover outer track");
     translate([ladder_cutout_length+box+4, 0, -box]) flat(box*3, "cover outer track");
}

module winch() {
     translate([0, -winch_plate_hole_offset, -winch_plate_depth]) {
          translate([-winch_plate_thickness, 0, 0]) cube([winch_plate_thickness, winch_plate_length, winch_plate_depth]);
          translate([-(winch_cylinder_offset + winch_cylinder_diameter/2),
                     -(winch_length - winch_plate_length),
                     winch_plate_depth/2
                         ]) {
               rotate([-90, 0, 0])
                    cylinder(winch_length, winch_cylinder_diameter/2, winch_cylinder_diameter/2);
          }
     }
     translate([-(winch_cylinder_diameter/2 + winch_cylinder_offset), fairlead_roller_length/2, fairlead_roller_centre_height]) {
          translate([fairlead_roller_centre_spacing/2, 0, 0])
               rotate([90, 0, 0])
               cylinder(fairlead_roller_length, fairlead_roller_diameter/2, fairlead_roller_diameter/2);
          translate([-fairlead_roller_centre_spacing/2, 0, 0])
               rotate([90, 0, 0])
               cylinder(fairlead_roller_length, fairlead_roller_diameter/2, fairlead_roller_diameter/2);
     }
}

module roofrack() {
     echo("start of roofrack");
     for (section=[0:1:standing_sections]) {
          translate([section*standing_section_length, 0, 0]) {
               standing();
          }
     }
     for (section=[1:1:floating_sections]) {
          translate([standing_sections*standing_section_length + section*floating_section_length, 0, 0]) {
               floating(section>floating_sections-2);
          }
     }

     /* central rail up to winch hatch */
     translate([0, -box/2, 0]) longitudinal(length+box*(sections-3)-section_length*2, "central rail");
     /* central rails around winch hatch */
     translate([length-section_length*2+box*(sections-3), -winch_hatch_width/2, 0]) longitudinal(section_length-box, "rail around winch hatch");
     translate([length-section_length*2+box*(sections-3), winch_hatch_width/2, 0]) longitudinal(section_length-box, "rail around winch hatch");
     translate([back_of_winch_position-box, -winch_hatch_width/2, 0]) transverse(winch_hatch_width, "rail across winch hatch");
     translate([front_of_winch_position-box, -winch_hatch_width/2, 0]) transverse(winch_hatch_width, "rail across winch hatch");
     /* central rail forward of winch hatch */
     translate([length - section_length+box*2, -box/2, 0]) longitudinal(section_length-box, "central rail forward of winch hatch");

     /* side rails */
     for (flip=[1,-1]) {
          scale([1, flip, 1]) {
               translate([0, -inner_half_width, 0]) {
                    longitudinal(length, "lower rail");
                    translate([0, 0, rack_height-box]) longitudinal(length, "upper rail");
               }
          }
     }

     /* area around ladder cutout */
     translate([0, -inner_half_width/2, 0]) longitudinal(length, "offside intermediate rail around ladder cutout");
     translate([0, inner_half_width/2, 0]) longitudinal(length-ladder_cutout_length, "nearside intermediate rail around ladder cutout");
     translate([length-floating_section_length*2, inner_half_width-ladder_cutout_width, 0]) longitudinal(floating_section_length*2, "around ladder cutout");
     translate([length-ladder_cutout_length, inner_half_width-ladder_cutout_width, 0]) transverse(ladder_cutout_width, "across ladder cutout");

     /* ladder cutout supports */
     translate([length-(ladder_cutout_length+box*4), 0, box]) {
          translate([0, (inner_half_width-ladder_cutout_width) + box, 0]) outer_cover_track();
          translate([0, inner_half_width-(box*2), 0]) outer_cover_track();
     }

     translate([0, (inner_half_width-ladder_cutout_width) + box*2, 0]) inner_cover_track();
     translate([0, inner_half_width-box*3, 0]) inner_cover_track();
          

     /* ladder cutout upper guide */
     translate([length-ladder_cutout_length*2, inner_half_width-box*3.5, rack_height]) wideflat(ladder_cutout_length*2, box*3.5, "ladder cutout guide A");
     translate([length-ladder_cutout_length*2, inner_half_width-box*3.5, rack_height]) rotate([-90, 0, 0]) wideflat(ladder_cutout_length*2, box*3.5, "ladder cutout guide B");
     
     /* winch supports */
     translate([front_of_winch_position, -inner_half_width/2, 0]) {
          translate([0, 0, -winch_depth]) transverse(inner_half_width*3/2-ladder_cutout_width, "winch support");
          translate([0, 0, -box]) transverse(inner_half_width*3/2-ladder_cutout_width, "winch support");
          translate([0, 0, -winch_depth]) upright(winch_depth, "winch support");
     }
     translate([front_of_winch_position, inner_half_width-ladder_cutout_width, -winch_depth]) upright(winch_depth, "winch support upright");
     translate([front_of_winch_position, -winch_hatch_width/2, -winch_depth]) upright(winch_depth, "winch support upright");
     translate([front_of_winch_position, winch_hatch_width/2, -winch_depth]) upright(winch_depth, "winch support upright");

     /* light bar supports */
     translate([light_bar_position-light_bar_depth/2, 0, -(light_bar_depth+ladder_rail_depth)]) {
          translate([0, -(light_bar_width/2+box), 0]) upright(light_bar_depth+ladder_rail_depth, "light bar hanger");
          translate([0, light_bar_width/2+box, 0]) upright(light_bar_depth+ladder_rail_depth, "light bar hanger");
     }
     translate([length-(section_length*2-box*3), -(light_bar_width/2+box), 0]) longitudinal(section_length, "light bar hanger holder");
     translate([length-(section_length*2-box*3), (light_bar_width/2+box), 0]) longitudinal(section_length*2 - ladder_cutout_length - box*2, "light bar hanger holder");
     
     /* front */
     translate([length, -inner_half_width, rack_height-box]) transverse(outer_width-ladder_cutout_width-box, "front");
     translate([length+box, -inner_half_width/2, 0]) upright(rack_height, "front upright");
     translate([length, box/2, 0]) upright(rack_height-box, "front upright");
     translate([length+box, inner_half_width-ladder_cutout_width, 0]) upright(rack_height, "front upright");

     /* support poles */
     for (flip=[1, -1]) {
          scale([1, flip, 1]) {
               translate([bumper, -(inner_half_width-box/2), -pole_height]) pole();
               translate([bumper-ladder_cutout_length, -(inner_half_width-box/2), 0]) rotate([0, bracing_angle, 0]) translate([0, 0, -bracing_height]) bracing();
          }
     }
     echo("end of roofrack");
}

module ladder_cutout_cover() {
     echo("start of ladder cutout cover");
     longitudinal(ladder_cutout_cover_length-box, "cover side");
     transverse(ladder_cutout_cover_width, "cover back");
     translate([0, ladder_cutout_cover_width, 0]) {
          longitudinal(ladder_cutout_cover_length, "cover side");
          upright(rack_height-box*2, "cover upright");
          translate([ladder_cutout_cover_length-box, 0, 0]) upright(rack_height-box*2, "cover upright");
          translate([(ladder_cutout_cover_length-box)/2, 0, 0]) upright(rack_height-box*2, "cover upright");
          translate([0, 0, rack_height-box*2]) longitudinal(ladder_cutout_cover_length, "cover side");
     }
     translate([ladder_cutout_cover_length-box,
                ladder_cutout_cover_width - ladder_cutout_cover_front_width,
                box]) transverse(ladder_cutout_cover_front_width, "cover lower front");
     translate([ladder_cutout_cover_length-box,
                ladder_cutout_cover_width - ladder_cutout_cover_front_width,
                rack_height-box*2])
          transverse(ladder_cutout_cover_front_width, "cover upper front");
     translate([(ladder_cutout_cover_length-box)/2, 0, 0]) transverse(ladder_cutout_cover_width, "cover middle crosspiece");
     translate([ladder_cutout_cover_length-box, 0, 0]) upright(rack_height-box, "cover upright");
     translate([ladder_cutout_cover_length-box,
                ladder_cutout_cover_width - ladder_cutout_cover_front_width,
                box]) upright(rack_height-box*2, "cover upright");
     /* handle */
     translate([(ladder_cutout_cover_length-box)/2, ladder_cutout_cover_width-box*2, 0]) upright(rack_height+box/2, "cover handle upright");
     translate([(ladder_cutout_cover_length-box)/2, ladder_cutout_cover_width-box*2, rack_height+box/2]) transverse(box*6, "cover handle top");
     translate([(ladder_cutout_cover_length-box)/2, ladder_cutout_cover_width+box*4, 0]) upright(rack_height+box*1.5, "cover handle outer");
     echo("end of ladder cutout cover");
}

module ladder() {
     ladder_rail();
     translate([0, ladder_width-ladder_rail_width, 0]) ladder_rail();
     for (rung=[0:1:ladder_rungs-2]) {
               translate([ladder_rung_spacing * (rung+0.5), 0, 0])
                    ladder_rung();
          }

}

module pose(stowed) {
     roofrack();
     /* accessories */
     color("cyan") translate([light_bar_position, 0, -(light_bar_depth+ladder_rail_depth+box)]) light_bar();
     ladder_cutout_side_offset = inner_half_width+box-ladder_cutout_width + ladder_cutout_cover_side_gap;
     color("green") translate([front_of_winch_position, 0, 0]) winch();
     if (stowed) {
          color("red") translate([length+box-ladder_cutout_cover_length, ladder_cutout_side_offset, 0]) ladder_cutout_cover();
          color("yellow") translate([0, inner_half_width-ladder_width-box*2-shim, -ladder_rail_depth-shim]) ladder();
     } else {
          color("red") translate([length+box-ladder_cutout_length*2.2, ladder_cutout_side_offset, box]) ladder_cutout_cover();
          color("yellow") translate([length+box+ladder_rail_depth-ladder_cutout_length, inner_half_width-ladder_width-box*2-shim, -ladder_rail_depth-shim]) rotate([0, 55, 0]) translate([-length*.25, 0, 0]) ladder();
     }
}

translate([0, -outer_width, 0]) pose(true);
translate([0, outer_width, 0]) pose(false);
translate([0, outer_width*3, 0]) roofrack();
translate([length+ladder_cutout_length, outer_width*3, 0]) color("red") ladder_cutout_cover();
