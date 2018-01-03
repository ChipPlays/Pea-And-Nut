//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.	
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~
//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//
// God Rays Shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 lightPositionOnScreen;
uniform vec2 surfaceSize;
uniform float Density;
uniform float Weight;
uniform float Decay;
uniform float Exposure;

const int NUM_SAMPLES = 100 ;

void main()
{

  vec2 deltaTextCoord = vec2( v_vTexcoord - vec2(lightPositionOnScreen.x/surfaceSize.x, lightPositionOnScreen.y/surfaceSize.y));
  vec2 textCoo = v_vTexcoord;
  deltaTextCoord *= 1.0 / float(NUM_SAMPLES) * Density;
  float illuminationDecay = 1.0;
  
  
  for(int i=0; i < NUM_SAMPLES ; i++)
   {
     textCoo -= deltaTextCoord;
     vec4 sample = texture2D(gm_BaseTexture, textCoo );
          sample *= illuminationDecay * Weight;
          gl_FragColor += sample;
          illuminationDecay *= Decay;
  }
  
  gl_FragColor *= Exposure;
}

