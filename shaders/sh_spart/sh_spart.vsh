/*/
    This is a shader made for use with the sPart system.
    This particular shader simulates primary 3D particles and draws them to screen.
    
    Sindre Hauge Larsen, 2019
    www.TheSnidr.com
/*/
//Attributes
attribute vec4 in_Colour;

//Varyings
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//Batch uniforms
uniform float u_batchInd;
uniform float u_partNum;

//Emitter uniforms
uniform mat4 u_EmStartMat;
uniform mat4 u_EmEndMat;
uniform float u_EmLifeSpan;
uniform float u_EmTimeAlive;
uniform float u_EmShapeDistrBurst;
uniform float u_EmID;
uniform float u_EmPtsPerStep;
uniform float u_EmSector;

//Particle type uniforms
uniform vec4 u_PtDir;
uniform vec4 u_PtSpd;
uniform vec2 u_PtLife;
uniform vec4 u_PtSize;
uniform vec2 u_PtSizeClamp;
uniform vec4 u_PtAngle;
uniform vec3 u_PtGravVec;
uniform bool u_PtAngleRel;
uniform bool u_PtDirRadial;
uniform vec4 u_PtCol[4];
uniform float u_PtColType;
uniform vec2 u_PtSprOrig;
uniform vec4 u_PtSprSettings;

//Noise function
highp vec2 seed = vec2(1.0);
float noise()
{
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt = dot(seed, vec2(a,b));
    highp float sn = mod(dt, 3.14);
    highp float val = fract(sin(sn) * c);
    seed.x += val;
    return val;
}

//Rotation and orientation
vec2 rotate2d(vec2 vec, float angle)
{
    float S = sin(angle);
    float C = cos(angle);
    return mat2(C, -S, S, C) * vec;
}
mat3 axisAngleToMatrix(vec3 axis, float angle) 
{
    float S = sin(angle);
    float C = cos(angle);
    float oc = 1.0 - C;
    return mat3(oc * axis.x * axis.x + C,           oc * axis.x * axis.y - axis.z * S,  oc * axis.z * axis.x + axis.y * S,
                oc * axis.x * axis.y + axis.z * S,  oc * axis.y * axis.y + C,           oc * axis.y * axis.z - axis.x * S,
                oc * axis.z * axis.x - axis.y * S,  oc * axis.y * axis.z + axis.x * S,  oc * axis.z * axis.z + C);
}
vec3 orthogonalize(vec3 vec, vec3 N)
{
    return normalize(vec - N * dot(vec, N));
}

//Simulate particles
float getRadialFactor(float R)
{
    float distr = mod(floor(u_EmShapeDistrBurst * .25), 3.);
    if (distr == 0.){return 1.;} //Linear distribution
    if (distr == 1.){return R * R;} //Gaussian distribution (not exactly, but similar)
    return inversesqrt(R); //Inverse gaussian distribution (not exactly, but similar)
}
vec3 PtGetSpawnPos()
{
    #define SPHERE 3.
    #define CYLINDER 2.
    #define CIRCLE 1.
    #define CUBE 0.
    float shape = mod(u_EmShapeDistrBurst, 4.);
    vec3 randv = vec3(noise(), noise(), noise()) * 2. - 1.;
    if (shape == SPHERE)
    {
        float R = pow(noise(), 1./3.);
        return R * getRadialFactor(R) * vec3(normalize(randv.xy) * sqrt(1. - randv.z * randv.z), randv.z);
    }
    if (shape == CYLINDER)
    {
        float R = sqrt(randv.y);
        randv.x *= u_EmSector;
        return vec3(R * getRadialFactor(R) * vec2(cos(randv.x), sin(randv.x)), randv.z);
    }
    if (shape == CIRCLE)
    {
        randv.x *= u_EmSector;
        return vec3(cos(randv.x), sin(randv.x), randv.z);
    }
    //Cubical if shape == 0
    return getRadialFactor(max(abs(randv.x), max(abs(randv.y), abs(randv.z)))) * randv;
}
vec3 PtGetPosition(float T, vec3 dir0, float spd0, vec4 PtSpeed, vec3 gravVec)
{
    return T * (dir0 * (spd0 + T * (PtSpeed[2] + T * PtSpeed[3])) + T * gravVec);
}
vec3 PtGetDirection(float T, vec3 dir0, float spd0, vec4 PtSpeed, vec3 gravVec)
{
    //Finds the tangent vector of the movement arc at the given time by checking two nearby points. This is more useful than actually using the derived function, since it allows for easily changing the movement function
    vec3 p1 = PtGetPosition(T-.01, dir0, spd0, PtSpeed, gravVec);
    vec3 p2 = PtGetPosition(T+.01, dir0, spd0, PtSpeed, gravVec);
    return normalize(p2 - p1);
}
vec3 PtDeviateVector(vec4 vec)
{
    //Makes a new vector from vec.xyz that may deviate by up to vec.w radians
    vec3 randv = vec3(noise(), noise(), noise()) - .5;
    float randAngle = noise() * vec.w;
    return vec.xyz * cos(randAngle) + sin(randAngle) * orthogonalize(randv, vec.xyz);
}
mat3 PtGetDirMat(vec3 dir)
{
    vec3 toDir = normalize(dir);
    vec3 upDir = orthogonalize(vec3(0.00011, 0.00011, 1.), toDir);
    mat3 dirMat = mat3(toDir, cross(upDir, toDir), upDir);    
    return dirMat;
}
float PtGetRand(vec2 v)
{    //Returns a random value between v.x and v.y
    return mix(v.x, v.y, noise());
}
float PtGetVar(float T, vec3 v)
{    //Returns a random value between v.x and v.y, and increasing by v.z per time
    return mix(v.x, v.y, noise()) + T * v.z;
}
float PtGetVar(float T, vec4 v)
{    //Returns a random value between v.x and v.y, increasing by v.z per time and accelerating by v.w per time
    return mix(v.x, v.y, noise()) + T * (v.z + T * v.w);
}
float PtGetImageIndex(float T, float lifeSpan)
{
    float imgAniSpd = u_PtSprSettings.x;
    float imgRandom = u_PtSprSettings.y;
    float imgNum = u_PtSprSettings.z;
    float imgInd = imgRandom * floor(imgNum * noise());
    if (imgAniSpd < 0.)
    {
        imgInd += floor(T * imgNum / lifeSpan);
    }
    else
    {
        imgInd += floor(T * imgAniSpd);
    }
    return mod(imgInd, imgNum);
}
vec4 PtGetColour(float T)
{
    if (u_PtColType == 0.)
    {
        int colInd = int(floor(noise() * 3. + .5));
        return u_PtCol[colInd];
    }
    float colProgress = T * max(u_PtColType - 1., 0.);
    int colInd = int(colProgress);
    return mix(u_PtCol[colInd], u_PtCol[colInd+1], fract(colProgress));
}

