$fn=124;

//case dimensions are for internal space 
width=160;
depth=135;
frontHeight=36;
backHeight=52;
wallThickenes=3;




render_all();
module render_all() {    
   top();
   bottom();  
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
        linear_extrude(height = width+2*wallThickenes) polygon( points=[[0,0],[0,backHeight+wallThickenes],[0+5,backHeight+5+wallThickenes],[depth+wallThickenes*2-5,frontHeight+wallThickenes+5], [depth+wallThickenes*2,frontHeight+wallThickenes],[depth+wallThickenes*2,0]]);
        translate([0+5,backHeight+wallThickenes,0]) cylinder(h = width+2*wallThickenes, r1 = 5, r2 = 5, center = false);
        translate([depth+wallThickenes*2-5,frontHeight+wallThickenes,0]) cylinder(h = width+2*wallThickenes, r1 = 5, r2 = 5, center = false);
    }
}


//case_cut();
module case_cut() {
    translate([wallThickenes,wallThickenes,0]) 
    difference() {
        union() {
              scale([depth/(depth+2*wallThickenes),width/(width+2*wallThickenes),(backHeight+5)/(backHeight+5+wallThickenes)-0.014]) case_base();
            //add a bottom part so that it properly cuts bottom
            translate([0,0,-2]) cube([depth,width, 3]);
            
        }
       translate([-1,-1,wallThickenes]) cube([10,10,backHeight+5]);
       translate([-1,1+width-10,wallThickenes]) cube([10,10,backHeight+5]);
       translate([depth-10+1,-1,wallThickenes]) cube([10,10,frontHeight+5]);
       translate([depth-10+1,1+width-10,wallThickenes]) cube([10,10,frontHeight+5]);
    }
}