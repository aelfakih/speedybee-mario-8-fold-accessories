
// --------- USER PARAMETERS ---------
standoff_spacing = 26;      // Distance between standoffs (mm)
extension_length = 15;      // How far base extends beyond second standoff (mm)
base_width = 10;            // Width of the base (left-right, X)
base_thickness = 5;         // Thickness of the base (up-down, Z)
hole_diameter = 5.1;        // Diameter of standoff holes (mm)

// XT60 holder parameters
xt60_holder_length = 12;    // Depth (front-back, Y)
xt60_holder_width = 12;     // Width (left-right, X)
xt60_holder_height = 20;    // Height (up, Z)
xt60_holder_thickness = 4;  // Wall thickness

// Tilt the base connection!
xt60_connection_angle = 90;  // NEW: Rotation of base around XT60 side (degrees)

// Internal holder slot parameters
xt60_slot_width = xt60_holder_width - xt60_holder_thickness;  // Width of XT60 plug opening
xt60_slot_height = xt60_holder_height - xt60_holder_thickness; // Height of XT60 plug opening

$fn = 60;                   // Smoothness for circles

// --------- MODULES ---------

// Base plate with standoff holes
module base_plate() {
    difference() {
        
        cube([standoff_spacing + extension_length, base_width, base_thickness], center=false);
        
        // First standoff hole
        translate([5, base_width/2, -1])
            cylinder(h=base_thickness + 2, d=hole_diameter, center=false);
        
        // Second standoff hole
        translate([5 + standoff_spacing, base_width/2, -1])
            cylinder(h=base_thickness + 2, d=hole_diameter, center=false);
    }
}

// XT60 hollow holder with insertion slot
module xt60_holder() {
    difference() {
        // Outer box
        cube([xt60_holder_width, xt60_holder_length, xt60_holder_height], center=false);
        
        // Inner hollow
        translate([xt60_holder_thickness, xt60_holder_thickness, xt60_holder_thickness])
            cube([
                xt60_holder_width - 2 * xt60_holder_thickness,
                xt60_holder_length - 2 * xt60_holder_thickness,
                xt60_holder_height - 2 * xt60_holder_thickness
            ], center=false);

        // Insert slot
        translate([
            (xt60_holder_width - xt60_slot_width)/2,
            -1,  // start before wall
            (xt60_holder_height - xt60_slot_height)/2
        ])
            cube([
                xt60_slot_width,
                xt60_holder_length + 2,
                xt60_slot_height
            ], center=false);
    }
}

// --------- ASSEMBLY ---------
union() {
    // XT60 holder at origin
    xt60_holder();
    
    // Extension arm rotated around holder side
    translate([
        0,  // move slightly if needed (no X offset)
        (xt60_holder_length)/4,     // center Y
        (xt60_holder_height/4) - (base_thickness/4) // center Z
    ])
    rotate([xt60_connection_angle, 0, 0])  // <--- NEW rotation around Y axis
    translate([
        -(standoff_spacing+extension_length),  // move base right after holder width
        -xt60_holder_height/6,
        -xt60_holder_thickness/2
    ])
        base_plate();
}
