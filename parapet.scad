
// TODO:
// [x] Add the taper to the base that exists in coaster-stack.scad, this allows it top stack smoothly without getting stuck.
// [x] Either fix the radius to fit the inlay-rings or make a new one to fit this.
// [ ] Decorative arches in the overhang slope
// [x] Tiny arrow slits
//     [x] Add the taper on the inside of the arrow slits
// [ ] Merlon caps


base_radius = 46;
base_thickness = 1;
wall_thickness = 4;

merlon_h = 3;
crenel_h = 2;

crenel_w =3; // If you change this number straight_cren_set() will need adjusting
merlon_w = 4.5;
wall_height = merlon_h + crenel_h;
wall_overhang_w = 3;
wall_overhang_h = 3;
insert_radius = 43;


wall_segments = 10; // If you change this number straight_cren_set() and offset will need adjusting

module base_poly(){
    polygon(points = [
        [0,0], 
        [base_radius - 0.3, 0], 
        [base_radius - 0.1, base_thickness], 
        [base_radius + wall_overhang_w, base_thickness + wall_overhang_h],
        [base_radius + wall_overhang_w, base_thickness + wall_overhang_h + wall_height],
        // Next 2 must be base_radius to allow stacking to work. So wall thickness is same as wall_overhang_w
        [base_radius , base_thickness + wall_overhang_h + wall_height],
        [base_radius , base_thickness + wall_overhang_h ],
        [insert_radius, base_thickness + wall_overhang_h ],
        [insert_radius, base_thickness ],
        [0, base_thickness],
        ]);
}

module base(){
    difference(){    
        rotate ([0,0,0]) rotate_extrude($fn=wall_segments) base_poly();
        translate([0,0,base_thickness-0.1]) cylinder(r=insert_radius, h=30, $fn=500);
    }
}

module crenel_cut() {
    step = 360/wall_segments;
    offset = step;///2;
    module cren_bar() {
        translate([-(crenel_w/2), -base_radius-wall_overhang_w-1,base_thickness + wall_overhang_h+ (wall_height-merlon_h)]) cube([crenel_w,(base_radius+wall_overhang_w + 1)*2, merlon_h + 1]);
    }
    module straight_cren_set() {
        translate([-merlon_w-merlon_w,0,0]) cren_bar();
        translate([0,0,0]) cren_bar();
        translate([merlon_w+merlon_w,0,0]) cren_bar();
    }
    union() {   
        for (i = [1:(wall_segments/2)]) {
            rotate([0,0,(step*i)-offset]) straight_cren_set();
        }
    }
}

module loophole_cut() {
    step = 360/wall_segments;
    offset = step;///2;
    loophole_w = 0.4;
    module loophole_bar() {
        translate([0, -base_radius-wall_overhang_w-1,base_thickness + wall_overhang_h+ (wall_height-merlon_h)-0.5]){
            union() {
                translate([-(loophole_w/2),0,0]) cube([loophole_w,(base_radius+wall_overhang_w + 1)*2, 2.5]);
                translate([-0.5,0,1]) cube([1,(base_radius+wall_overhang_w + 1)*2,  loophole_w]);
            }
        }
    }
    module straight_loophole_set() {
        translate([-merlon_w,0,0]) loophole_bar();
        translate([merlon_w,0,0]) loophole_bar();
    }
    union() {   
        for (i = [1:(wall_segments/2)]) {
            rotate([0,0,(step*i)-offset]) straight_loophole_set();
        }
    }
}

// This might need to be changed to not have a flat roof.
module embrasure_cut() {
    step = 360/wall_segments;
    offset = step;///2;
    embrasure_w = 3;
    module embrasure_bar() {
        translate([0, -base_radius,base_thickness + wall_overhang_h+ (wall_height-merlon_h)-0.5]){
            union() {
                translate([0,-0.7,0]) rotate([0,0,0]) rotate([0,0,45]) cube([embrasure_w,embrasure_w,embrasure_w]);
            }
        }
    }
    module straight_embrasure_set() {
        translate([-merlon_w,0,0]) embrasure_bar();
        translate([merlon_w,0,0]) embrasure_bar();
    }
    union() {   
        for (i = [1:(wall_segments)]) {
            rotate([0,0,(step*i)-offset]) straight_embrasure_set();
        }
    }
}


module stamp(){
    translate([-9.1,-2.6,base_thickness-0.99  ]) linear_extrude(3) text("mun", size=10, font="ProggyClean Nerd Font");
}

module crenelated_base() {
    difference() {
        base();
        crenel_cut();
        loophole_cut();
        embrasure_cut();
        stamp();
    }
}

//base_poly();
//crenel_cut();
//stamp();
//loophole_cut();
//embrasure_cut();
crenelated_base();