void main()
{
    gl_Position = vec4(0.);
    v_vTexcoord = vec2(0.);
    v_vColour = vec4(0.);
    
    //Reconstruct the particle index from the vertex rgb values
    float basePtInd = dot(vec4(u_batchInd, in_Colour.rgb), vec4(1., 255., 65280./*(256*255)*/, 16711680./*(256*256*255)*/));
    
    //Particle lifetime
    float stream = mod(floor(u_EmShapeDistrBurst / 12.), 2.);
    float PtNum = max(ceil(u_PtLife.y * u_EmPtsPerStep), u_partNum);
    float PtInd = basePtInd + stream * PtNum * floor((u_EmTimeAlive * u_EmPtsPerStep - basePtInd) / PtNum);
    float PtStartTime = PtInd / u_EmPtsPerStep;
    float PtTimeAlive = u_EmTimeAlive - PtStartTime;
    
    //Set the random seed to a 2D vector where the first value is unique for this Em, and the second value is unique for this particle
    seed = vec2(u_EmID, mod(PtInd, 100000.));
    float PtLifeSpan = PtGetRand(u_PtLife);
    
    //If this particle has been spawned and has not died yet
    if ((PtTimeAlive > 0.) && (PtTimeAlive < PtLifeSpan) && (PtStartTime >= 0.) && (PtStartTime < u_EmLifeSpan))
    {
        //Find current position of the particle
        vec3 spawnPos = PtGetSpawnPos();
        float amount = PtStartTime / u_EmLifeSpan;
        mat4 EmMat = u_EmStartMat * (1. - amount) + u_EmEndMat * amount;
        vec3 EmScale = vec3(length(EmMat[0].xyz), length(EmMat[1].xyz), length(EmMat[2].xyz));
        vec3 PtDir = (EmMat * vec4((u_PtDirRadial ? PtGetDirMat(EmScale * spawnPos) * u_PtDir.xyz : u_PtDir.xyz) / EmScale, 0.)).xyz;
        vec3 startDir = normalize(PtDeviateVector(vec4(PtDir, u_PtDir.w)));
        float startSpeed = PtGetRand(u_PtSpd.xy);
        vec3 PtObjSpacePos = (EmMat * vec4(spawnPos, 1.)).xyz + PtGetPosition(PtTimeAlive, startDir, startSpeed, u_PtSpd, u_PtGravVec);
        
        //Find particle-space vertex position
        vec2 vertCorner = vec2(mod(in_Colour.a * 255., 2.), floor(in_Colour.a * 127.5));
        vec2 vertNormPos = u_PtSprOrig + vertCorner;
        if (u_PtAngleRel)
        {
            vec2 viewSpaceDir = normalize((gm_Matrices[MATRIX_VIEW] * vec4(PtGetDirection(PtTimeAlive, startDir, startSpeed, u_PtSpd, u_PtGravVec), 0.)).xy);
            vertNormPos *= mat2(viewSpaceDir.x, -viewSpaceDir.y, viewSpaceDir.y, viewSpaceDir.x);
        }
        float PtAngle = PtGetVar(PtTimeAlive, u_PtAngle);
        float PtSize = clamp(PtGetVar(PtTimeAlive, u_PtSize), u_PtSizeClamp.x, u_PtSizeClamp.y);
        vec2 vertPtSpacePos = rotate2d(PtSize * vertNormPos, PtAngle);
        
        //Construct world-view position and transform vertex to projection space
        vec3 PtWorldPos = (gm_Matrices[MATRIX_WORLD] * vec4(PtObjSpacePos, 1.)).xyz;
        vec4 PtWorldViewPos = gm_Matrices[MATRIX_VIEW][3] + gm_Matrices[MATRIX_VIEW] * vec4(PtWorldPos, 0.);
        PtWorldViewPos.xy += vertPtSpacePos;
        gl_Position = gm_Matrices[MATRIX_PROJECTION] * PtWorldViewPos;
        
        //Texcoord and colour
        float imgInd = PtGetImageIndex(PtTimeAlive,  PtLifeSpan);
        v_vTexcoord = vec2((imgInd + vertCorner.x) / u_PtSprSettings.z, vertCorner.y);
        v_vColour = PtGetColour(PtTimeAlive / PtLifeSpan);
    }
}