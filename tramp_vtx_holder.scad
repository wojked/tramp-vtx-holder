STANDOFF_DISTANCE = 30.5;
STANDOFF_DIAMETER = 4.98;


MOUNTH_HEIGHT = 9.8;
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
VTX_TRACE_LENGTH = 24.47;

VTX_ANTENNA_SHIFT = -2;
VTX_ANTENNA_BEND = 14;
VTX_ANTENNA_SHELF_HEIGHT = 6;
VTX_PROTECTOR_WIDTH = 3.1;
VTX_PROTECTOR_ANGLE = 20;
VTX_PROTECTOR_HEIGHT = 2.5;



$fn = 128;
//frame_skeleton(STANDOFF_DISTANCE, STANDOFF_DIAMETER, STANDOFF_HEIGHT);
vtx_holder(STANDOFF_DISTANCE, STANDOFF_DIAMETER, MOUNTH_HEIGHT, VTX_WIDTH, VTX_HEIGHT_1, VTX_HEIGHT_2_ANTENNA, TOLERANCE);        

module vtx_holder(standoff_distance, standoff_diameter, mount_height, vtx_width, vtx_height_1, vtx_height_2_antenna, tolerance) {
    
    shelf_depth = 14.5;
    shelf_depth_outside = 10.5;
    shelf_height = 0.9;
    vtx_trace_height = 1.8;

    union(){
        difference(){
            holder(standoff_distance, standoff_diameter, mount_height, tolerance);

            translate([0,-vtx_width,0])    
            cube([vtx_width, 3*vtx_width, 3*mount_height], true);  
                      
        }
        translate([0,-standoff_distance/2+shelf_depth/2, shelf_height/2])
        cube([vtx_width, shelf_depth, shelf_height], true);     
   
        translate([0,-standoff_distance/2-shelf_depth_outside/2, shelf_height/2])       
        cube([vtx_width, shelf_depth_outside, shelf_height], true);         

        translate([0,-standoff_distance/2+VTX_TRACE_LENGTH/2-shelf_depth_outside, shelf_height+vtx_trace_height])
        vtx(vtx_trace_height);   
        
        //Antenna holder
        translate([0,-standoff_distance/2-shelf_depth_outside/2-standoff_diameter, shelf_height/2])        
        antenna_protector();
        
        //Zip tie holder
        translate([0,-5,shelf_height/2])
        ziptie_holder();     
    }    
}

module ziptie_holder(){
    shelf_height = 0.9;    
    holder_width = 20;
    zip_tie = 2.8;

    difference(){
        cube([holder_width,zip_tie*2,shelf_height],true);              
        cube([holder_width*2,zip_tie,shelf_height*2],true);                      
    }
}

module antenna_protector(){
    shelf_height = 0.9;    
    
    
    difference(){             
        union(){
            translate([VTX_ANTENNA_SHIFT, -VTX_ANTENNA_BEND, VTX_ANTENNA_SHELF_HEIGHT/2-shelf_height/2])
            cylinder(VTX_ANTENNA_SHELF_HEIGHT, 4.5/2, 4.5/2, true);    
//            cube([4.2, 4.2, VTX_ANTENNA_SHELF_HEIGHT], true);                        
            
            translate([VTX_ANTENNA_SHIFT-VTX_PROTECTOR_WIDTH,-VTX_ANTENNA_BEND/2,VTX_PROTECTOR_HEIGHT/2-shelf_height/2])
            rotate([0,0,VTX_PROTECTOR_ANGLE])
            cube([1.5, VTX_ANTENNA_BEND*1.2, VTX_PROTECTOR_HEIGHT], true);            
            

            translate([VTX_ANTENNA_SHIFT+VTX_PROTECTOR_WIDTH,-VTX_ANTENNA_BEND/2,VTX_PROTECTOR_HEIGHT/2-shelf_height/2])            
            rotate([0,0,-VTX_PROTECTOR_ANGLE])
            cube([1.5, VTX_ANTENNA_BEND*1.2, VTX_PROTECTOR_HEIGHT], true);
        };       

        translate([VTX_ANTENNA_SHIFT, -VTX_ANTENNA_BEND, VTX_ANTENNA_SHELF_HEIGHT/2-shelf_height/2])
        cylinder(VTX_ANTENNA_SHELF_HEIGHT*2, 2.4/2, 2.4/2, true);     
//        cube([2, 2, VTX_ANTENNA_SHELF_HEIGHT*2], true);                                
 
        translate([VTX_ANTENNA_SHIFT, -VTX_ANTENNA_BEND, VTX_ANTENNA_SHELF_HEIGHT-1])      
        rotate([-30,0,0])
        cube([2.2, 10, 4], true);                
    }    
}

