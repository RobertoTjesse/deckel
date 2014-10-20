// exakte Rohrmasse> aussen 28.6, innen 23,9

// TODO: ist das weit genug? Haengt vom Material ab.

rohraussen = 28.6;
rohrinnen = 23.9;
deckeldicke = 2.5; // die Raendelmutter braucht etwa 2.5mm von Gewinde plus Deckel gibt 5.0. Und das Gewinde hat 5.6
deckelhoehe = 7.5;
randstaerkeinnen = 1.5;
randstaerkeaussen = 3.6;
spacerinnen=29;
spaceraussen=36;
toleranz = 0.2;
knopfdurchmesser = 23.7; // mit Rand
potidurchmesser = 12.5;
innenknopfdurchmesser = 21;
poticenter = (rohrinnen-potidurchmesser)/2 - toleranz;
kabeldicke=3.3;
m7=7;

$fa=0.1;
$fs=0.5;

module voll() {
	difference() {
		intersection() {
	 		cylinder(h=1000, r=spaceraussen/2,center=true);
			translate([0,0,deckelhoehe-0.001]) rotate([180,0,0]) cylinder(h=1000, r=spaceraussen/2);
			union() {
				cylinder(h=deckelhoehe, r=spaceraussen/2);
				translate([-105,0,5]) rotate([0,70,0]) cylinder(h=100, r=40);
			}
		} 
		translate([poticenter,0,0.01]) rotate([0,180,0]) cylinder(h=10, r=knopfdurchmesser/2);
	};
};

module markers() {
	// temporaere Marker fuer Knopf
	translate([poticenter,0,0]) cylinder(0.2,r=innenknopfdurchmesser/2);
	translate([poticenter,0,2]) cylinder(3,r=potidurchmesser/2);
};

difference() {
	voll();
translate([0,0,deckeldicke]) difference()
{
	cylinder(deckelhoehe-deckeldicke, r=rohraussen/2);
	cylinder(deckelhoehe-deckeldicke, r=(rohrinnen-toleranz)/2);
}
	translate([poticenter,0,0]) cylinder(deckelhoehe, r=m7/2); // Loch M7 Gewinde
	translate([poticenter,0,deckeldicke]) cylinder(deckelhoehe-deckeldicke, r=12.5/2+toleranz); // so breit ist das Poti am Fuss
	translate([0,0,deckeldicke]) cylinder(deckelhoehe-deckeldicke, r=(rohrinnen-toleranz)/2 - randstaerkeinnen);

	// und ein Kabelloch. Mache den Lochzylinder ein bisschen zu lang, weil sonst das Innenloch wegen der Kruemmung nicht vollstaendig ist.
	rotate([0,-20,20]) translate([0,0,2+deckeldicke]) rotate([0,-90,0]) cylinder(1100, r=kabeldicke/2);

	markers();

	// und ein Loch fuer die LED 3mm. Die von Conrad bestellte hat 2.9 und Rand 3.1
	translate([-8,0,-40]) cylinder(100, r=1.45);

}


