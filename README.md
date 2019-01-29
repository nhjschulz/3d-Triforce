# 3D-Triforce

A mathematical correct tetrahedron Triforce made with OpenSCAD for 3D-printing

![Rendered 3D-Triforce Structure](/docs/triforce.png "Rendered 3D-Triforce Structure")

The used OpenSCAD version was  2015.03-2.

## Parameters
The script uses the following parameters add its beginning to modify the model.
Dimensions are in millimeter.

| Parameter     | Default |  Description                                         |
| ------------- |:-------:| --------------------------------------------------- :|
| edge_length   | 100.0   | The length of a tetrahedron edge.                    |
| frame_width   | 5.0     | The length for a frame edge                          |
| frame_standout| 5.0     | How much the edge is "extruded" out of the tri-force.|

The default parameters provide this model with a small frame to give it a 
3D-look:

	![Default settings with frame (triforce_framed_10cm.stl "10cm wide with 3D-frame")

Setting frame_standout to 0.0 gives a plain triforce where the frame only joins the 
tetrahedrons together:

	![STL result without frame standout (triforce_10cm.stl "10cm wide without 3D-frame")

Playing with frame_standout can create other interesting 3D-Models. Here is an example
with a huge frame_standout value of 36.0 mm:

	![STL result without frame standout (triforce_frame36_10cm.stl "10cm wide with large frame")

	
## Printing Recommendations

Print with supports enabled. My recommended Cura slicer settings are

 * Support Placement: Everywhere
 * Support Overhang Angle: 50
 * Support Pattern: Concentric
 
Setting the Outer Wall Line Count to 5 also creates more sturdiness and prevents
the infill from shining through. 