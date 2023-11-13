//-----------------------------------------------------------------------------------------
// Case
//
// Copyright (C) Stojos
//-----------------------------------------------------------------------------------------
// This program is free software: you can redistribute it and/or modify it under the terms
// of the GNU General Public License as published by the Free Software Foundation, either 
// version 3 of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program.
// If not, see <https://www.gnu.org/licenses/>.
//-----------------------------------------------------------------------------------------

$fn=124;

//-----------------------------------------------------------------------------------------
// Case dimensions
// NOTE: Case dimensions are for internal space and therefore :
//  - outside width is width + 2 * wallThickenes (left and right walltickness)
//  - ouside depth  is depth + 2 * wallThickenes (front and rear wall tickness)
//  - outside back height is backHeight + wallThickenes + wallThickenes/sin(90-slopeAngle)
//  - outside front height is frontHeight + wallThickenes + wallThickenes/sin(90-slopeAngle)
//-----------------------------------------------------------------------------------------
width=100;
depth=100;
frontHeight=30;
backHeight=40;
wallThickenes=3;
edgeRadius=10;
//-----------------------------------------------------------------------------------------
// End of Case dimensions defintion
//-----------------------------------------------------------------------------------------

// helpfull calcualations
heightDiff = backHeight-frontHeight;
slopeAngle = atan(heightDiff/depth);

echo("angle of slope is: ", slopeAngle);

render_all(assembled=false);

module render_all(assembled=true) {    
   if (!assembled) {
       translate([0,0,10]) top(); } else top();
   if (!assembled) {
    translate([0,0,-10]) bottom(); } else bottom();
}

//top();
module top() {
    difference() {
        case_base(); 
        case_cut();
       
        translate([7.5,7.5,-1]) cylinder(h=12, d=4.5, center=false);
        translate([7.5,width+2*wallThickenes-7.5,-1]) cylinder(h=12, d=4.5, center=false);
        translate([depth+2*wallThickenes-7.5,7.5,-1]) cylinder(h=12, d=4.5, center=false);
        translate([depth+2*wallThickenes-7.5,width+2*wallThickenes-7.5,-1]) cylinder(h=12, d=4.5, center=false);
        
    }
}

//bottom();
module bottom() {
    difference() {
        translate([3.5,3.5,0]) cube([depth-1,width-1,wallThickenes]);

        // main holes for scews that connect bottom to top 
        translate([7.5,7.5,-1]) cylinder(h=12, r1=1.75, r2=1.75, center=false);
        translate([7.5,width+2*wallThickenes-7.5,-1]) cylinder(h=12, d=2.5, center=false);
        translate([depth-1.5,7.5,-1]) cylinder(h=12, d=2.5, center=false);
        translate([depth-1.5,width+2*wallThickenes-7.5,-1]) cylinder(h=12, d=2.5, center=false);
        
        //hole enlargement for screw head
        translate([7.5,7.5,-0.1]) cylinder(h=1.6, r1=2.2, r2=1.4, center=false);
        translate([7.5,width+2*wallThickenes-7.5,-0.1]) cylinder(h=1.6, r1=2.2, r2=1.4, center=false);        
        translate([depth-1.5,7.5,-0.1]) cylinder(h=1.6, r1=2.2, r2=1.4, center=false);
        translate([depth-1.5,width+2*wallThickenes-7.5,-0.1]) cylinder(h=1.6, r1=2.2, r2=1.4, center=false);

    }
}

//case_base();
module case_base() {
    translate([0,width+2*wallThickenes,0]) 
    rotate ([90,0,0])
    hull() { 
        linear_extrude(height = width+2*wallThickenes) 
            polygon( 
                points=[
                    [0,0],
                    [0,
                        wallThickenes
                        +backHeight
                        +wallThickenes/sin(90-slopeAngle)
                        -edgeRadius
                        -(edgeRadius-wallThickenes)*heightDiff/depth],
                    [0+edgeRadius,
                        wallThickenes
                        +backHeight
                        +wallThickenes/sin(90-slopeAngle)
                        -(edgeRadius-wallThickenes)*heightDiff/depth],
                    [depth
                     +wallThickenes*2
                     -edgeRadius,
                        wallThickenes
                        +frontHeight
                        +wallThickenes/sin(90-slopeAngle)
                        +(edgeRadius-wallThickenes)*heightDiff/depth],
                    [depth
                     +wallThickenes*2,
                        wallThickenes
                        +frontHeight
                        +wallThickenes/sin(90-slopeAngle)
                        -edgeRadius
                        +(edgeRadius-wallThickenes)*heightDiff/depth],
                    [depth+wallThickenes*2,0]
                        ]
                );
                
        translate([
            0+edgeRadius,
                wallThickenes
                +backHeight
                +wallThickenes/sin(90-slopeAngle)
                -edgeRadius
                -(edgeRadius-wallThickenes)*heightDiff/depth,
            0])
            cylinder(h=width+2*wallThickenes, r1=edgeRadius, r2=edgeRadius, center = false);
        translate([
            depth+wallThickenes*2-edgeRadius,
                wallThickenes
                +frontHeight
                +wallThickenes/sin(90-slopeAngle)
                -edgeRadius
                +(edgeRadius-wallThickenes)*heightDiff/depth,
            0])
            cylinder(h=width+2*wallThickenes, r1=edgeRadius, r2=edgeRadius, center = false);
    }
}


//case_cut();
module case_cut() {
    translate([wallThickenes,wallThickenes,0])
    difference() {
        union() {
              scale([
                depth/(depth+2*wallThickenes),
                width/(width+2*wallThickenes),
                backHeight/(backHeight+wallThickenes/sin(90-slopeAngle))])             
                case_base();
            //add a bottom part so that it properly cuts bottom
            translate([0,0,-2]) cube([depth,width, 3]);
            
        }
       translate([-1,-1,wallThickenes]) cube([10,10,backHeight+2*wallThickenes]);
       translate([-1,1+width-10,wallThickenes]) cube([10,10,backHeight+2*wallThickenes]);
       translate([depth-10+1,-1,wallThickenes]) cube([10,10,frontHeight+2*wallThickenes]);
       translate([depth-10+1,1+width-10,wallThickenes]) cube([10,10,frontHeight+2*wallThickenes]);
    }
}

//test_dimensions();
module test_dimensions() {
    color("black") translate([wallThickenes, -20, wallThickenes]) 
        translate([0,10,0]) 
            rotate ([90,0,0])
                linear_extrude(height = 10) 
                    polygon( 
                        points=[
                            [0,0],
                            [0,backHeight],
                            [depth,frontHeight],
                            [depth,0]
                        ]
                    );
    color("red") translate([0, -10, 0]) 
        translate([0,10,0]) 
            rotate ([90,0,0])
                linear_extrude(height = 10) 
                    polygon( 
                        points=[
                            [0,0],
                            [0,
                                backHeight
                                +2*wallThickenes
                                -edgeRadius
                                -(edgeRadius-wallThickenes)*heightDiff/depth],
                            [0
                             +edgeRadius,
                                backHeight
                                +2*wallThickenes
                                -(edgeRadius-wallThickenes)*heightDiff/depth],
                            [depth+wallThickenes*2
                             -edgeRadius,
                                frontHeight
                                +2*wallThickenes
                                +(edgeRadius-wallThickenes)*heightDiff/depth],
                            [depth
                             +wallThickenes*2,
                                frontHeight
                                +2*wallThickenes
                                -edgeRadius
                                +(edgeRadius-wallThickenes)*heightDiff/depth],
                            [depth+wallThickenes*2,0]
                        ]
                   );

}