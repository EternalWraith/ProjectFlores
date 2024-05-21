void main()
{
  gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
  gl_FrontColor = gl_Color;
  float invY = 1 - gl_TexCoord[0].y;
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex * invY;
}