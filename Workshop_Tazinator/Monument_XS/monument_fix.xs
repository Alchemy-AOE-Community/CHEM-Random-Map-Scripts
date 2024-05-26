const int resource = 14;
int tick = 0;

// int _start = xsArrayCreateFloat(8, 0, "start")
// int _count = xsArrayCreateFloat(8, 0, "count")
// int _end = xsArrayCreateFloat(8, 0, "end")
// int _PrevCount = xsArrayCreateFloat(8, 0, "PrevCount")
// int _PrevEnd = xsArrayCreateFloat(8, 0, "PrevEnd")
float p1_start = 0;
float p1_count = 0;
float p1_end = 0;
float p1_PrevCount = 0;
float p1_PrevEnd = 0;

float p2_start = 0;
float p2_count = 0;
float p2_end = 0;
float p2_PrevCount = 0;
float p2_PrevEnd = 0;

float p3_start = 0;
float p3_count = 0;
float p3_end = 0;
float p3_PrevCount = 0;
float p3_PrevEnd = 0;

float p4_start = 0;
float p4_count = 0;
float p4_end = 0;
float p4_PrevCount = 0;
float p4_PrevEnd = 0;

float p5_start = 0;
float p5_count = 0;
float p5_end = 0;
float p5_PrevCount = 0;
float p5_PrevEnd = 0;

float p6_start = 0;
float p6_count = 0;
float p6_end = 0;
float p6_PrevCount = 0;
float p6_PrevEnd = 0;

float p7_start = 0;
float p7_count = 0;
float p7_end = 0;
float p7_PrevCount = 0;
float p7_PrevEnd = 0;

float p8_start = 0;
float p8_count = 0;
float p8_end = 0;
float p8_PrevCount = 0;
float p8_PrevEnd = 0;

int maxPlayer = 1;

void p1_update(int player = 1)
{
	p1_start = xsPlayerAttribute(player, resource);
	p1_count = p1_PrevCount + p1_start - p1_PrevEnd;

	if (p1_count >= 1) {
		p1_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p1_end = p1_count;
	}

	p1_PrevCount = p1_count;
	p1_PrevEnd = p1_end;

	int p1_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p1_civ + " owns " + 1*p1_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}


void p2_update(int player = 2)
{
	p2_start = xsPlayerAttribute(player, resource);
	p2_count = p2_PrevCount + p2_start - p2_PrevEnd;

	if (p2_count >= 1) {
		p2_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p2_end = p2_count;
	}

	p2_PrevCount = p2_count;
	p2_PrevEnd = p2_end;

	int p2_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p2_civ + " owns " + 1*p2_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}

void p3_update(int player = 2)
{
	p3_start = xsPlayerAttribute(player, resource);
	p3_count = p3_PrevCount + p3_start - p3_PrevEnd;

	if (p3_count >= 1) {
		p3_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p3_end = p3_count;
	}


	p3_PrevCount = p3_count;
	p3_PrevEnd = p3_end;

	int p3_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p3_civ + " owns " + 1*p3_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}

void p4_update(int player = 2)
{
	p4_start = xsPlayerAttribute(player, resource);
	p4_count = p4_PrevCount + p4_start - p4_PrevEnd;

	if (p4_count >= 1) {
		p4_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p4_end = p4_count;
	}

	p4_PrevCount = p4_count;
	p4_PrevEnd = p4_end;

	int p4_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p4_civ + " owns " + 1*p4_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}

void p5_update(int player = 2)
{
	p5_start = xsPlayerAttribute(player, resource);
	p5_count = p5_PrevCount + p5_start - p5_PrevEnd;

	if (p5_count >= 1) {
		p5_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p5_end = p5_count;
	}

	p5_PrevCount = p5_count;
	p5_PrevEnd = p5_end;

	int p5_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p5_civ + " owns " + 1*p5_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}

void p6_update(int player = 2)
{
	p6_start = xsPlayerAttribute(player, resource);
	p6_count = p6_PrevCount + p6_start - p6_PrevEnd;

	if (p6_count >= 1) {
		p6_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p6_end = p6_count;
	}

	p6_PrevCount = p6_count;
	p6_PrevEnd = p6_end;

	int p6_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p6_civ + " owns " + 1*p6_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}

void p7_update(int player = 2)
{
	p7_start = xsPlayerAttribute(player, resource);
	p7_count = p7_PrevCount + p7_start - p7_PrevEnd;

	if (p7_count >= 1) {
		p7_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p7_end = p7_count;
	}

	p7_PrevCount = p7_count;
	p7_PrevEnd = p7_end;

	int p7_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p7_civ + " owns " + 1*p7_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}

void p8_update(int player = 2)
{
	p8_start = xsPlayerAttribute(player, resource);
	p8_count = p8_PrevCount + p8_start - p8_PrevEnd;

	if (p8_count >= 1) {
		p8_end = 1;
		xsEffectAmount(cModResource, resource, cAttributeSet, 1, player);
	}  else {
		p8_end = p8_count;
	}

	p8_PrevCount = p8_count;
	p8_PrevEnd = p8_end;

	int p8_civ = xsGetPlayerCivilization(player);
	xsChatData("Player " + player + " of civilization " + p8_civ + " owns " + 1*p8_count + "monuments, resource14=" + 1*xsPlayerAttribute(player, resource));
}


void main() 
{
	int gaiamonument = 826;
	xsEffectAmount(cGaiaSetAttribute, gaiamonument, cHitpoints, 0); 
	maxPlayer = xsGetNumPlayers();

	// important! set gaia to own 0 monuments
	xsEffectAmount(cModResource, resource, cAttributeSet, 1, 0);

	if (maxPlayer == 2) {
		p1_update(1);
		p2_update(2);
	} else if (maxPlayer == 3) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
	} else if (maxPlayer == 4) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
	} else if (maxPlayer == 5) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
	} else if (maxPlayer == 6) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
		p6_update(6);
	} else if (maxPlayer == 7) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
		p6_update(6);
		p7_update(7);
	} else if (maxPlayer == 8) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
		p6_update(6);
		p7_update(7);
		p8_update(8);
	}
	tick++;
}

rule loop
	active
	// highFrequency
	minInterval 1
	maxInterval 1
{
	if (maxPlayer == 2) {
		p1_update(1);
		p2_update(2);
	} else if (maxPlayer == 3) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
	} else if (maxPlayer == 4) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
	} else if (maxPlayer == 5) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
	} else if (maxPlayer == 6) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
		p6_update(6);
	} else if (maxPlayer == 7) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
		p6_update(6);
		p7_update(7);
	} else if (maxPlayer == 8) {
		p1_update(1);
		p2_update(2);
		p3_update(3);
		p4_update(4);
		p5_update(5);
		p6_update(6);
		p7_update(7);
		p8_update(8);
	}
	tick++;
}

