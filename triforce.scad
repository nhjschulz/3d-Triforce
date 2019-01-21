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

// 3D-Triforce that looks like a triangular pyramid

// Parameters
//
edge_length = 100.0;
frame_width = 4;


// height of tetrahedron
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
//
module tetrahedron_frame(size=100, width = 2.0)
{
    corner = tetrahedron_corners(size);
    frame_height = tetrahedron_height(width);

    union() {

        hull() { // P0->P1
            translate(
                [corner[0][0],
                 corner[0][1],
                corner[0][2]])
            {
                tetrahedron(size = width);
            }
            translate(
                [corner[1][0] - width,
                 corner[1][1],
                 corner[1][2]])
            {
                tetrahedron(size = width);
            }
        }

        hull() { // P0->P2
            translate(
                [corner[0][0],
                 corner[0][1],
                 corner[0][2]])
            {
                tetrahedron(size = width);
            }
            translate(
                [corner[2][0] - width / 2.0,
                 corner[2][1] - frame_height,
                 0.0])
            {
                tetrahedron(size =width);
            }
        }

        hull() { // P1->P2
            translate(
                [corner[1][0]- width,
                 corner[1][1],
                 corner[1][2]])
            {
                tetrahedron(size = width);
            }
            translate(
                [corner[2][0] - width / 2.0,
                 corner[2][1] - frame_height,
                 corner[2][2]])
            {
                tetrahedron(size = width);
            }
        }

        hull() { // P0->P3
            translate(
                [corner[0][0],
                 corner[0][1],
                 corner[0][2]])
            {
               tetrahedron(size = width);
            }
            translate(
                [corner[3][0] - tetrahedron_center(width)[0],
                 corner[3][1] - tetrahedron_center(width)[1],
                 corner[3][2] - frame_height])
            {
                tetrahedron(size = width);
            }
        }

        hull() { // P1->P3
            translate(
                [corner[1][0]-width, corner[1][1], corner[1][2]])
            {
                tetrahedron(size = width);
            }
            translate(
                [corner[3][0] - tetrahedron_center(width)[0],
                 corner[3][1] - tetrahedron_center(width)[1],
                 corner[3][2] - frame_height])
            {
                tetrahedron(size=width);
            }
        }

        hull() { // P2->P3
            translate(
                [corner[2][0] - width / 2.0,
                 corner[2][1] - frame_height,
                 corner[2][2]])
            {
                tetrahedron(size=width);
            }
            translate(
                [corner[3][0] - tetrahedron_center(width)[0],
                 corner[3][1] - tetrahedron_center(width)[1],
                 corner[3][2] - frame_height])
            {
                tetrahedron(size = width);
            }
        }
    }
}

function dist(p1,p2) = sqrt( pow(p1[0]-p2[0], 2) + pow(p1[1]-p2[1], 2) + pow(p1[2]-p2[2], 2) );

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

// build the triforce
//
union() {

    // frame structure
    tetrahedron_frame(size = edge_length, width = frame_width);

    // bottom 3 triangles
    tetrahedron(size = edge_length / 2.0);
    translate(
        [corner[1][0] - edge_length / 2.0,
         corner[1][1],
         0.0])
    {
        tetrahedron(size = edge_length / 2);
    }
    translate(
        [corner[0][0] + edge_length / 4.0,
         equilateral_triangle_height(edge_length / 2.0),
         0.0])
    {
        tetrahedron(size=edge_length / 2);
    }

    // top one
    translate(
        [corner[0][0] + edge_length / 4.0,
         tetrahedron_center(edge_length / 2.0)[1],
         tetrahedron_height(edge_length / 2,0)])
    {
         tetrahedron(size = edge_length / 2.0);
    }
}
