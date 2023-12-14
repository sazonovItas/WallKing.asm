#version 330 core

out vec4 FragColor;

in vec2 TexCoords;
in vec3 FragPos;

uniform sampler2D tex0;
uniform sampler2D tex1;

void main() 
{
    FragColor = texture(tex0, TexCoords);
}