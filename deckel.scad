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
knopfdurchmesser = 23.7; // mit Rand, sonst 21
poticenter = (spaceraussen-knopfdurchmesser)/2;
poticenter = (rohrinnen-12.5)/2 - toleranz;
kabeldicke=3.05;
m7=7;

//$fa=0.1;
$fs=0.5;

difference() {
	cylinder(h=deckelhoehe, r=spaceraussen/2);
translate([0,0,deckeldicke]) difference()
{
	cylinder(deckelhoehe-deckeldicke, r=rohraussen/2);
	cylinder(deckelhoehe-deckeldicke, r=(rohrinnen-toleranz)/2);
}
	translate([poticenter,0,0]) cylinder(deckelhoehe, r=m7/2); // Loch M7 Gewinde
	translate([poticenter,0,deckeldicke]) cylinder(deckelhoehe-deckeldicke, r=12.5/2+toleranz); // so breit ist das Poti am Fuss
	translate([0,0,deckeldicke]) cylinder(deckelhoehe-deckeldicke, r=(rohrinnen-toleranz)/2 - randstaerkeinnen);

	// und ein Kabelloch. Mache den Lochzylinder ein bisschen zu lang, weil sonst das Innenloch wegen der Kruemmung nicht vollstaendig ist.
	rotate([0,0,20]) translate([-rohrinnen/2+randstaerkeinnen+0.5,0,deckeldicke+kabeldicke/2]) rotate([0,-90,0]) cylinder((spaceraussen-rohrinnen), r=kabeldicke/2);

	// und ein Loch fuer die LED 3mm. Die von Conrad bestellte hat 2.9 und Rand 3.1
	translate([-8,0,0]) cylinder(deckelhoehe-deckeldicke, r=1.45);

}



//	rotate([0,0,0]) translate([0,0,deckeldicke+kabeldicke/2]) rotate([20,-90,0]) cylinder((spaceraussen-rohrinnen)/0.2+1, r=kabeldicke/0.2+0.1);