module holder(standoff_distance, standoff_diameter, mount_height, tolerance) {
    mount_diameter = standoff_diameter + 2;
    mount_depth = 2;
    mount_offset = -2;
    
    

    angle_step = 90;
    number_of_bridges = 1;

    translate([0, 0, mount_height/2])
    
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
    
//            translate([-10,-5,0])
//            rotate([0,0,70])
//            bridge(standoff_distance-6, mount_depth, mount_height, standoff_diameter, mount_offset, tolerance, true);                
//             
//            translate([10,-5,0])
//            rotate([0,0,290])
//            bridge(standoff_distance-6, mount_depth, mount_height, standoff_diameter, mount_offset, tolerance, true);                             
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

module vtx(h)
{
    
  HEIGHT = 2;
  fudge = 0.1;
  //From INKSCAPE
    
  SCALE = 3.58;
  translate([0,0,HEIGHT/2])
  rotate([0,180,180])    
  scale([SCALE,SCALE,HEIGHT])    
  scale([25.4/90, -25.4/90, 1]) union()
  {
    difference()
    {
       linear_extrude(height=h)
         polygon([[-8.674923,-12.135435],[-8.674923,-3.728712],[-8.674923,-2.746859],[-4.376478,-2.746859],[-4.376478,-2.634721],[-4.376478,1.861645],[-2.013831,1.861645],[-2.013831,3.869275],[-4.340304,3.869275],[-4.340304,3.560249],[-8.275981,3.560249],[-8.275981,3.567483],[-8.606711,3.567483],[-8.606711,12.106497],[-5.498372,12.106497],[-5.498372,10.396008],[-5.498372,9.813613],[-5.048271,9.813613],[-4.428154,9.813613],[-4.428154,9.381598],[-3.728455,9.381598],[-3.728455,6.487718],[-3.975986,6.487718],[-3.975986,6.479966],[-5.711280,6.479966],[-5.711280,8.034912],[-7.299296,8.034912],[-7.299296,5.429385],[-7.299296,4.503343],[-5.711280,4.503343],[-2.404504,4.503343],[-2.404504,4.602562],[-2.404504,5.429385],[-2.404504,7.744489],[-2.418458,7.744489],[-2.418458,8.329983],[0.273367,8.329983],[0.273367,9.133551],[0.951362,9.133551],[0.951362,9.736616],[0.951362,10.001200],[0.951362,10.787197],[2.505789,10.787197],[2.505789,10.001200],[4.319116,10.001200],[4.319116,10.298856],[4.970238,10.298856],[4.970238,6.775040],[5.746419,6.775040],[7.698753,6.775040],[7.698753,12.135435],[8.650118,12.135435],[8.650118,6.775040],[8.650118,2.456958],[8.650118,2.308130],[8.650118,0.968158],[8.650118,-1.984116],[8.674923,-1.984116],[8.674923,-12.059470],[8.599990,-12.059470],[8.599990,-12.065153],[4.444688,-12.065153],[0.104902,-12.065153],[0.104902,-7.004481],[-4.126365,-7.004481],[-4.126365,-12.135435],[-8.674923,-12.135435]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[4.444688,-7.651988],[7.898741,-7.651988],[7.898741,-3.962807],[7.002155,-3.962807],[7.002155,0.633812],[0.289388,0.633812],[0.289388,-1.861127],[0.255281,-1.861127],[0.255281,-3.682204],[4.444172,-3.682204],[4.444172,-4.838205],[4.444172,-7.004481],[4.444688,-7.651988]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-1.462961,-4.464068],[-0.216008,-4.464068],[-0.216008,-3.682204],[-0.216008,-1.861127],[-1.462961,-1.861127],[-1.462961,-4.464068]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[4.192508,2.456958],[5.746419,2.456958],[5.746419,5.311047],[4.970238,5.311047],[4.749064,5.311047],[4.319116,5.311047],[4.192508,5.311047],[4.192508,2.456958]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-1.426271,4.640802],[3.894852,4.640802],[3.894852,5.311047],[3.861779,5.311047],[3.861779,9.067406],[2.075841,9.067406],[2.075841,8.141364],[1.182873,8.141364],[1.182873,7.744489],[-1.426271,7.744489],[-1.426271,4.640802]]);
    }
  }
}
