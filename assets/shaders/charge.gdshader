shader_type canvas_item;

uniform float pulse_frequency = 1.0;
uniform float pulse_amplitude = 0.5;
uniform float pulse_phase = 0.0;
uniform sampler2D texture;

void fragment() {
    // Get the color from the texture at the current UV coordinates
    vec4 texture_color = texture(TEXTURE, UV);

    // Calculate the current time
    float time = TIME * pulse_frequency + pulse_phase;

    // Calculate the green color component of the pulse using a sine wave
    float green_pulse = (sin(time) + 1.0) / 2.0 * pulse_amplitude;

    // Set the output color to a transparent-green color with the green pulse applied
    COLOR = vec4(texture_color.rgb * (1.0 - green_pulse) + vec3(0.0, green_pulse, 0.0), texture_color.a);
}