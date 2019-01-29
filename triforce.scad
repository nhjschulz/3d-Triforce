// Copyright(c) 2019 Norbert Schulz
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

// A 3D-Triforce that looks like a triangular pyramid
// Developed with OpenSCAD 15.03-2 http://www.openscad.org/
//

// Parameters
//
edge_length = 100.0;            // distance from corner to corner
frame_width = 5.0;              // frame thickness
frame_standout = 5.0;           // standout the frame, try same as frame_width

// ------------------Helper functions ----------------------------------------

// Height of tetrahedron
//
function tetrahedron_height(size) = sqrt(6.0) * size / 3.0;

// height of equilateral triangle
//
function equilateral_triangle_height(size) = sqrt(3.0) * size / 2.0;

// center point based of tetrahedron
//
function tetrahedron_center(size) =
    [
        size / 2.0,
        sqrt(12) * size / 12.0,
        sqrt(12) * size / 12.0
    ];

// tetrahedron corners:
// p0-p1-p2 build an equilateral triangle with
//  p0: in origin
//  p1: on x-axis,
//  p2: inside quadrant I
//
// p3 = in z-dimension over center
//
function tetrahedron_corners(size) =
    [
       [ 0.0, 0.0, 0.0 ],
       [ size, 0.0, 0.0 ],
       [ tetrahedron_center(size)[0], equilateral_triangle_height(size) , 0.0 ],
       [ tetrahedron_center(size)[0], tetrahedron_center(size)[1], tetrahedron_height(size) ],
    ];


// Distance between 2 points
//
function dist(p1,p2) = sqrt(pow(p2[0]-p1[0],2) + pow(p2[1]- p1[1],2) +pow(p2[2]-p1[2],2));


// ------------------Module section  -----------------------------------------


// Tetrahedron is a 3 sided pyramid made from equilateral triangles.
//
module tetrahedron(size = 100)
{
    // polyhedron faces spawn by the given corners
    connections =
        [
            [ 0, 1, 2 ],    // bottom
            [ 0, 2, 3 ],    // left
            [ 1, 2, 3 ],    // right
            [ 0, 1, 3 ]     // front
        ];

    hull() polyhedron( points = tetrahedron_corners(size), faces = connections);
}

// Build a tetrahedron frame to generate solid joints between the triforce parts
// The frame is build by placing small tetrahedrons with hull width in each
// corner and then join the the convex hulls of each line together.
// By setting standout you can make the fame stick out of the triangles.
// This gives the triforce a nicer 3D look, but makes it a lot harder to print
// as no even surfaces exists anymore that can be put onto the build plate.
//
module tetrahedron_frame(size=100, width = 2.0, standout = 0.0)
{
    corner = tetrahedron_corners(size);
    corner_standout = tetrahedron_corners(size + standout);

    frame_height = tetrahedron_height(width);

    union() {

