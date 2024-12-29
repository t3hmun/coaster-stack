// Stacking coasters with text design
// Raised sides to contain small spills

// Don't use the OpenSCAD 2021.x, rendering is silly slow. 
// Download a nighly version (2024.x or newer) and then in `Preferences>Avanced` select `3D Rendering>Backend>Manifold`, now rendering is instant.

// Tried a 45deg stacking shape, but it didn't feel nice when stacked, want it to feel more purposefully together
// Now fully drawing the whole shape as a polygon, simpler than differencing repeats.

emboss = 0.5;
smoothness = 200;

radius = 45; // total outer radius
wall = 1; // upper wall thikness
base = 1; // base thickness
insert_thick = 1;
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
        [radius - wall - 0.1, 0], // Bottom outer edge
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
            translate([0,0,base-emboss]) linear_extrude(height=2) text(text="mun", size=20, halign="center", valign="center", font=f);
        }
    }
}

build();

// 3d preview the stack 
//translate ([0,0,base + wall]) build();
