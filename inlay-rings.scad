// Stacking coasters with text design
// Raised sides to contain small spills

// Don't use the OpenSCAD 2021.x, rendering is silly slow. 
// Download a nighly version (2024.x or newer) and then in `Preferences>Avanced` select `3D Rendering>Backend>Manifold`, now rendering is instant.

// Tried a 45deg stacking shape, but it didn't feel nice when stacked, want it to feel more purposefully together
// Now fully drawing the whole shape as a polygon, simpler than differencing repeats.

emboss = 0.5;
smoothness = 200;

radius = 43; // total outer radius
height = 1;


module ring(r, t){
    difference() {
        cylinder(r=r, h=height);
        translate([0,0,-1]) cylinder(r=r-t, h=height*3, $fn=smoothness);
    }
}

module ring_grid(r, t){
    r_reps = ceil(radius*2/r/2);
    c_reps = ceil(radius*2/r) + 1; // Some extra rings because when centering in an odd size it becomes offset.
    // keep the number even so that we get a star in the middle.
    actual_w = r * (c_reps - (c_reps % 2 == 0 ? 0 : 1));
    echo(c_reps);
    translate([-actual_w/2,-actual_w/2,0])
    for (row = [0:(r_reps)]){
        translate([0,row*r*2]){
            for (col = [0:(c_reps)]){
                translate([col*r, col%2*r, 0]) ring(r, t, $fn = smoothness);
            }
        }
    }
}

union(){
    intersection(){
        ring_grid(8.5,1);
        translate([0,0,-1]) cylinder(r=radius, h=height*3, $fn = smoothness);
    }
    difference(){
        translate([0,0,0]) cylinder(r=radius, h=height, $fn = smoothness);
        translate([0,0,-1]) cylinder(r=radius-1, h=height*3, $fn = smoothness);
    }
}

// 3d preview the stack 
//translate ([0,0,base + wall]) build();