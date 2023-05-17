function result = customCross(vector1, vector2)

    result(1) =  vector1(2) * vector2(3) - vector1(3) * vector2(2);
    result(2) = -vector1(1) * vector2(3) + vector1(3) * vector2(1);
    result(3) =  vector1(1) * vector2(2) - vector1(2) * vector2(1);

end