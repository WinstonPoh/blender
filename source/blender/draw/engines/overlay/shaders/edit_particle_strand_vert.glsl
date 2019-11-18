
uniform sampler1D weightTex;
uniform bool useWeight;

in vec3 pos;
in float color;

out vec4 finalColor;

vec3 weight_to_rgb(float t)
{
  if (t == 666.0) {
    /* No weight. */
    return colorWire.rgb;
  }
  if (t > 1.0 || t < 0.0) {
    /* Error color */
    return vec3(1.0, 0.0, 1.0);
  }
  else {
    return texture(weightTex, t).rgb;
  }
}

void main()
{
  vec3 world_pos = point_object_to_world(pos);
  gl_Position = point_world_to_ndc(world_pos);

  if (useWeight) {
    finalColor = vec4(weight_to_rgb(color), 1.0);
  }
  else {
    finalColor = mix(colorWire, colorEdgeSelect, color);
  }

#ifdef USE_WORLD_CLIP_PLANES
  world_clip_planes_calc_clip_distance(world_pos);
#endif
}
