#version 330 core

out vec4 FragColor;

in vec2 TexCoords;
in vec3 FragPos;
in float condition;

uniform sampler2D tex0;
uniform sampler2D tex1;

void main() 
{
    if (condition < 1.2f) {
        FragColor = texture(tex0, TexCoords);
    } else {
        FragColor = texture(tex1, TexCoords);
    }
}