function DCM = DCMeci2pq(w,inc,raan)


DCM_w = [ cos(w),     sin(w),     0;
         -sin(w),    cos(w),     0;
         0,               0,             1];

DCM_inc = [1 , 0 , 0;
        0 , cos(inc), sin(inc);
        0 , -sin(inc), cos(inc) ];

DCM_raan = [ cos(raan),     sin(raan),     0;
            -sin(raan),    cos(raan),     0;
            0,               0,             1];

DCM = DCM_w*DCM_inc*DCM_raan;

end

