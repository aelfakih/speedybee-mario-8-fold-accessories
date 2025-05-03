$fn = 60; // Smooth curves

// Parameters
outer_size = 25;
inner_size = 20;
height = 6;
corner_radius = 2;

// Module
module rounded_frame() {
    difference() {
        // Outer block with rounded corners
        linear_extrude(height)
            offset(r = corner_radius)
            offset(delta = -corner_radius)
            square([outer_size, outer_size], center = true);

        // Cut-through hole with rounded corners
        translate([0, 0, -0.1])  // Ensure clean subtraction from Z=0
            linear_extrude(height + 0.2)
                offset(r = corner_radius)
                offset(delta = -corner_radius)
                square([inner_size, inner_size], center = true);
    }
}

// Preview
rounded_frame();
