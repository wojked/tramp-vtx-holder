STANDOFF_DISTANCE = 30.5;
STANDOFF_DIAMETER = 5.04;


MOUNTH_HEIGHT = 9.32;
MOUNT_THICKNESS = 2;
STANDOFF_HEIGHT = 30;

BRIDGE_OFFSET = -2.52; // [-2.5:0.1:2.5]
TOLERANCE = 0.5; // [0:0.05:0.5]

VTX_WIDTH = 17.30;
VTX_HEIGHT_1 = 5.36;
VTX_HEIGHT_2_ANTENNA = 6.22;

VTX_CONNECTOR_HEIGHT = 6.57;
VTX_CONNECTOR_DEPTH = 4.20;

VTX_DEPTH = 31.96;



$fn = 128;
frame_skeleton(STANDOFF_DISTANCE, STANDOFF_DIAMETER, STANDOFF_HEIGHT);
vtx_holder(STANDOFF_DISTANCE, STANDOFF_DIAMETER, MOUNTH_HEIGHT, 
           VTX_WIDTH, VTX_HEIGHT_1, VTX_HEIGHT_2_ANTENNA, TOLERANCE);        


module vtx_holder(standoff_distance, standoff_diameter, mount_height, vtx_width, vtx_height_1, vtx_height_2_antenna, tolerance) {
    difference(){
        holder(STANDOFF_DISTANCE, STANDOFF_DIAMETER, MOUNTH_HEIGHT, TOLERANCE);
//        vtx(vtx_width);
    }
        translate([-vtx_width/2,-vtx_width,0])    
        cube([vtx_width, vtx_width, vtx_height_1], true);    
}

//module vtx(vtx_width, vtx_height_1, vtx_height_2_antenna){
//    cube([vtx_width, vtx_width, vtx_width], true);
//}


module holder(standoff_distance, standoff_diameter, mount_height, tolerance) {
    mount_diameter = standoff_diameter + 2;
    mount_depth = 2;
    mount_offset = 0;
    
    

    angle_step = 90;
    number_of_bridges = 1;

    translate([0, 0,mount_height/2])
    
    difference(){
        union(){
            for (n = [0:1:number_of_bridges]){
                  rotate([0,0, n*angle_step])
                  translate([-standoff_distance/2,-standoff_distance/2, 0]) 
                  color("red")
                  standoff(mount_diameter, mount_height, true);
             };
             for (n = [0:1:number_of_bridges-1]){
                  rotate([0,0, n*angle_step])
                  translate([0,-standoff_distance/2, 0]) 
                  bridge(standoff_distance, mount_depth, mount_height, standoff_diameter, mount_offset, tolerance, true);
             };         
         };

         for (n = [0:1:number_of_bridges]){
                  rotate([0,0, n*angle_step])
                  translate([-standoff_distance/2,-standoff_distance/2, 0]) 
                  color("red")
                  standoff(standoff_diameter + tolerance, mount_height * 2, true);                  
         }    
        
    }
   
}

module frame_skeleton(standoff_distance, standoff_diameter, standoff_height) {
    base_width = 4;
    full_side_length = standoff_distance + standoff_diameter;
    echo(str("Side length", full_side_length));
    
    translate([0,0,-base_width/2])
    base(full_side_length, base_width, true);
    
    angle_step = 90;
    translate([0,0,standoff_height/2])
    for (n = [0:1:3]){
          rotate([0,0, n*angle_step])
          translate([standoff_distance/2,standoff_distance/2,0])
          standoff(standoff_diameter, standoff_height, true);
     }
     
     translate([0,0, standoff_height])
     base(full_side_length, base_width, true);
}

module base(full_side_length, base_width, center) {    
    color("green")
    cube([full_side_length,full_side_length, base_width], center);
}

module standoff(diameter, height, center) {
    color("yellow")
    cylinder(height,diameter/2, diameter/2, center);
}

module bridge(bridge_length, bridge_thickness, bridge_height, mount_diameter, bridge_offset, tolerance, center){
    angle_step = 180;
    
    color("red")
    difference(){
        translate([0, bridge_offset, 0])         
        cube([bridge_length, bridge_thickness, bridge_height], center);
        for (n = [0:1:1]){
          rotate([0,0, n*angle_step])
          translate([bridge_length/ 2, 0, 0]) 
          standoff(mount_diameter + tolerance, bridge_height*2, center);
        }
    }
}
