#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTex;

out vec2 TexCoords;
out float condition;
out vec3 FragPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

uniform int time;
uniform int state;

void main() 
{

    if (state == 1 || state == 2 || state == 8) {
        FragPos = vec3(model * vec4(aPos, 1.0f));
    } else if (state == 4) {
        float norm = abs(sin(time / 150.0) / 4.0) + 0.8;
        FragPos = vec3(model * vec4(norm * aPos, 1.0f));
    } 

    TexCoords = aTex;
    condition = state;
    gl_Position = proj * view * vec4(FragPos, 1.0);
}