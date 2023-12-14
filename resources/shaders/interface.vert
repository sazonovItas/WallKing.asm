#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTex;

out vec2 TexCoords;

out vec3 FragPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

uniform int time;
uniform int state;

void main() 
{
    float norm = abs(sin(time / 500.0)) + 0.5;
    FragPos = vec3(model * vec4(norm * aPos, 1.0f));

    TexCoords = aTex;
    gl_Position = proj * view * vec4(FragPos, 1.0);
}