{
#ifdef SIM_PLANE
    vec2 coords = vUv*2.0 - 1.0;
    vec3 targetPos = vec3(coords.x, 0.0, coords.y);
    targetPos *= 3.0;
#endif

#ifdef SIM_SPHERE
    // sphere, continuous along vUv.y
    vec2 coords = vUv;
    coords.x = coords.x * M_2PI - M_PI; // theta (lat)
    coords.y = coords.y * M_PI;         // phi (long)
    vec3 sphereCoords = vec3(
        sin(coords.y) * cos(coords.x),
        cos(coords.y),
        sin(coords.y) * sin(coords.x)
    );

    float r = 1.0;
    vec3 targetPos = r * sphereCoords;
    targetPos *= 2.0;
#endif

#ifdef SIM_BALL
    // sphere coords, rand radius, offset y+0.5 for snoise vel
    vec2 coords = vUv;
    coords.x = coords.x * M_2PI - M_PI;
    coords.y = coords.y * M_PI;
    vec3 sphereCoords = vec3(
        sin(coords.y) * cos(coords.x),
        cos(coords.y),
        sin(coords.y) * sin(coords.x)
    );
    vec3 targetPos = sphereCoords * rand(vUv);
    targetPos *= 2.0;
#endif

#ifdef SIM_CUBE
    vec3 targetPos = vec3(vUv.x, vUv.y, rand(vUv)) * 2.0 - 1.0;
    targetPos *= 2.0;
#endif

#if defined(SIM_PLANE) || defined(SIM_SPHERE) || defined(SIM_BALL) || defined(SIM_CUBE)
    vec3 toCenter = targetPos - currPos;
    float toCenterLength = length(toCenter);
    if (!EQUALSZERO(toCenterLength))
        accel += uShapeAccel * toCenter/toCenterLength;
#endif
}