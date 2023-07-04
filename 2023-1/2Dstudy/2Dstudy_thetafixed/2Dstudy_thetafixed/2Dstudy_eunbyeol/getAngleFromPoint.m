function theta = getAngleFromPoint(p1,p2);

vector = p2-p1;
theta = atan2(vector(2),vector(1));