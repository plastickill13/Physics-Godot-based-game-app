shader_type canvas_item;

// Grabs the raw image of the game rendering behind this rectangle
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Expose settings to the Inspector so you can tweak the vibe
uniform float curvature : hint_range(0.0, 10.0) = 4.0;
uniform float scanline_count : hint_range(0.0, 1080.0) = 250.0;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.2;
uniform float vignette_multiplier : hint_range(0.0, 5.0) = 1.2;

void fragment() {
    // 1. SCREEN CURVATURE (The Fish-Eye Effect)
    vec2 uv = SCREEN_UV;
    uv = uv * 2.0 - 1.0; // Shift coordinates to the center
    vec2 offset = uv.yx / curvature;
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5; // Shift coordinates back

    // 2. BLACK BORDERS
    // If the curvature pulls the screen inward, paint the empty space black
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // Grab the actual game pixels at the new curved coordinates
        vec4 screen_color = texture(screen_texture, uv);

        // 3. SCANLINES (Horizontal dark lines)
        // Uses sine waves based on the Y coordinate to create alternating bands
        float s = sin(uv.y * scanline_count * PI * 2.0);
        s = (s * 0.5 + 0.5) * scanline_opacity + (1.0 - scanline_opacity);
        screen_color.rgb *= s;

        // 4. VIGNETTE (Darkened corners)
        float r = length(uv - vec2(0.5));
        float vignette = smoothstep(0.8, 0.2, r * vignette_multiplier);
        screen_color.rgb *= vignette;

        // Output the final retro-ified pixel
        COLOR = screen_color;
    }
}