        hull() { // P0->P1
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[0][0],
                 corner[0][1],
                 corner[0][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[1][0] - width,
                 corner[1][1],
                 corner[1][2]])
            {
                tetrahedron(size = width);
            }

            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[0][0],
                 corner_standout[0][1],
                 corner_standout[0][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[1][0] - width,
                 corner_standout[1][1],
                 corner_standout[1][2]])
            {
                tetrahedron(size = width);
            }

        }

        hull() { // P0->P2
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[0][0],
                 corner[0][1],
                 corner[0][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[2][0] - width / 2.0,
                 corner[2][1] - equilateral_triangle_height(width),
                 0.0])
            {
                tetrahedron(size =width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[0][0],
                 corner_standout[0][1],
                 corner_standout[0][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[2][0] - width / 2.0,
                 corner_standout[2][1] - equilateral_triangle_height(width),
                 0.0])
            {
                tetrahedron(size =width);
            }
        }

        hull() { // P1->P2
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[1][0]- width,
                 corner[1][1],
                 corner[1][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[2][0] - width / 2.0,
                 corner[2][1] - equilateral_triangle_height(width),
                 corner[2][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[1][0]- width,
                 corner_standout[1][1],
                 corner_standout[1][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[2][0] - width / 2.0,
                 corner_standout[2][1] - equilateral_triangle_height(width),
                 corner_standout[2][2]])
            {
                tetrahedron(size = width);
            }
        }

        hull() { // P0->P3
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[0][0],
                 corner[0][1],
                 corner[0][2]])
            {
               tetrahedron(size = width);
            }
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[3][0] - tetrahedron_center(width)[0],
                 corner[3][1] - tetrahedron_center(width)[1],
                 corner[3][2] - frame_height])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[0][0],
                 corner_standout[0][1],
                 corner_standout[0][2]])
            {
               tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[3][0] - tetrahedron_center(width)[0],
                 corner_standout[3][1] - tetrahedron_center(width)[1],
                 corner_standout[3][2] - frame_height])
            {
                tetrahedron(size = width);
            }
        }

        hull() { // P1->P3
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[1][0] - width,
                 corner[1][1],
                 corner[1][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[3][0] - tetrahedron_center(width)[0],
                 corner[3][1] - tetrahedron_center(width)[1],
                 corner[3][2] - frame_height])
            {
                tetrahedron(size=width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[1][0] - width,
                 corner_standout[1][1],
                 corner_standout[1][2]])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[3][0] - tetrahedron_center(width)[0],
                 corner_standout[3][1] - tetrahedron_center(width)[1],
                 corner_standout[3][2] - frame_height])
            {
                tetrahedron(size=width);
            }
        }

        hull() { // P2->P3
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[2][0] - width / 2.0,
                 corner[2][1] - equilateral_triangle_height(width),
                 corner[2][2]])
            {
                tetrahedron(size=width);
            }
            translate(tetrahedron_center(size) * -1.0)
            translate(
                [corner[3][0] - tetrahedron_center(width)[0],
                 corner[3][1] - tetrahedron_center(width)[1],
                 corner[3][2] - frame_height])
            {
                tetrahedron(size = width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[2][0] - width / 2.0,
                 corner_standout[2][1] - equilateral_triangle_height(width),
                 corner_standout[2][2]])
            {
                tetrahedron(size=width);
            }
            translate(tetrahedron_center(size + standout) * -1.0)
            translate(
                [corner_standout[3][0] - tetrahedron_center(width)[0],
                 corner_standout[3][1] - tetrahedron_center(width)[1],
                 corner_standout[3][2] - frame_height])
            {
                tetrahedron(size = width);
            }
        }
    }
}

// build the triforce
//
module triforce(length, fwidth, fextra = 0.0)
{
    translate(tetrahedron_center(length+fextra))
    union() {

        // frame structure
        tetrahedron_frame(size = length, width = fwidth, standout=fextra);

        // triangles
        translate(tetrahedron_center(length) * -1.0)
        union() {
            // bottom 3 triangles
            tetrahedron(size = length / 2.0);
            translate(
                [corner[1][0] - length / 2.0 - fextra,
                 corner[1][1],
                 0.0])
            {
                tetrahedron(size = length / 2);
            }

            translate(
                [corner[0][0] + length / 4.0,
                 equilateral_triangle_height(length / 2.0),
                 0.0])
            {
                tetrahedron(size=length / 2);
            }

            // top one
            translate(
                [corner[0][0] + length / 4.0,
                 tetrahedron_center(length / 2.0)[1],
                 tetrahedron_height(length / 2,0)])
            {
                tetrahedron(size = length / 2.0);
            }
        }
    }
}

echo ("Triforce dimensions :");
corner = tetrahedron_corners(edge_length);
echo("p0=", corner[0]);
echo("p1=", corner[1]);
echo("p2=", corner[2]);
echo("p3=", corner[3]);

echo("p0->p1", dist(corner[0], corner[1]));
echo("p1->p2", dist(corner[1], corner[2]));
echo("p2->p0", dist(corner[2], corner[0]));

echo("p0->p3", dist(corner[0], corner[3]));
echo("p1->p3", dist(corner[1], corner[3]));
echo("p2->p3", dist(corner[2], corner[3]));

if (frame_standout != 0.0)
{
    triforce(length = edge_length - frame_standout, fwidth = frame_width, fextra = frame_standout);
} else {
    triforce(length = edge_length, fwidth = frame_width, fextra = frame_standout);
}
