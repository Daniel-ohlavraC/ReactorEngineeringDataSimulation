// ============================================================
// 1. GENERAL PARAMETERS
// ============================================================

// Reactor dimensions
T0 = 476;
H  = 476;

// Draft tube dimensions
T1 = 310;
H1 = 321;

// General geometry parameters
w = 31;
D = 300;
c = 190;

// Draft tube vertical position
Hin = (H - H1) / 2;

// Inlet and outlet diameters
Din  = 20;
Dout = 20;

// Impeller parameters
n_imp     = 5;
angle_imp = -25;
r_corner  = 20;

// Baffle parameters
n_baffles       = 5;
baffle_length   = 30.5;
baffle_thickness = 2.5;
central_gap     = 122;
baffle_angle    = -15;

// Rendering resolution
$fn = 128;


// ============================================================
// 2. INLET CONNECTION MODULE
// ============================================================

module inlet_connection() {

    // Inlet opening
    translate([0, (T0 - 6 + 75) / 2, Hin - 10])
        rotate([-90, 0, 0])
            cylinder(h = 2.5, d = Din);

    // Hollow inlet nozzle
    difference() {
        translate([0, (T0 - 6) / 2, Hin - 10])
            rotate([-90, 0, 0])
                cylinder(h = 40, d = Din);

        translate([0, (T0 - 6 - 2) / 2, Hin - 10])
            rotate([-90, 0, 0])
                cylinder(h = 43, d = Din - 1);
    }
}


// ============================================================
// 3. OUTLET CONNECTION MODULE
// ============================================================

module outlet_connection() {

    // Outlet opening
    translate([0, -(T0 - 6 + 75) / 2, Hin + H1 + 10])
        rotate([90, 0, 0])
            cylinder(h = 2.5, d = Din);

    // Hollow outlet nozzle
    difference() {
        translate([0, -(T0 - 6) / 2, Hin + H1 + 10])
            rotate([90, 0, 0])
                cylinder(h = 40, d = Din);

        translate([0, -(T0 - 6 - 2) / 2, Hin + H1 + 10])
            rotate([90, 0, 0])
                cylinder(h = 43, d = Din - 1);
    }
}


// ============================================================
// 4. IMPELLER MODULE
// ============================================================

module impeller(D, n, angle, r) {

    color("cyan") {

        // Central hub
        cylinder(
            h = D * 0.12,
            d = D * 0.15,
            center = true,
            $fn = 60
        );

        // Impeller blades
        for (i = [0 : n - 1]) {
            rotate([0, 0, i * 360 / n])
                rotate([angle, 0, 0])
                    linear_extrude(
                        height = D * 0.01,
                        center = true
                    )
                        offset(r = r, $fn = 20)
                            offset(delta = -r)
                                polygon(points = [
                                    [D * 0.007, -D * 0.055],
                                    [D * 0.007,  D * 0.075],
                                    [D * 0.48,   D * 0.15],
                                    [D * 0.48,  -D * 0.15]
                                ]);
        }
    }
}


// ============================================================
// 5. IMPELLER SHAFT MODULE
// ============================================================

module impeller_shaft() {

    color("gray")
        translate([0, 0, c])
            cylinder(
                h = H - c,
                d = D * 0.05,
                $fn = 30
            );
}


// ============================================================
// 6. REACTOR TANK MODULE
// ============================================================

module reactor_tank() {

    difference() {

        // Outer cylindrical wall
        cylinder(
            h = H,
            d = T0,
            center = false
        );

        // Optional side cutaway for visualization
//         x = 1000;
//         translate([0, -x / 2, 0])
//             cube(x);

        // Internal cavity
        translate([0, 0, 2.5])
            cylinder(
                h = H - 5,
                d = T0 - 5,
                center = false
            );

        // Inlet nozzle clearance
        translate([0, (T0 - 6 - 2) / 2, Hin - 10])
            rotate([-90, 0, 0])
                cylinder(h = 43, d = Din - 1);

        // Outlet nozzle clearance
        translate([0, -(T0 - 6 - 2) / 2, Hin + H1 + 10])
            rotate([90, 0, 0])
                cylinder(h = 43, d = Din - 1);
    }
}


// ============================================================
// 7. DRAFT TUBE MODULE
// ============================================================

module draft_tube() {

    difference() {

        // Outer cylindrical wall
        translate([0, 0, Hin])
            cylinder(
                h = H1,
                d = T1
            );

        // Optional side cutaway for visualization
        // translate([0, -500, 0])
        //     cube([1000, 1000, 1000]);

        // Inner cavity
        translate([0, 0, Hin - 2.5])
            cylinder(
                h = H1 + 10,
                d = T1 - 5
            );
    }
}


// ============================================================
// 8. BAFFLE ROW MODULE
// ============================================================

module baffles(
    n,
    length,
    thickness,
    height,
    central_gap,
    z_position,
    angle
) {

    translate([0, 0, z_position]) {

        // Equally spaced radial baffles
        for (i = [0 : n - 1]) {
            rotate([0, 0, i * 360 / n + angle])
                translate([
                    central_gap,
                    -thickness / 2,
                    0
                ])
                    cube([
                        length,
                        thickness,
                        height
                    ]);
        }
    }
}


// ============================================================
// 9. LOWER BAFFLE ROW MODULE
// ============================================================

module lower_baffles() {

    baffles(
        n           = n_baffles,
        length      = baffle_length,
        thickness   = baffle_thickness,
        height      = 85,
        central_gap = central_gap,
        z_position  = 77.5,
        angle       = baffle_angle
    );
}


// ============================================================
// 10. UPPER BAFFLE ROW MODULE
// ============================================================

module upper_baffles() {

    baffles(
        n           = n_baffles,
        length      = baffle_length,
        thickness   = baffle_thickness,
        height      = 181,
        central_gap = central_gap,
        z_position  = 217.5,
        angle       = baffle_angle
    );
}


// ============================================================
// 11. COMPLETE IMPELLER ASSEMBLY MODULE
// ============================================================

module impeller_assembly() {

    translate([0, 0, c])
        impeller(D, n_imp, angle_imp, r_corner);

    impeller_shaft();
}


// ============================================================
// 12. COMPLETE REACTOR ASSEMBLY MODULE
// ============================================================

module complete_reactor() {

    reactor_tank();

    inlet_connection();
    outlet_connection();

    draft_tube();

    impeller_assembly();

    lower_baffles();
    upper_baffles();
}


// ============================================================
// 13. COMPONENT SELECTION
// Uncomment only the module you want to display or export.
// ============================================================

// Individual components
// inlet_connection();
// outlet_connection();
// impeller_shaft();
// impeller_assembly();
// reactor_tank();
// draft_tube();
// lower_baffles();
// upper_baffles();


// Complete assembly
complete_reactor();