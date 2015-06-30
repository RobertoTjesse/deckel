/*

Copyright (c) 2014 Wolfgang Rohdewald <wolfgang@rohdewald.de>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.

exakte Rohrmasse> aussen 28.6, innen 23,9

Dieser Script sollte für http://www.fabberhouse.de passen.
Damit habe ich 4 Deckel gemacht, die aber alle mehr oder weniger zu
locker sitzen. Ihre Werte für die Toleranz waren 0.15, 0.20, 0.25,
welches der vierte Wert war, weiss ich leider nicht mehr.

*/

//meine exakten Rohrmasse
rohraussen = 28.6;
rohrinnen = 23.9;

deckeldicke = 2.5;
deckelhoehe = 8.5;
randstaerkeinnen = 2.1;
deckelaussen=33;
toleranz = 0.1;
kabeldicke=3.6;
kabelaussenradius=90;
innenbereich=rohrinnen-toleranz*2 - randstaerkeinnen*2;


m7=7;

$fa=0.1;
$fs=0.5;
$fn=100;

module kanal(durchmesser) {
	kabelkreisY=0;
	kabelkreisZ=1;
	difference() {
		translate([-30,kabelkreisY,11.2-kabelaussenradius])
			rotate([0,90,90])
				rotate_extrude(convexity=10)
					translate([kabelaussenradius,0,-kabelaussenradius])
						circle(d=durchmesser);
		// weil der sonst auf der anderen Knopfseite auch noch durchgeht:
		translate([innenbereich*0.8/2,-50,0]) cube(size=[100,100,deckelhoehe],center=false);
	};
};

module kabelkanal() {
	kanal(durchmesser=kabeldicke+4);
}

module kabel() {
	kanal(durchmesser=kabeldicke);
}

module nofrills2d() {
	ha=deckelhoehe;            // hoehe aussen
	hi=ha-deckeldicke;         // hoehe innen
	ri=innenbereich/2;         // innenbereich
	rri=ri+randstaerkeinnen;   // Rohraufnahme innen
	rra=rohraussen/2;          // Rohraufnahme aussen
	hri=4;
	ra=deckelaussen/2;         // deckelaussen
	kr=4;		   // Randkruemmung
	kele=100;
	kx=ra-kr;
	ky=ha-kr;
	polygon(concat([[0,hi],[ri,hi],[ri,0],[rri,0],[rri,hri],[rra,hri],[rra,0],
		[ra,0],
		// jetzt sind wir aussen unten und gehen erstmal senkrecht rauf
		[kx+kr,ky]],
		[for (i=[0:kele-1]) [kx+kr*cos(90*i/kele),ky+kr*sin(90*i/kele)]],
		[[kx,ky+kr],
		// und Abschluss innen oben
		[0,ha]]));
};

module nofrills() {
	rotate([0,0,0]) rotate_extrude() nofrills2d();
};

module ohneloecher() {
	difference() {
		nofrills();
		// die Rohraufnahme
		translate([0,0,deckeldicke]) difference()
		{
			cylinder(deckelhoehe-deckeldicke, d=rohraussen);
			cylinder(deckelhoehe-deckeldicke, d=rohrinnen);
		}
		// Innenbereich
		translate([0,0,deckeldicke])
			cylinder(deckelhoehe-deckeldicke, d=innenbereich);
	}
};

module knopf() {
	intersection() {
		difference() {
			union() {
				nofrills();
				kabelkanal();
			};
			// Kabel nicht schon in kabelkanal(), weil dann der Durchlass durch den Deckel fehlt
			kabel();
			// Innenbereich vom Rohr freihalten
			translate([0,0,deckelhoehe-deckeldicke])
				rotate([0,180,0]) cylinder(100, d=innenbereich);
		};
		cylinder(h=1000,d=deckelaussen);
	};

};

knopf();
