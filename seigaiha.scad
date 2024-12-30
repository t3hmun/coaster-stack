// Waves inlay for coaster - print in another colour and insert.

smoothness = 200;
feat_smoothness = 200;
feat_thick = 1;

radius = 43; // total outer radius
height = 1;


union(){
    intersection(){
        seigaiha_grid(15,height);
        translate([0,0,-1]) cylinder(r=radius, h=height*3, $fn = smoothness);
    }
    difference(){
        translate([0,0,0]) cylinder(r=radius, h=height, $fn = smoothness);
        translate([0,0,-1]) cylinder(r=radius-1, h=height*3, $fn = smoothness);
    }
}



module stencil (r,h) {
    difference() {
        cylinder(h=h, r=r, $fn=feat_smoothness);
        translate([0,0,-h]) difference() {
            cylinder(h=h*3, r=r-feat_thick, $fn=feat_smoothness);
            translate([0,0,-2*h]) cylinder(h=h*4, r=r/4*3, $fn=feat_smoothness);
        }
        translate([0,0,-h]) difference() {
            cylinder(h=h*3, r=r/4*3-feat_thick, $fn=feat_smoothness);
            translate([0,0,-2*h]) cylinder(h=h*4, r=r/4*2, $fn=feat_smoothness);
        }
        translate([0,0,-h]) difference() {
            cylinder(h=h*3, r=r/4*2-feat_thick, $fn=feat_smoothness);
            translate([0,0,-2*h]) cylinder(h=h*4, r=r/4*1, $fn=feat_smoothness);
        }
        translate([0,0,-h]) difference() {
            cylinder(h=h*3, r=r/4*1-feat_thick, $fn=feat_smoothness);
            //translate([0,0,-2*h]) cylinder(h=h*4, r=r/4*1, $fn=feat_smoothness);
        }
        translate([r,-r/2,-h]) cylinder(h=h*3, r=r, $fn=feat_smoothness);
        translate([-r,-r/2,-h]) cylinder(h=h*3, r=r, $fn=feat_smoothness);
        translate([0,-r,-h]) cylinder(h=h*3, r=r, $fn=feat_smoothness);
    }
}


module seigaiha_grid(r,h) {
    vrep = 10;
    hrep = 10;
    translate([-hrep/2*r, -vrep/2*r]) for(row = [0:vrep]) {
        translate([0,row*r,0]) {
            stencil(r,h);
            for(col = [0:hrep]) {
                translate([col*r, (col%2)*(r/2), 0]) stencil(r,h);
            }
        }
    }
}

