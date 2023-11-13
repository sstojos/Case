# Case
This is a 3D design of a case for devices that are used horizontaly and have controlls and displays on the top. In other words any device that is used by standing on the floor or standing on the table such as guitar pedals, synthisizers, midi controllers etc.

![Case assembled](assets/Case-assembled.png)

It is developed using openscad and therefore easily customzable programaticaly for adding additional items or for cutting the holes for attaching additional hardware and displays.

## Case configurable parameters

The following case parameters can be configured:
- dimesnions such as depth, width, back and front height
- wall thickenes
- radius for front and end edge slope

![Case dimensions](assets/dimensions.png)

Case dimensions for depth, width, back and front height are internal case dimension. 

Internal dimensiosn are used becasue case at teh end is for enclosing somthign insdie it. Therefore case outside dimensiosn are the following:
- outside width is width + 2 * wall thickenes (left and right wall tickness)
- ouside depth  is depth + 2 * wall thickenes (front and rear  wall tickness)
- outside back height is back height + wallThickenes + wallThickenes/sin(90-slopeAngle)
- outside front height is front height + wallThickenes + wallThickenes/sin(90-slopeAngle)

## Main parts

Case consist of top and bottom parts.

![Case dissassembled](assets/Case-dissasembled.png)

### Top part

Top part is made by case_base that is cut by case_cut.

