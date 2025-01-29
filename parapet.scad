
// TODO:
// [x] Add the taper to the base that exists in coaster-stack.scad, this allows it top stack smoothly without getting stuck.
// [x] Either fix the radius to fit the inlay-rings or make a new one to fit this.
// [ ] Decorative arches in the overhang slope
// [x] Tiny arrow slits
//     [ ] Add the taper on the inside of the arrow slits
// [ ] Merlon caps


base_radius = 43;
base_thickness = 2;
wall_thickness = 4;
merlon_h = 2.0;
crenel_h = 2.2;

crenel_w =1.6; // If you change this number straight_cren_set() will need adjusting
merlon_w = 2.4;
wall_height = merlon_h + crenel_h;
wall_overhang_w = 2;
wall_overhang_h = 3;
insert_radius = 38;


wall_segments = 20; // If you change this number straight_cren_set() and offset will need adjusting

module base_poly(){
    polygon(points = [
        [0,0], 
        [base_radius - 0.3, 0], 
        [base_radius - 0.1, base_thickness], 
        [base_radius + wall_overhang_w, base_thickness + wall_overhang_h],
        [base_radius + wall_overhang_w, base_thickness + wall_overhang_h + wall_height],
        [base_radius , base_thickness + wall_overhang_h + wall_height],
        [base_radius , base_thickness + wall_overhang_h ],
        [insert_radius, base_thickness + wall_overhang_h ],
        [insert_radius, base_thickness ],
        [0, base_thickness],
        ]);
}

module base(){
    rotate ([0,0,0]) rotate_extrude($fn=wall_segments) base_poly();
}

module crenel_cut() {
    step = 360/wall_segments;
    offset = step/2;
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
    offset = step/2;
    loophole_w = 0.2;
    module loophole_bar() {
        translate([0, -base_radius-wall_overhang_w-1,base_thickness + wall_overhang_h+ (wall_height-merlon_h)-0.5]){
            union() {
                translate([-(loophole_w/2),0,0]) cube([loophole_w,(base_radius+wall_overhang_w + 1)*2, 2]);
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


module stamp(){
    translate([-9.1,-2.6,base_thickness -1 ]) linear_extrude(3) text("mun", size=10, font="ProggyClean Nerd Font");
}

module crenelated_base() {
    difference() {
        base();
        crenel_cut();
        loophole_cut();
        stamp();
    }
}


//base_poly();
//crenel_cut();
//stamp();
//loophole_cut();
crenelated_base();