// Stacking coasters with text design
// Raised sides to contain small spills

// Don't use the OpenSCAD 2021.x, rendering is silly slow. 
// Download a nighly version (2024.x or newer) and then in `Preferences>Avanced` select `3D Rendering>Backend>Manifold`, now rendering is instant.

// Tried a 45deg stacking shape, but it didn't feel nice when stacked, want it to feel more purposefully together
// Now fully drawing the whole shape as a polygon, simpler than differencing repeats.

// All printing is done with a 0.2 layer height, so stepping vertical sizes by 0.2mm - so don't use 1.5mm.

emboss = 0;
smoothness = 200;

radius = 46; // total outer radius
wall = 2; // upper wall thikness
base = 2; // base thickness
insert_thick = 1.6;
insert_radius = 43;

gohu = "GohuFont 14 Nerd Font";
mun = "mun ";
proggy = "ProggyClean Nerd Font";
three = "3270 Nerd Font";
f = gohu;

font_size = 12;


module x_poly(){
    polygon(points=[
        [0              ,0], // Bottom centre-point
        [radius - wall - 0.3, 0], // Bottom outer edge
        [radius - wall - 0.1, base], // The vertical lower out wall 
        [radius         , base + wall], // The 45deg outer wall
        [radius         , base + wall + wall], // The vertical top outer wall
        [radius - wall  , base + wall + wall], // Top inner edge
        [radius - wall  , base + wall], // Inside edge
        [insert_radius  , base + wall],
        [insert_radius  , base + wall - insert_thick],
        [0              , base + wall - insert_thick] // Top centre point.
    ]);
}

module build(){
    intersection(){
        cube(100, center=true);
        difference(){
            rotate_extrude($fn=smoothness) x_poly();
            // trying to make the top and bottom of the hollow only 0.2mm (1 layer) creates artifacts on the base and top.
            translate([0,0,0.4]) linear_extrude(height=1.4) text(text="mun", size=20, halign="center", valign="center", font=f);
        }
    }
}

build();

// 3d preview the stack 
//translate ([0,0,base + wall]) build();
