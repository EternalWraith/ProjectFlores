precision mediump float;

uniform sampler2D texture;
uniform sampler2D mask;
uniform float geneHue;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  vec4 col = texture2D(texture, gl_TexCoord[0].xy);
  vec4 cmsk = texture2D(mask, gl_TexCoord[0].xy);
  vec4 pixel;
  if (cmsk.a == 0.0) {
    pixel = vec4(col);
  }
  else 
  {
    vec3 hsv = rgb2hsv(col.xyz);
    float h = hsv.x + (geneHue/360.0);//hsv.x + 0.1;
    if (h > 1.0) {
      h -= 1.0;
    }
    if (h < 0.0) {
      h += 1.0;
    }
    vec3 rgb = hsv2rgb(vec3(h, hsv.yz));
    pixel = vec4(rgb, 1.0);
  }
  
  gl_FragColor = vec4(pixel);
}