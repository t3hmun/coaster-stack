// Stacking coasters with text design
// Raised sides to contain small spills

// Don't use the OpenSCAD 2021.x, rendering is silly slow. 
// Download a nighly version (2024.x or newer) and then in `Preferences>Avanced` select `3D Rendering>Backend>Manifold`, now rendering is instant.

// Prints Results:
// First attempt was without a bevel but a 90deg rug cutout, that print failed, 90deg unsupported does not work.
// 3mm h, 2,mm thick, 0.4 stack gap: TODO.


wall_h = 3;
radius = 45;
// Base thickness
thickness = 2;
emboss = 0.5;
smoothness = 200;
// Want to tweak this to see how sharp the top edge will print and how hard the stack is to separate.
stack_gap = 0.4;

gohu = "GohuFont 14 Nerd Font";
mun = "mun ";
proggy = "ProggyClean Nerd Font";
three = "3270 Nerd Font";
f = proggy;

font_size = 12;

module bev_cyl() {
    // 45 deg bevel because anything steeper will probs fail to print.
    rotate_extrude($fn=smoothness) polygon(points=[[0,0],[radius-wall_h,0],[radius,wall_h],[0,wall_h]]);
}

module build(){
    difference(){
        bev_cyl();
        // Cut the exact same shape so it stacks exact
        translate([0,0,thickness]) bev_cyl();
        translate([0,0,thickness-emboss]) linear_extrude(height=2) text(text="mun", size=20, halign="center", valign="center", font=f);
        // An outside ring to cut off the edge so that the wall beyond the stacking is vertical.
        difference(){
            cylinder(r=radius+10, h=wall_h*5, center=true, $fn=smoothness);
            cylinder(r=radius-thickness+stack_gap, h=wall_h*6, center=true, $fn=smoothness);
        }
    }
}

build();

// 3d preview the stack 
// translate ([0,0,thickness]) build();
// translate ([0,0,thickness*2]) build();
