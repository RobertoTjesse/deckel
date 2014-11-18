// exakte Rohrmasse> aussen 28.6, innen 23,9

// Dieser Script passt für Trinckle Kunststoff-Sinter. Das ist aber
// nicht ausreichend wasserdicht.


rohraussen = 28.6;
rohrinnen = 23.9;
deckeldicke = 2.5; // die Raendelmutter braucht etwa 2.5mm von Gewinde plus Deckel gibt 5.0. Und das Gewinde hat 5.6
deckelhoehe = 7.5;
randstaerkeinnen = 2.1;
randstaerkeaussen = 3.6;
spacerinnen=29;
spaceraussen=36;
vorbaudicke=33.5;
toleranz = 0.1;
knopfdurchmesser = 20.5;
potidurchmesser = 12.5;
poticenter = (rohrinnen-potidurchmesser)/2 - 1;
kabeldicke=3.3;
kabelaussenradius=10; // enger sollte ich nicht
innenbereich=rohrinnen-toleranz*2 - randstaerkeinnen*2;

m7=7;

$fa=0.1;
$fs=0.5;
$fn=100;

module kabelkanal() {
	strength=3; // the hull
	rotate_extrude(convexity=10)
		translate([kabelaussenradius,0,0])
			circle(d=kabeldicke+strength*2);
};

module kabel() {
	translate([-12.2,-8,9.3])
		rotate([0,90,110])
			rotate_extrude(convexity=10)
				translate([kabelaussenradius,0,0])
					circle(d=kabeldicke);
};

module oring() {
	// mache 2.0. Exakte Wunschgrösse Mitte Durchmesser 26.25mm
	gummidicke=2.0;
	color("black")
	translate([0,0,deckeldicke+gummidicke/2])
	rotate_extrude(convexity=10)
		translate([(rohraussen + rohrinnen)/4,0,0])
			circle(d=gummidicke);
};

//	translate([-13,-4,11.3]) rotate([0,90,110]) kabelkanal();
module voll() {
	union() {
	difference() {
		intersection() {
			union() {
				// der Hauptkoerper:
				cylinder(h=deckelhoehe, d=spaceraussen);
				translate([-12.2,-8,9.3]) rotate([0,90,110]) kabelkanal();
			}
			// säge ab, was wir vom Kabelkanal nicht wollen
			translate([0,0,deckelhoehe-0.001]) rotate([180,0,0]) cylinder(h=1000, d=spaceraussen);
		} 
	};
}
};

module ohneloecher() {
	difference() {
		voll();
		// die Rohraufnahme
		translate([0,0,deckeldicke]) difference()
		{
			cylinder(deckelhoehe-deckeldicke, d=rohraussen+toleranz);
			cylinder(deckelhoehe-deckeldicke, d=rohrinnen-toleranz);
		}
		// Innenbereich
		translate([0,0,deckeldicke])
			cylinder(deckelhoehe-deckeldicke, d=innenbereich);
	}
};

module markers() {
	// temporaerer Marker fuer Knopf
	translate([poticenter,0,0]) cylinder(0.2,d=knopfdurchmesser);
	// und innen für den Potikörper
	translate([poticenter,0,2]) cylinder(3,d=potidurchmesser);
};

module led() {
	// und ein Loch fuer die LED 3mm. Die von Conrad bestellte hat 2.9 und Rand 3.1.
	// Ihr schmaler Teil ist 2.9x3.28mm, der Sockel hat 3.1x1.02mm. Sie steht also
	// bei deckeldicke 2.5mm um 0.4mm über.
	rotate([0,0,160]) translate([(innenbereich-3.1)/2,0,0]) cylinder(100, d=2.9);
};

module poti() {
	// Loch fuer das Poti: Gewinde M7
	translate([poticenter,0,0]) cylinder(deckelhoehe, d=m7);

	// Platz fuer Potikoerper
	translate([poticenter,0,deckeldicke])
		cylinder(deckelhoehe-deckeldicke, d=potidurchmesser+toleranz*2);

	// Platz fuer Potideckel
	translate([poticenter,0,-100])
		cylinder(100, d=knopfdurchmesser);
};

module henkel() {
	// um daran den Forumslader aufzuhängen, evtl. mit einer Feder.
	henkeldicke = 3;
	intersection() {
		translate([-3,5.5,3])
			rotate([0,90,165])
				rotate_extrude(convexity=10)
					translate([4,0,0])
						circle(d=henkeldicke);
		// schneide ab, was oben vom Kreis rausguckt
		// die 0.2 sind wegen dem Marker für den Knopf
		translate([-50,-50,0.2])
			cube(size=[100,100,100]);
	}
};

module knopf() {
	difference() {
		ohneloecher();
		kabel();
		poti();
		led();
//		markers();
	}
	henkel();
//	oring();
};

knopf();

